--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝
    ██████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

    🐺 LXR Core - Police System

    Version: 1.0.0
    Developer: iBoss21 / The Lux Empire
    Website:   https://www.wolves.land
    Discord:   https://discord.gg/CrKcWdfd3A
    GitHub:    https://github.com/iBoss21

    SERVER SCRIPT - DUTY SYSTEM
    Hard-enforcement duty state management for law enforcement officers.

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]


-- Duty state tracking (server-authoritative)
local dutyStates = {}
local dutyStartTimes = {}
local afkTimers = {}
local lastActivity = {}

-- ══════════════════════════════════════════════════════════════
-- DUTY STATE MANAGEMENT
-- ══════════════════════════════════════════════════════════════

---Check if player is on duty
---@param src number Player source
---@return boolean
function IsOnDuty(src)
    return dutyStates[src] == true
end

---Set player duty state
---@param src number Player source
---@param state boolean On/off duty
---@param force boolean Skip checks
local function SetDutyState(src, state, force)
    local player = exports["lxr-police"]:GetPlayer(src)
    if not player then return false end
    
    -- Check if player is LEO
    if not exports["lxr-police"]:IsOfficer(src) and not force then
        return false
    end
    
    local oldState = dutyStates[src]
    dutyStates[src] = state
    
    if state then
        -- Going on duty
        dutyStartTimes[src] = os.time()
        lastActivity[src] = os.time()
        
        -- Log duty start
        if Config.LEOCore and Config.LEOCore.Audit.LogDutyChanges then
            exports["lxr-police"]:logAudit(src, "duty_on", "duty", 0, "Clocked in")
            
            -- Database tracking
            if Config.LEOCore.Duty.TrackDutyTime then
                MySQL.Async.execute([[
                    INSERT INTO leo_duty_logs (officer_id, duty_start, status)
                    VALUES (@id, NOW(), 'active')
                ]], {
                    ["@id"] = player.PlayerData and player.PlayerData.citizenid or player.citizenid
                })
            end
        end
        
        -- Auto-equip uniform if configured
        if Config.LEOCore and Config.LEOCore.Duty.AutoChangeUniform then
            TriggerClientEvent("lxr-police:duty:equipUniform", src)
        end
        
        TriggerClientEvent("lxr-police:notify", src, "You are now on duty", "success")
    else
        -- Going off duty
        local dutyTime = dutyStates[src] and dutyStartTimes[src] and (os.time() - dutyStartTimes[src]) or 0
        dutyStartTimes[src] = nil
        lastActivity[src] = nil
        
        -- Log duty end
        if Config.LEOCore and Config.LEOCore.Audit.LogDutyChanges then
            exports["lxr-police"]:logAudit(src, "duty_off", "duty", dutyTime, "Clocked out - " .. dutyTime .. "s on duty")
            
            -- Update database
            if Config.LEOCore.Duty.TrackDutyTime then
                MySQL.Async.execute([[
                    UPDATE leo_duty_logs 
                    SET duty_end = NOW(), 
                        status = 'completed',
                        duration = @duration
                    WHERE officer_id = @id 
                    AND status = 'active'
                    ORDER BY duty_start DESC
                    LIMIT 1
                ]], {
                    ["@id"] = player.PlayerData and player.PlayerData.citizenid or player.citizenid,
                    ["@duration"] = dutyTime
                })
            end
        end
        
        TriggerClientEvent("lxr-police:notify", src, "You are now off duty", "info")
    end
    
    -- Notify client
    TriggerClientEvent("lxr-police:duty:stateChanged", src, state)
    
    -- Clear any active interactions when going off duty
    if not state then
        TriggerClientEvent("lxr-police:duty:clearInteractions", src)
    end
    
    return true
end

-- ══════════════════════════════════════════════════════════════
-- PERMISSION ENFORCEMENT
-- ══════════════════════════════════════════════════════════════

---Check if player has permission for action
---@param src number Player source
---@param permission string Permission name
---@return boolean
function HasDutyPermission(src, permission)
    -- Check if officer
    if not exports["lxr-police"]:IsOfficer(src) then
        return false
    end
    
    -- Get permission definition
    local permDef = Config.LEOCore and Config.LEOCore.Permissions.Definitions[permission]
    if not permDef then
        return false -- Unknown permission
    end
    
    -- Check duty requirement
    if permDef.requireDuty and not IsOnDuty(src) then
        TriggerClientEvent("lxr-police:notify", src, "You must be on duty for this action", "error")
        return false
    end
    
    -- Check rank requirement
    local grade = exports["lxr-police"]:GetGrade(src)
    if grade < permDef.minRank then
        TriggerClientEvent("lxr-police:notify", src, "Insufficient rank for this action", "error")
        return false
    end
    
    return true
end

-- ══════════════════════════════════════════════════════════════
-- COOLDOWN SYSTEM (Anti-Spam)
-- ══════════════════════════════════════════════════════════════

local cooldowns = {}

---Check if action is on cooldown
---@param src number Player source
---@param action string Action name
---@return boolean
function IsOnCooldown(src, action)
    local cd = cooldowns[src] and cooldowns[src][action]
    if cd and os.time() < cd then
        local remaining = cd - os.time()
        TriggerClientEvent("lxr-police:notify", src, "Please wait " .. remaining .. " seconds", "warning")
        return true
    end
    return false
end

---Set cooldown for action
---@param src number Player source
---@param action string Action name
---@param duration number Cooldown duration in seconds
local function SetCooldown(src, action, duration)
    if not cooldowns[src] then
        cooldowns[src] = {}
    end
    cooldowns[src][action] = os.time() + duration
end

-- ══════════════════════════════════════════════════════════════
-- AFK DETECTION
-- ══════════════════════════════════════════════════════════════

---Update player activity timestamp
---@param src number Player source
function UpdateActivity(src)
    if IsOnDuty(src) then
        lastActivity[src] = os.time()
    end
end

-- AFK Check using SetTimeout (no loops)
if Config.LEOCore and Config.LEOCore.Duty.AFKTimeoutMinutes > 0 then
    local checkInterval = (Config.LEOCore.Duty.AFKCheckInterval or 60) * 1000
    
    local function CheckAFK()
        for src, state in pairs(dutyStates) do
            if state and lastActivity[src] then
                local afkTime = os.time() - lastActivity[src]
                local afkMinutes = afkTime / 60
                
                -- Warning
                if afkMinutes >= Config.LEOCore.Duty.AFKWarningMinutes then
                    TriggerClientEvent("lxr-police:notify", src, 
                        "AFK Warning: You will be clocked out in " .. 
                        (Config.LEOCore.Duty.AFKTimeoutMinutes - afkMinutes) .. " minutes",
                        "warning"
                    )
                end
                
                -- Timeout
                if afkMinutes >= Config.LEOCore.Duty.AFKTimeoutMinutes then
                    SetDutyState(src, false)
                    TriggerClientEvent("lxr-police:notify", src, 
                        "You have been clocked out due to inactivity",
                        "error"
                    )
                    exports["lxr-police"]:logAudit(src, "duty_afk_timeout", "duty", 0, 
                        "Auto clocked out after " .. afkMinutes .. " minutes AFK"
                    )
                end
            end
        end
        
        -- Schedule next check
        SetTimeout(checkInterval, CheckAFK)
    end
    
    -- Start the check cycle
    SetTimeout(checkInterval, CheckAFK)
end

-- ══════════════════════════════════════════════════════════════
-- EVENT HANDLERS
-- ══════════════════════════════════════════════════════════════

RegisterNetEvent("lxr-police:duty:toggle")
AddEventHandler("lxr-police:duty:toggle", function()
    local src = source
    UpdateActivity(src)
    
    if not exports["lxr-police"]:IsOfficer(src) then
        TriggerClientEvent("lxr-police:notify", src, "You are not law enforcement", "error")
        return
    end
    
    local newState = not IsOnDuty(src)
    SetDutyState(src, newState)
end)

RegisterNetEvent("lxr-police:duty:clockin")
AddEventHandler("lxr-police:duty:clockin", function(station)
    local src = source
    UpdateActivity(src)
    
    if not exports["lxr-police"]:IsOfficer(src) then
        exports["lxr-police"]:logAudit(src, "unauthorized_duty", "station", station, "Attempted unauthorized clock-in")
        DropPlayer(src, "Unauthorized duty attempt")
        return
    end
    
    SetDutyState(src, true)
end)

RegisterNetEvent("lxr-police:duty:clockout")
AddEventHandler("lxr-police:duty:clockout", function()
    local src = source
    SetDutyState(src, false)
end)

-- Activity tracking from various events
RegisterNetEvent("lxr-police:duty:activity")
AddEventHandler("lxr-police:duty:activity", function()
    UpdateActivity(source)
end)

-- ══════════════════════════════════════════════════════════════
-- PLAYER DISCONNECT CLEANUP
-- ══════════════════════════════════════════════════════════════

AddEventHandler("playerDropped", function(reason)
    local src = source
    
    if IsOnDuty(src) then
        -- Log duty end on disconnect
        local dutyTime = dutyStartTimes[src] and (os.time() - dutyStartTimes[src]) or 0
        exports["lxr-police"]:logAudit(src, "duty_disconnect", "duty", dutyTime, 
            "Disconnected while on duty - Reason: " .. reason
        )
        
        -- Update database
        if Config.LEOCore and Config.LEOCore.Duty.TrackDutyTime then
            local player = exports["lxr-police"]:GetPlayer(src)
            if player then
                MySQL.Async.execute([[
                    UPDATE leo_duty_logs 
                    SET duty_end = NOW(), 
                        status = 'disconnected',
                        duration = @duration
                    WHERE officer_id = @id 
                    AND status = 'active'
                    ORDER BY duty_start DESC
                    LIMIT 1
                ]], {
                    ["@id"] = player.PlayerData and player.PlayerData.citizenid or player.citizenid,
                    ["@duration"] = dutyTime
                })
            end
        end
    end
    
    -- Cleanup
    dutyStates[src] = nil
    dutyStartTimes[src] = nil
    afkTimers[src] = nil
    lastActivity[src] = nil
    cooldowns[src] = nil
end)

-- ══════════════════════════════════════════════════════════════
-- EXPORTS
-- ══════════════════════════════════════════════════════════════

exports("IsOnDuty", IsOnDuty)
exports("HasDutyPermission", HasDutyPermission)
exports("IsOnCooldown", IsOnCooldown)
exports("SetCooldown", SetCooldown)
exports("UpdateActivity", UpdateActivity)

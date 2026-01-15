--[[
    ╔════════════════════════════════════════════════════════════╗
    ║  Anti-Abuse System                                        ║
    ║  Rate Limiting, Suspicious Activity Detection             ║
    ║  Distance Checks, Server-Side Validation                  ║
    ╚════════════════════════════════════════════════════════════╝
]]

-- Rate limit tracking
local rateLimits = {}
local suspiciousActivity = {}
local actionTimestamps = {}

-- ══════════════════════════════════════════════════════════════
-- RATE LIMITING
-- ══════════════════════════════════════════════════════════════

---Check if player is rate limited for action
---@param src number Player source
---@param action string Action type
---@return boolean isLimited
function IsRateLimited(src, action)
    if not Config.LEOCore or not Config.LEOCore.AntiAbuse.EnableRateLimiting then
        return false
    end
    
    local limits = Config.LEOCore.AntiAbuse.RateLimits[action]
    if not limits then
        return false
    end
    
    -- Initialize tracking
    if not rateLimits[src] then
        rateLimits[src] = {}
    end
    if not rateLimits[src][action] then
        rateLimits[src][action] = {}
    end
    
    local now = os.time()
    local window = limits.window
    local maxActions = limits.max
    
    -- Clean old timestamps outside window
    local validTimestamps = {}
    for _, timestamp in ipairs(rateLimits[src][action]) do
        if (now - timestamp) < window then
            table.insert(validTimestamps, timestamp)
        end
    end
    rateLimits[src][action] = validTimestamps
    
    -- Check if limit exceeded
    if #validTimestamps >= maxActions then
        return true
    end
    
    -- Add current timestamp
    table.insert(rateLimits[src][action], now)
    
    return false
end

---Handle rate limit violation
---@param src number Player source
---@param action string Action type
function HandleRateLimit(src, action)
    local player = exports["lxr-police"]:GetPlayer(src)
    if not player then return end
    
    TriggerClientEvent("lxr-police:notify", src, 
        "You are performing actions too quickly. Please slow down.",
        "error"
    )
    
    -- Log the violation
    exports["lxr-police"]:logAudit(src, "rate_limit_hit", "abuse", 0, 
        "Rate limit exceeded for action: " .. action
    )
    
    -- Track as suspicious
    TrackSuspiciousActivity(src, "rate_limit", action)
end

-- ══════════════════════════════════════════════════════════════
-- SUSPICIOUS ACTIVITY DETECTION
-- ══════════════════════════════════════════════════════════════

---Track suspicious activity
---@param src number Player source
---@param activityType string Type of suspicious activity
---@param details string Additional details
function TrackSuspiciousActivity(src, activityType, details)
    if not Config.LEOCore or not Config.LEOCore.AntiAbuse.DetectSuspicious then
        return
    end
    
    if not suspiciousActivity[src] then
        suspiciousActivity[src] = {}
    end
    
    table.insert(suspiciousActivity[src], {
        type = activityType,
        details = details,
        timestamp = os.time()
    })
    
    -- Check if threshold exceeded
    local recentCount = 0
    local now = os.time()
    for _, activity in ipairs(suspiciousActivity[src]) do
        if (now - activity.timestamp) < 300 then -- 5 minutes
            recentCount = recentCount + 1
        end
    end
    
    if recentCount >= 3 then
        HandleSuspiciousActivity(src, activityType, details)
    end
end

---Handle suspicious activity
---@param src number Player source
---@param activityType string Type of activity
---@param details string Details
function HandleSuspiciousActivity(src, activityType, details)
    local player = exports["lxr-police"]:GetPlayer(src)
    if not player then return end
    
    local action = Config.LEOCore and Config.LEOCore.AntiAbuse.OnAbuse or "log"
    
    -- Log the suspicious activity
    exports["lxr-police"]:logAudit(src, "suspicious_activity", "abuse", 0, 
        "Suspicious " .. activityType .. " detected: " .. (details or "")
    )
    
    -- Notify admins if configured
    if Config.LEOCore and Config.LEOCore.AntiAbuse.NotifyAdmins then
        NotifyAdmins(src, activityType, details)
    end
    
    -- Take action
    if action == "warn" then
        TriggerClientEvent("lxr-police:notify", src, 
            "Warning: Suspicious activity detected. Your actions are being monitored.",
            "error"
        )
    elseif action == "kick" then
        DropPlayer(src, "Suspicious activity detected: Abuse of law enforcement systems")
    elseif action == "ban" then
        -- This would integrate with your ban system
        local banDuration = Config.LEOCore.AntiAbuse.BanDuration or 86400
        local banEvent = Config.LEOCore.AntiAbuse.BanEventName or "qb-admin:server:ban"
        TriggerEvent(banEvent, src, banDuration, "LEO system abuse")
        DropPlayer(src, "Banned for abuse of law enforcement systems")
    end
end

---Notify admins of suspicious activity
---@param src number Player source
---@param activityType string Type of activity
---@param details string Details
function NotifyAdmins(src, activityType, details)
    local player = exports["lxr-police"]:GetPlayer(src)
    if not player then return end
    
    local playerName = player.PlayerData and 
        (player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname) or
        GetPlayerName(src)
    
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local targetSrc = tonumber(playerId)
        -- Check if player is admin (you'll need to implement this based on your framework)
        if IsPlayerAceAllowed(targetSrc, "command.admin") then
            TriggerClientEvent("lxr-police:notify", targetSrc, 
                "[ADMIN] Suspicious LEO activity: " .. playerName .. " - " .. activityType,
                "warning"
            )
        end
    end
end

-- ══════════════════════════════════════════════════════════════
-- RAPID ACTION DETECTION
-- ══════════════════════════════════════════════════════════════

---Track action for rapid detection
---@param src number Player source
---@param action string Action type
function TrackAction(src, action)
    if not actionTimestamps[src] then
        actionTimestamps[src] = {}
    end
    if not actionTimestamps[src][action] then
        actionTimestamps[src][action] = {}
    end
    
    local now = os.time()
    table.insert(actionTimestamps[src][action], now)
    
    -- Keep only last 30 seconds
    local recent = {}
    for _, timestamp in ipairs(actionTimestamps[src][action]) do
        if (now - timestamp) < 30 then
            table.insert(recent, timestamp)
        end
    end
    actionTimestamps[src][action] = recent
    
    -- Check for rapid actions
    CheckRapidActions(src, action, #recent)
end

---Check for rapid actions
---@param src number Player source
---@param action string Action type
---@param count number Number of actions in last 30 seconds
function CheckRapidActions(src, action, count)
    if not Config.LEOCore or not Config.LEOCore.AntiAbuse.DetectSuspicious then
        return
    end
    
    local thresholds = Config.LEOCore.AntiAbuse.SuspiciousThresholds
    local threshold = thresholds["rapid_" .. action] or 999
    
    if count >= threshold then
        TrackSuspiciousActivity(src, "rapid_" .. action, 
            count .. " " .. action .. " in 30 seconds"
        )
    end
end

-- ══════════════════════════════════════════════════════════════
-- DISTANCE VALIDATION
-- ══════════════════════════════════════════════════════════════

---Validate distance between two players
---@param src number Source player
---@param target number Target player
---@param maxDistance number Maximum allowed distance
---@param action string Action being performed
---@return boolean isValid
function ValidateDistance(src, target, maxDistance, action)
    if not Config.LEOCore or not Config.LEOCore.AntiAbuse then
        return true
    end
    
    local srcPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(target)
    
    if not srcPed or not targetPed then
        return false
    end
    
    local srcCoords = GetEntityCoords(srcPed)
    local targetCoords = GetEntityCoords(targetPed)
    
    local distance = #(srcCoords - targetCoords)
    
    if distance > maxDistance then
        TriggerClientEvent("lxr-police:notify", src, 
            "You are too far away to perform this action",
            "error"
        )
        
        -- Log potential abuse
        exports["lxr-police"]:logAudit(src, "distance_violation", "abuse", 0, 
            action .. " attempted at " .. string.format("%.2f", distance) .. "m (max: " .. maxDistance .. "m)"
        )
        
        TrackSuspiciousActivity(src, "distance_abuse", 
            action .. " at " .. string.format("%.2f", distance) .. "m"
        )
        
        return false
    end
    
    return true
end

-- ══════════════════════════════════════════════════════════════
-- PROTECTED ACTION WRAPPER
-- ══════════════════════════════════════════════════════════════

---Execute action with all anti-abuse checks
---@param src number Player source
---@param action string Action type
---@param target number|nil Target player (for distance check)
---@param callback function Callback to execute if valid
function ProtectedAction(src, action, target, callback)
    -- Check rate limit
    if IsRateLimited(src, action) then
        HandleRateLimit(src, action)
        return false
    end
    
    -- Check distance if target specified
    if target then
        local maxDist = Config.LEOCore.AntiAbuse.MaxInteractDistance or 5.0
        if action == "arrests" then
            maxDist = Config.LEOCore.AntiAbuse.MaxArrestDistance or 3.0
        elseif action == "searches" then
            maxDist = Config.LEOCore.AntiAbuse.MaxSearchDistance or 2.0
        end
        
        if not ValidateDistance(src, target, maxDist, action) then
            return false
        end
    end
    
    -- Track action
    TrackAction(src, action)
    
    -- Execute callback
    if callback then
        callback()
    end
    
    return true
end

-- ══════════════════════════════════════════════════════════════
-- CLEANUP
-- ══════════════════════════════════════════════════════════════

AddEventHandler("playerDropped", function()
    local src = source
    rateLimits[src] = nil
    suspiciousActivity[src] = nil
    actionTimestamps[src] = nil
end)

-- Periodic cleanup using SetTimeout (no loops)
local function CleanupOldData()
    local now = os.time()
    
    -- Clean rate limits
    for src, actions in pairs(rateLimits) do
        for action, timestamps in pairs(actions) do
            local valid = {}
            for _, timestamp in ipairs(timestamps) do
                if (now - timestamp) < 600 then -- Keep 10 minutes
                    table.insert(valid, timestamp)
                end
            end
            rateLimits[src][action] = valid
        end
    end
    
    -- Clean suspicious activity
    for src, activities in pairs(suspiciousActivity) do
        local valid = {}
        for _, activity in ipairs(activities) do
            if (now - activity.timestamp) < 3600 then -- Keep 1 hour
                table.insert(valid, activity)
            end
        end
        suspiciousActivity[src] = valid
    end
    
    -- Schedule next cleanup
    SetTimeout(300000, CleanupOldData) -- 5 minutes
end

-- Start cleanup cycle
SetTimeout(300000, CleanupOldData)

-- ══════════════════════════════════════════════════════════════
-- EXPORTS
-- ══════════════════════════════════════════════════════════════

exports("IsRateLimited", IsRateLimited)
exports("ValidateDistance", ValidateDistance)
exports("ProtectedAction", ProtectedAction)
exports("TrackAction", TrackAction)

--[[
    ╔════════════════════════════════════════════════════════════╗
    ║  Warrant System - Supervisor Approval Required           ║
    ║  Arrest, Search, and Bench Warrants                       ║
    ║  Probable Cause, Approval Workflow, Auto-Expiry           ║
    ╚════════════════════════════════════════════════════════════╝
]]

-- Pending warrant approvals
local pendingWarrants = {}
local warrantApprovalQueue = {}

-- ══════════════════════════════════════════════════════════════
-- WARRANT REQUEST
-- ══════════════════════════════════════════════════════════════

RegisterNetEvent("lxr-police:warrant:request")
AddEventHandler("lxr-police:warrant:request", function(data)
    local src = source
    
    -- Check permission
    if not exports["lxr-police"]:HasDutyPermission(src, "warrant_request") then
        TriggerClientEvent("lxr-police:notify", src, "You don't have permission to request warrants", "error")
        return
    end
    
    -- Check cooldown
    if exports["lxr-police"]:IsOnCooldown(src, "warrant_request") then
        return
    end
    
    -- Validate data
    if not data.citizenId or not data.warrantType or not data.probableCause then
        TriggerClientEvent("lxr-police:notify", src, "Missing required warrant information", "error")
        return
    end
    
    -- Validate warrant type
    local warrantConfig = Config.LEOCore and Config.LEOCore.Warrants.Types[data.warrantType]
    if not warrantConfig then
        TriggerClientEvent("lxr-police:notify", src, "Invalid warrant type", "error")
        return
    end
    
    -- Check probable cause length
    if Config.LEOCore and Config.LEOCore.Warrants.RequireProbableCause then
        if string.len(data.probableCause) < (Config.LEOCore.Warrants.MinCauseLength or 50) then
            TriggerClientEvent("lxr-police:notify", src, 
                "Probable cause must be at least " .. (Config.LEOCore.Warrants.MinCauseLength or 50) .. " characters",
                "error"
            )
            return
        end
    end
    
    -- Check if search warrant needs location
    if data.warrantType == "search" and warrantConfig.requireLocation and not data.location then
        TriggerClientEvent("lxr-police:notify", src, "Search warrants require a specific location", "error")
        return
    end
    
    -- Get officer info
    local officer = exports["lxr-police"]:GetPlayer(src)
    if not officer then return end
    
    -- Check if requires approval
    if warrantConfig.requireApproval and Config.LEOCore and Config.LEOCore.Warrants.RequireSupervisorApproval then
        -- Create pending warrant
        local warrantId = GenerateWarrantId()
        pendingWarrants[warrantId] = {
            id = warrantId,
            citizenId = data.citizenId,
            warrantType = data.warrantType,
            probableCause = data.probableCause,
            location = data.location,
            charges = data.charges or {},
            requestedBy = officer.PlayerData and officer.PlayerData.citizenid or officer.citizenid,
            requestedByName = officer.PlayerData and officer.PlayerData.charinfo.firstname .. " " .. officer.PlayerData.charinfo.lastname or "Officer",
            requestedAt = os.time(),
            status = "pending",
        }
        
        -- Notify requesting officer
        TriggerClientEvent("lxr-police:notify", src, 
            "Warrant request submitted for supervisor approval",
            "success"
        )
        
        -- Notify online supervisors
        NotifySupervisors(warrantId, pendingWarrants[warrantId])
        
        -- Log
        exports["lxr-police"]:logAudit(src, "warrant_request", "warrant", warrantId, 
            data.warrantType .. " warrant requested for citizen " .. data.citizenId
        )
        
        -- Set cooldown
        exports["lxr-police"]:SetCooldown(src, "warrant_request", 30)
    else
        -- Auto-approve (bench warrants, etc.)
        IssueWarrant(src, data, officer, "auto")
    end
end)

-- ══════════════════════════════════════════════════════════════
-- WARRANT APPROVAL
-- ══════════════════════════════════════════════════════════════

RegisterNetEvent("lxr-police:warrant:approve")
AddEventHandler("lxr-police:warrant:approve", function(warrantId, approved, notes)
    local src = source
    
    -- Check permission
    if not exports["lxr-police"]:HasDutyPermission(src, "warrant_approve") then
        TriggerClientEvent("lxr-police:notify", src, "You don't have permission to approve warrants", "error")
        return
    end
    
    -- Check if warrant exists
    local warrant = pendingWarrants[warrantId]
    if not warrant then
        TriggerClientEvent("lxr-police:notify", src, "Warrant not found", "error")
        return
    end
    
    -- Get supervisor info
    local supervisor = exports["lxr-police"]:GetPlayer(src)
    if not supervisor then return end
    
    if approved then
        -- Issue warrant
        IssueWarrant(src, warrant, supervisor, "approved", notes)
        
        TriggerClientEvent("lxr-police:notify", src, "Warrant approved and issued", "success")
        
        -- Notify requesting officer
        local requestingOfficer = GetPlayerFromCitizenId(warrant.requestedBy)
        if requestingOfficer then
            TriggerClientEvent("lxr-police:notify", requestingOfficer, 
                "Your warrant request has been approved",
                "success"
            )
        end
    else
        -- Deny warrant
        warrant.status = "denied"
        warrant.deniedBy = supervisor.PlayerData and supervisor.PlayerData.citizenid or supervisor.citizenid
        warrant.deniedAt = os.time()
        warrant.denialNotes = notes or "No reason provided"
        
        TriggerClientEvent("lxr-police:notify", src, "Warrant denied", "info")
        
        -- Notify requesting officer
        local requestingOfficer = GetPlayerFromCitizenId(warrant.requestedBy)
        if requestingOfficer then
            TriggerClientEvent("lxr-police:notify", requestingOfficer, 
                "Your warrant request was denied: " .. warrant.denialNotes,
                "error"
            )
        end
        
        -- Log denial
        exports["lxr-police"]:logAudit(src, "warrant_denied", "warrant", warrantId, 
            "Warrant denied - " .. warrant.denialNotes
        )
    end
    
    -- Remove from pending
    pendingWarrants[warrantId] = nil
end)

-- ══════════════════════════════════════════════════════════════
-- WARRANT EXECUTION
-- ══════════════════════════════════════════════════════════════

RegisterNetEvent("lxr-police:warrant:execute")
AddEventHandler("lxr-police:warrant:execute", function(warrantId, targetId)
    local src = source
    
    -- Check permission
    if not exports["lxr-police"]:HasDutyPermission(src, "warrant_execute") then
        TriggerClientEvent("lxr-police:notify", src, "You don't have permission to execute warrants", "error")
        return
    end
    
    -- Get warrant from database
    MySQL.Async.fetchAll("SELECT * FROM mdt_warrants WHERE id = @id AND status = 'active'", {
        ["@id"] = warrantId
    }, function(result)
        if not result or not result[1] then
            TriggerClientEvent("lxr-police:notify", src, "Warrant not found or already executed", "error")
            return
        end
        
        local warrant = result[1]
        
        -- Check expiry
        local issuedAt = warrant.issued_at
        local expiryDays = Config.LEOCore and Config.LEOCore.Warrants.Types[warrant.warrant_type].expiryDays or 30
        local expiryTime = issuedAt + (expiryDays * 86400)
        
        if os.time() > expiryTime then
            TriggerClientEvent("lxr-police:notify", src, "This warrant has expired", "error")
            MySQL.Async.execute("UPDATE mdt_warrants SET status = 'expired' WHERE id = @id", {
                ["@id"] = warrantId
            })
            return
        end
        
        -- Execute warrant
        MySQL.Async.execute([[
            UPDATE mdt_warrants 
            SET status = 'executed',
                executed_by = @officer,
                executed_at = @time
            WHERE id = @id
        ]], {
            ["@id"] = warrantId,
            ["@officer"] = src,
            ["@time"] = os.time()
        })
        
        -- Log execution
        exports["lxr-police"]:logAudit(src, "warrant_executed", "warrant", warrantId, 
            warrant.warrant_type .. " warrant executed on citizen " .. warrant.citizen_id
        )
        
        TriggerClientEvent("lxr-police:notify", src, "Warrant executed successfully", "success")
        
        -- If arrest warrant, trigger arrest flow
        if warrant.warrant_type == "arrest" and targetId then
            TriggerEvent("lxr-police:arrest:beginArrest", src, targetId, warrant.charges)
        end
    end)
end)

-- ══════════════════════════════════════════════════════════════
-- HELPER FUNCTIONS
-- ══════════════════════════════════════════════════════════════

---Issue a warrant
---@param src number Source of approver/issuer
---@param data table Warrant data
---@param officer table Officer player object
---@param approvalType string "auto" or "approved"
---@param notes string Optional approval notes
function IssueWarrant(src, data, officer, approvalType, notes)
    local warrantConfig = Config.LEOCore and Config.LEOCore.Warrants.Types[data.warrantType]
    if not warrantConfig then return end
    
    local expiryTime = os.time() + (warrantConfig.expiryDays * 86400)
    
    -- Insert into database
    MySQL.Async.execute([[
        INSERT INTO mdt_warrants (
            citizen_id, warrant_type, probable_cause, location, charges,
            issued_by, issued_at, expires_at, status, approval_type, approval_notes
        ) VALUES (
            @citizen, @type, @cause, @location, @charges,
            @officer, @issued, @expires, 'active', @approval, @notes
        )
    ]], {
        ["@citizen"] = data.citizenId,
        ["@type"] = data.warrantType,
        ["@cause"] = data.probableCause,
        ["@location"] = data.location or "",
        ["@charges"] = json.encode(data.charges or {}),
        ["@officer"] = officer.PlayerData and officer.PlayerData.citizenid or officer.citizenid,
        ["@issued"] = os.time(),
        ["@expires"] = expiryTime,
        ["@approval"] = approvalType,
        ["@notes"] = notes or ""
    }, function(insertId)
        -- Log issuance
        exports["lxr-police"]:logAudit(src, "warrant_issued", "warrant", insertId, 
            data.warrantType .. " warrant issued for citizen " .. data.citizenId
        )
        
        -- Notify target if online (with delay)
        if Config.LEOCore and Config.LEOCore.Warrants.NotifyOnline then
            Citizen.SetTimeout((Config.LEOCore.Warrants.NotifyDelay or 300) * 1000, function()
                local targetPlayer = GetPlayerFromCitizenId(data.citizenId)
                if targetPlayer then
                    TriggerClientEvent("lxr-police:notify", targetPlayer, 
                        "A warrant has been issued for your arrest",
                        "error"
                    )
                end
            end)
        end
    end)
end

---Generate unique warrant ID
---@return string
function GenerateWarrantId()
    return "WRT-" .. os.time() .. "-" .. math.random(1000, 9999)
end

---Notify all online supervisors of pending warrant
---@param warrantId string Warrant ID
---@param warrant table Warrant data
function NotifySupervisors(warrantId, warrant)
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local src = tonumber(playerId)
        if exports["lxr-police"]:IsOfficer(src) then
            local grade = exports["lxr-police"]:GetGrade(src)
            local minRank = Config.LEOCore and Config.LEOCore.Warrants.MinApprovalRank or 3
            
            if grade >= minRank and exports["lxr-police"]:IsOnDuty(src) then
                TriggerClientEvent("lxr-police:warrant:pendingNotification", src, {
                    id = warrantId,
                    type = warrant.warrantType,
                    citizen = warrant.citizenId,
                    requestedBy = warrant.requestedByName,
                })
            end
        end
    end
end

---Get player source from citizen ID
---@param citizenId string Citizen ID
---@return number|nil Player source or nil
function GetPlayerFromCitizenId(citizenId)
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local src = tonumber(playerId)
        local player = exports["lxr-police"]:GetPlayer(src)
        if player then
            local pCitizenId = player.PlayerData and player.PlayerData.citizenid or player.citizenid
            if pCitizenId == citizenId then
                return src
            end
        end
    end
    return nil
end

-- ══════════════════════════════════════════════════════════════
-- EXPORTS
-- ══════════════════════════════════════════════════════════════

exports("GetPendingWarrants", function()
    return pendingWarrants
end)

exports("GetActiveWarrants", function(citizenId)
    local p = promise.new()
    
    MySQL.Async.fetchAll([[
        SELECT * FROM mdt_warrants 
        WHERE citizen_id = @id 
        AND status = 'active'
        AND expires_at > @now
    ]], {
        ["@id"] = citizenId,
        ["@now"] = os.time()
    }, function(result)
        p:resolve(result or {})
    end)
    
    return Citizen.Await(p)
end)

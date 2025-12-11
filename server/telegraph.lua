-- Telegraph Dispatch System for The Land of Wolves RP
local activeDispatches = {}
local dispatchCounter = 1

-- Send telegraph alert
RegisterNetEvent("tlw-law:dispatch:sendTelegraph")
AddEventHandler("tlw-law:dispatch:sendTelegraph", function(alertData)
    local src = source
    
    local dispatchId = "DISPATCH-" .. string.format("%06d", dispatchCounter)
    dispatchCounter = dispatchCounter + 1
    
    local dispatch = {
        id = dispatchId,
        type = alertData.type or "10-60",
        message = alertData.message,
        location = alertData.location or GetEntityCoords(GetPlayerPed(src)),
        sender = src,
        timestamp = os.time(),
        responding = {},
        status = "active"
    }
    
    table.insert(activeDispatches, dispatch)
    
    -- Notify all officers based on range
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local pid = tonumber(playerId)
        if exports["lxr-police"]:IsOfficer(pid) then
            -- Check if in range (if telegraph has range limit)
            TriggerClientEvent("tlw-law:dispatch:alert", pid, dispatch)
        end
    end
    
    -- Save to database
    MySQL.Async.execute([[
        INSERT INTO mdt_dispatch (dispatch_id, type, message, location, sender, timestamp, status)
        VALUES (@id, @type, @message, @location, @sender, @time, @status)
    ]], {
        ["@id"] = dispatchId,
        ["@type"] = dispatch.type,
        ["@message"] = dispatch.message,
        ["@location"] = json.encode(dispatch.location),
        ["@sender"] = src,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S'),
        ["@status"] = "active"
    })
    
    -- Log
    exports["lxr-police"]:logAudit(src, "dispatch_send", "dispatch", dispatchId, "Type: " .. dispatch.type)
    
    -- Delay for telegraph (period-accurate)
    if Config.Dispatch.Methods.telegraph.delay then
        Citizen.Wait(Config.Dispatch.Methods.telegraph.delay * 1000)
    end
end)

-- Respond to dispatch
RegisterNetEvent("tlw-law:dispatch:respond")
AddEventHandler("tlw-law:dispatch:respond", function(dispatchId)
    local src = source
    
    if not exports["lxr-police"]:IsOfficer(src) then
        return
    end
    
    local dispatch = findDispatchById(dispatchId)
    if not dispatch then
        TriggerClientEvent("lxr-police:notify", src, "Dispatch not found", "error")
        return
    end
    
    if dispatch.status ~= "active" then
        TriggerClientEvent("lxr-police:notify", src, "Dispatch is not active", "error")
        return
    end
    
    -- Add to responding
    if not table.contains(dispatch.responding, src) then
        table.insert(dispatch.responding, src)
    end
    
    -- Notify sender
    TriggerClientEvent("tlw-law:dispatch:officerResponding", dispatch.sender, {
        dispatchId = dispatchId,
        officer = src
    })
    
    TriggerClientEvent("lxr-police:notify", src, "Responding to dispatch", "success")
    
    -- Log
    exports["lxr-police"]:logAudit(src, "dispatch_respond", "dispatch", dispatchId, "Responding to call")
end)

-- Complete dispatch
RegisterNetEvent("tlw-law:dispatch:complete")
AddEventHandler("tlw-law:dispatch:complete", function(dispatchId)
    local src = source
    
    if not exports["lxr-police"]:IsOfficer(src) then
        return
    end
    
    local dispatch = findDispatchById(dispatchId)
    if not dispatch then
        return
    end
    
    dispatch.status = "completed"
    dispatch.completedBy = src
    dispatch.completedAt = os.time()
    
    -- Update database
    MySQL.Async.execute([[
        UPDATE mdt_dispatch SET status = @status, completed_by = @officer, completed_at = @time
        WHERE dispatch_id = @id
    ]], {
        ["@id"] = dispatchId,
        ["@status"] = "completed",
        ["@officer"] = src,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S')
    })
    
    -- Notify responding officers
    for _, officerId in ipairs(dispatch.responding) do
        TriggerClientEvent("tlw-law:dispatch:completed", officerId, dispatchId)
    end
    
    -- Log
    exports["lxr-police"]:logAudit(src, "dispatch_complete", "dispatch", dispatchId, "Completed call")
end)

-- Request backup
RegisterNetEvent("tlw-law:dispatch:requestBackup")
AddEventHandler("tlw-law:dispatch:requestBackup", function()
    local src = source
    
    if not exports["lxr-police"]:IsOfficer(src) then
        return
    end
    
    local coords = GetEntityCoords(GetPlayerPed(src))
    
    local dispatch = {
        id = "BACKUP-" .. src .. "-" .. os.time(),
        type = "10-00",
        message = "Officer needs assistance!",
        location = coords,
        sender = src,
        timestamp = os.time(),
        responding = {},
        status = "active",
        priority = 1
    }
    
    table.insert(activeDispatches, dispatch)
    
    -- Notify all officers
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local pid = tonumber(playerId)
        if exports["lxr-police"]:IsOfficer(pid) and pid ~= src then
            TriggerClientEvent("tlw-law:dispatch:backup", pid, dispatch)
        end
    end
    
    TriggerClientEvent("lxr-police:notify", src, "Backup requested", "success")
    
    -- Log
    exports["lxr-police"]:logAudit(src, "dispatch_backup", "dispatch", dispatch.id, "Requested backup")
end)

-- Get active dispatches
RegisterNetEvent("tlw-law:dispatch:getActive")
AddEventHandler("tlw-law:dispatch:getActive", function()
    local src = source
    
    if not exports["lxr-police"]:IsOfficer(src) then
        return
    end
    
    local active = {}
    for _, dispatch in ipairs(activeDispatches) do
        if dispatch.status == "active" then
            table.insert(active, dispatch)
        end
    end
    
    TriggerClientEvent("tlw-law:dispatch:activeList", src, active)
end)

-- Helper functions
function findDispatchById(id)
    for _, dispatch in ipairs(activeDispatches) do
        if dispatch.id == id then
            return dispatch
        end
    end
    return nil
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- Cleanup old dispatches
CreateThread(function()
    while true do
        Citizen.Wait(300000) -- 5 minutes
        
        local currentTime = os.time()
        for i = #activeDispatches, 1, -1 do
            local dispatch = activeDispatches[i]
            if dispatch.status ~= "active" and (currentTime - dispatch.timestamp) > 3600 then
                table.remove(activeDispatches, i)
            end
        end
    end
end)

-- Exports
exports("GetActiveDispatches", function()
    local active = {}
    for _, dispatch in ipairs(activeDispatches) do
        if dispatch.status == "active" then
            table.insert(active, dispatch)
        end
    end
    return active
end)

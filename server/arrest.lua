-- Arrest state tracking
local arrestStates = {}
local mugshots = {}

local function sendWebhook(action, officer, target, details)
    if Config.Logging.Webhook and Config.Logging.Webhook ~= "" then
        PerformHttpRequest(Config.Logging.Webhook, function() end, "POST", json.encode({
            action = action,
            officer = officer,
            target = target,
            details = details,
            timestamp = os.date('%Y-%m-%d %H:%M:%S')
        }), {["Content-Type"]="application/json"})
    end
end

local function getPlayerIdentifier(src)
    local player = exports["lxr-police"]:GetPlayer(src)
    if player then
        return player.PlayerData and player.PlayerData.citizenid or player.citizenid
    end
    return nil
end

RegisterNetEvent("lxr-police:arrest:softCuff")
AddEventHandler("lxr-police:arrest:softCuff", function(targetId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then
        sendWebhook("unauthorized_arrest", src, targetId, "Attempted soft cuff")
        DropPlayer(src, "Unauthorized police action.")
        return
    end
    
    arrestStates[targetId] = {
        cuffed = true,
        cuffType = "soft",
        officer = src,
        timestamp = os.time()
    }
    
    TriggerClientEvent("lxr-police:arrest:softCuff", targetId, GetPlayerPed(src))
    sendWebhook("arrest_softCuff", src, targetId, "Soft cuff applied")
    exports["lxr-police"]:logAudit(src, "arrest_softCuff", "player", targetId, "Soft cuff applied")
    
    -- Notify nearby officers
    local coords = GetEntityCoords(GetPlayerPed(src))
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        if exports["lxr-police"]:IsOfficer(tonumber(playerId)) then
            local playerCoords = GetEntityCoords(GetPlayerPed(tonumber(playerId)))
            if #(coords - playerCoords) < 50.0 then
                TriggerClientEvent("lxr-police:notify", tonumber(playerId), "Officer cuffed a suspect nearby", "primary")
            end
        end
    end
end)

RegisterNetEvent("lxr-police:arrest:hardCuff")
AddEventHandler("lxr-police:arrest:hardCuff", function(targetId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then
        sendWebhook("unauthorized_arrest", src, targetId, "Attempted hard cuff")
        DropPlayer(src, "Unauthorized police action.")
        return
    end
    
    arrestStates[targetId] = {
        cuffed = true,
        cuffType = "hard",
        officer = src,
        timestamp = os.time()
    }
    
    TriggerClientEvent("lxr-police:arrest:hardCuff", targetId, GetPlayerPed(src))
    sendWebhook("arrest_hardCuff", src, targetId, "Hard cuff applied - full arrest")
    exports["lxr-police"]:logAudit(src, "arrest_hardCuff", "player", targetId, "Hard cuff applied - full arrest")
end)

RegisterNetEvent("lxr-police:arrest:uncuff")
AddEventHandler("lxr-police:arrest:uncuff", function(targetId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then
        sendWebhook("unauthorized_uncuff", src, targetId, "Attempted uncuff")
        DropPlayer(src, "Unauthorized police action.")
        return
    end
    
    arrestStates[targetId] = nil
    
    TriggerClientEvent("lxr-police:arrest:uncuff", targetId)
    sendWebhook("arrest_uncuff", src, targetId, "Uncuffed")
    exports["lxr-police"]:logAudit(src, "arrest_uncuff", "player", targetId, "Uncuffed")
end)

RegisterNetEvent("lxr-police:arrest:drag")
AddEventHandler("lxr-police:arrest:drag", function(targetId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then return end
    
    if not arrestStates[targetId] or not arrestStates[targetId].cuffed then
        TriggerClientEvent("lxr-police:notify", src, "Target must be cuffed first", "error")
        return
    end
    
    local officerPed = GetPlayerPed(src)
    TriggerClientEvent("lxr-police:arrest:drag", targetId, PedToNet(officerPed))
    exports["lxr-police"]:logAudit(src, "arrest_drag", "player", targetId, "Started dragging")
end)

RegisterNetEvent("lxr-police:arrest:stopDrag")
AddEventHandler("lxr-police:arrest:stopDrag", function(targetId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then return end
    
    TriggerClientEvent("lxr-police:arrest:stopDrag", targetId)
    exports["lxr-police"]:logAudit(src, "arrest_stopDrag", "player", targetId, "Stopped dragging")
end)

RegisterNetEvent("lxr-police:arrest:search")
AddEventHandler("lxr-police:arrest:search", function(targetId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then return end
    
    if not arrestStates[targetId] or not arrestStates[targetId].cuffed then
        TriggerClientEvent("lxr-police:notify", src, "Target must be cuffed first", "error")
        return
    end
    
    TriggerClientEvent("lxr-police:arrest:search", targetId, GetPlayerPed(src))
    
    -- Get inventory
    local inventory = exports["lxr-police"]:GetInventory(targetId)
    local contraband = {}
    local cash = 0
    
    for _, item in pairs(inventory) do
        if item.name and (item.name:find("weapon") or item.name == "lockpick" or item.name == "illegal") then
            table.insert(contraband, item)
        end
    end
    
    -- Send search results
    TriggerClientEvent("lxr-police:arrest:searchResults", src, {
        targetId = targetId,
        contraband = contraband,
        cash = cash,
        inventory = inventory
    })
    
    exports["lxr-police"]:logAudit(src, "arrest_search", "player", targetId, "Searched player - found " .. #contraband .. " contraband items")
end)

RegisterNetEvent("lxr-police:arrest:pushIntoVehicle")
AddEventHandler("lxr-police:arrest:pushIntoVehicle", function(targetId, vehicleNetId, seat)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then return end
    
    if not arrestStates[targetId] or not arrestStates[targetId].cuffed then
        TriggerClientEvent("lxr-police:notify", src, "Target must be cuffed first", "error")
        return
    end
    
    TriggerClientEvent("lxr-police:arrest:pushIntoVehicle", targetId, vehicleNetId, seat or 2)
    exports["lxr-police"]:logAudit(src, "arrest_pushVehicle", "player", targetId, "Pushed into vehicle")
end)

RegisterNetEvent("lxr-police:arrest:takeOutOfVehicle")
AddEventHandler("lxr-police:arrest:takeOutOfVehicle", function(targetId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then return end
    
    TriggerClientEvent("lxr-police:arrest:takeOutOfVehicle", targetId)
    exports["lxr-police"]:logAudit(src, "arrest_takeOutVehicle", "player", targetId, "Removed from vehicle")
end)

RegisterNetEvent("lxr-police:arrest:mugshot")
AddEventHandler("lxr-police:arrest:mugshot", function(targetId, photoData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then return end
    
    local identifier = getPlayerIdentifier(targetId)
    if identifier then
        mugshots[identifier] = {
            photo = photoData,
            date = os.date('%Y-%m-%d %H:%M:%S'),
            officer = src
        }
        
        -- Save to database
        MySQL.Async.execute("UPDATE mdt_citizens SET mugshot = @mugshot WHERE identifier = @id", {
            ["@id"] = identifier,
            ["@mugshot"] = photoData
        })
        
        TriggerClientEvent("lxr-police:notify", src, "Mugshot captured and saved", "success")
        exports["lxr-police"]:logAudit(src, "arrest_mugshot", "player", targetId, "Captured mugshot")
    end
end)

RegisterNetEvent("lxr-police:arrest:fingerprint")
AddEventHandler("lxr-police:arrest:fingerprint", function(targetId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then return end
    
    local identifier = getPlayerIdentifier(targetId)
    if identifier then
        -- Generate fingerprint data
        local fingerprint = "FP-" .. string.upper(string.sub(identifier, 1, 8))
        
        TriggerClientEvent("lxr-police:arrest:fingerprintResult", src, {
            targetId = targetId,
            fingerprint = fingerprint,
            identifier = identifier
        })
        
        exports["lxr-police"]:logAudit(src, "arrest_fingerprint", "player", targetId, "Collected fingerprint: " .. fingerprint)
    end
end)

RegisterNetEvent("lxr-police:arrest:dna")
AddEventHandler("lxr-police:arrest:dna", function(targetId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then return end
    
    local identifier = getPlayerIdentifier(targetId)
    if identifier then
        -- Generate DNA data
        local dna = "DNA-" .. string.upper(string.sub(identifier, 1, 8))
        
        TriggerClientEvent("lxr-police:arrest:dnaResult", src, {
            targetId = targetId,
            dna = dna,
            identifier = identifier
        })
        
        exports["lxr-police"]:logAudit(src, "arrest_dna", "player", targetId, "Collected DNA sample: " .. dna)
    end
end)

RegisterNetEvent("lxr-police:arrest:surrender")
AddEventHandler("lxr-police:arrest:surrender", function(targetId)
    -- Notify nearby officers
    local coords = GetEntityCoords(GetPlayerPed(targetId))
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        if exports["lxr-police"]:IsOfficer(tonumber(playerId)) then
            local playerCoords = GetEntityCoords(GetPlayerPed(tonumber(playerId)))
            if #(coords - playerCoords) < 50.0 then
                TriggerClientEvent("lxr-police:notify", tonumber(playerId), "A suspect is surrendering at your location", "primary")
            end
        end
    end
end)

-- Export functions
exports("GetArrestState", function(targetId)
    return arrestStates[targetId]
end)

exports("IsCuffed", function(targetId)
    return arrestStates[targetId] and arrestStates[targetId].cuffed or false
end)
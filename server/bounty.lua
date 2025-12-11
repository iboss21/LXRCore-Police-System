-- Bounty System for The Land of Wolves RP
local activeBounties = {}
local bountyHunters = {}
local wantedPosters = {}

-- Create wanted poster
RegisterNetEvent("tlw-law:bounty:createPoster")
AddEventHandler("tlw-law:bounty:createPoster", function(targetId, bountyAmount, crimes, description)
    local src = source
    
    if not exports["lxr-police"]:HasPermission(src, "bounty_place") then
        TriggerClientEvent("lxr-police:notify", src, "You don't have permission to place bounties", "error")
        return
    end
    
    local targetPlayer = exports["lxr-police"]:GetPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent("lxr-police:notify", src, "Player not found", "error")
        return
    end
    
    local identifier = targetPlayer.PlayerData and targetPlayer.PlayerData.citizenid or targetPlayer.citizenid
    local name = targetPlayer.PlayerData and targetPlayer.PlayerData.charinfo.firstname .. " " .. targetPlayer.PlayerData.charinfo.lastname or "Unknown"
    
    local posterId = "WANTED-" .. string.format("%06d", #wantedPosters + 1)
    
    local poster = {
        id = posterId,
        targetId = targetId,
        identifier = identifier,
        name = name,
        bounty = bountyAmount,
        crimes = crimes,
        description = description,
        placedBy = src,
        placedAt = os.time(),
        status = "active",
        capturedBy = nil,
        capturedAt = nil
    }
    
    table.insert(wantedPosters, poster)
    activeBounties[identifier] = poster
    
    -- Save to database
    MySQL.Async.execute([[
        INSERT INTO mdt_bounties (poster_id, identifier, name, bounty, crimes, description, placed_by, placed_at, status)
        VALUES (@id, @identifier, @name, @bounty, @crimes, @desc, @officer, @time, @status)
    ]], {
        ["@id"] = posterId,
        ["@identifier"] = identifier,
        ["@name"] = name,
        ["@bounty"] = bountyAmount,
        ["@crimes"] = json.encode(crimes),
        ["@desc"] = description,
        ["@officer"] = src,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S'),
        ["@status"] = "active"
    })
    
    -- Notify all players
    TriggerClientEvent("tlw-law:bounty:newPoster", -1, poster)
    
    -- Log
    exports["lxr-police"]:logAudit(src, "bounty_create", "poster", posterId, "Bounty: $" .. bountyAmount .. " for " .. name)
    
    TriggerClientEvent("lxr-police:notify", src, "Wanted poster created: $" .. bountyAmount, "success")
end)

-- Claim bounty
RegisterNetEvent("tlw-law:bounty:claim")
AddEventHandler("tlw-law:bounty:claim", function(posterId, targetId, isAlive)
    local src = source
    
    if not exports["lxr-police"]:IsOfficer(src) and not isBountyHunter(src) then
        TriggerClientEvent("lxr-police:notify", src, "You're not authorized to claim bounties", "error")
        return
    end
    
    local poster = findPosterById(posterId)
    if not poster or poster.status ~= "active" then
        TriggerClientEvent("lxr-police:notify", src, "Bounty is not active", "error")
        return
    end
    
    -- Calculate reward based on alive/dead
    local reward = poster.bounty
    if isAlive then
        reward = math.floor(reward * (Config.Bounty.CaptureAliveBonus or 1.5))
    else
        reward = math.floor(reward * (Config.Bounty.CaptureDeadPenalty or 0.5))
    end
    
    -- Update poster
    poster.status = "claimed"
    poster.capturedBy = src
    poster.capturedAt = os.time()
    activeBounties[poster.identifier] = nil
    
    -- Update database
    MySQL.Async.execute([[
        UPDATE mdt_bounties SET status = @status, captured_by = @capturer, captured_at = @time, reward_paid = @reward
        WHERE poster_id = @id
    ]], {
        ["@id"] = posterId,
        ["@status"] = "claimed",
        ["@capturer"] = src,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S'),
        ["@reward"] = reward
    })
    
    -- Pay reward
    exports["lxr-police"]:AddMoney(src, "cash", reward)
    
    -- Notify
    TriggerClientEvent("lxr-police:notify", src, "Bounty claimed! Reward: $" .. reward, "success")
    TriggerClientEvent("tlw-law:bounty:posterClaimed", -1, posterId)
    
    -- Log
    exports["lxr-police"]:logAudit(src, "bounty_claim", "poster", posterId, "Claimed bounty: $" .. reward)
end)

-- Get active bounties
RegisterNetEvent("tlw-law:bounty:getActive")
AddEventHandler("tlw-law:bounty:getActive", function()
    local src = source
    
    local activeList = {}
    for _, poster in pairs(wantedPosters) do
        if poster.status == "active" then
            table.insert(activeList, poster)
        end
    end
    
    TriggerClientEvent("tlw-law:bounty:activeList", src, activeList)
end)

-- Bounty hunter license
RegisterNetEvent("tlw-law:bounty:getLicense")
AddEventHandler("tlw-law:bounty:getLicense", function()
    local src = source
    
    if isBountyHunter(src) then
        TriggerClientEvent("lxr-police:notify", src, "You already have a bounty hunter license", "error")
        return
    end
    
    local cost = Config.Bounty.LicenseCost or 250
    
    if exports["lxr-police"]:RemoveMoney(src, "cash", cost) then
        bountyHunters[src] = {
            obtained = os.time(),
            captures = 0
        }
        
        -- Give item
        -- TriggerClientEvent("lxr-police:giveItem", src, "bounty_license", 1)
        
        TriggerClientEvent("lxr-police:notify", src, "Bounty hunter license obtained!", "success")
    else
        TriggerClientEvent("lxr-police:notify", src, "Insufficient funds (Need $" .. cost .. ")", "error")
    end
end)

-- Helper functions
function isBountyHunter(src)
    return bountyHunters[src] ~= nil or exports["lxr-police"]:GetJob(src) == Config.Bounty.BountyHunterJob
end

function findPosterById(id)
    for _, poster in pairs(wantedPosters) do
        if poster.id == id then
            return poster
        end
    end
    return nil
end

-- Load bounties from database on start
CreateThread(function()
    MySQL.Async.fetchAll("SELECT * FROM mdt_bounties WHERE status = 'active'", {}, function(results)
        for _, row in ipairs(results) do
            local poster = {
                id = row.poster_id,
                identifier = row.identifier,
                name = row.name,
                bounty = row.bounty,
                crimes = json.decode(row.crimes),
                description = row.description,
                placedBy = row.placed_by,
                placedAt = row.placed_at,
                status = row.status
            }
            table.insert(wantedPosters, poster)
            activeBounties[row.identifier] = poster
        end
        print("[TLoW Law] Loaded " .. #wantedPosters .. " active bounties")
    end)
end)

-- Exports
exports("GetActiveBounties", function()
    return wantedPosters
end)

exports("HasBounty", function(identifier)
    return activeBounties[identifier] ~= nil
end)

exports("GetBountyAmount", function(identifier)
    local bounty = activeBounties[identifier]
    return bounty and bounty.bounty or 0
end)

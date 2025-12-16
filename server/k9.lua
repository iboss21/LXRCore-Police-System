-- K9 Dog System - Server Side
local RSGCore = exports['rsg-core']:GetCoreObject()

-- ══════════════════════════════════════════════════════════════
-- K9 TRACK SUCCESS
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:k9:trackSuccess', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Award XP
    local xpGain = Config.K9.Training.xpGainRate.trackSuccess or 25
    
    -- TODO: Add XP to player's K9 training progress
    -- This would be stored in database
    
    -- Notify officer
    TriggerClientEvent('RSGCore:Notify', src, 'K9 successfully tracked suspect! +' .. xpGain .. ' XP', 'success')
    
    -- Log audit
    if exports['lxr-police'] and exports['lxr-police'].logAudit then
        exports['lxr-police']:logAudit(src, "k9_track_success", "k9", 0, "K9 successfully tracked suspect")
    end
end)

-- ══════════════════════════════════════════════════════════════
-- K9 SEARCH EVIDENCE
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:k9:searchEvidence', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check for evidence nearby (simplified version)
    local successChance = Config.K9.Search.successChance.bloodhound or 80
    local success = math.random(100) <= successChance
    
    if success then
        -- Award XP
        local xpGain = Config.K9.Search.rewardXP or 25
        
        -- Give evidence item
        local evidenceType = Config.K9.Search.evidenceTypes[math.random(#Config.K9.Search.evidenceTypes)]
        local evidenceItemConfig = Config.PhysicalItems.EvidenceBag.types[evidenceType]
        
        if evidenceItemConfig then
            local metadata = {
                type = evidenceType,
                foundBy = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
                foundDate = os.date("%Y-%m-%d %H:%M:%S"),
                k9Search = true,
            }
            
            -- Add evidence item to inventory
            if GetResourceState('rsg-inventory') == 'started' then
                exports['rsg-inventory']:AddItem(src, evidenceItemConfig.itemName, 1, nil, metadata)
            else
                Player.Functions.AddItem(evidenceItemConfig.itemName, 1, false, metadata)
            end
            
            TriggerClientEvent('RSGCore:Notify', src, 'K9 found evidence: ' .. evidenceItemConfig.label .. '! +' .. xpGain .. ' XP', 'success')
        else
            TriggerClientEvent('RSGCore:Notify', src, 'K9 found evidence! +' .. xpGain .. ' XP', 'success')
        end
        
        -- Log audit
        if exports['lxr-police'] and exports['lxr-police'].logAudit then
            exports['lxr-police']:logAudit(src, "k9_search_success", "k9", 0, "K9 found " .. evidenceType .. " evidence")
        end
    else
        TriggerClientEvent('RSGCore:Notify', src, 'K9 did not find any evidence', 'error')
    end
end)

-- ══════════════════════════════════════════════════════════════
-- K9 ATTACK TARGET
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:k9:attackTarget', function(targetId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local Target = RSGCore.Functions.GetPlayer(targetId)
    
    if not Player or not Target then return end
    
    -- Apply damage to target
    local damage = Config.K9.Apprehension.attackDamage or 25
    
    -- Check subdue chance
    local subdueChance = Config.K9.Apprehension.subdueChance.shepherd or 75
    local subdued = math.random(100) <= subdueChance
    
    if subdued then
        -- Ragdoll target
        TriggerClientEvent('lxr-police:k9:subdueTarget', targetId, Config.K9.Apprehension.subdueTime)
        
        -- Notify both parties
        TriggerClientEvent('RSGCore:Notify', src, 'K9 subdued the suspect!', 'success')
        TriggerClientEvent('RSGCore:Notify', targetId, 'You have been subdued by a K9!', 'error')
        
        -- Award XP
        local xpGain = Config.K9.Apprehension.rewardXP or 50
        TriggerClientEvent('RSGCore:Notify', src, '+' .. xpGain .. ' K9 XP', 'primary')
        
        -- Log audit
        if exports['lxr-police'] and exports['lxr-police'].logAudit then
            exports['lxr-police']:logAudit(src, "k9_subdue_success", "player", targetId, "K9 subdued suspect")
        end
    else
        -- Just damage
        TriggerClientEvent('lxr-police:k9:takeDamage', targetId, damage)
        TriggerClientEvent('RSGCore:Notify', targetId, 'You were attacked by a K9!', 'error')
        TriggerClientEvent('RSGCore:Notify', src, 'K9 attacked the suspect', 'primary')
    end
end)

-- ══════════════════════════════════════════════════════════════
-- K9 DATABASE FUNCTIONS (Optional)
-- ══════════════════════════════════════════════════════════════
function SaveK9Data(citizenid, k9Data)
    if not Config.K9.Integration.useDatabase then return end
    
    MySQL.Async.execute([[
        INSERT INTO leo_k9_data (citizenid, breed, level, xp, health, stamina, updated_at)
        VALUES (@citizenid, @breed, @level, @xp, @health, @stamina, NOW())
        ON DUPLICATE KEY UPDATE
        breed = @breed, level = @level, xp = @xp, health = @health, stamina = @stamina, updated_at = NOW()
    ]], {
        ['@citizenid'] = citizenid,
        ['@breed'] = k9Data.breed or 'bloodhound',
        ['@level'] = k9Data.level or 1,
        ['@xp'] = k9Data.xp or 0,
        ['@health'] = k9Data.health or 100,
        ['@stamina'] = k9Data.stamina or 100,
    })
end

function LoadK9Data(citizenid, cb)
    if not Config.K9.Integration.useDatabase then
        cb(nil)
        return
    end
    
    MySQL.Async.fetchAll('SELECT * FROM leo_k9_data WHERE citizenid = @citizenid', {
        ['@citizenid'] = citizenid
    }, function(result)
        if result[1] then
            cb(result[1])
        else
            cb(nil)
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
-- K9 COMMANDS
-- ══════════════════════════════════════════════════════════════
RSGCore.Commands.Add('k9', 'Open K9 Unit Menu', {}, false, function(source, args)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check if player is law enforcement
    if Player.PlayerData.job.type ~= 'leo' then
        TriggerClientEvent('RSGCore:Notify', src, 'You are not a law enforcement officer', 'error')
        return
    end
    
    -- Check grade requirement
    if Player.PlayerData.job.grade.level < Config.K9.RequiredGrade then
        TriggerClientEvent('RSGCore:Notify', src, 'You do not have the required rank for K9 handling (Rank ' .. Config.K9.RequiredGrade .. '+)', 'error')
        return
    end
    
    -- Check if on duty
    if not Player.PlayerData.job.onduty then
        TriggerClientEvent('RSGCore:Notify', src, 'You must be on duty to use K9 unit', 'error')
        return
    end
    
    TriggerClientEvent('lxr-police:k9:openMenu', src)
end)

RSGCore.Commands.Add('k9spawn', 'Spawn K9 Dog', {{name = 'breed', help = 'Dog breed (1-3)'}}, false, function(source, args)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check permissions
    if Player.PlayerData.job.type ~= 'leo' or Player.PlayerData.job.grade.level < Config.K9.RequiredGrade then
        TriggerClientEvent('RSGCore:Notify', src, 'You do not have permission to spawn K9', 'error')
        return
    end
    
    local breedIndex = tonumber(args[1]) or 1
    TriggerClientEvent('lxr-police:k9:spawn', src, breedIndex)
end)

RSGCore.Commands.Add('k9dismiss', 'Dismiss K9 Dog', {}, false, function(source, args)
    local src = source
    TriggerClientEvent('lxr-police:k9:dismiss', src)
end)

RSGCore.Commands.Add('k9follow', 'Order K9 to Follow', {}, false, function(source, args)
    local src = source
    TriggerClientEvent('lxr-police:k9:follow', src)
end)

RSGCore.Commands.Add('k9stay', 'Order K9 to Stay', {}, false, function(source, args)
    local src = source
    TriggerClientEvent('lxr-police:k9:stay', src)
end)

RSGCore.Commands.Add('k9track', 'Order K9 to Track', {}, false, function(source, args)
    local src = source
    TriggerClientEvent('lxr-police:k9:track', src)
end)

RSGCore.Commands.Add('k9search', 'Order K9 to Search', {}, false, function(source, args)
    local src = source
    TriggerClientEvent('lxr-police:k9:search', src)
end)

RSGCore.Commands.Add('k9attack', 'Order K9 to Attack', {}, false, function(source, args)
    local src = source
    TriggerClientEvent('lxr-police:k9:attack', src)
end)

-- ══════════════════════════════════════════════════════════════
-- EXPORTS
-- ══════════════════════════════════════════════════════════════
exports('SaveK9Data', SaveK9Data)
exports('LoadK9Data', LoadK9Data)

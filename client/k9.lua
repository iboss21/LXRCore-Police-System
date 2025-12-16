-- K9 Dog System - Client Side
local RSGCore = exports['rsg-core']:GetCoreObject()
local k9Active = false
local k9Ped = nil
local k9Data = {
    breed = nil,
    health = 100,
    stamina = 100,
    level = 1,
    xp = 0,
    following = false,
    tracking = false,
    searching = false,
}

-- ══════════════════════════════════════════════════════════════
-- K9 SPAWN COMMAND
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:k9:spawn', function(breedIndex)
    if k9Active then
        RSGCore.Functions.Notify("You already have a K9 with you", "error")
        return
    end
    
    local breed = Config.K9.Breeds[breedIndex or 1]
    if not breed then
        RSGCore.Functions.Notify("Invalid K9 breed selected", "error")
        return
    end
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    -- Spawn K9 dog
    local modelHash = GetHashKey(breed.model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(100)
    end
    
    k9Ped = CreatePed(modelHash, coords.x + 2.0, coords.y, coords.z, heading, true, false, false, false)
    SetPedAsGroupMember(k9Ped, GetPedGroupIndex(playerPed))
    SetPedCanRagdoll(k9Ped, false)
    SetEntityAsMissionEntity(k9Ped, true, true)
    SetModelAsNoLongerNeeded(modelHash)
    
    -- Set K9 data
    k9Active = true
    k9Data.breed = breed
    k9Data.health = breed.health
    k9Data.stamina = breed.stamina
    k9Data.following = true
    
    RSGCore.Functions.Notify("K9 " .. breed.label .. " has been deployed", "success")
    
    -- Start K9 update thread
    CreateThread(function()
        K9UpdateLoop()
    end)
end)

-- ══════════════════════════════════════════════════════════════
-- K9 DISMISS COMMAND
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:k9:dismiss', function()
    if not k9Active or not k9Ped then
        RSGCore.Functions.Notify("You don't have a K9 deployed", "error")
        return
    end
    
    DeleteEntity(k9Ped)
    k9Ped = nil
    k9Active = false
    k9Data.following = false
    k9Data.tracking = false
    k9Data.searching = false
    
    RSGCore.Functions.Notify("K9 has been dismissed", "success")
end)

-- ══════════════════════════════════════════════════════════════
-- K9 FOLLOW COMMAND
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:k9:follow', function()
    if not k9Active or not k9Ped then
        RSGCore.Functions.Notify("You don't have a K9 deployed", "error")
        return
    end
    
    k9Data.following = true
    k9Data.tracking = false
    k9Data.searching = false
    
    local playerPed = PlayerPedId()
    TaskFollowToOffsetOfEntity(k9Ped, playerPed, 0.0, -2.0, 0.0, 5.0, -1, Config.K9.FollowDistance, true)
    
    RSGCore.Functions.Notify("K9 is now following you", "success")
end)

-- ══════════════════════════════════════════════════════════════
-- K9 STAY COMMAND
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:k9:stay', function()
    if not k9Active or not k9Ped then
        RSGCore.Functions.Notify("You don't have a K9 deployed", "error")
        return
    end
    
    k9Data.following = false
    ClearPedTasks(k9Ped)
    TaskStandStill(k9Ped, -1)
    
    RSGCore.Functions.Notify("K9 is staying in place", "success")
end)

-- ══════════════════════════════════════════════════════════════
-- K9 TRACK COMMAND
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:k9:track', function()
    if not k9Active or not k9Ped then
        RSGCore.Functions.Notify("You don't have a K9 deployed", "error")
        return
    end
    
    if k9Data.stamina < Config.K9.Stamina.exhaustedThreshold then
        RSGCore.Functions.Notify("K9 is too exhausted to track", "error")
        return
    end
    
    k9Data.tracking = true
    k9Data.following = false
    
    -- Find closest player
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local closestPlayer, closestDistance = RSGCore.Functions.GetClosestPlayer(coords)
    
    if closestPlayer ~= -1 and closestDistance < Config.K9.Tracking.trackUpdateInterval then
        local targetPed = GetPlayerPed(closestPlayer)
        local targetCoords = GetEntityCoords(targetPed)
        
        RSGCore.Functions.Notify("K9 has picked up a scent!", "success")
        
        -- Start tracking
        CreateThread(function()
            local trackingTime = 0
            while k9Data.tracking and trackingTime < Config.K9.Commands.track.duration do
                if k9Data.stamina > 0 then
                    k9Data.stamina = k9Data.stamina - (Config.K9.Stamina.depletionRate.tracking / 10)
                    
                    -- Move K9 towards target
                    targetCoords = GetEntityCoords(targetPed)
                    TaskGoToCoordAnyMeans(k9Ped, targetCoords.x, targetCoords.y, targetCoords.z, 5.0, 0, 0, 786603, 0xbf800000)
                    
                    -- Check if close to target
                    local k9Coords = GetEntityCoords(k9Ped)
                    local distance = #(k9Coords - targetCoords)
                    
                    if distance < Config.K9.Tracking.alertRadius then
                        RSGCore.Functions.Notify("K9 has located the suspect!", "success")
                        TriggerServerEvent('lxr-police:k9:trackSuccess')
                        k9Data.tracking = false
                        break
                    end
                else
                    RSGCore.Functions.Notify("K9 is exhausted from tracking", "error")
                    k9Data.tracking = false
                    break
                end
                
                trackingTime = trackingTime + 1000
                Wait(1000)
            end
            
            if trackingTime >= Config.K9.Commands.track.duration then
                RSGCore.Functions.Notify("K9 lost the scent", "error")
            end
            
            k9Data.tracking = false
        end)
    else
        RSGCore.Functions.Notify("K9 couldn't find any scent to track", "error")
        k9Data.tracking = false
    end
end)

-- ══════════════════════════════════════════════════════════════
-- K9 SEARCH COMMAND
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:k9:search', function()
    if not k9Active or not k9Ped then
        RSGCore.Functions.Notify("You don't have a K9 deployed", "error")
        return
    end
    
    if k9Data.stamina < Config.K9.Stamina.exhaustedThreshold then
        RSGCore.Functions.Notify("K9 is too exhausted to search", "error")
        return
    end
    
    k9Data.searching = true
    k9Data.following = false
    
    RSGCore.Functions.Notify("K9 is searching for evidence...", "primary")
    
    -- Search animation
    TaskStartScenarioInPlace(k9Ped, GetHashKey("WORLD_ANIMAL_DOG_EATING"), 0, true, false, 0, false)
    
    -- Search for evidence
    TriggerServerEvent('lxr-police:k9:searchEvidence')
    
    Wait(Config.K9.Search.searchTime)
    
    ClearPedTasks(k9Ped)
    k9Data.searching = false
end)

-- ══════════════════════════════════════════════════════════════
-- K9 ATTACK COMMAND
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:k9:attack', function()
    if not k9Active or not k9Ped then
        RSGCore.Functions.Notify("You don't have a K9 deployed", "error")
        return
    end
    
    if k9Data.stamina < Config.K9.Stamina.exhaustedThreshold then
        RSGCore.Functions.Notify("K9 is too exhausted to attack", "error")
        return
    end
    
    -- Find closest player
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local closestPlayer, closestDistance = RSGCore.Functions.GetClosestPlayer(coords)
    
    if closestPlayer ~= -1 and closestDistance < Config.K9.Apprehension.attackRange then
        local targetPed = GetPlayerPed(closestPlayer)
        
        RSGCore.Functions.Notify("K9 is attacking the suspect!", "success")
        
        -- Attack task
        TaskCombatPed(k9Ped, targetPed, 0, 16)
        
        -- Notify target
        TriggerServerEvent('lxr-police:k9:attackTarget', GetPlayerServerId(closestPlayer))
        
        -- Deplete stamina
        k9Data.stamina = k9Data.stamina - (Config.K9.Stamina.depletionRate.attacking * 3)
    else
        RSGCore.Functions.Notify("No suspect in range for K9 attack", "error")
    end
end)

-- ══════════════════════════════════════════════════════════════
-- K9 UPDATE LOOP
-- ══════════════════════════════════════════════════════════════
function K9UpdateLoop()
    while k9Active and k9Ped do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local k9Coords = GetEntityCoords(k9Ped)
        local distance = #(playerCoords - k9Coords)
        
        -- Check if K9 is too far
        if distance > Config.K9.MaxDistance then
            -- Teleport K9 back to handler
            SetEntityCoords(k9Ped, playerCoords.x + 2.0, playerCoords.y, playerCoords.z, false, false, false, false)
        end
        
        -- Regenerate stamina when idle
        if not k9Data.tracking and not k9Data.searching and not k9Data.following then
            if k9Data.stamina < 100 then
                k9Data.stamina = math.min(100, k9Data.stamina + (Config.K9.Stamina.regenRate / 10))
            end
        end
        
        -- Deplete stamina when following
        if k9Data.following and IsPedRunning(k9Ped) then
            k9Data.stamina = math.max(0, k9Data.stamina - (Config.K9.Stamina.depletionRate.running / 10))
        end
        
        -- Regenerate health
        if Config.K9.Health.enabled and k9Data.health < k9Data.breed.health then
            k9Data.health = math.min(k9Data.breed.health, k9Data.health + (Config.K9.Health.regenRate / 10))
            SetEntityHealth(k9Ped, k9Data.health)
        end
        
        -- Check if K9 died
        if IsEntityDead(k9Ped) then
            RSGCore.Functions.Notify("Your K9 has been injured!", "error")
            k9Active = false
            k9Ped = nil
            break
        end
        
        Wait(100)
    end
end

-- ══════════════════════════════════════════════════════════════
-- REGISTER COMMANDS
-- ══════════════════════════════════════════════════════════════
RegisterCommand('k9menu', function()
    -- Open K9 menu
    TriggerEvent('lxr-police:k9:openMenu')
end, false)

-- ══════════════════════════════════════════════════════════════
-- K9 SUBDUE TARGET (CLIENT RECEIVE)
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:k9:subdueTarget', function(subdueTime)
    local playerPed = PlayerPedId()
    
    -- Ragdoll player
    SetPedToRagdoll(playerPed, subdueTime, subdueTime, 0, 0, 0, 0)
    
    -- Disable controls temporarily
    CreateThread(function()
        local timer = subdueTime
        while timer > 0 do
            DisableControlAction(0, 0x8FD015D8, true) -- Sprint
            DisableControlAction(0, 0xD9D0E1C0, true) -- Attack
            DisableControlAction(0, 0x07CE1E61, true) -- Melee Attack
            timer = timer - 100
            Wait(100)
        end
    end)
end)

-- ══════════════════════════════════════════════════════════════
-- K9 TAKE DAMAGE (CLIENT RECEIVE)
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:k9:takeDamage', function(damage)
    local playerPed = PlayerPedId()
    local currentHealth = GetEntityHealth(playerPed)
    SetEntityHealth(playerPed, currentHealth - damage)
end)

RegisterNetEvent('lxr-police:k9:openMenu', function()
    local PlayerData = RSGCore.Functions.GetPlayerData()
    
    if not PlayerData.job or PlayerData.job.type ~= "leo" then
        RSGCore.Functions.Notify("You are not a law enforcement officer", "error")
        return
    end
    
    if PlayerData.job.grade.level < Config.K9.RequiredGrade then
        RSGCore.Functions.Notify("You don't have the required rank for K9 handling", "error")
        return
    end
    
    local menuOptions = {
        {
            header = "K9 Unit Menu",
            isMenuHeader = true,
        },
    }
    
    if not k9Active then
        for i, breed in ipairs(Config.K9.Breeds) do
            table.insert(menuOptions, {
                header = "Deploy " .. breed.label,
                txt = breed.description,
                params = {
                    event = "lxr-police:k9:spawn",
                    args = i
                }
            })
        end
    else
        table.insert(menuOptions, {
            header = "K9 Commands",
            txt = "Control your K9 partner",
            isMenuHeader = true,
        })
        table.insert(menuOptions, {
            header = "Follow",
            txt = "Order K9 to follow you",
            params = {
                event = "lxr-police:k9:follow"
            }
        })
        table.insert(menuOptions, {
            header = "Stay",
            txt = "Order K9 to stay in place",
            params = {
                event = "lxr-police:k9:stay"
            }
        })
        table.insert(menuOptions, {
            header = "Track Suspect",
            txt = "Order K9 to track nearby suspect",
            params = {
                event = "lxr-police:k9:track"
            }
        })
        table.insert(menuOptions, {
            header = "Search Evidence",
            txt = "Order K9 to search for evidence",
            params = {
                event = "lxr-police:k9:search"
            }
        })
        table.insert(menuOptions, {
            header = "Attack Suspect",
            txt = "Order K9 to subdue suspect",
            params = {
                event = "lxr-police:k9:attack"
            }
        })
        table.insert(menuOptions, {
            header = "Dismiss K9",
            txt = "Send K9 back to kennel",
            params = {
                event = "lxr-police:k9:dismiss"
            }
        })
    end
    
    exports['rsg-menu']:openMenu(menuOptions)
end)

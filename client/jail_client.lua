-- Client-side Jail System
local inJail = false
local sentenceData = nil
local jailBlip = nil

-- Start jail sentence
RegisterNetEvent("lxr-police:jail:startSentence")
AddEventHandler("lxr-police:jail:startSentence", function(data)
    inJail = true
    sentenceData = data
    
    local ped = PlayerPedId()
    
    -- Teleport to cell
    SetEntityCoords(ped, data.cellCoords.x, data.cellCoords.y, data.cellCoords.z)
    FreezeEntityPosition(ped, true)
    Citizen.Wait(500)
    FreezeEntityPosition(ped, false)
    
    -- Remove weapons
    RemoveAllPedWeapons(ped, true)
    
    -- Create blip
    jailBlip = Blip.AddForCoord(data.cellCoords.x, data.cellCoords.y, data.cellCoords.z)
    SetBlipSprite(jailBlip, `blip_proc_home`)
    Citizen.InvokeNative(0x9CB1A1623062F402, jailBlip, "Prison Cell")
    
    -- Show charges
    local chargeText = "Charges:\n"
    for _, charge in ipairs(data.charges) do
        chargeText = chargeText .. "- " .. charge.name .. "\n"
    end
    
    exports["lxr-police"]:Notify("You are in jail!\n" .. chargeText, "error")
    
    -- Start jail loop
    startJailLoop()
end)

-- Jail control loop
function startJailLoop()
    CreateThread(function()
        while inJail do
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            
            -- Restrict area
            if sentenceData and sentenceData.cellCoords then
                local distance = #(coords - sentenceData.cellCoords)
                if distance > 10.0 then
                    -- Teleport back to cell
                    SetEntityCoords(ped, sentenceData.cellCoords.x, sentenceData.cellCoords.y, sentenceData.cellCoords.z)
                    exports["lxr-police"]:Notify("You cannot leave your cell!", "error")
                end
            end
            
            -- Disable certain controls
            DisableControlAction(0, 0xF84FA74F, true) -- Draw Weapon
            DisableControlAction(0, 0x07CE1E61, true) -- Melee Attack
            DisableControlAction(0, 0xD9D0E1C0, true) -- Attack
            
            Citizen.Wait(0)
        end
    end)
end

-- Update remaining time
RegisterNetEvent("lxr-police:jail:updateTime")
AddEventHandler("lxr-police:jail:updateTime", function(remainingTime)
    if inJail then
        sentenceData.remainingTime = remainingTime
        
        -- Show time on screen every 30 seconds
        if remainingTime % 30 == 0 then
            local minutes = math.floor(remainingTime / 60)
            local seconds = remainingTime % 60
            exports["lxr-police"]:Notify("Remaining time: " .. minutes .. "m " .. seconds .. "s", "primary")
        end
    end
end)

-- Release from jail
RegisterNetEvent("lxr-police:jail:release")
AddEventHandler("lxr-police:jail:release", function(releaseCoords)
    inJail = false
    sentenceData = nil
    
    local ped = PlayerPedId()
    
    -- Teleport to release location
    SetEntityCoords(ped, releaseCoords.x, releaseCoords.y, releaseCoords.z)
    
    -- Remove blip
    if jailBlip then
        RemoveBlip(jailBlip)
        jailBlip = nil
    end
    
    exports["lxr-police"]:Notify("You have been released from prison", "success")
end)

-- Jail UI
CreateThread(function()
    while true do
        local sleep = 1000
        
        if inJail and sentenceData then
            sleep = 0
            
            -- Draw sentence info
            local minutes = math.floor(sentenceData.remainingTime / 60)
            local seconds = sentenceData.remainingTime % 60
            
            SetTextScale(0.5, 0.5)
            SetTextColor(255, 255, 255, 215)
            SetTextCentre(true)
            SetTextDropshadow(0, 0, 0, 0, 255)
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName("~r~IN JAIL~s~\nTime: " .. string.format("%02d:%02d", minutes, seconds))
            EndTextCommandDisplayText(0.5, 0.85)
            
            -- Show parole option if eligible
            if sentenceData.paroleEligible then
                SetTextScale(0.4, 0.4)
                SetTextColor(255, 255, 255, 215)
                SetTextCentre(true)
                BeginTextCommandDisplayText("STRING")
                AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ for Parole Options")
                EndTextCommandDisplayText(0.5, 0.92)
                
                if IsControlJustPressed(0, 0xCEFD9220) then -- E key
                    openParoleMenu()
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)

-- Parole menu
function openParoleMenu()
    local menu = {
        {
            label = "Request Parole (50% of fine)",
            value = "parole",
            description = "Pay 50% of your fine for early release"
        },
        {
            label = "Pay Bail (200% of fine)",
            value = "bail",
            description = "Pay double your fine for immediate release"
        },
        {
            label = "Prison Jobs",
            value = "jobs",
            description = "Work to reduce your sentence"
        }
    }
    
    -- Trigger menu (implementation depends on menu system)
    TriggerEvent("lxr-police:openMenu", {
        title = "Parole Options",
        items = menu,
        onSelect = function(item)
            if item.value == "parole" then
                TriggerServerEvent("lxr-police:jail:requestParole")
            elseif item.value == "bail" then
                TriggerServerEvent("lxr-police:jail:payBail")
            elseif item.value == "jobs" then
                openPrisonJobsMenu()
            end
        end
    })
end

-- Prison jobs menu
function openPrisonJobsMenu()
    local menu = {
        {
            label = "Cleanup Duty (-30s)",
            value = "cleanup",
            description = "Clean the prison yard"
        },
        {
            label = "Laundry Service (-45s)",
            value = "laundry",
            description = "Do laundry for the prison"
        },
        {
            label = "Kitchen Work (-60s)",
            value = "kitchen",
            description = "Help in the prison kitchen"
        }
    }
    
    TriggerEvent("lxr-police:openMenu", {
        title = "Prison Jobs",
        items = menu,
        onSelect = function(item)
            startPrisonJob(item.value)
        end
    })
end

-- Start prison job
function startPrisonJob(jobType)
    local jobDurations = {
        cleanup = 15000,
        laundry = 20000,
        kitchen = 25000
    }
    
    local duration = jobDurations[jobType] or 15000
    local ped = PlayerPedId()
    
    -- Play work animation
    RequestAnimDict("script_rc@rsc2@ig@p2")
    while not HasAnimDictLoaded("script_rc@rsc2@ig@p2") do
        Citizen.Wait(10)
    end
    TaskPlayAnim(ped, "script_rc@rsc2@ig@p2", "action_work", 8.0, -8.0, duration, 1, 0, false, false, false)
    
    exports["lxr-police"]:Progress("Working...", duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        -- Success
        ClearPedTasks(ped)
        TriggerServerEvent("lxr-police:jail:completeJob", jobType)
    end, function()
        -- Cancelled
        ClearPedTasks(ped)
        exports["lxr-police"]:Notify("Job cancelled", "error")
    end)
end

-- Export functions
exports("IsInJail", function()
    return inJail
end)

exports("GetSentenceData", function()
    return sentenceData
end)

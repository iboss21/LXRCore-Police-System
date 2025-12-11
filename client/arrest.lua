-- State tracking
local isCuffed = false
local isBeingDragged = false
local draggedBy = nil

-- RedM Animation Dictionaries
local ARREST_ANIMS = {
    cuff = {dict = "script_rc@cldn@ig@rsc2@ig@p2", anim = "action_arrest", flag = 1},
    cuffed_idle = {dict = "script_rc@prhud@ig@player_rest@1h@1@base", anim = "base", flag = 1},
    uncuff = {dict = "script_rc@cldn@ig@rsc2@ig@p2", anim = "action_search", flag = 1},
    drag = {dict = "script_rc@cldn@ig@rsc2@ig@p2", anim = "grab_drag", flag = 1},
    search = {dict = "script_rc@rsc2@ig@p2", anim = "p_search_grab_player", flag = 1}
}

-- Load animation dictionary
local function loadAnimDict(dict)
    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) and timeout < 5000 do
        Citizen.Wait(10)
        timeout = timeout + 10
    end
    return HasAnimDictLoaded(dict)
end

-- Play arrest animation
local function playArrestAnim(animData)
    local ped = PlayerPedId()
    if loadAnimDict(animData.dict) then
        TaskPlayAnim(ped, animData.dict, animData.anim, 8.0, -8.0, -1, animData.flag, 0, false, false, false)
    end
end

-- Main cuff animation loop
local function playCuffedLoop()
    CreateThread(function()
        while isCuffed do
            local ped = PlayerPedId()
            if not IsEntityPlayingAnim(ped, ARREST_ANIMS.cuffed_idle.dict, ARREST_ANIMS.cuffed_idle.anim, 3) then
                playArrestAnim(ARREST_ANIMS.cuffed_idle)
            end
            
            -- Disable controls while cuffed
            DisableControlAction(0, 0x8FFC75D6, true) -- Sprint
            DisableControlAction(0, 0xD9D0E1C0, true) -- Attack
            DisableControlAction(0, 0x07CE1E61, true) -- Melee Attack
            DisableControlAction(0, 0xF84FA74F, true) -- Draw Weapon
            DisableControlAction(0, 0xCEE12B50, true) -- Open Satchel
            DisableControlAction(0, 0x4CC0E2FE, true) -- Reload
            
            Citizen.Wait(0)
        end
    end)
end

RegisterNetEvent("lxr-police:arrest:softCuff")
AddEventHandler("lxr-police:arrest:softCuff", function(officerNetId)
    local ped = PlayerPedId()
    isCuffed = true
    
    -- Play cuffing animation
    playArrestAnim(ARREST_ANIMS.cuff)
    Citizen.Wait(2000)
    
    -- Start cuffed loop
    playCuffedLoop()
    
    -- Disable player control
    exports["lxr-police"]:SetPlayerControl(false)
    exports["lxr-police"]:Notify("You have been cuffed", "error")
end)

RegisterNetEvent("lxr-police:arrest:hardCuff")
AddEventHandler("lxr-police:arrest:hardCuff", function(officerNetId)
    local ped = PlayerPedId()
    isCuffed = true
    
    -- Play cuffing animation with more restriction
    playArrestAnim(ARREST_ANIMS.cuff)
    Citizen.Wait(2000)
    
    -- Completely freeze player
    FreezeEntityPosition(ped, true)
    playCuffedLoop()
    
    exports["lxr-police"]:Notify("You have been arrested", "error")
end)

RegisterNetEvent("lxr-police:arrest:uncuff")
AddEventHandler("lxr-police:arrest:uncuff", function()
    local ped = PlayerPedId()
    isCuffed = false
    isBeingDragged = false
    
    -- Play uncuff animation
    playArrestAnim(ARREST_ANIMS.uncuff)
    Citizen.Wait(1500)
    
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    DetachEntity(ped, true, true)
    
    exports["lxr-police"]:SetPlayerControl(true)
    exports["lxr-police"]:Notify("You have been uncuffed", "success")
end)

RegisterNetEvent("lxr-police:arrest:drag")
AddEventHandler("lxr-police:arrest:drag", function(officerNetId)
    local officer = NetworkGetEntityFromNetworkId(officerNetId)
    local ped = PlayerPedId()
    
    if not isCuffed then
        exports["lxr-police"]:Notify("You must be cuffed to be dragged", "error")
        return
    end
    
    isBeingDragged = true
    draggedBy = officer
    
    -- Attach to officer
    AttachEntityToEntity(ped, officer, GetEntityBoneIndexByName(officer, "SKEL_R_Hand"), 0.35, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    
    -- Play dragging animation
    playArrestAnim(ARREST_ANIMS.drag)
end)

RegisterNetEvent("lxr-police:arrest:stopDrag")
AddEventHandler("lxr-police:arrest:stopDrag", function()
    local ped = PlayerPedId()
    isBeingDragged = false
    draggedBy = nil
    
    DetachEntity(ped, true, false)
    ClearPedTasks(ped)
    
    if isCuffed then
        playCuffedLoop()
    end
end)

RegisterNetEvent("lxr-police:arrest:search")
AddEventHandler("lxr-police:arrest:search", function(officerNetId)
    local ped = PlayerPedId()
    
    -- Play search animation
    playArrestAnim(ARREST_ANIMS.search)
    exports["lxr-police"]:Notify("You are being searched...", "primary")
    
    Citizen.Wait(5000)
    ClearPedTasks(ped)
end)

RegisterNetEvent("lxr-police:arrest:pushIntoVehicle")
AddEventHandler("lxr-police:arrest:pushIntoVehicle", function(vehicleNetId, seat)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    local ped = PlayerPedId()
    
    if not DoesEntityExist(vehicle) then
        exports["lxr-police"]:Notify("Vehicle not found", "error")
        return
    end
    
    -- Detach if being dragged
    if isBeingDragged then
        DetachEntity(ped, true, false)
        isBeingDragged = false
    end
    
    -- Put player in vehicle
    TaskEnterVehicle(ped, vehicle, 10000, seat or 2, 1.0, 1, 0)
    exports["lxr-police"]:Notify("You have been placed in the vehicle", "primary")
end)

RegisterNetEvent("lxr-police:arrest:takeOutOfVehicle")
AddEventHandler("lxr-police:arrest:takeOutOfVehicle", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle ~= 0 then
        TaskLeaveVehicle(ped, vehicle, 0)
        Citizen.Wait(1500)
        
        if isCuffed then
            playCuffedLoop()
        end
    end
end)

-- Command to request officer assistance
RegisterCommand("surrender", function()
    local ped = PlayerPedId()
    if not isCuffed then
        -- Play surrender animation
        if loadAnimDict("script_rc@cldn@ig@rsc2@ig@p2") then
            TaskPlayAnim(ped, "script_rc@cldn@ig@rsc2@ig@p2", "surrender", 8.0, -8.0, -1, 1, 0, false, false, false)
        end
        TriggerServerEvent("lxr-police:arrest:surrender", GetPlayerServerId(PlayerId()))
    end
end)

-- Export functions
exports("IsCuffed", function()
    return isCuffed
end)

exports("IsBeingDragged", function()
    return isBeingDragged
end)
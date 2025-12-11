-- Evidence Collection System for RedM Police
local evidenceMarkers = {}
local collectingEvidence = false

-- Evidence types
local EVIDENCE_TYPES = {
    blood = {
        model = `p_bloodsplat01x`,
        label = "Blood Sample",
        collectTime = 5000,
        anim = {dict = "script_rc@rsc2@ig@p2", anim = "inspect_ground"}
    },
    casing = {
        model = `w_pistol_cartridge01`,
        label = "Bullet Casing",
        collectTime = 3000,
        anim = {dict = "script_rc@rsc2@ig@p2", anim = "pickup_object"}
    },
    fingerprint = {
        label = "Fingerprint",
        collectTime = 8000,
        anim = {dict = "script_rc@rsc2@ig@p2", anim = "examine_object"}
    },
    footprint = {
        label = "Footprint",
        collectTime = 5000,
        anim = {dict = "script_rc@rsc2@ig@p2", anim = "examine_ground"}
    },
    weapon = {
        label = "Weapon Evidence",
        collectTime = 4000,
        anim = {dict = "script_rc@rsc2@ig@p2", anim = "pickup_weapon"}
    },
    document = {
        label = "Document Evidence",
        collectTime = 3000,
        anim = {dict = "script_rc@rsc2@ig@p2", anim = "read_paper"}
    }
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

-- Create evidence marker
local function createEvidenceMarker(coords, evidenceType, data)
    local id = #evidenceMarkers + 1
    evidenceMarkers[id] = {
        coords = coords,
        type = evidenceType,
        data = data,
        timestamp = GetGameTimer()
    }
    return id
end

-- Collect evidence
local function collectEvidence(evidenceId)
    if collectingEvidence then return end
    
    local evidence = evidenceMarkers[evidenceId]
    if not evidence then return end
    
    local evidenceInfo = EVIDENCE_TYPES[evidence.type]
    if not evidenceInfo then return end
    
    collectingEvidence = true
    local ped = PlayerPedId()
    
    -- Play collection animation
    if loadAnimDict(evidenceInfo.anim.dict) then
        TaskPlayAnim(ped, evidenceInfo.anim.dict, evidenceInfo.anim.anim, 8.0, -8.0, evidenceInfo.collectTime, 1, 0, false, false, false)
    end
    
    exports["lxr-police"]:Progress("Collecting Evidence", evidenceInfo.collectTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        -- Success
        ClearPedTasks(ped)
        TriggerServerEvent("lxr-police:evidence:collect", evidenceId, evidence.type, evidence.data)
        evidenceMarkers[evidenceId] = nil
        collectingEvidence = false
    end, function()
        -- Cancelled
        ClearPedTasks(ped)
        collectingEvidence = false
    end)
end

-- Draw evidence markers
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        if exports["lxr-police"]:IsOfficer(PlayerId()) then
            for id, evidence in pairs(evidenceMarkers) do
                local distance = #(playerCoords - evidence.coords)
                
                if distance < 20.0 then
                    sleep = 0
                    -- Draw marker at evidence location
                    DrawMarker(28, evidence.coords.x, evidence.coords.y, evidence.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 200, 0, 100, false, true, 2, false, nil, nil, false)
                    
                    if distance < 2.0 then
                        -- Show help text
                        local evidenceInfo = EVIDENCE_TYPES[evidence.type]
                        SetTextScale(0.35, 0.35)
                        SetTextColor(255, 255, 255, 215)
                        SetTextCentre(true)
                        SetTextDropshadow(0, 0, 0, 0, 255)
                        BeginTextCommandDisplayText("STRING")
                        AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to collect " .. evidenceInfo.label)
                        EndTextCommandDisplayText(0.5, 0.95)
                        
                        if IsControlJustPressed(0, 0xCEFD9220) then -- E key
                            collectEvidence(id)
                        end
                    end
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)

-- Create blood evidence
RegisterNetEvent("lxr-police:evidence:createBlood")
AddEventHandler("lxr-police:evidence:createBlood", function(coords, bloodType)
    createEvidenceMarker(coords, "blood", {
        bloodType = bloodType or "Unknown",
        timestamp = os.date('%Y-%m-%d %H:%M:%S')
    })
end)

-- Create casing evidence
RegisterNetEvent("lxr-police:evidence:createCasing")
AddEventHandler("lxr-police:evidence:createCasing", function(coords, weaponType, serialNumber)
    createEvidenceMarker(coords, "casing", {
        weaponType = weaponType,
        serialNumber = serialNumber or "Unknown",
        timestamp = os.date('%Y-%m-%d %H:%M:%S')
    })
end)

-- Create fingerprint evidence
RegisterNetEvent("lxr-police:evidence:createFingerprint")
AddEventHandler("lxr-police:evidence:createFingerprint", function(coords, surface)
    createEvidenceMarker(coords, "fingerprint", {
        surface = surface or "Unknown",
        timestamp = os.date('%Y-%m-%d %H:%M:%S')
    })
end)

-- Evidence bag system
RegisterCommand("evidence-bag", function()
    if exports["lxr-police"]:IsOfficer(PlayerId()) then
        -- Check for nearby evidence
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local nearbyEvidence = {}
        
        for id, evidence in pairs(evidenceMarkers) do
            local distance = #(playerCoords - evidence.coords)
            if distance < 5.0 then
                table.insert(nearbyEvidence, {id = id, evidence = evidence, distance = distance})
            end
        end
        
        if #nearbyEvidence > 0 then
            TriggerServerEvent("lxr-police:evidence:showBagMenu", nearbyEvidence)
        else
            exports["lxr-police"]:Notify("No evidence nearby to bag", "error")
        end
    end
end)

-- Photo evidence
RegisterCommand("photo-evidence", function()
    if exports["lxr-police"]:IsOfficer(PlayerId()) then
        -- Take screenshot
        exports["lxr-police"]:Notify("Taking photo evidence...", "primary")
        
        CreateMobilePhone(0)
        CellCamActivate(true, true)
        
        CreateThread(function()
            while true do
                if IsControlJustPressed(1, 0xCEFD9220) then -- E key to capture
                    local photoData = {
                        coords = GetEntityCoords(PlayerPedId()),
                        heading = GetEntityHeading(PlayerPedId()),
                        timestamp = os.date('%Y-%m-%d %H:%M:%S')
                    }
                    
                    TriggerServerEvent("lxr-police:evidence:photoTaken", photoData)
                    exports["lxr-police"]:Notify("Photo evidence captured", "success")
                    
                    CellCamActivate(false, false)
                    DestroyMobilePhone()
                    break
                elseif IsControlJustPressed(1, 0x308588E6) then -- Backspace to cancel
                    exports["lxr-police"]:Notify("Photo cancelled", "error")
                    CellCamActivate(false, false)
                    DestroyMobilePhone()
                    break
                end
                Citizen.Wait(0)
            end
        end)
    end
end)

-- Crime scene tape
local tapeObjects = {}

RegisterCommand("crime-tape", function()
    if exports["lxr-police"]:IsOfficer(PlayerId()) then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        
        -- Create crime scene tape
        local tape = CreateObject(`p_rope01x`, coords.x, coords.y, coords.z, true, false, false)
        SetEntityHeading(tape, heading)
        PlaceObjectOnGroundProperly(tape)
        FreezeEntityPosition(tape, true)
        
        table.insert(tapeObjects, tape)
        exports["lxr-police"]:Notify("Crime scene tape placed", "success")
    end
end)

RegisterCommand("remove-tape", function()
    if exports["lxr-police"]:IsOfficer(PlayerId()) then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        for i = #tapeObjects, 1, -1 do
            local tape = tapeObjects[i]
            if DoesEntityExist(tape) then
                local tapeCoords = GetEntityCoords(tape)
                if #(coords - tapeCoords) < 3.0 then
                    DeleteObject(tape)
                    table.remove(tapeObjects, i)
                    exports["lxr-police"]:Notify("Crime scene tape removed", "success")
                    return
                end
            end
        end
        
        exports["lxr-police"]:Notify("No tape nearby to remove", "error")
    end
end)

-- Export functions
exports("CreateEvidence", function(coords, evidenceType, data)
    return createEvidenceMarker(coords, evidenceType, data)
end)

exports("GetNearbyEvidence", function(coords, radius)
    local nearby = {}
    for id, evidence in pairs(evidenceMarkers) do
        if #(coords - evidence.coords) <= radius then
            table.insert(nearby, {id = id, evidence = evidence})
        end
    end
    return nearby
end)

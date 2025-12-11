-- Wearable Items & Attachments System for The Land of Wolves RP
-- RedM bone attachment system for badges, tools, and equipment

local attachedItems = {}
local playerAttachments = {}

-- RedM Bone Indices for Attachments
local BONES = {
    -- Torso & Chest
    SKEL_Spine3 = 0x3779, -- Upper chest (badges)
    SKEL_Spine2 = 0x14410, -- Mid chest
    SKEL_Spine1 = 0x5C57, -- Lower chest
    
    -- Waist & Belt
    SKEL_Pelvis = 0x5C57, -- Hip/pelvis
    SKEL_L_Thigh = 0x5C57, -- Left hip
    SKEL_R_Thigh = 0x5C57, -- Right hip
    
    -- Hands
    SKEL_R_Hand = 0xDEAD, -- Right hand
    SKEL_L_Hand = 0x60F0, -- Left hand
    
    -- Back
    SKEL_Spine_Root = 0xE0FD, -- Lower back
    
    -- Head
    SKEL_Head = 0x796E, -- Head
}

-- Attachment Offsets for Different Items
local ATTACHMENT_CONFIGS = {
    -- BADGES (worn on chest/vest)
    ["badge_sheriff"] = {
        bone = BONES.SKEL_Spine3,
        offset = {x = 0.12, y = 0.05, z = 0.0},
        rotation = {x = 0.0, y = 0.0, z = 0.0},
        model = `p_cs_badge01x`,
        label = "Sheriff's Star"
    },
    ["badge_deputy"] = {
        bone = BONES.SKEL_Spine3,
        offset = {x = 0.12, y = 0.05, z = 0.0},
        rotation = {x = 0.0, y = 0.0, z = 0.0},
        model = `p_cs_badge02x`,
        label = "Deputy Badge"
    },
    ["badge_marshal"] = {
        bone = BONES.SKEL_Spine3,
        offset = {x = 0.12, y = 0.05, z = 0.0},
        rotation = {x = 0.0, y = 0.0, z = 0.0},
        model = `p_cs_badge03x`,
        label = "US Marshal Badge"
    },
    ["badge_ranger"] = {
        bone = BONES.SKEL_Spine3,
        offset = {x = 0.12, y = 0.05, z = 0.0},
        rotation = {x = 0.0, y = 0.0, z = 0.0},
        model = `p_cs_badge04x`,
        label = "Ranger Badge"
    },
    
    -- BELT ITEMS (worn on hip/belt)
    ["handcuffs"] = {
        bone = BONES.SKEL_Pelvis,
        offset = {x = -0.15, y = -0.05, z = 0.0},
        rotation = {x = 0.0, y = 90.0, z = 0.0},
        model = `p_cs_cuffs01x`,
        label = "Handcuffs"
    },
    ["rope_coiled"] = {
        bone = BONES.SKEL_Pelvis,
        offset = {x = 0.15, y = -0.05, z = 0.0},
        rotation = {x = 0.0, y = 0.0, z = 90.0},
        model = `p_rope01x`,
        label = "Coiled Rope"
    },
    ["baton"] = {
        bone = BONES.SKEL_Pelvis,
        offset = {x = -0.20, y = 0.0, z = 0.0},
        rotation = {x = 0.0, y = 0.0, z = 180.0},
        model = `w_melee_club01`,
        label = "Police Baton"
    },
    
    -- BACK ITEMS (worn on back)
    ["rifle_back"] = {
        bone = BONES.SKEL_Spine_Root,
        offset = {x = 0.0, y = -0.15, z = 0.05},
        rotation = {x = 0.0, y = 180.0, z = 0.0},
        model = `w_repeater_carbine01`,
        label = "Carbine (Back)"
    },
    ["shotgun_back"] = {
        bone = BONES.SKEL_Spine_Root,
        offset = {x = 0.0, y = -0.15, z = 0.05},
        rotation = {x = 0.0, y = 180.0, z = 0.0},
        model = `w_shotgun_doublebarrel01`,
        label = "Shotgun (Back)"
    },
    
    -- HAND TOOLS (held in hand)
    ["notebook"] = {
        bone = BONES.SKEL_L_Hand,
        offset = {x = 0.05, y = 0.0, z = 0.0},
        rotation = {x = 0.0, y = 0.0, z = 0.0},
        model = `p_notebook01x`,
        label = "Investigation Journal"
    },
    ["lantern"] = {
        bone = BONES.SKEL_L_Hand,
        offset = {x = 0.08, y = 0.02, z = -0.03},
        rotation = {x = 0.0, y = 0.0, z = 0.0},
        model = `p_cs_lantern01x`,
        label = "Lantern"
    },
    ["whistle"] = {
        bone = BONES.SKEL_Spine3,
        offset = {x = 0.08, y = 0.08, z = 0.0},
        rotation = {x = 0.0, y = 0.0, z = 0.0},
        model = `p_whistle01x`,
        label = "Police Whistle"
    },
    
    -- POCKET ITEMS (watch chain visible)
    ["pocket_watch"] = {
        bone = BONES.SKEL_Spine2,
        offset = {x = 0.15, y = 0.05, z = 0.0},
        rotation = {x = 0.0, y = 0.0, z = 0.0},
        model = `p_pocketwatch01x`,
        label = "Pocket Watch"
    },
}

-- Request model and wait for load
local function loadModel(model)
    if type(model) == "string" then
        model = GetHashKey(model)
    end
    
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 10000 do
        Citizen.Wait(10)
        timeout = timeout + 10
    end
    return HasModelLoaded(model)
end

-- Attach item to player
function AttachItemToPlayer(itemName)
    local ped = PlayerPedId()
    local config = ATTACHMENT_CONFIGS[itemName]
    
    if not config then
        print("No attachment config for: " .. itemName)
        return false
    end
    
    -- Remove existing attachment if present
    if playerAttachments[itemName] then
        DetachItemFromPlayer(itemName)
    end
    
    -- Load model
    if not loadModel(config.model) then
        print("Failed to load model for: " .. itemName)
        return false
    end
    
    -- Create object
    local coords = GetEntityCoords(ped)
    local object = CreateObject(config.model, coords.x, coords.y, coords.z, false, false, false)
    
    if not DoesEntityExist(object) then
        print("Failed to create object for: " .. itemName)
        return false
    end
    
    -- Attach to bone
    AttachEntityToEntity(
        object,
        ped,
        GetEntityBoneIndexByName(ped, config.bone),
        config.offset.x,
        config.offset.y,
        config.offset.z,
        config.rotation.x,
        config.rotation.y,
        config.rotation.z,
        false,
        false,
        false,
        false,
        2,
        true
    )
    
    -- Store attachment
    playerAttachments[itemName] = {
        object = object,
        config = config
    }
    
    print("Attached: " .. config.label)
    return true
end

-- Detach item from player
function DetachItemFromPlayer(itemName)
    local attachment = playerAttachments[itemName]
    
    if not attachment then
        return false
    end
    
    if DoesEntityExist(attachment.object) then
        DetachEntity(attachment.object, false, false)
        DeleteObject(attachment.object)
    end
    
    playerAttachments[itemName] = nil
    return true
end

-- Equip duty gear based on job and rank
function EquipDutyGear(job, rank)
    local ped = PlayerPedId()
    
    -- Remove all attachments first
    ClearAllAttachments()
    
    -- Attach badge based on job
    if job == "sheriff" then
        if rank >= 4 then
            AttachItemToPlayer("badge_sheriff")
        else
            AttachItemToPlayer("badge_deputy")
        end
    elseif job == "marshal" then
        AttachItemToPlayer("badge_marshal")
    elseif job == "ranger" then
        AttachItemToPlayer("badge_ranger")
    elseif job == "lawman" then
        AttachItemToPlayer("badge_deputy")
    end
    
    -- Attach belt items (all ranks)
    AttachItemToPlayer("rope_coiled")
    
    -- Rank 1+ gets handcuffs
    if rank >= 1 then
        AttachItemToPlayer("handcuffs")
    end
    
    -- Rank 2+ gets baton
    if rank >= 2 then
        AttachItemToPlayer("baton")
    end
    
    -- Rank 3+ gets pocket watch
    if rank >= 3 then
        AttachItemToPlayer("pocket_watch")
    end
    
    -- Whistle (all ranks)
    AttachItemToPlayer("whistle")
end

-- Clear all attachments
function ClearAllAttachments()
    for itemName, _ in pairs(playerAttachments) do
        DetachItemFromPlayer(itemName)
    end
    playerAttachments = {}
end

-- Toggle lantern
RegisterCommand("lantern", function()
    if playerAttachments["lantern"] then
        DetachItemFromPlayer("lantern")
        exports["lxr-police"]:Notify("Lantern put away", "primary")
    else
        AttachItemToPlayer("lantern")
        exports["lxr-police"]:Notify("Lantern equipped", "success")
    end
end)

-- Toggle notebook
RegisterCommand("notebook", function()
    if playerAttachments["notebook"] then
        DetachItemFromPlayer("notebook")
        exports["lxr-police"]:Notify("Notebook put away", "primary")
    else
        AttachItemToPlayer("notebook")
        exports["lxr-police"]:Notify("Notebook out", "success")
    end
end)

-- Duty toggle integration
RegisterNetEvent("lxr-police:duty:setState")
AddEventHandler("lxr-police:duty:setState", function(isOnDuty, job, rank)
    if isOnDuty then
        EquipDutyGear(job, rank)
        exports["lxr-police"]:Notify("Duty gear equipped", "success")
    else
        ClearAllAttachments()
        exports["lxr-police"]:Notify("Duty gear removed", "primary")
    end
end)

-- Clean up on resource stop
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        ClearAllAttachments()
    end
end)

-- Clean up on player death
AddEventHandler("gameEventTriggered", function(event, data)
    if event == "CEventNetworkEntityDamage" then
        local victim = data[1]
        if victim == PlayerPedId() then
            if IsEntityDead(victim) then
                ClearAllAttachments()
            end
        end
    end
end)

-- Exports
exports("AttachItem", AttachItemToPlayer)
exports("DetachItem", DetachItemFromPlayer)
exports("ClearAttachments", ClearAllAttachments)
exports("GetAttachments", function()
    return playerAttachments
end)

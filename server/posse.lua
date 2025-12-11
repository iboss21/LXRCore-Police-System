-- Posse System for The Land of Wolves RP
local activePosse = {}
local posseMembers = {}

-- Form a posse
RegisterNetEvent("tlw-law:posse:create")
AddEventHandler("tlw-law:posse:create", function(posseName)
    local src = source
    
    if not exports["lxr-police"]:HasPermission(src, "posse_form") then
        TriggerClientEvent("lxr-police:notify", src, "You don't have permission to form a posse", "error")
        return
    end
    
    if activePosse[src] then
        TriggerClientEvent("lxr-police:notify", src, "You're already in a posse", "error")
        return
    end
    
    local posseId = "POSSE-" .. src .. "-" .. os.time()
    
    activePosse[src] = {
        id = posseId,
        leader = src,
        name = posseName or "Lawman Posse",
        members = {src},
        created = os.time(),
        maxSize = Config.Posse.MaxPosseSize or 8
    }
    
    posseMembers[src] = posseId
    
    TriggerClientEvent("tlw-law:posse:created", src, activePosse[src])
    TriggerClientEvent("lxr-police:notify", src, "Posse formed: " .. posseName, "success")
    
    exports["lxr-police"]:logAudit(src, "posse_create", "posse", posseId, "Created posse: " .. posseName)
end)

-- Invite to posse
RegisterNetEvent("tlw-law:posse:invite")
AddEventHandler("tlw-law:posse:invite", function(targetId)
    local src = source
    
    local posse = activePosse[src]
    if not posse or posse.leader ~= src then
        TriggerClientEvent("lxr-police:notify", src, "You're not a posse leader", "error")
        return
    end
    
    if #posse.members >= posse.maxSize then
        TriggerClientEvent("lxr-police:notify", src, "Posse is full", "error")
        return
    end
    
    if posseMembers[targetId] then
        TriggerClientEvent("lxr-police:notify", src, "Player is already in a posse", "error")
        return
    end
    
    -- Send invite
    TriggerClientEvent("tlw-law:posse:inviteReceived", targetId, {
        posseId = posse.id,
        leader = src,
        name = posse.name
    })
    
    TriggerClientEvent("lxr-police:notify", src, "Invitation sent", "success")
end)

-- Accept posse invitation
RegisterNetEvent("tlw-law:posse:accept")
AddEventHandler("tlw-law:posse:accept", function(posseId)
    local src = source
    
    if posseMembers[src] then
        TriggerClientEvent("lxr-police:notify", src, "You're already in a posse", "error")
        return
    end
    
    -- Find posse
    local posse = nil
    for _, p in pairs(activePosse) do
        if p.id == posseId then
            posse = p
            break
        end
    end
    
    if not posse then
        TriggerClientEvent("lxr-police:notify", src, "Posse not found", "error")
        return
    end
    
    if #posse.members >= posse.maxSize then
        TriggerClientEvent("lxr-police:notify", src, "Posse is full", "error")
        return
    end
    
    -- Add member
    table.insert(posse.members, src)
    posseMembers[src] = posseId
    
    -- Notify all members
    for _, memberId in ipairs(posse.members) do
        TriggerClientEvent("tlw-law:posse:memberJoined", memberId, {
            playerId = src,
            posse = posse
        })
    end
    
    TriggerClientEvent("lxr-police:notify", src, "Joined posse: " .. posse.name, "success")
    
    exports["lxr-police"]:logAudit(src, "posse_join", "posse", posseId, "Joined posse")
end)

-- Leave posse
RegisterNetEvent("tlw-law:posse:leave")
AddEventHandler("tlw-law:posse:leave", function()
    local src = source
    
    local posseId = posseMembers[src]
    if not posseId then
        TriggerClientEvent("lxr-police:notify", src, "You're not in a posse", "error")
        return
    end
    
    local posse = nil
    local leaderSrc = nil
    for leaderId, p in pairs(activePosse) do
        if p.id == posseId then
            posse = p
            leaderSrc = leaderId
            break
        end
    end
    
    if not posse then return end
    
    -- Remove member
    for i, memberId in ipairs(posse.members) do
        if memberId == src then
            table.remove(posse.members, i)
            break
        end
    end
    
    posseMembers[src] = nil
    
    -- Notify remaining members
    for _, memberId in ipairs(posse.members) do
        TriggerClientEvent("tlw-law:posse:memberLeft", memberId, {
            playerId = src,
            posse = posse
        })
    end
    
    TriggerClientEvent("lxr-police:notify", src, "Left the posse", "success")
    
    -- Disband if leader left or empty
    if src == posse.leader or #posse.members == 0 then
        disbandPosse(posseId, leaderSrc)
    end
end)

-- Disband posse
RegisterNetEvent("tlw-law:posse:disband")
AddEventHandler("tlw-law:posse:disband", function()
    local src = source
    
    local posse = activePosse[src]
    if not posse or posse.leader ~= src then
        TriggerClientEvent("lxr-police:notify", src, "You're not a posse leader", "error")
        return
    end
    
    disbandPosse(posse.id, src)
end)

function disbandPosse(posseId, leaderSrc)
    local posse = activePosse[leaderSrc]
    if not posse then return end
    
    -- Notify all members
    for _, memberId in ipairs(posse.members) do
        TriggerClientEvent("tlw-law:posse:disbanded", memberId)
        posseMembers[memberId] = nil
    end
    
    activePosse[leaderSrc] = nil
    
    exports["lxr-police"]:logAudit(leaderSrc, "posse_disband", "posse", posseId, "Disbanded posse")
end

-- Posse chat
RegisterNetEvent("tlw-law:posse:chat")
AddEventHandler("tlw-law:posse:chat", function(message)
    local src = source
    
    local posseId = posseMembers[src]
    if not posseId then return end
    
    local posse = nil
    for _, p in pairs(activePosse) do
        if p.id == posseId then
            posse = p
            break
        end
    end
    
    if not posse then return end
    
    -- Send to all members
    for _, memberId in ipairs(posse.members) do
        TriggerClientEvent("tlw-law:posse:chatMessage", memberId, {
            sender = src,
            message = message
        })
    end
end)

-- Get posse info
RegisterNetEvent("tlw-law:posse:getInfo")
AddEventHandler("tlw-law:posse:getInfo", function()
    local src = source
    
    local posseId = posseMembers[src]
    if not posseId then
        TriggerClientEvent("tlw-law:posse:info", src, nil)
        return
    end
    
    local posse = nil
    for _, p in pairs(activePosse) do
        if p.id == posseId then
            posse = p
            break
        end
    end
    
    TriggerClientEvent("tlw-law:posse:info", src, posse)
end)

-- Exports
exports("IsInPosse", function(src)
    return posseMembers[src] ~= nil
end)

exports("GetPosse", function(src)
    local posseId = posseMembers[src]
    if not posseId then return nil end
    
    for _, p in pairs(activePosse) do
        if p.id == posseId then
            return p
        end
    end
    return nil
end)

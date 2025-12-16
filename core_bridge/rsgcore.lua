-- RSGCore Framework Bridge
local RSGCore = exports['rsg-core']:GetCoreObject()
local M = {}

function M.GetPlayer(src)
    if IsDuplicityVersion() then
        return RSGCore.Functions.GetPlayer(src)
    else
        return RSGCore.Functions.GetPlayerData()
    end
end

function M.IsOfficer(src)
    local player = M.GetPlayer(src)
    if not player then return false end
    local jobName = player.PlayerData and player.PlayerData.job.name or player.job
    return jobName == "police" or jobName == "sheriff" or jobName == "marshal" or jobName == "ranger"
end

function M.GetJob(src)
    local player = M.GetPlayer(src)
    if not player then return nil end
    return player.PlayerData and player.PlayerData.job or player.job
end

function M.GetGrade(src)
    local player = M.GetPlayer(src)
    if not player then return 0 end
    local job = M.GetJob(src)
    return job and job.grade and job.grade.level or 0
end

function M.HasPermission(src, perm)
    if not M.IsOfficer(src) then return false end
    local grade = M.GetGrade(src)
    -- Basic permission system, can be expanded
    local perms = {
        arrest = 0,
        mdt_view = 0,
        mdt_edit = 1,
        armory = 0,
        impound = 0,
        admin = 3,
    }
    return grade >= (perms[perm] or 0)
end

function M.Notify(src, msg, type)
    if IsDuplicityVersion() then
        TriggerClientEvent('RSGCore:Notify', src, msg, type or 'primary')
    else
        RSGCore.Functions.Notify(msg, type or 'primary')
    end
end

function M.SetPlayerControl(src, enabled)
    if not IsDuplicityVersion() then
        FreezeEntityPosition(PlayerPedId(), not enabled)
        SetPlayerControl(PlayerId(), enabled, 0)
    end
end

function M.AddMoney(src, type, amount)
    local player = M.GetPlayer(src)
    if player then
        player.Functions.AddMoney(type, amount)
    end
end

function M.RemoveMoney(src, type, amount)
    local player = M.GetPlayer(src)
    if player then
        player.Functions.RemoveMoney(type, amount)
    end
end

function M.GetInventory(src)
    local player = M.GetPlayer(src)
    if player then
        return player.PlayerData.items or {}
    end
    return {}
end

function M.AddItem(src, item, amount, metadata)
    local player = M.GetPlayer(src)
    if player then
        -- Check for rsg-inventory
        if GetResourceState('rsg-inventory') == 'started' then
            return exports['rsg-inventory']:AddItem(src, item, amount or 1, metadata or {})
        else
            -- Fallback to core inventory
            return player.Functions.AddItem(item, amount or 1, false, metadata or {})
        end
    end
    return false
end

function M.RemoveItem(src, item, amount)
    local player = M.GetPlayer(src)
    if player then
        -- Check for rsg-inventory
        if GetResourceState('rsg-inventory') == 'started' then
            return exports['rsg-inventory']:RemoveItem(src, item, amount or 1)
        else
            -- Fallback to core inventory
            return player.Functions.RemoveItem(item, amount or 1)
        end
    end
    return false
end

function M.HasItem(src, item, amount)
    local player = M.GetPlayer(src)
    if player then
        local inventory = M.GetInventory(src)
        local count = 0
        for _, invItem in pairs(inventory) do
            if invItem.name == item then
                count = count + (invItem.amount or 1)
            end
        end
        return count >= (amount or 1)
    end
    return false
end

function M.Progress(src, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    if not IsDuplicityVersion() then
        RSGCore.Functions.Progressbar(label, label, duration, useWhileDead or false, canCancel or false, {
            disableMovement = disableControls and disableControls.disableMovement or false,
            disableCarMovement = disableControls and disableControls.disableCarMovement or false,
            disableMouse = disableControls and disableControls.disableMouse or false,
            disableCombat = disableControls and disableControls.disableCombat or false,
        }, animation or {}, {}, {}, onFinish, onCancel)
    end
end

function M.Target(options)
    -- RSGCore target integration (if using rsg-target)
    if GetResourceState('rsg-target') == 'started' then
        return exports['rsg-target']:AddTargetEntity(options.entity, {
            options = options.options,
            distance = options.distance or 2.5
        })
    end
end

function M.Callback(name, cb)
    if IsDuplicityVersion() then
        RSGCore.Functions.CreateCallback(name, cb)
    else
        return RSGCore.Functions.TriggerCallback(name, cb)
    end
end

function M.Event(name, handler)
    RegisterNetEvent(name, handler)
end

function M.ServerExport(name, func)
    if IsDuplicityVersion() then
        exports(name, func)
    end
end

function M.GetOfficerDept(src)
    local job = M.GetJob(src)
    return job and job.name or nil
end

function M.logAudit(src, action, target_type, target_id, details)
    if IsDuplicityVersion() then
        TriggerEvent("lxr-police:audit:log", src, action, target_type, target_id, details)
    else
        TriggerServerEvent("lxr-police:audit:log", action, target_type, target_id, details)
    end
end

return M

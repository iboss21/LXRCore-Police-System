--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

    🐺 LXR Core - Police System

    ═══════════════════════════════════════════════════════════════════════════════
    CORE BRIDGE - LXRCORE
    ═══════════════════════════════════════════════════════════════════════════════

    Framework bridge implementation for LXR-Core. Provides the unified API
    used by all lxr-police systems for player management, job checks, inventory,
    notifications, and permission validation.

    Events follow the LXR-Core naming convention — no fake events, no guesses.

    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LXRCORE BRIDGE ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

local LXRCore  = nil
local isServer = IsDuplicityVersion()

local function getCore()
    if LXRCore then return LXRCore end
    local res = GetResourceState('lxr-core') == 'started' and 'lxr-core'
             or GetResourceState('lxrcore') == 'started' and 'lxrcore'
    if res then
        LXRCore = exports[res]:GetCoreObject()
    end
    return LXRCore
end

local M = {}

-- ══════════════════════════════════════════════════════════════
-- PLAYER
-- ══════════════════════════════════════════════════════════════

function M.GetPlayer(src)
    local core = getCore()
    if not core then return nil end
    if isServer then
        return core.Functions.GetPlayer(src)
    else
        return core.Functions.GetPlayerData()
    end
end

-- ══════════════════════════════════════════════════════════════
-- JOB & RANK
-- ══════════════════════════════════════════════════════════════

function M.GetJob(src)
    local player = M.GetPlayer(src)
    if not player then return nil end
    return player.PlayerData and player.PlayerData.job or player.job
end

function M.GetGrade(src)
    local job = M.GetJob(src)
    return job and job.grade and job.grade.level or 0
end

function M.GetOfficerDept(src)
    local job = M.GetJob(src)
    return job and job.name or nil
end

function M.IsOfficer(src)
    local job = M.GetJob(src)
    if not job then return false end
    local name = job.name or ''
    return name == 'sheriff' or name == 'marshal' or
           name == 'ranger'  or name == 'lawman'  or name == 'police'
end

-- ══════════════════════════════════════════════════════════════
-- PERMISSIONS
-- ══════════════════════════════════════════════════════════════

function M.HasPermission(src, perm)
    if not M.IsOfficer(src) then return false end
    local grade = M.GetGrade(src)
    local thresholds = {
        arrest = 0, mdt_view = 0, mdt_edit = 1,
        armory = 0, impound = 0, admin = 3,
    }
    return grade >= (thresholds[perm] or 0)
end

-- ══════════════════════════════════════════════════════════════
-- NOTIFICATIONS
-- ══════════════════════════════════════════════════════════════

function M.Notify(src, msg, msgType)
    if isServer then
        TriggerClientEvent('lxr-core:client:Notify', src, tostring(msg), msgType or 'primary')
    else
        local core = getCore()
        if core and core.Functions and core.Functions.Notify then
            core.Functions.Notify(msg, msgType or 'primary')
        end
    end
end

-- ══════════════════════════════════════════════════════════════
-- PLAYER CONTROL
-- ══════════════════════════════════════════════════════════════

function M.SetPlayerControl(src, enabled)
    if not isServer then
        FreezeEntityPosition(PlayerPedId(), not enabled)
        SetPlayerControl(PlayerId(), enabled, 0)
    end
end

-- ══════════════════════════════════════════════════════════════
-- ECONOMY
-- ══════════════════════════════════════════════════════════════

function M.AddMoney(src, moneyType, amount)
    local player = M.GetPlayer(src)
    if player and isServer then
        player.Functions.AddMoney(moneyType or 'cash', amount)
    end
end

function M.RemoveMoney(src, moneyType, amount)
    local player = M.GetPlayer(src)
    if player and isServer then
        player.Functions.RemoveMoney(moneyType or 'cash', amount)
    end
end

-- ══════════════════════════════════════════════════════════════
-- INVENTORY
-- ══════════════════════════════════════════════════════════════

function M.GetInventory(src)
    local player = M.GetPlayer(src)
    if player then
        return player.PlayerData and player.PlayerData.items or {}
    end
    return {}
end

function M.AddItem(src, item, amount, metadata)
    if isServer then
        if GetResourceState('lxr-inventory') == 'started' then
            return exports['lxr-inventory']:AddItem(src, item, amount or 1, metadata or {})
        end
        local player = M.GetPlayer(src)
        if player then
            return player.Functions.AddItem(item, amount or 1, false, metadata or {})
        end
    end
    return false
end

function M.RemoveItem(src, item, amount)
    if isServer then
        if GetResourceState('lxr-inventory') == 'started' then
            return exports['lxr-inventory']:RemoveItem(src, item, amount or 1)
        end
        local player = M.GetPlayer(src)
        if player then
            return player.Functions.RemoveItem(item, amount or 1)
        end
    end
    return false
end

function M.HasItem(src, item, amount)
    local inventory = M.GetInventory(src)
    local count = 0
    for _, invItem in pairs(inventory) do
        if invItem.name == item then
            count = count + (invItem.amount or 1)
        end
    end
    return count >= (amount or 1)
end

-- ══════════════════════════════════════════════════════════════
-- PROGRESS BAR
-- ══════════════════════════════════════════════════════════════

function M.Progress(src, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    if not isServer then
        local core = getCore()
        if core and core.Functions and core.Functions.Progressbar then
            core.Functions.Progressbar(label, label, duration, useWhileDead or false, canCancel or false, {
                disableMovement = disableControls and disableControls.disableMovement or false,
                disableCarMovement = disableControls and disableControls.disableCarMovement or false,
                disableMouse = disableControls and disableControls.disableMouse or false,
                disableCombat = disableControls and disableControls.disableCombat or false,
            }, animation or {}, {}, {}, onFinish, onCancel)
        else
            -- Fallback: simple timer
            CreateThread(function()
                Wait(duration or 3000)
                if onFinish then onFinish() end
            end)
        end
    end
end

-- ══════════════════════════════════════════════════════════════
-- TARGETING
-- ══════════════════════════════════════════════════════════════

function M.Target(options)
    if not options or not options.entity or not options.options then return end
    if GetResourceState('ox_target') == 'started' then
        return exports['ox_target']:addEntity(options.entity, options.options)
    end
end

-- ══════════════════════════════════════════════════════════════
-- CALLBACKS
-- ══════════════════════════════════════════════════════════════

function M.Callback(name, cb, ...)
    local core = getCore()
    if not core then return end
    if isServer then
        core.Functions.CreateCallback(name, cb)
    else
        return core.Functions.TriggerCallback(name, cb, ...)
    end
end

-- ══════════════════════════════════════════════════════════════
-- EVENTS / SERVER EXPORTS
-- ══════════════════════════════════════════════════════════════

function M.Event(name, handler)
    RegisterNetEvent(name, handler)
end

function M.ServerExport(name, func)
    if isServer then
        exports(name, func)
    end
end

-- ══════════════════════════════════════════════════════════════
-- AUDIT
-- ══════════════════════════════════════════════════════════════

function M.logAudit(src, action, targetType, targetId, details)
    if isServer then
        TriggerEvent('lxr-police:audit:log', src, action, targetType, targetId, details)
    else
        TriggerServerEvent('lxr-police:audit:log', action, targetType, targetId, details)
    end
end

return M
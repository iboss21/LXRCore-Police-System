--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

    🐺 LXR Core - Police System

    ═══════════════════════════════════════════════════════════════════════════════
    CORE BRIDGE - VORP CORE
    ═══════════════════════════════════════════════════════════════════════════════

    Framework bridge implementation for VORP Core. Provides the unified API
    used by all lxr-police systems for player management, job checks, inventory,
    notifications, and permission validation.

    Events follow the VORP naming convention — no fake events, no guesses.

    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ VORP CORE BRIDGE ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

local VORPcore  = nil
local VORPinv   = nil
local isServer  = IsDuplicityVersion()

-- Lazy-load VORP core & inventory exports once the resource is running
local function getCore()
    if VORPcore then return VORPcore end
    if GetResourceState('vorp_core') == 'started' then
        VORPcore = exports.vorp_core:GetCore()
    end
    return VORPcore
end

local function getInventory()
    if VORPinv then return VORPinv end
    if GetResourceState('vorp_inventory') == 'started' then
        VORPinv = exports.vorp_inventory:getInventory()
    end
    return VORPinv
end

local M = {}

-- ══════════════════════════════════════════════════════════════
-- PLAYER
-- ══════════════════════════════════════════════════════════════

function M.GetPlayer(src)
    local core = getCore()
    if not core then return nil end
    if isServer then
        return core.getUser(src)
    else
        return core.getUser()
    end
end

-- ══════════════════════════════════════════════════════════════
-- JOB & RANK
-- ══════════════════════════════════════════════════════════════

function M.GetJob(src)
    local player = M.GetPlayer(src)
    if not player then return nil end
    -- VORP stores job on the character object (same API on both sides)
    local character = player.getUsedCharacter and player.getUsedCharacter()
    if character then
        return { name = character.job, grade = { level = character.jobGrade } }
    end
    return nil
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
    return job.name == 'sheriff' or job.name == 'marshal' or
           job.name == 'ranger'  or job.name == 'lawman'  or job.name == 'police'
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
    -- VORP uses TriggerEvent('vorpcore:notify', ...) client-side
    -- and TriggerClientEvent for server → client
    if isServer then
        TriggerClientEvent('vorpcore:notify', src, tostring(msg), msgType or 'info', 3000)
    else
        TriggerEvent('vorpcore:notify', tostring(msg), msgType or 'info', 3000)
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
        -- VORP money: "money" (cash) or "gold" (premium currency)
        local vType = (moneyType == 'cash' or moneyType == 'money') and 'money' or 'gold'
        player.addCurrency(vType == 'money' and 0 or 1, amount)
    end
end

function M.RemoveMoney(src, moneyType, amount)
    local player = M.GetPlayer(src)
    if player and isServer then
        local vType = (moneyType == 'cash' or moneyType == 'money') and 'money' or 'gold'
        player.subCurrency(vType == 'money' and 0 or 1, amount)
    end
end

-- ══════════════════════════════════════════════════════════════
-- INVENTORY
-- ══════════════════════════════════════════════════════════════

function M.GetInventory(src)
    local inv = getInventory()
    if inv and isServer then
        return exports.vorp_inventory:getUserInventory(src) or {}
    end
    return {}
end

function M.AddItem(src, item, amount, metadata)
    if isServer then
        exports.vorp_inventory:addItem(src, item, amount or 1)
    end
    return true
end

function M.RemoveItem(src, item, amount)
    if isServer then
        exports.vorp_inventory:subItem(src, item, amount or 1)
    end
    return true
end

function M.HasItem(src, item, amount)
    if isServer then
        local count = exports.vorp_inventory:getItemCount(src, item) or 0
        return count >= (amount or 1)
    end
    return false
end

-- ══════════════════════════════════════════════════════════════
-- PROGRESS BAR
-- ══════════════════════════════════════════════════════════════

function M.Progress(src, label, duration, _useWhileDead, _canCancel, _controls, _animation, _prop, _propTwo, onFinish, onCancel)
    -- VORP does not ship a native progress-bar; fall back to a simple timer
    if not isServer then
        CreateThread(function()
            Wait(duration or 3000)
            if onFinish then onFinish() end
        end)
    end
end

-- ══════════════════════════════════════════════════════════════
-- TARGETING
-- ══════════════════════════════════════════════════════════════

function M.Target(_options)
    -- VORP does not ship ox_target; targeting is optional — no-op here
end

-- ══════════════════════════════════════════════════════════════
-- CALLBACKS
-- ══════════════════════════════════════════════════════════════

function M.Callback(name, cb)
    -- VORP uses its own callback system via vorp_core exports
    local core = getCore()
    if not core then return end
    if isServer then
        core.registerCallback(name, function(source, ...) cb(source, ...) end)
    else
        core.callbackCall(name, function(...) cb(...) end)
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

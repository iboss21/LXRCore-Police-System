--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

    🐺 LXR Core - Police System

    ═══════════════════════════════════════════════════════════════════════════════
    SHARED BRIDGE
    ═══════════════════════════════════════════════════════════════════════════════

    Single-file framework bridge — auto-detects LXR-Core, RSG-Core, or VORP Core
    and exposes a unified global `Bridge` table consumed directly by all client
    and server scripts. No separate folder, no intermediate exports layer.

    Priority: LXR-Core → RSG-Core → VORP Core

    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- FRAMEWORK AUTO-DETECTION
-- ═══════════════════════════════════════════════════════════════════════════════

local isServer = IsDuplicityVersion()

local configType       = type(Config.Framework)
local frameworkSetting = (configType == 'table')  and Config.Framework.Type
                      or (configType == 'string') and Config.Framework
                      or 'auto'

local framework
if frameworkSetting == 'auto' then
    if     GetResourceState('lxr-core')  == 'started' then framework = 'lxrcore'
    elseif GetResourceState('lxrcore')   == 'started' then framework = 'lxrcore'
    elseif GetResourceState('rsg-core')  == 'started' then framework = 'rsgcore'
    elseif GetResourceState('rsgcore')   == 'started' then framework = 'rsgcore'
    elseif GetResourceState('vorp_core') == 'started' then framework = 'vorp'
    elseif GetResourceState('vorp')      == 'started' then framework = 'vorp'
    else
        print('^1[lxr-police] ERROR: No supported framework detected (lxr-core / rsg-core / vorp_core).^7')
        framework = 'lxrcore' -- safe fallback so Bridge table is still populated
    end
else
    framework = frameworkSetting
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- LAZY CORE ACCESSOR HELPERS
-- ═══════════════════════════════════════════════════════════════════════════════

local _lxrCore, _rsgCore, _vorpCore, _vorpInv

local function getLXR()
    if _lxrCore then return _lxrCore end
    local res = GetResourceState('lxr-core')  == 'started' and 'lxr-core'
             or GetResourceState('lxrcore')   == 'started' and 'lxrcore'
    if res then _lxrCore = exports[res]:GetCoreObject() end
    return _lxrCore
end

local function getRSG()
    if _rsgCore then return _rsgCore end
    if GetResourceState('rsg-core') == 'started' then
        _rsgCore = exports['rsg-core']:GetCoreObject()
    elseif GetResourceState('rsgcore') == 'started' then
        _rsgCore = exports['rsgcore']:GetCoreObject()
    end
    return _rsgCore
end

local function getVORP()
    if _vorpCore then return _vorpCore end
    if GetResourceState('vorp_core') == 'started' then
        _vorpCore = exports.vorp_core:GetCore()
    end
    return _vorpCore
end

local function getVORPInv()
    if _vorpInv then return _vorpInv end
    if GetResourceState('vorp_inventory') == 'started' then
        _vorpInv = exports.vorp_inventory:getInventory()
    end
    return _vorpInv
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- GLOBAL BRIDGE TABLE
-- ═══════════════════════════════════════════════════════════════════════════════

Bridge = {}

-- ──────────────────────────────────────────────────────────────────────────────
-- PLAYER
-- ──────────────────────────────────────────────────────────────────────────────

if framework == 'lxrcore' then
    function Bridge.GetPlayer(src)
        local core = getLXR()
        if not core then return nil end
        if isServer then
            return core.Functions.GetPlayer(src)
        else
            return core.Functions.GetPlayerData()
        end
    end

elseif framework == 'rsgcore' then
    function Bridge.GetPlayer(src)
        local core = getRSG()
        if not core then return nil end
        if isServer then
            return core.Functions.GetPlayer(src)
        else
            return core.Functions.GetPlayerData()
        end
    end

else -- vorp
    function Bridge.GetPlayer(src)
        local core = getVORP()
        if not core then return nil end
        if isServer then return core.getUser(src) else return core.getUser() end
    end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- JOB & RANK
-- ──────────────────────────────────────────────────────────────────────────────

if framework == 'vorp' then
    function Bridge.GetJob(src)
        local player = Bridge.GetPlayer(src)
        if not player then return nil end
        local character = player.getUsedCharacter and player.getUsedCharacter()
        if character then
            return { name = character.job, grade = { level = character.jobGrade } }
        end
        return nil
    end
else
    function Bridge.GetJob(src)
        local player = Bridge.GetPlayer(src)
        if not player then return nil end
        return player.PlayerData and player.PlayerData.job or player.job
    end
end

function Bridge.GetGrade(src)
    local job = Bridge.GetJob(src)
    return job and job.grade and job.grade.level or 0
end

function Bridge.GetOfficerDept(src)
    local job = Bridge.GetJob(src)
    return job and job.name or nil
end

function Bridge.IsOfficer(src)
    local job = Bridge.GetJob(src)
    if not job then return false end
    local name = job.name or ''
    return name == 'sheriff' or name == 'marshal' or
           name == 'ranger'  or name == 'lawman'  or name == 'police'
end

-- ──────────────────────────────────────────────────────────────────────────────
-- PERMISSIONS
-- ──────────────────────────────────────────────────────────────────────────────

function Bridge.HasPermission(src, perm)
    if not Bridge.IsOfficer(src) then return false end
    local grade = Bridge.GetGrade(src)
    local thresholds = {
        arrest = 0, mdt_view = 0, mdt_edit = 1,
        armory = 0, impound = 0, admin = 3,
    }
    return grade >= (thresholds[perm] or 0)
end

-- ──────────────────────────────────────────────────────────────────────────────
-- NOTIFICATIONS
-- ──────────────────────────────────────────────────────────────────────────────

if framework == 'lxrcore' then
    function Bridge.Notify(src, msg, msgType)
        if isServer then
            TriggerClientEvent('lxr-core:client:Notify', src, tostring(msg), msgType or 'primary')
        else
            local core = getLXR()
            if core and core.Functions and core.Functions.Notify then
                core.Functions.Notify(msg, msgType or 'primary')
            end
        end
    end

elseif framework == 'rsgcore' then
    function Bridge.Notify(src, msg, msgType)
        if isServer then
            TriggerClientEvent('RSGCore:Notify', src, msg, msgType or 'primary')
        else
            local core = getRSG()
            if core then core.Functions.Notify(msg, msgType or 'primary') end
        end
    end

else -- vorp
    function Bridge.Notify(src, msg, msgType)
        if isServer then
            TriggerClientEvent('vorpcore:notify', src, tostring(msg), msgType or 'info', 3000)
        else
            TriggerEvent('vorpcore:notify', tostring(msg), msgType or 'info', 3000)
        end
    end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- PLAYER CONTROL
-- ──────────────────────────────────────────────────────────────────────────────

function Bridge.SetPlayerControl(src, enabled)
    if not isServer then
        FreezeEntityPosition(PlayerPedId(), not enabled)
        SetPlayerControl(PlayerId(), enabled, 0)
    end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- ECONOMY
-- ──────────────────────────────────────────────────────────────────────────────

if framework == 'vorp' then
    function Bridge.AddMoney(src, moneyType, amount)
        local player = Bridge.GetPlayer(src)
        if player and isServer then
            local vType = (moneyType == 'cash' or moneyType == 'money') and 0 or 1
            player.addCurrency(vType, amount)
        end
    end

    function Bridge.RemoveMoney(src, moneyType, amount)
        local player = Bridge.GetPlayer(src)
        if player and isServer then
            local vType = (moneyType == 'cash' or moneyType == 'money') and 0 or 1
            player.subCurrency(vType, amount)
        end
    end
else
    function Bridge.AddMoney(src, moneyType, amount)
        local player = Bridge.GetPlayer(src)
        if player and isServer then
            player.Functions.AddMoney(moneyType or 'cash', amount)
        end
    end

    function Bridge.RemoveMoney(src, moneyType, amount)
        local player = Bridge.GetPlayer(src)
        if player and isServer then
            player.Functions.RemoveMoney(moneyType or 'cash', amount)
        end
    end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- INVENTORY
-- ──────────────────────────────────────────────────────────────────────────────

if framework == 'lxrcore' then
    function Bridge.GetInventory(src)
        local player = Bridge.GetPlayer(src)
        return player and (player.PlayerData and player.PlayerData.items or {}) or {}
    end

    function Bridge.AddItem(src, item, amount, metadata)
        if not isServer then return false end
        if GetResourceState('lxr-inventory') == 'started' then
            return exports['lxr-inventory']:AddItem(src, item, amount or 1, metadata or {})
        end
        local player = Bridge.GetPlayer(src)
        return player and player.Functions.AddItem(item, amount or 1, false, metadata or {}) or false
    end

    function Bridge.RemoveItem(src, item, amount)
        if not isServer then return false end
        if GetResourceState('lxr-inventory') == 'started' then
            return exports['lxr-inventory']:RemoveItem(src, item, amount or 1)
        end
        local player = Bridge.GetPlayer(src)
        return player and player.Functions.RemoveItem(item, amount or 1) or false
    end

elseif framework == 'rsgcore' then
    function Bridge.GetInventory(src)
        local player = Bridge.GetPlayer(src)
        return player and (player.PlayerData and player.PlayerData.items or {}) or {}
    end

    function Bridge.AddItem(src, item, amount, metadata)
        if not isServer then return false end
        if GetResourceState('rsg-inventory') == 'started' then
            return exports['rsg-inventory']:AddItem(src, item, amount or 1, metadata or {})
        end
        local player = Bridge.GetPlayer(src)
        return player and player.Functions.AddItem(item, amount or 1, false, metadata or {}) or false
    end

    function Bridge.RemoveItem(src, item, amount)
        if not isServer then return false end
        if GetResourceState('rsg-inventory') == 'started' then
            return exports['rsg-inventory']:RemoveItem(src, item, amount or 1)
        end
        local player = Bridge.GetPlayer(src)
        return player and player.Functions.RemoveItem(item, amount or 1) or false
    end

else -- vorp
    function Bridge.GetInventory(src)
        if isServer then
            return exports.vorp_inventory:getUserInventory(src) or {}
        end
        return {}
    end

    function Bridge.AddItem(src, item, amount, _metadata)
        if isServer then exports.vorp_inventory:addItem(src, item, amount or 1) end
        return true
    end

    function Bridge.RemoveItem(src, item, amount)
        if isServer then exports.vorp_inventory:subItem(src, item, amount or 1) end
        return true
    end
end

function Bridge.HasItem(src, item, amount)
    if framework == 'vorp' then
        if not isServer then return false end
        local count = exports.vorp_inventory:getItemCount(src, item) or 0
        return count >= (amount or 1)
    end
    local inventory = Bridge.GetInventory(src)
    local count = 0
    for _, invItem in pairs(inventory) do
        if invItem.name == item then
            count = count + (invItem.amount or 1)
        end
    end
    return count >= (amount or 1)
end

-- ──────────────────────────────────────────────────────────────────────────────
-- PROGRESS BAR
-- ──────────────────────────────────────────────────────────────────────────────

if framework == 'lxrcore' then
    function Bridge.Progress(src, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
        if isServer then return end
        local core = getLXR()
        if core and core.Functions and core.Functions.Progressbar then
            core.Functions.Progressbar(label, label, duration, useWhileDead or false, canCancel or false, {
                disableMovement    = disableControls and disableControls.disableMovement    or false,
                disableCarMovement = disableControls and disableControls.disableCarMovement or false,
                disableMouse       = disableControls and disableControls.disableMouse       or false,
                disableCombat      = disableControls and disableControls.disableCombat      or false,
            }, animation or {}, {}, {}, onFinish, onCancel)
        else
            CreateThread(function() Wait(duration or 3000); if onFinish then onFinish() end end)
        end
    end

elseif framework == 'rsgcore' then
    function Bridge.Progress(src, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
        if isServer then return end
        local core = getRSG()
        if core then
            core.Functions.Progressbar(label, label, duration, useWhileDead or false, canCancel or false, {
                disableMovement    = disableControls and disableControls.disableMovement    or false,
                disableCarMovement = disableControls and disableControls.disableCarMovement or false,
                disableMouse       = disableControls and disableControls.disableMouse       or false,
                disableCombat      = disableControls and disableControls.disableCombat      or false,
            }, animation or {}, {}, {}, onFinish, onCancel)
        else
            CreateThread(function() Wait(duration or 3000); if onFinish then onFinish() end end)
        end
    end

else -- vorp (no native progress bar)
    function Bridge.Progress(src, label, duration, _uwd, _cc, _dc, _anim, _p, _p2, onFinish, onCancel)
        if not isServer then
            CreateThread(function() Wait(duration or 3000); if onFinish then onFinish() end end)
        end
    end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- TARGETING
-- ──────────────────────────────────────────────────────────────────────────────

if framework == 'rsgcore' then
    function Bridge.Target(options)
        if not options or not options.entity or not options.options then return end
        if GetResourceState('rsg-target') == 'started' then
            return exports['rsg-target']:AddTargetEntity(options.entity, {
                options  = options.options,
                distance = options.distance or 2.5,
            })
        end
    end
else
    function Bridge.Target(options)
        if not options or not options.entity or not options.options then return end
        if GetResourceState('ox_target') == 'started' then
            return exports['ox_target']:addEntity(options.entity, options.options)
        end
    end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- CALLBACKS
-- ──────────────────────────────────────────────────────────────────────────────

if framework == 'lxrcore' then
    function Bridge.Callback(name, cb, ...)
        local core = getLXR()
        if not core then return end
        if isServer then
            core.Functions.CreateCallback(name, cb)
        else
            return core.Functions.TriggerCallback(name, cb, ...)
        end
    end

elseif framework == 'rsgcore' then
    function Bridge.Callback(name, cb, ...)
        local core = getRSG()
        if not core then return end
        if isServer then
            core.Functions.CreateCallback(name, cb)
        else
            return core.Functions.TriggerCallback(name, cb, ...)
        end
    end

else -- vorp
    function Bridge.Callback(name, cb, ...)
        local core = getVORP()
        if not core then return end
        if isServer then
            core.registerCallback(name, function(source, ...) cb(source, ...) end)
        else
            core.callbackCall(name, function(...) cb(...) end)
        end
    end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- EVENTS / SERVER EXPORTS
-- ──────────────────────────────────────────────────────────────────────────────

function Bridge.Event(name, handler)
    RegisterNetEvent(name, handler)
end

function Bridge.ServerExport(name, func)
    if isServer then exports(name, func) end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- AUDIT
-- ──────────────────────────────────────────────────────────────────────────────

function Bridge.logAudit(src, action, targetType, targetId, details)
    if isServer then
        TriggerEvent('lxr-police:audit:log', src, action, targetType, targetId, details)
    else
        TriggerServerEvent('lxr-police:audit:log', action, targetType, targetId, details)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════

print(('^2[lxr-police] Bridge loaded — framework: %s ✓^7'):format(framework))

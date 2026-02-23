--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝
    ██████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

    🐺 LXR Core - Police System

    ═══════════════════════════════════════════════════════════════════════════════
    CORE BRIDGE - INITIALIZATION
    ═══════════════════════════════════════════════════════════════════════════════

    Auto-detects and initializes the correct framework bridge.
    Priority: LXR-Core → RSG-Core → VORP Core → error (halts resource).

    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK AUTO-DETECTION
-- ═══════════════════════════════════════════════════════════════════════════════

local framework = nil

-- Support both table-form (Config.Framework.Type) and string-form (Config.Framework)
local configType = type(Config.Framework)
local frameworkSetting = (configType == 'table') and Config.Framework.Type
                       or (configType == 'string') and Config.Framework
                       or 'auto'

if frameworkSetting == 'auto' then
    -- Priority: LXR-Core > RSG-Core > VORP Core
    if GetResourceState('lxr-core') == 'started' then
        framework = 'lxrcore'
    elseif GetResourceState('lxrcore') == 'started' then
        framework = 'lxrcore'
    elseif GetResourceState('rsg-core') == 'started' then
        framework = 'rsgcore'
    elseif GetResourceState('rsgcore') == 'started' then
        framework = 'rsgcore'
    elseif GetResourceState('vorp_core') == 'started' then
        framework = 'vorp'
    elseif GetResourceState('vorp') == 'started' then
        framework = 'vorp'
    else
        print('^1[lxr-police] ERROR: No supported framework detected (lxr-core / rsg-core / vorp_core). Halting bridge init.^7')
        framework = 'lxrcore' -- safe fallback so exports don't hard-crash
    end
else
    framework = frameworkSetting
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- LOAD BRIDGE
-- ═══════════════════════════════════════════════════════════════════════════════

local bridge = {}

if framework == 'lxrcore' then
    bridge = require('core_bridge.lxrcore')
elseif framework == 'rsgcore' then
    bridge = require('core_bridge.rsgcore')
elseif framework == 'vorp' then
    bridge = require('core_bridge.vorp')
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- REGISTER EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════

exports('GetPlayer',        bridge.GetPlayer)
exports('IsOfficer',        bridge.IsOfficer)
exports('Notify',           bridge.Notify)
exports('HasPermission',    bridge.HasPermission)
exports('GetJob',           bridge.GetJob)
exports('GetGrade',         bridge.GetGrade)
exports('SetPlayerControl', bridge.SetPlayerControl)
exports('AddMoney',         bridge.AddMoney)
exports('RemoveMoney',      bridge.RemoveMoney)
exports('GetInventory',     bridge.GetInventory)
exports('Progress',         bridge.Progress)
exports('Target',           bridge.Target)
exports('Callback',         bridge.Callback)
exports('Event',            bridge.Event)
exports('ServerExport',     bridge.ServerExport)
exports('GetOfficerDept',   bridge.GetOfficerDept)
exports('logAudit',         bridge.logAudit)

print(('^2[lxr-police] Core bridge loaded — framework: %s ✓^7'):format(framework))

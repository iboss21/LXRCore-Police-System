--[[
    ██╗     ██╗  ██╗██████╗  ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
                                                              
    🐺 LXR Core - Police System
    "Professional Law Enforcement & Management System"
    
    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════

    Server:      The Land of Wolves 🐺
    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io

    ═══════════════════════════════════════════════════════════════════════════════

    Version:     1.0.0

    FX MANIFEST
    All resource configuration and file loading for the LXRCore Police System.
    Compatible with RSGCore / LXRCore frameworks for RedM.
    
    Modify values below to customize The Land of Wolves police experience.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

fx_version 'cerulean'
game       'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'

name        'lxr-police'
author      'iBoss21 / The Lux Empire | wolves.land'
description 'The World\'s Most Advanced & Authentic 1899 Wild West Law Enforcement System for RedM'
version     '1.0.0'

-- UI Files
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/images/**/*',
}

-- Shared Configuration (single supreme config — all systems in one file)
shared_scripts {
    'config/config.lua',
    'config/locales/en.lua',
    'shared/bridge.lua',
}

-- Client Scripts
client_scripts {
    'client/arrest.lua',
    'client/jail.lua',
    'client/jail_client.lua',
    'client/dispatch.lua',
    'client/citations.lua',
    'client/impound.lua',
    'client/duty.lua',
    'client/ui_bridge.lua',
    'client/evidence.lua',
    'client/evidence_collection.lua',
    'client/attachments.lua',
    'client/journal.lua',          -- NEW: Period-accurate journal system
    -- 'client/mdt_client.lua',     -- DISABLED: Modern MDT replaced by journal
    'client/k9.lua',
}

-- Server Scripts
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/versionchecker.lua',
    'server/duty_system.lua',
    'server/anti_abuse.lua',
    'server/warrant_system.lua',
    'server/arrest.lua',
    'server/audit.lua',
    'server/citations.lua',
    'server/dispatch.lua',
    'server/journal_ledger.lua',  -- NEW: Period-accurate journal/ledger system
    -- 'server/mdt.lua',           -- DISABLED: Replaced by journal_ledger.lua
    -- 'server/mdt_enhanced.lua',  -- DISABLED: Replaced by journal_ledger.lua
    'server/permissions.lua',
    'server/players.lua',
    -- 'server/profiler.lua',      -- DISABLED: Performance overhead (enable only for debugging)
    'server/evidence_management.lua',
    'server/bounty.lua',
    'server/posse.lua',
    'server/telegraph.lua',
    'server/k9.lua',
    'server/physical_items.lua',
}

-- Exports
exports {
    'IsOfficer',
    'GetOfficerDept',
    'IsCuffed',
    'IsBeingDragged',
    'IsInJail',
}

server_exports {
    'IsOfficer',
    'GetOfficerDept',
    'HasPermission',
    'GetPlayer',
    'IsCuffed',
    'GetArrestState',
    'IsInJail',
    'GetPrisonerData',
    'GetEvidence',
    'CreateEvidence',
}

-- Dependencies
dependencies {
    'oxmysql',
}

-- Optional Dependencies (framework auto-detected at runtime)
optional_dependencies {
    'lxr-core',
    'lxr-inventory',
    'rsg-core',
    'rsg-target',
    'rsg-inventory',
    'vorp_core',
    'vorp_inventory',
    'ox_target',
}

-- Provide
provide 'qb-policejob'  -- Compatibility layer
provide 'rsg-lawman'    -- Replaces old lawman script
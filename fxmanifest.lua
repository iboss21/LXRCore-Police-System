--[[
    ██╗     ██╗  ██╗██████╗  ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
                                                              
    🐺 The Land of Wolves - LXRCore Police System
    "Professional Law Enforcement & Management System"
    
    Version: 1.0.0
    Author: iBoss
    Website: www.wolves.land
    Server: The Land of Wolves
    
    FX MANIFEST
    All resource configuration and file loading for the LXRCore Police System.
    Compatible with RSGCore / LXRCore frameworks for RedM.
    
    Modify values below to customize The Land of Wolves police experience.
    
    © 2026 iBoss | The Land of Wolves | www.wolves.land
    License: All Rights Reserved
]]

fx_version 'cerulean'
games { 'rdr3' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'

author 'The Land of Wolves RP Team'
description 'The World\'s Most Advanced & Authentic 1899 Wild West Law Enforcement System for RedM'
version '1.0.0'

-- UI Files
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/images/**/*',
}

-- Shared Configuration
shared_scripts {
    'config/config.lua',
    'config/config_main.lua',
    'config/config_advanced.lua',
    'config/wearable_items.lua',
    'config/physical_items.lua',
    'config/k9_system.lua',
    'config/statutes.lua',
    'config/locales/en.lua',
}

-- Client Scripts
client_scripts {
    'core_bridge/init.lua',
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
    'core_bridge/init.lua',
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
    'rsg-core',  -- or 'lxrcore'
    'oxmysql',
}

-- Optional Dependencies
optional_dependencies {
    'rsg-target',
    'rsg-inventory',
}

-- Provide
provide 'qb-policejob'  -- Compatibility layer
provide 'rsg-lawman'    -- Replaces old lawman script
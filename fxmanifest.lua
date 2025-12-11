--[[
    ╔════════════════════════════════════════════════════════════╗
    ║  The Land of Wolves RP - Law Enforcement System           ║
    ║  1899 Wild West Authentic Police System for RedM          ║
    ║  www.wolves.land                                          ║
    ║                                                            ║
    ║  Version: 1.0.0                                           ║
    ║  Author: The Land of Wolves RP Team                       ║
    ║  Framework: RSGCore / LXRCore                             ║
    ║  Game: RedM (Red Dead Redemption 2)                       ║
    ╚════════════════════════════════════════════════════════════╝
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
}

-- Server Scripts
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'core_bridge/init.lua',
    'server/arrest.lua',
    'server/audit.lua',
    'server/citations.lua',
    'server/dispatch.lua',
    'server/mdt.lua',
    'server/permissions.lua',
    'server/players.lua',
    'server/profiler.lua',
    'server/evidence_management.lua',
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
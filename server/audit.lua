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

    SERVER SCRIPT - AUDIT LOG
    Security and audit logging for all police actions. Tracks arrests, releases,
    evidence handling, warrant actions, and administrative changes.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

RegisterNetEvent("lxr-police:audit:log")
AddEventHandler("lxr-police:audit:log", function(src, action, target_type, target_id, details)
    local user_id = Bridge.GetPlayer(src).identifier
    MySQL.Async.execute("INSERT INTO mdt_audit (user_id, action, target_type, target_id, details) VALUES (@uid, @act, @type, @tid, @det)", {
        ['@uid']=user_id, ['@act']=action, ['@type']=target_type, ['@tid']=target_id, ['@det']=details
    })
    -- Optionally send to webhook
end)
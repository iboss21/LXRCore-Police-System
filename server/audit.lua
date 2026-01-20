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
    
    SERVER SCRIPT - AUDIT LOG
    Security and audit logging for all police actions. Tracks arrests, releases,
    evidence handling, warrant actions, and administrative changes.
    
    © 2026 iBoss | The Land of Wolves | www.wolves.land
    License: All Rights Reserved
]]

RegisterNetEvent("lxr-police:audit:log")
AddEventHandler("lxr-police:audit:log", function(src, action, target_type, target_id, details)
    local user_id = exports["lxr-police"]:GetPlayer(src).identifier
    MySQL.Async.execute("INSERT INTO mdt_audit (user_id, action, target_type, target_id, details) VALUES (@uid, @act, @type, @tid, @det)", {
        ['@uid']=user_id, ['@act']=action, ['@type']=target_type, ['@tid']=target_id, ['@det']=details
    })
    -- Optionally send to webhook
end)
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

    SERVER SCRIPT - CITATIONS
    Citation issuance system. Handles statute checks, database storage,
    and audit logging for all citations issued by law enforcement.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- Server: Statute check, DB insert, audit

RegisterNetEvent("lxr-police:citations:issue")
AddEventHandler("lxr-police:citations:issue", function(target, statute, amount)
    local src = source
    if not Bridge.HasPermission(src, "citation") then
        Bridge.logAudit(src, "unauthorized_citation", "player", target, "Denied")
        return
    end
    MySQL.Async.execute("INSERT INTO leo_citations (citizen_id, statute, amount, issued_by) VALUES (@cid, @stat, @amt, @off)", {
        ["@cid"] = target, ["@stat"] = statute, ["@amt"] = amount, ["@off"] = src
    })
    Bridge.logAudit(src, "citation", "player", target, "Issued")
    TriggerClientEvent("lxr-police:notifyCitation", src)
end)
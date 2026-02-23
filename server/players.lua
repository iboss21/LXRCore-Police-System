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

    SERVER SCRIPT - PLAYER MANAGEMENT
    Duty roster, last-seen tracking, and officer status management.
    Handles clock-in/clock-out and duty state persistence.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- Server: Duty roster, last-seen, audit log

RegisterNetEvent("lxr-police:duty:clockin")
AddEventHandler("lxr-police:duty:clockin", function(station)
    local src = source
    local player = Bridge.GetPlayer(src)
    if player and Bridge.IsOfficer(src) then
        local dept, grade = player.job, player.job_grade
        MySQL.Async.execute("UPDATE leo_roster SET last_seen=NOW(), department=@dept, grade=@grade WHERE officer_id=@id", {
            ["@id"] = player.identifier, ["@dept"] = dept, ["@grade"] = grade
        })
        Bridge.logAudit(src, "clockin", "station", station, "Duty start")
        TriggerClientEvent("lxr-police:duty:setState", src, true, dept, grade)
    else
        DropPlayer(src, "Unauthorized duty attempt")
    end
end)
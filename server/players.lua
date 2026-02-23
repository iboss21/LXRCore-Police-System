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
    
    SERVER SCRIPT - PLAYER MANAGEMENT
    Duty roster, last-seen tracking, and officer status management.
    Handles clock-in/clock-out and duty state persistence.
    
    © 2026 iBoss | The Land of Wolves | www.wolves.land
    License: All Rights Reserved
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
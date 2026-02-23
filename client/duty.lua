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

    CLIENT SCRIPT - DUTY MANAGEMENT
    Station check-in/check-out system, duty status tracking, and uniform management.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

local stations = Config.Stations

Citizen.CreateThread(function()
    for k, v in pairs(stations) do
        while true do
            Citizen.Wait(1)
            local playerCoords = GetEntityCoords(PlayerPedId())
            if #(playerCoords - v.coords) < 2.0 then
                -- Show interaction prompt using RedM natives
                if IsControlJustReleased(0, 38) then -- E
                    TriggerServerEvent("lxr-police:duty:clockin", k)
                end
            end
        end
    end
end)

RegisterNetEvent("lxr-police:duty:setState")
AddEventHandler("lxr-police:duty:setState", function(isOnDuty, dept, grade)
    -- Change outfit via RedM native scenario
end)
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
    
    SERVER SCRIPT - PROFILER (DEBUG)
    Performance monitoring and memory tracking for debugging purposes.
    NOTE: Should be disabled in production for optimal performance.
    
    © 2026 iBoss | The Land of Wolves | www.wolves.land
    License: All Rights Reserved
]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        -- CPU monitoring removed: GetResourceCPUUsage doesn't exist in FiveM/RedM
        -- Memory monitoring replaced: GetResourceMemoryUsage replaced with collectgarbage
        local mem = collectgarbage("count") / 1024 -- collectgarbage returns memory in KB, divide by 1024 to convert to MB
        print(string.format("[PROFILER] Police System - Total Lua Memory: %.2f MB", mem))
    end
end)
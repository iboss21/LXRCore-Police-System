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
    DISABLED in production for optimal performance (0.00ms target).
    Enable only when debugging performance issues.
    
    © 2026 iBoss | The Land of Wolves | www.wolves.land
    License: All Rights Reserved
]]

-- PROFILER DISABLED FOR PRODUCTION PERFORMANCE
-- Uncomment below to enable debug monitoring (runs every 60 seconds instead of 10)

--[[
Citizen.CreateThread(function()
    while Config.Debug do  -- Only runs if Config.Debug = true
        Citizen.Wait(60000)  -- Changed from 10000ms to 60000ms (1 minute)
        local mem = collectgarbage("count") / 1024
        print(string.format("[PROFILER] LXRCore Police - Lua Memory: %.2f MB", mem))
    end
end)
]]
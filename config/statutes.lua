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
    
    CONFIGURATION FILE - STATUTES
    1899 Wild West law statutes and crime definitions. All crimes, fines,
    and jail times are configurable for period-accurate law enforcement.
    
    Modify values below to customize The Land of Wolves police experience.
    
    © 2026 iBoss | The Land of Wolves | www.wolves.land
    License: All Rights Reserved
]]

Statutes = {
    ["DISORDERLY_CONDUCT"] = {
        label = "Disorderly Conduct",
        category = "Misdemeanor",
        fine = 25,
        jail_min = 0,
        jail_max = 5,
        contraband = false,
        version = 1,
    },
    ["HORSE_THEFT"] = {
        label = "Horse Theft",
        category = "Felony",
        fine = 200,
        jail_min = 15,
        jail_max = 30,
        contraband = true,
        version = 1,
    },
    -- Add more statutes as needed
}
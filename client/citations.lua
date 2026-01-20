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
    
    CLIENT SCRIPT - CITATIONS
    Citation issuance UI with statute selection, fine amounts, and signature collection.
    
    © 2026 iBoss | The Land of Wolves | www.wolves.land
    License: All Rights Reserved
]]

RegisterCommand("issuecitation", function(source, args)
    local target = tonumber(args[1])
    SetNuiFocus(true, true)
    SendNUIMessage({type="openCitation", target=target})
end)

RegisterNUICallback("submitCitation", function(data)
    TriggerServerEvent("lxr-police:citations:issue", data.target, data.statute, data.amount)
end)
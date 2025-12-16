-- Enhanced MDT Client Script
-- Handles UI interactions and communication with server

local mdtOpen = false

-- ============================================================================
-- NUI CALLBACKS
-- ============================================================================

-- Close MDT
RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({action = 'close'})
    mdtOpen = false
    cb('ok')
end)

-- Search citizens
RegisterNUICallback('searchCitizens', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:searchCitizens', data)
    cb('ok')
end)

-- Get citizen profile
RegisterNUICallback('getCitizenProfile', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:getCitizenProfile', data.citizenId)
    cb('ok')
end)

-- Save citizen
RegisterNUICallback('saveCitizen', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:saveCitizen', data)
    cb('ok')
end)

-- Add citizen file
RegisterNUICallback('addCitizenFile', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:addCitizenFile', data)
    cb('ok')
end)

-- Delete citizen file
RegisterNUICallback('deleteCitizenFile', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:deleteCitizenFile', data.fileId)
    cb('ok')
end)

-- Get reports
RegisterNUICallback('getReports', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:getReports', data)
    cb('ok')
end)

-- Create report
RegisterNUICallback('createReport', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:createReport', data)
    cb('ok')
end)

-- Update report
RegisterNUICallback('updateReport', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:updateReport', data.reportId, data)
    cb('ok')
end)

-- Delete report
RegisterNUICallback('deleteReport', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:deleteReport', data.reportId)
    cb('ok')
end)

-- Create arrest
RegisterNUICallback('createArrest', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:createArrest', data)
    cb('ok')
end)

-- Get arrests
RegisterNUICallback('getArrests', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:getArrests', data.citizenId)
    cb('ok')
end)

-- Update arrest
RegisterNUICallback('updateArrest', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:updateArrest', data.arrestId, data)
    cb('ok')
end)

-- Create warrant
RegisterNUICallback('createWarrant', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:createWarrant', data)
    cb('ok')
end)

-- Execute warrant
RegisterNUICallback('executeWarrant', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:executeWarrant', data.warrantId)
    cb('ok')
end)

-- Cancel warrant
RegisterNUICallback('cancelWarrant', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:cancelWarrant', data.warrantId)
    cb('ok')
end)

-- Create wanted poster
RegisterNUICallback('createWantedPoster', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:createWantedPoster', data)
    cb('ok')
end)

-- Get wanted posters
RegisterNUICallback('getWantedPosters', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:getWantedPosters', data.status)
    cb('ok')
end)

-- Mark wanted as captured
RegisterNUICallback('markCaptured', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:captureWanted', data.posterId)
    cb('ok')
end)

-- Create case
RegisterNUICallback('createCase', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:createCase', data)
    cb('ok')
end)

-- Update case status
RegisterNUICallback('updateCaseStatus', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:updateCaseStatus', data.caseId, data.status)
    cb('ok')
end)

-- Vehicle lookup
RegisterNUICallback('vehicleLookup', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:vehicleLookup', data.plate)
    cb('ok')
end)

-- Register vehicle
RegisterNUICallback('registerVehicle', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:registerVehicle', data)
    cb('ok')
end)

-- Create BOLO
RegisterNUICallback('createBOLO', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:createBOLO', data)
    cb('ok')
end)

-- Get BOLOs
RegisterNUICallback('getBOLOs', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:getBOLOs')
    cb('ok')
end)

-- Resolve BOLO
RegisterNUICallback('resolveBOLO', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:resolveBOLO', data.boloId)
    cb('ok')
end)

-- Get dashboard stats
RegisterNUICallback('getDashboardStats', function(data, cb)
    TriggerServerEvent('lxr-police:mdt:getDashboardStats')
    cb('ok')
end)

-- ============================================================================
-- SERVER EVENT HANDLERS
-- ============================================================================

-- Search results
RegisterNetEvent('lxr-police:mdt:searchResults')
AddEventHandler('lxr-police:mdt:searchResults', function(results)
    SendNUIMessage({
        action = 'searchResults',
        results = results
    })
end)

-- Citizen profile
RegisterNetEvent('lxr-police:mdt:citizenProfile')
AddEventHandler('lxr-police:mdt:citizenProfile', function(profile)
    SendNUIMessage({
        action = 'citizenProfile',
        profile = profile
    })
end)

-- Report list
RegisterNetEvent('lxr-police:mdt:reportList')
AddEventHandler('lxr-police:mdt:reportList', function(reports)
    SendNUIMessage({
        action = 'reportList',
        reports = reports
    })
end)

-- Arrest list
RegisterNetEvent('lxr-police:mdt:arrestList')
AddEventHandler('lxr-police:mdt:arrestList', function(arrests)
    SendNUIMessage({
        action = 'arrestList',
        arrests = arrests
    })
end)

-- Wanted posters list
RegisterNetEvent('lxr-police:mdt:wantedPosterList')
AddEventHandler('lxr-police:mdt:wantedPosterList', function(posters)
    SendNUIMessage({
        action = 'wantedPosterList',
        posters = posters
    })
end)

-- BOLO list
RegisterNetEvent('lxr-police:mdt:boloList')
AddEventHandler('lxr-police:mdt:boloList', function(bolos)
    SendNUIMessage({
        action = 'boloList',
        bolos = bolos
    })
end)

-- Vehicle info
RegisterNetEvent('lxr-police:mdt:vehicleInfo')
AddEventHandler('lxr-police:mdt:vehicleInfo', function(vehicle)
    SendNUIMessage({
        action = 'vehicleInfo',
        vehicle = vehicle
    })
end)

-- Dashboard stats
RegisterNetEvent('lxr-police:mdt:dashboardStats')
AddEventHandler('lxr-police:mdt:dashboardStats', function(stats)
    SendNUIMessage({
        action = 'updateStats',
        stats = stats
    })
end)

-- New BOLO notification
RegisterNetEvent('lxr-police:mdt:newBOLO')
AddEventHandler('lxr-police:mdt:newBOLO', function(bolo)
    SendNUIMessage({
        action = 'notification',
        type = 'warning',
        message = 'New BOLO: ' .. bolo.title
    })
end)

-- Notifications
RegisterNetEvent('lxr-police:notify')
AddEventHandler('lxr-police:notify', function(message, type)
    SendNUIMessage({
        action = 'notification',
        type = type or 'info',
        message = message
    })
end)

-- ============================================================================
-- COMMANDS
-- ============================================================================

-- Open MDT
RegisterCommand('mdt', function()
    if not exports['lxr-police']:IsOfficer() then
        TriggerEvent('lxr-police:notify', 'You are not authorized to access the MDT', 'error')
        return
    end
    
    if mdtOpen then
        SetNuiFocus(false, false)
        SendNUIMessage({action = 'close'})
        mdtOpen = false
    else
        SetNuiFocus(true, true)
        SendNUIMessage({action = 'open'})
        mdtOpen = true
        
        -- Load initial dashboard stats
        TriggerServerEvent('lxr-police:mdt:getDashboardStats')
    end
end, false)

-- Quick citizen lookup
RegisterCommand('lookup', function(source, args)
    if not exports['lxr-police']:IsOfficer() then
        TriggerEvent('lxr-police:notify', 'You are not authorized', 'error')
        return
    end
    
    if #args == 0 then
        TriggerEvent('lxr-police:notify', 'Usage: /lookup [name or ID]', 'error')
        return
    end
    
    local query = table.concat(args, ' ')
    TriggerServerEvent('lxr-police:mdt:searchCitizens', {query = query})
end, false)

-- Quick vehicle lookup
RegisterCommand('platecheck', function(source, args)
    if not exports['lxr-police']:IsOfficer() then
        TriggerEvent('lxr-police:notify', 'You are not authorized', 'error')
        return
    end
    
    if #args == 0 then
        TriggerEvent('lxr-police:notify', 'Usage: /platecheck [plate]', 'error')
        return
    end
    
    local plate = string.upper(args[1])
    TriggerServerEvent('lxr-police:mdt:vehicleLookup', plate)
end, false)

-- ============================================================================
-- KEY MAPPING
-- ============================================================================

-- Optional: Register key mapping for MDT
-- RegisterKeyMapping('mdt', 'Open MDT', 'keyboard', 'F5')

-- ============================================================================
-- EXPORTS
-- ============================================================================

exports('OpenMDT', function()
    ExecuteCommand('mdt')
end)

exports('IsMDTOpen', function()
    return mdtOpen
end)

print('^2[MDT Enhanced]^7 Client script loaded successfully')

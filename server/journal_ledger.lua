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
    
    SERVER SCRIPT - JOURNAL & LEDGER SYSTEM
    Period-accurate 1899 law enforcement records. Officers use handwritten journals
    for field notes. Station ledgers track arrests, warrants, and wanted posters.
    All record access requires physical presence at sheriff's office or marshal station.
    
    © 2026 iBoss | The Land of Wolves | www.wolves.land
    License: All Rights Reserved
]]

-- ══════════════════════════════════════════════════════════════
-- JOURNAL SYSTEM - Officer's Personal Notebook
-- ══════════════════════════════════════════════════════════════

-- Note: In-memory storage removed for consistency. All journal entries stored in database only.

-- Write note in officer's journal
RegisterNetEvent("lxr-police:journal:writeNote")
AddEventHandler("lxr-police:journal:writeNote", function(note)
    local src = source
    
    if not Bridge.IsOfficer(src) then
        return
    end
    
    local player = Bridge.GetPlayer(src)
    local officerId = player.identifier
    
    -- Save directly to database for persistence
    MySQL.Async.execute("INSERT INTO leo_journal_entries (officer_id, note, timestamp) VALUES (@id, @note, NOW())", {
        ["@id"] = officerId,
        ["@note"] = note
    })
    
    TriggerClientEvent("lxr-police:notify", src, "Note written in journal", "success")
end)

-- Read officer's journal entries
RegisterNetEvent("lxr-police:journal:readEntries")
AddEventHandler("lxr-police:journal:readEntries", function()
    local src = source
    
    if not Bridge.IsOfficer(src) then
        return
    end
    
    local player = Bridge.GetPlayer(src)
    local officerId = player.identifier
    
    MySQL.Async.fetchAll("SELECT * FROM leo_journal_entries WHERE officer_id = @id ORDER BY timestamp DESC LIMIT 50", {
        ["@id"] = officerId
    }, function(entries)
        TriggerClientEvent("lxr-police:journal:showEntries", src, entries)
    end)
end)

-- ══════════════════════════════════════════════════════════════
-- LEDGER SYSTEM - Station Record Books (Location-Based)
-- ══════════════════════════════════════════════════════════════

-- Check if player is at a law enforcement station
-- Cached station coords for performance
local stationCoords = {}

Citizen.CreateThread(function()
    -- Cache station coordinates on startup
    for stationName, station in pairs(Config.Stations) do
        if station.recordsOffice then
            stationCoords[stationName] = {
                coords = station.recordsOffice,
                name = stationName
            }
        end
    end
end)

local function IsAtStation(src)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    
    -- Check cached coordinates for better performance
    for _, station in pairs(stationCoords) do
        local distance = #(playerCoords - station.coords)
        if distance < 5.0 then  -- Must be within 5 meters
            return true, station.name
        end
    end
    
    return false, nil
end

-- Search station ledger for citizen records (MUST be at station)
RegisterNetEvent("lxr-police:ledger:searchCitizen")
AddEventHandler("lxr-police:ledger:searchCitizen", function(citizenName)
    local src = source
    
    if not Bridge.IsOfficer(src) then
        return
    end
    
    local atStation, stationName = IsAtStation(src)
    
    if not atStation then
        TriggerClientEvent("lxr-police:notify", src, "You must be at the Records Office to search ledgers", "error")
        return
    end
    
    -- Notify client to show searching animation
    TriggerClientEvent("lxr-police:notify", src, "Searching station ledgers for: " .. citizenName, "info")
    
    -- Simulate time delay for manual ledger search (client-side delay is better for performance)
    -- Server processes immediately for optimal performance
    
    -- Search for citizen in ledger
    MySQL.Async.fetchAll([[
        SELECT c.*, 
        (SELECT COUNT(*) FROM leo_arrests WHERE citizen_id = c.id) as arrest_count,
        (SELECT COUNT(*) FROM leo_warrants WHERE citizen_id = c.id AND status = 'active') as warrant_count
        FROM leo_citizens c
        WHERE c.name LIKE @name
        LIMIT 10
    ]], {
        ["@name"] = "%" .. citizenName .. "%"
    }, function(results)
        if #results > 0 then
            TriggerClientEvent("lxr-police:ledger:searchResults", src, results, stationName)
        else
            TriggerClientEvent("lxr-police:notify", src, "No records found in " .. stationName .. " ledger", "info")
        end
    end)
end)

-- Write arrest record in ledger
RegisterNetEvent("lxr-police:ledger:recordArrest")
AddEventHandler("lxr-police:ledger:recordArrest", function(citizenId, charges, jailTime)
    local src = source
    
    if not Bridge.IsOfficer(src) then
        return
    end
    
    local atStation, stationName = IsAtStation(src)
    
    if not atStation then
        TriggerClientEvent("lxr-police:notify", src, "You must be at the station to record arrests", "error")
        return
    end
    
    local player = Bridge.GetPlayer(src)
    
    MySQL.Async.execute([[
        INSERT INTO leo_arrests (citizen_id, officer_id, station, charges, jail_time, date)
        VALUES (@cid, @oid, @station, @charges, @time, NOW())
    ]], {
        ["@cid"] = citizenId,
        ["@oid"] = player.identifier,
        ["@station"] = stationName,
        ["@charges"] = json.encode(charges),
        ["@time"] = jailTime
    })
    
    Bridge.logAudit(src, "arrest_recorded", "ledger", citizenId, "Arrest entered in " .. stationName .. " ledger")
    
    TriggerClientEvent("lxr-police:notify", src, "Arrest recorded in station ledger", "success")
end)

-- ══════════════════════════════════════════════════════════════
-- WANTED POSTERS - Physical Bulletin Board System
-- ══════════════════════════════════════════════════════════════

local wantedPosters = {} -- Active wanted posters

-- Create wanted poster (generates physical item)
RegisterNetEvent("lxr-police:poster:create")
AddEventHandler("lxr-police:poster:create", function(citizenId, bounty, crimes)
    local src = source
    
    if not Bridge.HasPermission(src, "warrant_create") then
        TriggerClientEvent("lxr-police:notify", src, "You don't have permission to create wanted posters", "error")
        return
    end
    
    local atStation, stationName = IsAtStation(src)
    
    if not atStation then
        TriggerClientEvent("lxr-police:notify", src, "You must be at the station to create wanted posters", "error")
        return
    end
    
    -- Get citizen details
    MySQL.Async.fetchAll("SELECT * FROM leo_citizens WHERE id = @id", {
        ["@id"] = citizenId
    }, function(citizen)
        if not citizen[1] then
            TriggerClientEvent("lxr-police:notify", src, "Citizen not found", "error")
            return
        end
        
        local posterData = {
            id = #wantedPosters + 1,
            citizenId = citizenId,
            citizenName = citizen[1].name,
            bounty = bounty,
            crimes = crimes,
            station = stationName,
            date = os.date("%B %d, %Y"),
            status = "active"
        }
        
        table.insert(wantedPosters, posterData)
        
        -- Save to database
        MySQL.Async.execute([[
            INSERT INTO leo_wanted_posters (citizen_id, bounty, crimes, station, date, status)
            VALUES (@cid, @bounty, @crimes, @station, NOW(), 'active')
        ]], {
            ["@cid"] = citizenId,
            ["@bounty"] = bounty,
            ["@crimes"] = json.encode(crimes),
            ["@station"] = stationName
        })
        
        -- Give physical wanted poster item to officer
        TriggerClientEvent("lxr-police:poster:giveItem", src, posterData)
        
        TriggerClientEvent("lxr-police:notify", src, "Wanted poster created for " .. citizen[1].name, "success")
        
        Bridge.logAudit(src, "poster_created", "wanted", citizenId, "Wanted poster created at " .. stationName)
    end)
end)

-- View wanted board at station
RegisterNetEvent("lxr-police:poster:viewBoard")
AddEventHandler("lxr-police:poster:viewBoard", function()
    local src = source
    
    local atStation, stationName = IsAtStation(src)
    
    if not atStation then
        TriggerClientEvent("lxr-police:notify", src, "You must be at the station to view wanted board", "error")
        return
    end
    
    -- Get all active wanted posters for this station
    MySQL.Async.fetchAll([[
        SELECT p.*, c.name as citizen_name
        FROM leo_wanted_posters p
        LEFT JOIN leo_citizens c ON p.citizen_id = c.id
        WHERE p.status = 'active' AND (p.station = @station OR p.station = 'territory')
        ORDER BY p.date DESC
        LIMIT 20
    ]], {
        ["@station"] = stationName
    }, function(posters)
        TriggerClientEvent("lxr-police:poster:showBoard", src, posters, stationName)
    end)
end)

-- ══════════════════════════════════════════════════════════════
-- OPTIMIZATION: Cached Queries
-- ══════════════════════════════════════════════════════════════

-- Cache active warrants (refresh every 5 minutes instead of querying constantly)
local cachedWarrants = {}
local lastWarrantUpdate = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000) -- 5 minutes
        
        MySQL.Async.fetchAll("SELECT citizen_id FROM leo_warrants WHERE status = 'active'", {}, function(warrants)
            cachedWarrants = {}
            for _, warrant in ipairs(warrants) do
                cachedWarrants[warrant.citizen_id] = true
            end
            lastWarrantUpdate = GetGameTimer()
        end)
    end
end)

-- Exports for other scripts
exports("IsAtStation", IsAtStation)
exports("HasActiveWarrant", function(citizenId)
    return cachedWarrants[citizenId] == true
end)

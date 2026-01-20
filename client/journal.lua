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
    
    CLIENT SCRIPT - JOURNAL SYSTEM
    Period-accurate officer's journal for handwritten field notes. Replace modern
    MDT with authentic 1899 notebook system. Officers write observations, suspect
    descriptions, and case notes in a personal journal.
    
    © 2026 iBoss | The Land of Wolves | www.wolves.land
    License: All Rights Reserved
]]

local journalOpen = false
local currentJournalEntries = {}

-- ══════════════════════════════════════════════════════════════
-- JOURNAL COMMANDS
-- ══════════════════════════════════════════════════════════════

-- Open journal to write new note
RegisterCommand("journal", function()
    if not exports["lxr-police"]:IsOfficer(GetPlayerServerId(PlayerId())) then
        return
    end
    
    -- Simple input prompt for writing note (period-accurate, no fancy UI)
    local note = exports["lxr-police"]:GetTextInput("Write Journal Entry", "Your field observations...", 500)
    
    if note and #note > 0 then
        TriggerServerEvent("lxr-police:journal:writeNote", note)
    end
end, false)

-- Read journal entries
RegisterCommand("readjournal", function()
    if not exports["lxr-police"]:IsOfficer(GetPlayerServerId(PlayerId())) then
        return
    end
    
    TriggerServerEvent("lxr-police:journal:readEntries")
end, false)

-- Display journal entries
RegisterNetEvent("lxr-police:journal:showEntries")
AddEventHandler("lxr-police:journal:showEntries", function(entries)
    if #entries == 0 then
        exports["lxr-police"]:Notify("Journal is empty", "info")
        return
    end
    
    -- Display entries in chat (simple, period-accurate)
    print("^3========== JOURNAL ENTRIES ==========^0")
    for i = math.max(1, #entries - 10), #entries do
        local entry = entries[i]
        print(string.format("^2[%s]^0 %s", entry.timestamp or "Unknown", entry.note))
    end
    print("^3====================================^0")
end)

-- ══════════════════════════════════════════════════════════════
-- STATION LEDGER ACCESS (Location-Based)
-- ══════════════════════════════════════════════════════════════

-- Search citizen in station ledger
RegisterCommand("searchledger", function(source, args)
    if not exports["lxr-police"]:IsOfficer(GetPlayerServerId(PlayerId())) then
        return
    end
    
    if not args[1] then
        exports["lxr-police"]:Notify("Usage: /searchledger [name]", "error")
        return
    end
    
    local citizenName = table.concat(args, " ")
    
    -- Show searching animation
    exports["lxr-police"]:Notify("Searching station ledgers for: " .. citizenName, "info")
    
    TriggerServerEvent("lxr-police:ledger:searchCitizen", citizenName)
end, false)

-- Display ledger search results
RegisterNetEvent("lxr-police:ledger:searchResults")
AddEventHandler("lxr-police:ledger:searchResults", function(results, stationName)
    print(string.format("^3========== %s LEDGER RECORDS ==========^0", stationName:upper()))
    
    for _, citizen in ipairs(results) do
        print(string.format("^2Name:^0 %s", citizen.name))
        print(string.format("^2Arrests:^0 %d | ^2Warrants:^0 %d", citizen.arrest_count or 0, citizen.warrant_count or 0))
        if citizen.last_arrest then
            print(string.format("^2Last Arrest:^0 %s", citizen.last_arrest))
        end
        print("^3---------------------------------^0")
    end
    
    print("^3====================================^0")
end)

-- ══════════════════════════════════════════════════════════════
-- WANTED BOARD (Bulletin Board at Stations)
-- ══════════════════════════════════════════════════════════════

-- View wanted board
RegisterCommand("wantedboard", function()
    if not exports["lxr-police"]:IsOfficer(GetPlayerServerId(PlayerId())) then
        -- Allow civilians to view wanted board too
    end
    
    TriggerServerEvent("lxr-police:poster:viewBoard")
end, false)

-- Display wanted posters
RegisterNetEvent("lxr-police:poster:showBoard")
AddEventHandler("lxr-police:poster:showBoard", function(posters, stationName)
    if #posters == 0 then
        exports["lxr-police"]:Notify("No wanted posters on the board", "info")
        return
    end
    
    print(string.format("^3========== %s WANTED BOARD ==========^0", stationName:upper()))
    
    for _, poster in ipairs(posters) do
        print("^1╔══════════════════════════════════╗^0")
        print(string.format("^1║^0 ^2WANTED:^0 %-23s^1║^0", poster.citizen_name))
        print(string.format("^1║^0 ^3Bounty:^0 $%-22d^1║^0", poster.bounty))
        print(string.format("^1║^0 ^3Crimes:^0 %-22s^1║^0", poster.crimes or "Various"))
        print(string.format("^1║^0 ^3Date:^0 %-24s^1║^0", poster.date))
        print("^1╚══════════════════════════════════╝^0")
    end
    
    print("^3====================================^0")
end)

-- ══════════════════════════════════════════════════════════════
-- STATION RECORDS OFFICE MARKERS
-- ══════════════════════════════════════════════════════════════

local recordsOfficeBlips = {}

Citizen.CreateThread(function()
    for stationName, station in pairs(Config.Stations) do
        if station.recordsOffice then
            -- Create blip for records office
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, station.recordsOffice)  -- BlipAddForCoords
            SetBlipSprite(blip, -1230993421, true)  -- Document icon
            SetBlipScale(blip, 0.2)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Records Office")  -- SetBlipName
            
            table.insert(recordsOfficeBlips, blip)
        end
        
        if station.wantedBoard then
            -- Create blip for wanted board
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, station.wantedBoard)
            SetBlipSprite(blip, 1960216838, true)  -- Wanted poster icon
            SetBlipScale(blip, 0.2)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Wanted Board")
            
            table.insert(recordsOfficeBlips, blip)
        end
    end
end)

-- Prompt at records office
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local nearRecords = false
        local nearWantedBoard = false
        
        for stationName, station in pairs(Config.Stations) do
            if station.recordsOffice then
                local distance = #(playerCoords - station.recordsOffice)
                
                if distance < 2.0 then
                    nearRecords = true
                    
                    -- Draw text prompt
                    exports["lxr-police"]:DrawText3D(station.recordsOffice.x, station.recordsOffice.y, station.recordsOffice.z, 
                        "~o~[E]~w~ Search Ledgers")
                    
                    if IsControlJustPressed(0, 0xCEFD9220) then  -- E key
                        ExecuteCommand("searchledger")
                    end
                end
            end
            
            if station.wantedBoard then
                local distance = #(playerCoords - station.wantedBoard)
                
                if distance < 2.0 then
                    nearWantedBoard = true
                    
                    -- Draw text prompt
                    exports["lxr-police"]:DrawText3D(station.wantedBoard.x, station.wantedBoard.y, station.wantedBoard.z,
                        "~o~[E]~w~ View Wanted Board")
                    
                    if IsControlJustPressed(0, 0xCEFD9220) then  -- E key
                        ExecuteCommand("wantedboard")
                    end
                end
            end
        end
        
        if not nearRecords and not nearWantedBoard then
            Citizen.Wait(1000)  -- Reduce checks when not near stations
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- HELPER FUNCTIONS
-- ══════════════════════════════════════════════════════════════

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text)
    SetTextCentre(1)
    DisplayText(str, _x, _y)
end

-- Export helper functions
exports("DrawText3D", DrawText3D)

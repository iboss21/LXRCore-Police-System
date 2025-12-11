-- Enhanced MDT (Mobile Data Terminal) System
local MDT_VERSION = Config.Branding and Config.Branding.Version or "1.0.0"

-- Search citizens
RegisterNetEvent("lxr-police:mdt:searchCitizen")
AddEventHandler("lxr-police:mdt:searchCitizen", function(query)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_view") then
        exports["lxr-police"]:logAudit(src, "unauthorized_mdt", "mdt", 0, "View denied")
        return
    end
    
    MySQL.Async.fetchAll([[
        SELECT c.*, 
        COUNT(DISTINCT r.id) as report_count,
        COUNT(DISTINCT w.id) as warrant_count
        FROM mdt_citizens c
        LEFT JOIN mdt_reports r ON c.id = r.citizen_id
        LEFT JOIN mdt_warrants w ON c.id = w.citizen_id AND w.status = 'active'
        WHERE c.name LIKE @q OR c.identifier LIKE @q
        GROUP BY c.id
        LIMIT 50
    ]], {["@q"] = "%" .. query .. "%"}, function(results)
        TriggerClientEvent("lxr-police:mdt:searchResult", src, results)
    end)
    
    exports["lxr-police"]:logAudit(src, "mdt_search", "mdt", 0, "Query: " .. query)
end)

-- Get citizen profile
RegisterNetEvent("lxr-police:mdt:getCitizenProfile")
AddEventHandler("lxr-police:mdt:getCitizenProfile", function(citizenId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_view") then return end
    
    -- Get citizen data
    MySQL.Async.fetchAll("SELECT * FROM mdt_citizens WHERE id = @id", {["@id"] = citizenId}, function(citizen)
        if not citizen[1] then
            TriggerClientEvent("lxr-police:notify", src, "Citizen not found", "error")
            return
        end
        
        -- Get reports
        MySQL.Async.fetchAll([[
            SELECT r.*, o.name as officer_name 
            FROM mdt_reports r 
            LEFT JOIN mdt_citizens o ON r.officer_id = o.id
            WHERE r.citizen_id = @id 
            ORDER BY r.created_at DESC
        ]], {["@id"] = citizenId}, function(reports)
            
            -- Get warrants
            MySQL.Async.fetchAll([[
                SELECT w.*, o.name as officer_name
                FROM mdt_warrants w
                LEFT JOIN mdt_citizens o ON w.issued_by = o.id
                WHERE w.citizen_id = @id
                ORDER BY w.issued_at DESC
            ]], {["@id"] = citizenId}, function(warrants)
                
                -- Get convictions
                MySQL.Async.fetchAll([[
                    SELECT * FROM mdt_convictions
                    WHERE citizen_id = @id
                    ORDER BY conviction_date DESC
                ]], {["@id"] = citizenId}, function(convictions)
                    
                    local profile = {
                        citizen = citizen[1],
                        reports = reports,
                        warrants = warrants,
                        convictions = convictions
                    }
                    
                    TriggerClientEvent("lxr-police:mdt:citizenProfile", src, profile)
                end)
            end)
        end)
    end)
    
    exports["lxr-police"]:logAudit(src, "mdt_view_profile", "citizen", citizenId, "Viewed citizen profile")
end)

-- Create incident report
RegisterNetEvent("lxr-police:mdt:createReport")
AddEventHandler("lxr-police:mdt:createReport", function(reportData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        INSERT INTO mdt_reports (officer_id, citizen_id, report_type, title, description, location, evidence_ids, created_at)
        VALUES (@officer, @citizen, @type, @title, @description, @location, @evidence, @time)
    ]], {
        ["@officer"] = reportData.officerId,
        ["@citizen"] = reportData.citizenId,
        ["@type"] = reportData.reportType,
        ["@title"] = reportData.title,
        ["@description"] = reportData.description,
        ["@location"] = reportData.location,
        ["@evidence"] = json.encode(reportData.evidenceIds or {}),
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S')
    }, function(insertId)
        TriggerClientEvent("lxr-police:notify", src, "Report created successfully", "success")
        TriggerClientEvent("lxr-police:mdt:reportCreated", src, insertId)
        exports["lxr-police"]:logAudit(src, "mdt_create_report", "report", insertId, "Created report: " .. reportData.title)
    end)
end)

-- Update report
RegisterNetEvent("lxr-police:mdt:updateReport")
AddEventHandler("lxr-police:mdt:updateReport", function(reportId, reportData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        UPDATE mdt_reports SET
        title = @title,
        description = @description,
        location = @location,
        evidence_ids = @evidence,
        updated_at = @time
        WHERE id = @id
    ]], {
        ["@id"] = reportId,
        ["@title"] = reportData.title,
        ["@description"] = reportData.description,
        ["@location"] = reportData.location,
        ["@evidence"] = json.encode(reportData.evidenceIds or {}),
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S')
    })
    
    TriggerClientEvent("lxr-police:notify", src, "Report updated", "success")
    exports["lxr-police"]:logAudit(src, "mdt_update_report", "report", reportId, "Updated report")
end)

-- Create warrant
RegisterNetEvent("lxr-police:mdt:createWarrant")
AddEventHandler("lxr-police:mdt:createWarrant", function(warrantData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        INSERT INTO mdt_warrants (citizen_id, issued_by, warrant_type, charges, bail_amount, status, issued_at)
        VALUES (@citizen, @officer, @type, @charges, @bail, @status, @time)
    ]], {
        ["@citizen"] = warrantData.citizenId,
        ["@officer"] = src,
        ["@type"] = warrantData.warrantType,
        ["@charges"] = json.encode(warrantData.charges),
        ["@bail"] = warrantData.bailAmount,
        ["@status"] = "active",
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S')
    }, function(insertId)
        TriggerClientEvent("lxr-police:notify", src, "Warrant issued", "success")
        
        -- Notify all officers
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            if exports["lxr-police"]:IsOfficer(tonumber(playerId)) then
                TriggerClientEvent("lxr-police:notify", tonumber(playerId), "New warrant issued for citizen ID: " .. warrantData.citizenId, "primary")
            end
        end
        
        exports["lxr-police"]:logAudit(src, "mdt_create_warrant", "warrant", insertId, "Issued warrant")
    end)
end)

-- Execute warrant
RegisterNetEvent("lxr-police:mdt:executeWarrant")
AddEventHandler("lxr-police:mdt:executeWarrant", function(warrantId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then return end
    
    MySQL.Async.execute([[
        UPDATE mdt_warrants SET status = @status, executed_at = @time, executed_by = @officer
        WHERE id = @id
    ]], {
        ["@id"] = warrantId,
        ["@status"] = "executed",
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S'),
        ["@officer"] = src
    })
    
    TriggerClientEvent("lxr-police:notify", src, "Warrant executed", "success")
    exports["lxr-police"]:logAudit(src, "mdt_execute_warrant", "warrant", warrantId, "Executed warrant")
end)

-- BOLO system
RegisterNetEvent("lxr-police:mdt:createBOLO")
AddEventHandler("lxr-police:mdt:createBOLO", function(boloData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        INSERT INTO mdt_bolos (created_by, bolo_type, title, description, plate, suspect_name, status, created_at)
        VALUES (@officer, @type, @title, @description, @plate, @suspect, @status, @time)
    ]], {
        ["@officer"] = src,
        ["@type"] = boloData.boloType,
        ["@title"] = boloData.title,
        ["@description"] = boloData.description,
        ["@plate"] = boloData.plate,
        ["@suspect"] = boloData.suspectName,
        ["@status"] = "active",
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S')
    }, function(insertId)
        TriggerClientEvent("lxr-police:notify", src, "BOLO created", "success")
        
        -- Notify all officers
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            if exports["lxr-police"]:IsOfficer(tonumber(playerId)) then
                TriggerClientEvent("lxr-police:mdt:newBOLO", tonumber(playerId), {
                    id = insertId,
                    type = boloData.boloType,
                    title = boloData.title,
                    description = boloData.description
                })
            end
        end
        
        exports["lxr-police"]:logAudit(src, "mdt_create_bolo", "bolo", insertId, "Created BOLO: " .. boloData.title)
    end)
end)

-- Get active BOLOs
RegisterNetEvent("lxr-police:mdt:getBOLOs")
AddEventHandler("lxr-police:mdt:getBOLOs", function()
    local src = source
    if not exports["lxr-police"]:IsOfficer(src) then return end
    
    MySQL.Async.fetchAll([[
        SELECT b.*, c.name as officer_name
        FROM mdt_bolos b
        LEFT JOIN mdt_citizens c ON b.created_by = c.id
        WHERE b.status = 'active'
        ORDER BY b.created_at DESC
    ]], {}, function(bolos)
        TriggerClientEvent("lxr-police:mdt:boloList", src, bolos)
    end)
end)

-- Vehicle lookup
RegisterNetEvent("lxr-police:mdt:vehicleLookup")
AddEventHandler("lxr-police:mdt:vehicleLookup", function(plate)
    local src = source
    if not exports["lxr-police"]:IsOfficer(src) then return end
    
    MySQL.Async.fetchAll([[
        SELECT v.*, c.name as owner_name, c.identifier as owner_id
        FROM mdt_vehicles v
        LEFT JOIN mdt_citizens c ON v.owner_id = c.identifier
        WHERE v.plate = @plate
    ]], {["@plate"] = plate}, function(results)
        if results[1] then
            -- Check for BOLOs on this plate
            MySQL.Async.fetchAll("SELECT * FROM mdt_bolos WHERE plate = @plate AND status = 'active'", {
                ["@plate"] = plate
            }, function(bolos)
                results[1].bolos = bolos
                TriggerClientEvent("lxr-police:mdt:vehicleInfo", src, results[1])
            end)
        else
            TriggerClientEvent("lxr-police:notify", src, "Vehicle not found", "error")
        end
    end)
    
    exports["lxr-police"]:logAudit(src, "mdt_vehicle_lookup", "vehicle", plate, "Looked up vehicle")
end)

-- Officer roster
RegisterNetEvent("lxr-police:mdt:getOfficerRoster")
AddEventHandler("lxr-police:mdt:getOfficerRoster", function()
    local src = source
    if not exports["lxr-police"]:IsOfficer(src) then return end
    
    MySQL.Async.fetchAll([[
        SELECT * FROM leo_roster
        ORDER BY department, rank DESC, name
    ]], {}, function(roster)
        TriggerClientEvent("lxr-police:mdt:officerRoster", src, roster)
    end)
end)

-- Update officer status
RegisterNetEvent("lxr-police:mdt:updateOfficerStatus")
AddEventHandler("lxr-police:mdt:updateOfficerStatus", function(status)
    local src = source
    if not exports["lxr-police"]:IsOfficer(src) then return end
    
    MySQL.Async.execute([[
        UPDATE leo_roster SET status = @status, last_active = @time
        WHERE officer_id = @officer
    ]], {
        ["@officer"] = src,
        ["@status"] = status,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S')
    })
    
    -- Notify other officers
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        if exports["lxr-police"]:IsOfficer(tonumber(playerId)) and tonumber(playerId) ~= src then
            TriggerClientEvent("lxr-police:mdt:officerStatusUpdate", tonumber(playerId), src, status)
        end
    end
end)

-- Export functions
exports("GetMDTVersion", function()
    return MDT_VERSION
end)
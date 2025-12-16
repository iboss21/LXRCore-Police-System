-- Enhanced MDT (Mobile Data Terminal) System
-- Comprehensive CRUD operations for all MDT features

local MDT_VERSION = "2.0.0"

-- ============================================================================
-- CITIZEN MANAGEMENT
-- ============================================================================

-- Search citizens with advanced filters
RegisterNetEvent("lxr-police:mdt:searchCitizens")
AddEventHandler("lxr-police:mdt:searchCitizens", function(searchData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_view") then
        TriggerClientEvent("lxr-police:notify", src, "Access denied", "error")
        return
    end
    
    local query = searchData.query or ""
    local filters = searchData.filters or {}
    
    local sql = [[
        SELECT c.*, 
        COUNT(DISTINCT r.id) as report_count,
        COUNT(DISTINCT a.id) as arrest_count,
        COUNT(DISTINCT w.id) as warrant_count
        FROM mdt_citizens c
        LEFT JOIN mdt_reports r ON c.id = r.citizen_id
        LEFT JOIN mdt_arrests a ON c.id = a.citizen_id
        LEFT JOIN mdt_warrants w ON c.id = w.citizen_id AND w.status = 'active'
        WHERE (c.name LIKE @q OR c.identifier LIKE @q)
    ]]
    
    if filters.gender then
        sql = sql .. " AND c.gender = @gender"
    end
    
    sql = sql .. " GROUP BY c.id ORDER BY c.name LIMIT 50"
    
    local params = {["@q"] = "%" .. query .. "%"}
    if filters.gender then params["@gender"] = filters.gender end
    
    
    local params = {["@q"] = "%" .. query .. "%"}
    if filters.gender then params["@gender"] = filters.gender end
    
    MySQL.Async.fetchAll(sql, params, function(results)
        TriggerClientEvent("lxr-police:mdt:searchResults", src, results)
    end)
    
    exports["lxr-police"]:logAudit(src, "mdt_search_citizens", "mdt", 0, "Query: " .. query)
end)

-- Get full citizen profile
RegisterNetEvent("lxr-police:mdt:getCitizenProfile")
AddEventHandler("lxr-police:mdt:getCitizenProfile", function(citizenId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_view") then return end
    
    MySQL.Async.fetchAll("SELECT * FROM mdt_citizens WHERE id = @id", {["@id"] = citizenId}, function(citizen)
        if not citizen[1] then
            TriggerClientEvent("lxr-police:notify", src, "Citizen not found", "error")
            return
        end
        
        -- Get all related data
        MySQL.Async.fetchAll("SELECT * FROM mdt_reports WHERE citizen_id = @id ORDER BY created_at DESC", {["@id"] = citizenId}, function(reports)
            MySQL.Async.fetchAll("SELECT * FROM mdt_arrests WHERE citizen_id = @id ORDER BY arrest_date DESC", {["@id"] = citizenId}, function(arrests)
                MySQL.Async.fetchAll("SELECT * FROM mdt_warrants WHERE citizen_id = @id ORDER BY issued_at DESC", {["@id"] = citizenId}, function(warrants)
                    MySQL.Async.fetchAll("SELECT * FROM mdt_convictions WHERE citizen_id = @id ORDER BY conviction_date DESC", {["@id"] = citizenId}, function(convictions)
                        MySQL.Async.fetchAll("SELECT * FROM mdt_citizen_files WHERE citizen_id = @id ORDER BY uploaded_at DESC", {["@id"] = citizenId}, function(files)
                            
                            local profile = {
                                citizen = citizen[1],
                                reports = reports,
                                arrests = arrests,
                                warrants = warrants,
                                convictions = convictions,
                                files = files
                            }
                            
                            TriggerClientEvent("lxr-police:mdt:citizenProfile", src, profile)
                        end)
                    end)
                end)
            end)
        end)
    end)
    
    exports["lxr-police"]:logAudit(src, "mdt_view_profile", "citizen", citizenId, "Viewed citizen profile")
end)

-- Create or update citizen
RegisterNetEvent("lxr-police:mdt:saveCitizen")
AddEventHandler("lxr-police:mdt:saveCitizen", function(citizenData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    -- Validate required fields
    if not citizenData.identifier or not citizenData.name then
        TriggerClientEvent("lxr-police:notify", src, "Missing required fields", "error")
        return
    end
    
    if citizenData.id then
        -- Update existing citizen
        MySQL.Async.execute([[
            UPDATE mdt_citizens SET
            name = @name,
            date_of_birth = @dob,
            gender = @gender,
            address = @address,
            phone = @phone,
            mugshot = @mugshot,
            notes = @notes,
            licenses = @licenses,
            tags = @tags,
            updated_at = @time
            WHERE id = @id
        ]], {
            ["@id"] = citizenData.id,
            ["@name"] = citizenData.name,
            ["@dob"] = citizenData.dateOfBirth,
            ["@gender"] = citizenData.gender or 'unknown',
            ["@address"] = citizenData.address,
            ["@phone"] = citizenData.phone,
            ["@mugshot"] = citizenData.mugshot,
            ["@notes"] = citizenData.notes,
            ["@licenses"] = json.encode(citizenData.licenses or {}),
            ["@tags"] = json.encode(citizenData.tags or {}),
            ["@time"] = os.date('%Y-%m-%d %H:%M:%S')
        }, function(affectedRows)
            TriggerClientEvent("lxr-police:notify", src, "Citizen updated", "success")
            TriggerClientEvent("lxr-police:mdt:citizenSaved", src, citizenData.id)
            exports["lxr-police"]:logAudit(src, "mdt_update_citizen", "citizen", citizenData.id, "Updated citizen")
        end)
    else
        -- Create new citizen
        MySQL.Async.execute([[
            INSERT INTO mdt_citizens (identifier, name, date_of_birth, gender, address, phone, mugshot, notes, licenses, tags, created_at)
            VALUES (@identifier, @name, @dob, @gender, @address, @phone, @mugshot, @notes, @licenses, @tags, @time)
        ]], {
            ["@identifier"] = citizenData.identifier,
            ["@name"] = citizenData.name,
            ["@dob"] = citizenData.dateOfBirth,
            ["@gender"] = citizenData.gender or 'unknown',
            ["@address"] = citizenData.address,
            ["@phone"] = citizenData.phone,
            ["@mugshot"] = citizenData.mugshot,
            ["@notes"] = citizenData.notes,
            ["@licenses"] = json.encode(citizenData.licenses or {}),
            ["@tags"] = json.encode(citizenData.tags or {}),
            ["@time"] = os.date('%Y-%m-%d %H:%M:%S')
        }, function(insertId)
            TriggerClientEvent("lxr-police:notify", src, "Citizen created", "success")
            TriggerClientEvent("lxr-police:mdt:citizenSaved", src, insertId)
            exports["lxr-police"]:logAudit(src, "mdt_create_citizen", "citizen", insertId, "Created citizen")
        end)
    end
end)

-- Add file/note to citizen
RegisterNetEvent("lxr-police:mdt:addCitizenFile")
AddEventHandler("lxr-police:mdt:addCitizenFile", function(fileData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        INSERT INTO mdt_citizen_files (citizen_id, file_type, title, content, file_url, uploaded_by, uploaded_at)
        VALUES (@citizen, @type, @title, @content, @url, @officer, @time)
    ]], {
        ["@citizen"] = fileData.citizenId,
        ["@type"] = fileData.fileType or 'note',
        ["@title"] = fileData.title,
        ["@content"] = fileData.content,
        ["@url"] = fileData.fileUrl,
        ["@officer"] = src,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S')
    }, function(insertId)
        TriggerClientEvent("lxr-police:notify", src, "File added", "success")
        TriggerClientEvent("lxr-police:mdt:fileAdded", src, insertId)
        exports["lxr-police"]:logAudit(src, "mdt_add_file", "citizen", fileData.citizenId, "Added file: " .. fileData.title)
    end)
end)

-- Delete citizen file
RegisterNetEvent("lxr-police:mdt:deleteCitizenFile")
AddEventHandler("lxr-police:mdt:deleteCitizenFile", function(fileId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_delete") then return end
    
    MySQL.Async.execute("DELETE FROM mdt_citizen_files WHERE id = @id", {["@id"] = fileId}, function()
        TriggerClientEvent("lxr-police:notify", src, "File deleted", "success")
        exports["lxr-police"]:logAudit(src, "mdt_delete_file", "file", fileId, "Deleted file")
    end)
end)

-- ============================================================================
-- REPORT MANAGEMENT
-- ============================================================================

-- Get all reports with filters
RegisterNetEvent("lxr-police:mdt:getReports")
AddEventHandler("lxr-police:mdt:getReports", function(filters)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_view") then return end
    
    local sql = [[
        SELECT r.*, 
        o.name as officer_name,
        c.name as citizen_name
        FROM mdt_reports r
        LEFT JOIN mdt_citizens o ON r.officer_id = o.id
        LEFT JOIN mdt_citizens c ON r.citizen_id = c.id
        WHERE 1=1
    ]]
    
    local params = {}
    
    if filters and filters.reportType then
        sql = sql .. " AND r.report_type = @type"
        params["@type"] = filters.reportType
    end
    
    if filters and filters.citizenId then
        sql = sql .. " AND r.citizen_id = @citizen"
        params["@citizen"] = filters.citizenId
    end
    
    sql = sql .. " ORDER BY r.created_at DESC LIMIT 100"
    
    MySQL.Async.fetchAll(sql, params, function(reports)
        TriggerClientEvent("lxr-police:mdt:reportList", src, reports)
    end)
end)

-- Create new report
RegisterNetEvent("lxr-police:mdt:createReport")
AddEventHandler("lxr-police:mdt:createReport", function(reportData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        INSERT INTO mdt_reports (officer_id, citizen_id, report_type, title, description, location, charges, evidence_ids, created_at)
        VALUES (@officer, @citizen, @type, @title, @description, @location, @charges, @evidence, @time)
    ]], {
        ["@officer"] = reportData.officerId or src,
        ["@citizen"] = reportData.citizenId,
        ["@type"] = reportData.reportType,
        ["@title"] = reportData.title,
        ["@description"] = reportData.description,
        ["@location"] = reportData.location,
        ["@charges"] = json.encode(reportData.charges or {}),
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
        charges = @charges,
        evidence_ids = @evidence,
        updated_at = @time,
        updated_by = @officer
        WHERE id = @id
    ]], {
        ["@id"] = reportId,
        ["@title"] = reportData.title,
        ["@description"] = reportData.description,
        ["@location"] = reportData.location,
        ["@charges"] = json.encode(reportData.charges or {}),
        ["@evidence"] = json.encode(reportData.evidenceIds or {}),
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S'),
        ["@officer"] = src
    }, function()
        TriggerClientEvent("lxr-police:notify", src, "Report updated", "success")
        exports["lxr-police"]:logAudit(src, "mdt_update_report", "report", reportId, "Updated report")
    end)
end)

-- Delete report
RegisterNetEvent("lxr-police:mdt:deleteReport")
AddEventHandler("lxr-police:mdt:deleteReport", function(reportId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_delete") then return end
    
    MySQL.Async.execute("DELETE FROM mdt_reports WHERE id = @id", {["@id"] = reportId}, function()
        TriggerClientEvent("lxr-police:notify", src, "Report deleted", "success")
        exports["lxr-police"]:logAudit(src, "mdt_delete_report", "report", reportId, "Deleted report")
    end)
end)

-- ============================================================================
-- ARREST RECORDS
-- ============================================================================

-- Create arrest record
RegisterNetEvent("lxr-police:mdt:createArrest")
AddEventHandler("lxr-police:mdt:createArrest", function(arrestData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        INSERT INTO mdt_arrests (citizen_id, officer_id, report_id, arrest_date, location, charges, bail_amount, fine_amount, jail_time, notes)
        VALUES (@citizen, @officer, @report, @date, @location, @charges, @bail, @fine, @jail, @notes)
    ]], {
        ["@citizen"] = arrestData.citizenId,
        ["@officer"] = src,
        ["@report"] = arrestData.reportId,
        ["@date"] = os.date('%Y-%m-%d %H:%M:%S'),
        ["@location"] = arrestData.location,
        ["@charges"] = json.encode(arrestData.charges),
        ["@bail"] = arrestData.bailAmount or 0,
        ["@fine"] = arrestData.fineAmount or 0,
        ["@jail"] = arrestData.jailTime or 0,
        ["@notes"] = arrestData.notes
    }, function(insertId)
        TriggerClientEvent("lxr-police:notify", src, "Arrest record created", "success")
        TriggerClientEvent("lxr-police:mdt:arrestCreated", src, insertId)
        exports["lxr-police"]:logAudit(src, "mdt_create_arrest", "arrest", insertId, "Created arrest record")
    end)
end)

-- Get arrest records
RegisterNetEvent("lxr-police:mdt:getArrests")
AddEventHandler("lxr-police:mdt:getArrests", function(citizenId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_view") then return end
    
    MySQL.Async.fetchAll([[
        SELECT a.*, 
        o.name as officer_name,
        c.name as citizen_name
        FROM mdt_arrests a
        LEFT JOIN mdt_citizens o ON a.officer_id = o.id
        LEFT JOIN mdt_citizens c ON a.citizen_id = c.id
        WHERE a.citizen_id = @citizen
        ORDER BY a.arrest_date DESC
    ]], {["@citizen"] = citizenId}, function(arrests)
        TriggerClientEvent("lxr-police:mdt:arrestList", src, arrests)
    end)
end)

-- Update arrest record
RegisterNetEvent("lxr-police:mdt:updateArrest")
AddEventHandler("lxr-police:mdt:updateArrest", function(arrestId, arrestData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        UPDATE mdt_arrests SET
        plea = @plea,
        conviction_status = @status,
        conviction_date = @conviction_date,
        notes = @notes
        WHERE id = @id
    ]], {
        ["@id"] = arrestId,
        ["@plea"] = arrestData.plea,
        ["@status"] = arrestData.convictionStatus,
        ["@conviction_date"] = arrestData.convictionDate,
        ["@notes"] = arrestData.notes
    }, function()
        TriggerClientEvent("lxr-police:notify", src, "Arrest record updated", "success")
        exports["lxr-police"]:logAudit(src, "mdt_update_arrest", "arrest", arrestId, "Updated arrest")
    end)
end)

-- ============================================================================
-- WARRANT MANAGEMENT
-- ============================================================================

-- Create warrant
RegisterNetEvent("lxr-police:mdt:createWarrant")
AddEventHandler("lxr-police:mdt:createWarrant", function(warrantData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        INSERT INTO mdt_warrants (citizen_id, officer_id, issued_by, warrant_type, description, charges, bail_amount, status, issued_at)
        VALUES (@citizen, @officer, @issued_by, @type, @description, @charges, @bail, @status, @time)
    ]], {
        ["@citizen"] = warrantData.citizenId,
        ["@officer"] = src,
        ["@issued_by"] = src,
        ["@type"] = warrantData.warrantType or 'arrest',
        ["@description"] = warrantData.description,
        ["@charges"] = json.encode(warrantData.charges),
        ["@bail"] = warrantData.bailAmount or 0,
        ["@status"] = "active",
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S')
    }, function(insertId)
        TriggerClientEvent("lxr-police:notify", src, "Warrant issued", "success")
        
        -- Notify all officers
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            if exports["lxr-police"]:IsOfficer(tonumber(playerId)) then
                TriggerClientEvent("lxr-police:notify", tonumber(playerId), "New warrant issued", "primary")
            end
        end
        
        exports["lxr-police"]:logAudit(src, "mdt_create_warrant", "warrant", insertId, "Issued warrant")
    end)
end)

-- Execute/serve warrant
RegisterNetEvent("lxr-police:mdt:executeWarrant")
AddEventHandler("lxr-police:mdt:executeWarrant", function(warrantId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "arrest") then return end
    
    MySQL.Async.execute([[
        UPDATE mdt_warrants SET 
        status = 'approved', 
        executed_at = @time, 
        executed_by = @officer
        WHERE id = @id
    ]], {
        ["@id"] = warrantId,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S'),
        ["@officer"] = src
    }, function()
        TriggerClientEvent("lxr-police:notify", src, "Warrant executed", "success")
        exports["lxr-police"]:logAudit(src, "mdt_execute_warrant", "warrant", warrantId, "Executed warrant")
    end)
end)

-- Cancel warrant
RegisterNetEvent("lxr-police:mdt:cancelWarrant")
AddEventHandler("lxr-police:mdt:cancelWarrant", function(warrantId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute("UPDATE mdt_warrants SET status = 'expired' WHERE id = @id", {["@id"] = warrantId}, function()
        TriggerClientEvent("lxr-police:notify", src, "Warrant cancelled", "success")
        exports["lxr-police"]:logAudit(src, "mdt_cancel_warrant", "warrant", warrantId, "Cancelled warrant")
    end)
end)

-- ============================================================================
-- WANTED POSTERS
-- ============================================================================

-- Create wanted poster
RegisterNetEvent("lxr-police:mdt:createWantedPoster")
AddEventHandler("lxr-police:mdt:createWantedPoster", function(posterData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    -- Generate poster number
    local posterNumber = "WP-" .. os.date("%Y%m%d") .. "-" .. math.random(1000, 9999)
    
    MySQL.Async.execute([[
        INSERT INTO mdt_wanted_posters (poster_number, citizen_id, created_by, title, description, charges, reward_amount, danger_level, last_known_location, physical_description, known_associates, status, created_at)
        VALUES (@number, @citizen, @officer, @title, @description, @charges, @reward, @danger, @location, @physical, @associates, @status, @time)
    ]], {
        ["@number"] = posterNumber,
        ["@citizen"] = posterData.citizenId,
        ["@officer"] = src,
        ["@title"] = posterData.title,
        ["@description"] = posterData.description,
        ["@charges"] = json.encode(posterData.charges),
        ["@reward"] = posterData.rewardAmount or 0,
        ["@danger"] = posterData.dangerLevel or 'medium',
        ["@location"] = posterData.lastKnownLocation,
        ["@physical"] = posterData.physicalDescription,
        ["@associates"] = posterData.knownAssociates,
        ["@status"] = "active",
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S')
    }, function(insertId)
        TriggerClientEvent("lxr-police:notify", src, "Wanted poster created", "success")
        TriggerClientEvent("lxr-police:mdt:posterCreated", src, insertId, posterNumber)
        
        -- Notify all officers
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            if exports["lxr-police"]:IsOfficer(tonumber(playerId)) then
                TriggerClientEvent("lxr-police:notify", tonumber(playerId), "New wanted poster: " .. posterData.title, "warning")
            end
        end
        
        exports["lxr-police"]:logAudit(src, "mdt_create_poster", "poster", insertId, "Created wanted poster: " .. posterData.title)
    end)
end)

-- Get active wanted posters
RegisterNetEvent("lxr-police:mdt:getWantedPosters")
AddEventHandler("lxr-police:mdt:getWantedPosters", function(status)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_view") then return end
    
    local sql = [[
        SELECT wp.*, c.name as citizen_name, c.mugshot
        FROM mdt_wanted_posters wp
        LEFT JOIN mdt_citizens c ON wp.citizen_id = c.id
    ]]
    
    if status then
        sql = sql .. " WHERE wp.status = @status"
    else
        sql = sql .. " WHERE wp.status = 'active'"
    end
    
    sql = sql .. " ORDER BY wp.danger_level DESC, wp.reward_amount DESC, wp.created_at DESC"
    
    MySQL.Async.fetchAll(sql, status and {["@status"] = status} or {}, function(posters)
        TriggerClientEvent("lxr-police:mdt:wantedPosterList", src, posters)
    end)
end)

-- Mark poster as captured
RegisterNetEvent("lxr-police:mdt:captureWanted")
AddEventHandler("lxr-police:mdt:captureWanted", function(posterId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        UPDATE mdt_wanted_posters SET 
        status = 'captured',
        captured_at = @time,
        captured_by = @officer
        WHERE id = @id
    ]], {
        ["@id"] = posterId,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S'),
        ["@officer"] = src
    }, function()
        TriggerClientEvent("lxr-police:notify", src, "Suspect captured", "success")
        exports["lxr-police"]:logAudit(src, "mdt_capture_wanted", "poster", posterId, "Marked as captured")
    end)
end)

-- ============================================================================
-- CASE MANAGEMENT
-- ============================================================================

-- Create case file
RegisterNetEvent("lxr-police:mdt:createCase")
AddEventHandler("lxr-police:mdt:createCase", function(caseData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    -- Generate case number
    local caseNumber = "CASE-" .. os.date("%Y%m%d") .. "-" .. math.random(1000, 9999)
    
    MySQL.Async.execute([[
        INSERT INTO mdt_cases (case_number, title, description, case_type, status, priority, lead_officer, assigned_officers, suspects, victims, witnesses, notes, opened_at)
        VALUES (@number, @title, @description, @type, @status, @priority, @lead, @assigned, @suspects, @victims, @witnesses, @notes, @time)
    ]], {
        ["@number"] = caseNumber,
        ["@title"] = caseData.title,
        ["@description"] = caseData.description,
        ["@type"] = caseData.caseType or 'criminal',
        ["@status"] = "open",
        ["@priority"] = caseData.priority or 'medium',
        ["@lead"] = src,
        ["@assigned"] = json.encode(caseData.assignedOfficers or {}),
        ["@suspects"] = json.encode(caseData.suspects or {}),
        ["@victims"] = json.encode(caseData.victims or {}),
        ["@witnesses"] = json.encode(caseData.witnesses or {}),
        ["@notes"] = caseData.notes,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S')
    }, function(insertId)
        TriggerClientEvent("lxr-police:notify", src, "Case file created", "success")
        TriggerClientEvent("lxr-police:mdt:caseCreated", src, insertId, caseNumber)
        exports["lxr-police"]:logAudit(src, "mdt_create_case", "case", insertId, "Created case: " .. caseData.title)
    end)
end)

-- Update case status
RegisterNetEvent("lxr-police:mdt:updateCaseStatus")
AddEventHandler("lxr-police:mdt:updateCaseStatus", function(caseId, status)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    local closedAt = nil
    if status == "closed" then
        closedAt = os.date('%Y-%m-%d %H:%M:%S')
    end
    
    MySQL.Async.execute([[
        UPDATE mdt_cases SET 
        status = @status,
        closed_at = @closed
        WHERE id = @id
    ]], {
        ["@id"] = caseId,
        ["@status"] = status,
        ["@closed"] = closedAt
    }, function()
        TriggerClientEvent("lxr-police:notify", src, "Case status updated", "success")
        exports["lxr-police"]:logAudit(src, "mdt_update_case", "case", caseId, "Updated status to " .. status)
    end)
end)

-- ============================================================================
-- VEHICLE LOOKUPS
-- ============================================================================

-- Vehicle lookup by plate
RegisterNetEvent("lxr-police:mdt:vehicleLookup")
AddEventHandler("lxr-police:mdt:vehicleLookup", function(plate)
    local src = source
    if not exports["lxr-police"]:IsOfficer(src) then return end
    
    MySQL.Async.fetchAll([[
        SELECT v.*, c.name as owner_name
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
            TriggerClientEvent("lxr-police:notify", src, "Vehicle not found in database", "error")
        end
    end)
    
    exports["lxr-police"]:logAudit(src, "mdt_vehicle_lookup", "vehicle", plate, "Looked up vehicle: " .. plate)
end)

-- Register/Update vehicle
RegisterNetEvent("lxr-police:mdt:registerVehicle")
AddEventHandler("lxr-police:mdt:registerVehicle", function(vehicleData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        INSERT INTO mdt_vehicles (plate, owner_id, vehicle_model, vehicle_type, color, registration_status, insurance_status, notes)
        VALUES (@plate, @owner, @model, @type, @color, @reg_status, @ins_status, @notes)
        ON DUPLICATE KEY UPDATE
        owner_id = @owner,
        vehicle_model = @model,
        vehicle_type = @type,
        color = @color,
        registration_status = @reg_status,
        insurance_status = @ins_status,
        notes = @notes
    ]], {
        ["@plate"] = vehicleData.plate,
        ["@owner"] = vehicleData.ownerId,
        ["@model"] = vehicleData.model,
        ["@type"] = vehicleData.type,
        ["@color"] = vehicleData.color,
        ["@reg_status"] = vehicleData.registrationStatus or 'valid',
        ["@ins_status"] = vehicleData.insuranceStatus or 'none',
        ["@notes"] = vehicleData.notes
    }, function()
        TriggerClientEvent("lxr-police:notify", src, "Vehicle registered", "success")
        exports["lxr-police"]:logAudit(src, "mdt_register_vehicle", "vehicle", vehicleData.plate, "Registered vehicle")
    end)
end)

-- ============================================================================
-- BOLO SYSTEM
-- ============================================================================

-- Create BOLO
RegisterNetEvent("lxr-police:mdt:createBOLO")
AddEventHandler("lxr-police:mdt:createBOLO", function(boloData)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        INSERT INTO mdt_bolos (created_by, bolo_type, title, description, plate, suspect_name, suspect_description, last_seen_location, danger_level, status, created_at)
        VALUES (@officer, @type, @title, @description, @plate, @suspect, @suspect_desc, @location, @danger, @status, @time)
    ]], {
        ["@officer"] = src,
        ["@type"] = boloData.boloType,
        ["@title"] = boloData.title,
        ["@description"] = boloData.description,
        ["@plate"] = boloData.plate,
        ["@suspect"] = boloData.suspectName,
        ["@suspect_desc"] = boloData.suspectDescription,
        ["@location"] = boloData.lastSeenLocation,
        ["@danger"] = boloData.dangerLevel or 'medium',
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
        ORDER BY b.danger_level DESC, b.created_at DESC
    ]], {}, function(bolos)
        TriggerClientEvent("lxr-police:mdt:boloList", src, bolos)
    end)
end)

-- Resolve BOLO
RegisterNetEvent("lxr-police:mdt:resolveBOLO")
AddEventHandler("lxr-police:mdt:resolveBOLO", function(boloId)
    local src = source
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then return end
    
    MySQL.Async.execute([[
        UPDATE mdt_bolos SET 
        status = 'resolved',
        resolved_at = @time,
        resolved_by = @officer
        WHERE id = @id
    ]], {
        ["@id"] = boloId,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S'),
        ["@officer"] = src
    }, function()
        TriggerClientEvent("lxr-police:notify", src, "BOLO resolved", "success")
        exports["lxr-police"]:logAudit(src, "mdt_resolve_bolo", "bolo", boloId, "Resolved BOLO")
    end)
end)

-- ============================================================================
-- DASHBOARD STATISTICS
-- ============================================================================

-- Get dashboard stats
RegisterNetEvent("lxr-police:mdt:getDashboardStats")
AddEventHandler("lxr-police:mdt:getDashboardStats", function()
    local src = source
    if not exports["lxr-police"]:IsOfficer(src) then return end
    
    -- Count active officers
    local activeOfficers = 0
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        if exports["lxr-police"]:IsOfficer(tonumber(playerId)) then
            activeOfficers = activeOfficers + 1
        end
    end
    
    -- Get other stats from database
    MySQL.Async.fetchAll("SELECT COUNT(*) as count FROM mdt_warrants WHERE status = 'active'", {}, function(warrants)
        MySQL.Async.fetchAll("SELECT COUNT(*) as count FROM mdt_wanted_posters WHERE status = 'active'", {}, function(posters)
            MySQL.Async.fetchAll("SELECT SUM(reward_amount) as total FROM mdt_wanted_posters WHERE status = 'active'", {}, function(bounties)
                MySQL.Async.fetchAll("SELECT COUNT(*) as count FROM leo_jail WHERE release_time IS NULL OR release_time > NOW()", {}, function(prisoners)
                    
                    local stats = {
                        activeOfficers = activeOfficers,
                        activeWarrants = warrants[1].count or 0,
                        activePrisoners = prisoners[1].count or 0,
                        activePosters = posters[1].count or 0,
                        totalBounties = bounties[1].total or 0
                    }
                    
                    TriggerClientEvent("lxr-police:mdt:dashboardStats", src, stats)
                end)
            end)
        end)
    end)
end)

-- ============================================================================
-- EXPORTS
-- ============================================================================

exports("GetMDTVersion", function()
    return MDT_VERSION
end)

exports("SearchCitizen", function(query, cb)
    MySQL.Async.fetchAll([[
        SELECT * FROM mdt_citizens 
        WHERE name LIKE @q OR identifier LIKE @q 
        LIMIT 10
    ]], {["@q"] = "%" .. query .. "%"}, function(results)
        if cb then cb(results) end
    end)
end)

exports("GetCitizenByIdentifier", function(identifier, cb)
    MySQL.Async.fetchAll("SELECT * FROM mdt_citizens WHERE identifier = @id", {["@id"] = identifier}, function(results)
        if cb then cb(results[1] or nil) end
    end)
end)

print("^2[MDT Enhanced]^7 MDT System v" .. MDT_VERSION .. " loaded successfully")

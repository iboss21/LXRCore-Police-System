-- Server-side Evidence Management
local evidenceStorage = {}
local evidenceCounter = 1

-- Store collected evidence
RegisterNetEvent("lxr-police:evidence:collect")
AddEventHandler("lxr-police:evidence:collect", function(evidenceId, evidenceType, data)
    local src = source
    
    if not exports["lxr-police"]:IsOfficer(src) then
        return
    end
    
    local evidenceNumber = "EVD-" .. string.format("%06d", evidenceCounter)
    evidenceCounter = evidenceCounter + 1
    
    local evidence = {
        id = evidenceNumber,
        type = evidenceType,
        data = data,
        collectedBy = src,
        collectedAt = os.date('%Y-%m-%d %H:%M:%S'),
        status = "collected"
    }
    
    evidenceStorage[evidenceNumber] = evidence
    
    -- Save to database
    MySQL.Async.execute([[
        INSERT INTO mdt_evidence (evidence_number, type, data, collected_by, collected_at, status)
        VALUES (@number, @type, @data, @officer, @time, @status)
    ]], {
        ["@number"] = evidenceNumber,
        ["@type"] = evidenceType,
        ["@data"] = json.encode(data),
        ["@officer"] = src,
        ["@time"] = evidence.collectedAt,
        ["@status"] = "collected"
    })
    
    TriggerClientEvent("lxr-police:notify", src, "Evidence collected: " .. evidenceNumber, "success")
    exports["lxr-police"]:logAudit(src, "evidence_collect", "evidence", evidenceNumber, "Collected " .. evidenceType)
end)

-- Analyze evidence
RegisterNetEvent("lxr-police:evidence:analyze")
AddEventHandler("lxr-police:evidence:analyze", function(evidenceNumber)
    local src = source
    
    if not exports["lxr-police"]:IsOfficer(src) then
        return
    end
    
    local evidence = evidenceStorage[evidenceNumber]
    if not evidence then
        -- Try to load from database
        MySQL.Async.fetchAll("SELECT * FROM mdt_evidence WHERE evidence_number = @number", {
            ["@number"] = evidenceNumber
        }, function(result)
            if result[1] then
                evidence = {
                    id = result[1].evidence_number,
                    type = result[1].type,
                    data = json.decode(result[1].data),
                    collectedBy = result[1].collected_by,
                    collectedAt = result[1].collected_at,
                    status = result[1].status
                }
                evidenceStorage[evidenceNumber] = evidence
                
                -- Perform analysis
                performAnalysis(src, evidence)
            else
                TriggerClientEvent("lxr-police:notify", src, "Evidence not found", "error")
            end
        end)
    else
        performAnalysis(src, evidence)
    end
end)

function performAnalysis(src, evidence)
    local analysisResults = {
        evidenceNumber = evidence.id,
        type = evidence.type,
        findings = {}
    }
    
    -- Type-specific analysis
    if evidence.type == "blood" then
        analysisResults.findings = {
            bloodType = evidence.data.bloodType or "O+",
            dnaProfile = generateDNAProfile(),
            quality = math.random(60, 100)
        }
    elseif evidence.type == "casing" then
        analysisResults.findings = {
            caliber = evidence.data.weaponType or ".45 ACP",
            serialNumber = evidence.data.serialNumber,
            firingPinMark = generateFiringPinMark(),
            quality = math.random(70, 100)
        }
    elseif evidence.type == "fingerprint" then
        analysisResults.findings = {
            pattern = {"Whorl", "Loop", "Arch"}[math.random(1, 3)],
            quality = math.random(50, 100),
            matches = searchFingerprintDatabase(evidence.data)
        }
    elseif evidence.type == "weapon" then
        analysisResults.findings = {
            weaponType = evidence.data.weaponType or "Pistol",
            serialNumber = evidence.data.serialNumber or "Unknown",
            lastFired = evidence.data.lastFired or "Unknown",
            registered = math.random() > 0.5
        }
    end
    
    -- Update database with analysis
    MySQL.Async.execute([[
        UPDATE mdt_evidence SET status = @status, analysis = @analysis
        WHERE evidence_number = @number
    ]], {
        ["@number"] = evidence.id,
        ["@status"] = "analyzed",
        ["@analysis"] = json.encode(analysisResults.findings)
    })
    
    TriggerClientEvent("lxr-police:evidence:analysisComplete", src, analysisResults)
    exports["lxr-police"]:logAudit(src, "evidence_analyze", "evidence", evidence.id, "Analyzed evidence")
end

-- Constants
local DNA_PROFILE_SEGMENTS = 8

function generateDNAProfile()
    local profile = ""
    for i = 1, DNA_PROFILE_SEGMENTS do
        profile = profile .. string.format("%02X", math.random(0, 255))
        if i < DNA_PROFILE_SEGMENTS then profile = profile .. "-" end
    end
    return profile
end

function generateFiringPinMark()
    return "FP-" .. string.format("%04X", math.random(0, 65535))
end

function searchFingerprintDatabase(data)
    -- Placeholder: Would search against citizen database
    if math.random() > 0.7 then
        return {
            match = true,
            citizenId = "CID-" .. math.random(1000, 9999),
            confidence = math.random(80, 100)
        }
    else
        return {match = false}
    end
end

-- Link evidence to case
RegisterNetEvent("lxr-police:evidence:linkToCase")
AddEventHandler("lxr-police:evidence:linkToCase", function(evidenceNumber, caseId)
    local src = source
    
    if not exports["lxr-police"]:HasPermission(src, "mdt_edit") then
        return
    end
    
    MySQL.Async.execute([[
        UPDATE mdt_evidence SET case_id = @case WHERE evidence_number = @number
    ]], {
        ["@number"] = evidenceNumber,
        ["@case"] = caseId
    })
    
    TriggerClientEvent("lxr-police:notify", src, "Evidence linked to case", "success")
    exports["lxr-police"]:logAudit(src, "evidence_link", "evidence", evidenceNumber, "Linked to case: " .. caseId)
end)

-- Photo evidence
RegisterNetEvent("lxr-police:evidence:photoTaken")
AddEventHandler("lxr-police:evidence:photoTaken", function(photoData)
    local src = source
    
    if not exports["lxr-police"]:IsOfficer(src) then
        return
    end
    
    local photoNumber = "PHOTO-" .. string.format("%06d", evidenceCounter)
    evidenceCounter = evidenceCounter + 1
    
    MySQL.Async.execute([[
        INSERT INTO mdt_evidence (evidence_number, type, data, collected_by, collected_at, status)
        VALUES (@number, @type, @data, @officer, @time, @status)
    ]], {
        ["@number"] = photoNumber,
        ["@type"] = "photo",
        ["@data"] = json.encode(photoData),
        ["@officer"] = src,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S'),
        ["@status"] = "collected"
    })
    
    exports["lxr-police"]:logAudit(src, "evidence_photo", "evidence", photoNumber, "Photo evidence captured")
end)

-- Get evidence by case
RegisterNetEvent("lxr-police:evidence:getByCaseId")
AddEventHandler("lxr-police:evidence:getByCaseId", function(caseId)
    local src = source
    
    if not exports["lxr-police"]:IsOfficer(src) then
        return
    end
    
    MySQL.Async.fetchAll("SELECT * FROM mdt_evidence WHERE case_id = @case ORDER BY collected_at DESC", {
        ["@case"] = caseId
    }, function(results)
        local evidence = {}
        for _, row in ipairs(results) do
            table.insert(evidence, {
                id = row.evidence_number,
                type = row.type,
                data = json.decode(row.data),
                collectedBy = row.collected_by,
                collectedAt = row.collected_at,
                status = row.status,
                analysis = row.analysis and json.decode(row.analysis) or nil
            })
        end
        
        TriggerClientEvent("lxr-police:evidence:caseEvidenceList", src, caseId, evidence)
    end)
end)

-- Search evidence
RegisterNetEvent("lxr-police:evidence:search")
AddEventHandler("lxr-police:evidence:search", function(query)
    local src = source
    
    if not exports["lxr-police"]:IsOfficer(src) then
        return
    end
    
    MySQL.Async.fetchAll([[
        SELECT * FROM mdt_evidence 
        WHERE evidence_number LIKE @query 
        OR type LIKE @query 
        ORDER BY collected_at DESC 
        LIMIT 50
    ]], {
        ["@query"] = "%" .. query .. "%"
    }, function(results)
        local evidence = {}
        for _, row in ipairs(results) do
            table.insert(evidence, {
                id = row.evidence_number,
                type = row.type,
                data = json.decode(row.data),
                collectedBy = row.collected_by,
                collectedAt = row.collected_at,
                status = row.status
            })
        end
        
        TriggerClientEvent("lxr-police:evidence:searchResults", src, evidence)
    end)
end)

-- Chain of custody
RegisterNetEvent("lxr-police:evidence:transfer")
AddEventHandler("lxr-police:evidence:transfer", function(evidenceNumber, targetOfficer, reason)
    local src = source
    
    if not exports["lxr-police"]:IsOfficer(src) then
        return
    end
    
    MySQL.Async.execute([[
        INSERT INTO mdt_evidence_custody (evidence_number, from_officer, to_officer, transfer_time, reason)
        VALUES (@number, @from, @to, @time, @reason)
    ]], {
        ["@number"] = evidenceNumber,
        ["@from"] = src,
        ["@to"] = targetOfficer,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S'),
        ["@reason"] = reason
    })
    
    TriggerClientEvent("lxr-police:notify", src, "Evidence transferred", "success")
    TriggerClientEvent("lxr-police:notify", targetOfficer, "You received evidence: " .. evidenceNumber, "primary")
    exports["lxr-police"]:logAudit(src, "evidence_transfer", "evidence", evidenceNumber, "Transferred to officer " .. targetOfficer)
end)

-- Export functions
exports("GetEvidence", function(evidenceNumber)
    return evidenceStorage[evidenceNumber]
end)

exports("CreateEvidence", function(evidenceType, data, collectedBy)
    local evidenceNumber = "EVD-" .. string.format("%06d", evidenceCounter)
    evidenceCounter = evidenceCounter + 1
    
    local evidence = {
        id = evidenceNumber,
        type = evidenceType,
        data = data,
        collectedBy = collectedBy,
        collectedAt = os.date('%Y-%m-%d %H:%M:%S'),
        status = "collected"
    }
    
    evidenceStorage[evidenceNumber] = evidence
    
    MySQL.Async.execute([[
        INSERT INTO mdt_evidence (evidence_number, type, data, collected_by, collected_at, status)
        VALUES (@number, @type, @data, @officer, @time, @status)
    ]], {
        ["@number"] = evidenceNumber,
        ["@type"] = evidenceType,
        ["@data"] = json.encode(data),
        ["@officer"] = collectedBy,
        ["@time"] = evidence.collectedAt,
        ["@status"] = "collected"
    })
    
    return evidenceNumber
end)

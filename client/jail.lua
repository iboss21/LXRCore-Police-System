-- Comprehensive Jail/Prison System for RedM
local prisonerData = {}
local jailCells = {}
local jailActivities = {}

-- Initialize jail cells from config
CreateThread(function()
    for stationName, station in pairs(Config.Stations) do
        if station.cells then
            for i, cellCoords in ipairs(station.cells) do
                table.insert(jailCells, {
                    station = stationName,
                    coords = cellCoords,
                    occupied = false,
                    prisoner = nil
                })
            end
        end
    end
end)

-- Get available cell
local function getAvailableCell()
    for i, cell in ipairs(jailCells) do
        if not cell.occupied then
            return i, cell
        end
    end
    return nil, nil
end

-- Sentence calculation based on charges
local function calculateSentence(charges)
    local totalTime = 0
    local totalFine = 0
    
    for _, charge in ipairs(charges) do
        totalTime = totalTime + (charge.jailTime or 0)
        totalFine = totalFine + (charge.fine or 0)
    end
    
    -- Apply minimum and maximum limits
    totalTime = math.max(Config.Jail.ParoleMin or 10, totalTime)
    totalTime = math.min(600, totalTime) -- Max 600 seconds (10 minutes)
    
    return totalTime, totalFine
end

-- Send player to jail
RegisterNetEvent("lxr-police:jail:sentence")
AddEventHandler("lxr-police:jail:sentence", function(targetId, charges, reason)
    local src = source
    
    if not exports["lxr-police"]:HasPermission(src, "arrest") then
        TriggerClientEvent("lxr-police:notify", src, "You don't have permission to jail players", "error")
        return
    end
    
    local cellIndex, cell = getAvailableCell()
    if not cellIndex then
        TriggerClientEvent("lxr-police:notify", src, "No available cells", "error")
        return
    end
    
    local jailTime, fine = calculateSentence(charges)
    
    -- Mark cell as occupied
    jailCells[cellIndex].occupied = true
    jailCells[cellIndex].prisoner = targetId
    
    -- Store prisoner data
    prisonerData[targetId] = {
        cellIndex = cellIndex,
        sentenceTime = jailTime,
        remainingTime = jailTime,
        fine = fine,
        charges = charges,
        reason = reason,
        sentencedBy = src,
        sentencedAt = os.time(),
        paroleEligible = false
    }
    
    -- Save to database
    MySQL.Async.execute([[
        INSERT INTO leo_jail (prisoner_id, cell_id, sentence_time, fine, charges, reason, sentenced_by, sentenced_at)
        VALUES (@prisoner, @cell, @time, @fine, @charges, @reason, @officer, @sentenced)
    ]], {
        ["@prisoner"] = targetId,
        ["@cell"] = cellIndex,
        ["@time"] = jailTime,
        ["@fine"] = fine,
        ["@charges"] = json.encode(charges),
        ["@reason"] = reason,
        ["@officer"] = src,
        ["@sentenced"] = os.date('%Y-%m-%d %H:%M:%S')
    })
    
    -- Teleport and start sentence
    TriggerClientEvent("lxr-police:jail:startSentence", targetId, {
        cellCoords = cell.coords,
        sentenceTime = jailTime,
        fine = fine,
        charges = charges
    })
    
    TriggerClientEvent("lxr-police:notify", src, "Prisoner sent to jail for " .. jailTime .. " seconds", "success")
    TriggerClientEvent("lxr-police:notify", targetId, "You have been sentenced to " .. jailTime .. " seconds in jail", "error")
    
    exports["lxr-police"]:logAudit(src, "jail_sentence", "player", targetId, "Jailed for " .. jailTime .. "s. Reason: " .. reason)
    
    -- Start sentence timer
    startSentenceTimer(targetId)
end)

-- Sentence timer
function startSentenceTimer(targetId)
    CreateThread(function()
        while prisonerData[targetId] and prisonerData[targetId].remainingTime > 0 do
            Citizen.Wait(1000)
            
            if prisonerData[targetId] then
                prisonerData[targetId].remainingTime = prisonerData[targetId].remainingTime - 1
                
                -- Update client with remaining time
                TriggerClientEvent("lxr-police:jail:updateTime", targetId, prisonerData[targetId].remainingTime)
                
                -- Check for parole eligibility (at 50% of sentence)
                if prisonerData[targetId].remainingTime <= (prisonerData[targetId].sentenceTime * 0.5) then
                    prisonerData[targetId].paroleEligible = true
                    if prisonerData[targetId].remainingTime == math.floor(prisonerData[targetId].sentenceTime * 0.5) then
                        TriggerClientEvent("lxr-police:notify", targetId, "You are now eligible for parole", "primary")
                    end
                end
                
                -- Auto-release when time is up
                if prisonerData[targetId].remainingTime <= 0 then
                    releaseFromJail(targetId, "sentence_completed")
                end
            else
                break
            end
        end
    end)
end

-- Release from jail
function releaseFromJail(targetId, reason)
    if not prisonerData[targetId] then return end
    
    local cellIndex = prisonerData[targetId].cellIndex
    
    -- Free the cell
    if jailCells[cellIndex] then
        jailCells[cellIndex].occupied = false
        jailCells[cellIndex].prisoner = nil
    end
    
    -- Update database
    MySQL.Async.execute([[
        UPDATE leo_jail SET released_at = @time, release_reason = @reason
        WHERE prisoner_id = @prisoner AND released_at IS NULL
    ]], {
        ["@prisoner"] = targetId,
        ["@time"] = os.date('%Y-%m-%d %H:%M:%S'),
        ["@reason"] = reason
    })
    
    -- Teleport to release location
    local releaseCoords = Config.Jail.ReleaseLocation or vec3(-350.0, 800.0, 115.0)
    TriggerClientEvent("lxr-police:jail:release", targetId, releaseCoords)
    
    TriggerClientEvent("lxr-police:notify", targetId, "You have been released from jail", "success")
    
    -- Clear prisoner data
    prisonerData[targetId] = nil
end

RegisterNetEvent("lxr-police:jail:release")
AddEventHandler("lxr-police:jail:release", function(targetId, reason)
    local src = source
    
    if not exports["lxr-police"]:HasPermission(src, "arrest") then
        TriggerClientEvent("lxr-police:notify", src, "You don't have permission to release prisoners", "error")
        return
    end
    
    releaseFromJail(targetId, reason or "officer_release")
    exports["lxr-police"]:logAudit(src, "jail_release", "player", targetId, "Released. Reason: " .. (reason or "officer_release"))
end)

-- Parole application
RegisterNetEvent("lxr-police:jail:requestParole")
AddEventHandler("lxr-police:jail:requestParole", function()
    local src = source
    
    if not prisonerData[src] then
        TriggerClientEvent("lxr-police:notify", src, "You are not in jail", "error")
        return
    end
    
    if not prisonerData[src].paroleEligible then
        TriggerClientEvent("lxr-police:notify", src, "You are not eligible for parole yet", "error")
        return
    end
    
    -- Pay parole fine (50% of original fine)
    local paroleFine = math.floor(prisonerData[src].fine * 0.5)
    
    if exports["lxr-police"]:RemoveMoney(src, "cash", paroleFine) then
        releaseFromJail(src, "parole")
        TriggerClientEvent("lxr-police:notify", src, "Parole granted. Paid $" .. paroleFine, "success")
        exports["lxr-police"]:logAudit(src, "jail_parole", "player", src, "Granted parole. Paid $" .. paroleFine)
    else
        TriggerClientEvent("lxr-police:notify", src, "Insufficient funds for parole ($" .. paroleFine .. ")", "error")
    end
end)

-- Bail system
RegisterNetEvent("lxr-police:jail:payBail")
AddEventHandler("lxr-police:jail:payBail", function()
    local src = source
    
    if not prisonerData[src] then
        TriggerClientEvent("lxr-police:notify", src, "You are not in jail", "error")
        return
    end
    
    local bailAmount = prisonerData[src].fine * 2 -- Bail is double the fine
    
    if exports["lxr-police"]:RemoveMoney(src, "bank", bailAmount) then
        releaseFromJail(src, "bail_paid")
        TriggerClientEvent("lxr-police:notify", src, "Bail paid. Released. Amount: $" .. bailAmount, "success")
        exports["lxr-police"]:logAudit(src, "jail_bail", "player", src, "Paid bail. Amount: $" .. bailAmount)
    else
        TriggerClientEvent("lxr-police:notify", src, "Insufficient funds for bail ($" .. bailAmount .. ")", "error")
    end
end)

-- Prison jobs (reduce sentence)
RegisterNetEvent("lxr-police:jail:completeJob")
AddEventHandler("lxr-police:jail:completeJob", function(jobType)
    local src = source
    
    if not prisonerData[src] then
        TriggerClientEvent("lxr-police:notify", src, "You are not in jail", "error")
        return
    end
    
    -- Reduce sentence based on job
    local timeReduction = {
        cleanup = 30,  -- 30 seconds
        laundry = 45,  -- 45 seconds
        kitchen = 60   -- 60 seconds
    }
    
    local reduction = timeReduction[jobType] or 30
    prisonerData[src].remainingTime = math.max(0, prisonerData[src].remainingTime - reduction)
    
    TriggerClientEvent("lxr-police:notify", src, "Sentence reduced by " .. reduction .. " seconds", "success")
    TriggerClientEvent("lxr-police:jail:updateTime", src, prisonerData[src].remainingTime)
end)

-- Get prisoner list
RegisterNetEvent("lxr-police:jail:getPrisoners")
AddEventHandler("lxr-police:jail:getPrisoners", function()
    local src = source
    
    if not exports["lxr-police"]:IsOfficer(src) then
        return
    end
    
    local prisoners = {}
    for playerId, data in pairs(prisonerData) do
        table.insert(prisoners, {
            id = playerId,
            cellIndex = data.cellIndex,
            remainingTime = data.remainingTime,
            fine = data.fine,
            charges = data.charges,
            paroleEligible = data.paroleEligible
        })
    end
    
    TriggerClientEvent("lxr-police:jail:prisonerList", src, prisoners)
end)

-- Export functions
exports("IsInJail", function(targetId)
    return prisonerData[targetId] ~= nil
end)

exports("GetPrisonerData", function(targetId)
    return prisonerData[targetId]
end)

exports("GetJailCells", function()
    return jailCells
end)
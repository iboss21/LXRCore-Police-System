-- Physical Items System - Server Side
local RSGCore = exports['rsg-core']:GetCoreObject()

-- ══════════════════════════════════════════════════════════════
-- HELPER FUNCTIONS
-- ══════════════════════════════════════════════════════════════
local function GivePhysicalItem(src, itemConfig, metadata)
    if not Config.PhysicalItems.Enabled or not itemConfig.enabled then
        return false
    end
    
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return false end
    
    -- Check inventory space if required
    if Config.PhysicalItems.RequireInventorySpace then
        -- TODO: Check if player has space
    end
    
    -- Create metadata
    local itemMetadata = metadata or {}
    itemMetadata.created = os.date("%Y-%m-%d %H:%M:%S")
    itemMetadata.unique = itemConfig.unique or false
    
    -- Add item to inventory
    if GetResourceState('rsg-inventory') == 'started' then
        return exports['rsg-inventory']:AddItem(src, itemConfig.itemName, 1, nil, itemMetadata)
    else
        return Player.Functions.AddItem(itemConfig.itemName, 1, false, itemMetadata)
    end
end

-- ══════════════════════════════════════════════════════════════
-- INCIDENT REPORT CREATION
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:items:giveIncidentReport', function(reportData)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player or not Config.PhysicalItems.IncidentReport.enabled then return end
    
    local metadata = {
        reportId = reportData.id or 0,
        title = reportData.title or "Incident Report",
        officer = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
        location = reportData.location or "Unknown",
        date = os.date("%Y-%m-%d %H:%M:%S"),
        description = reportData.description or "",
    }
    
    if Config.PhysicalItems.IncidentReport.giveToOfficer then
        local success = GivePhysicalItem(src, Config.PhysicalItems.IncidentReport, metadata)
        if success then
            TriggerClientEvent('RSGCore:Notify', src, 'You received an incident report document', 'success')
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- ARREST REPORT CREATION
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:items:giveArrestReport', function(arrestData)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player or not Config.PhysicalItems.ArrestReport.enabled then return end
    
    local metadata = {
        reportId = arrestData.id or 0,
        suspect = arrestData.suspectName or "Unknown",
        charges = arrestData.charges or {},
        officer = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
        date = os.date("%Y-%m-%d %H:%M:%S"),
        location = arrestData.location or "Unknown",
    }
    
    -- Give to officer
    if Config.PhysicalItems.ArrestReport.giveToOfficer then
        GivePhysicalItem(src, Config.PhysicalItems.ArrestReport, metadata)
        TriggerClientEvent('RSGCore:Notify', src, 'You received an arrest report document', 'success')
    end
    
    -- Give to suspect
    if Config.PhysicalItems.ArrestReport.giveToSuspect and arrestData.suspectId then
        local Suspect = RSGCore.Functions.GetPlayer(arrestData.suspectId)
        if Suspect then
            GivePhysicalItem(arrestData.suspectId, Config.PhysicalItems.ArrestReport, metadata)
            TriggerClientEvent('RSGCore:Notify', arrestData.suspectId, 'You received a copy of your arrest report', 'primary')
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- CITATION TICKET CREATION
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:items:giveCitation', function(citationData)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player or not Config.PhysicalItems.Citation.enabled then return end
    
    local metadata = {
        citationId = citationData.id or 0,
        violation = citationData.violation or "Unknown",
        fine = citationData.fine or 0,
        officer = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
        date = os.date("%Y-%m-%d %H:%M:%S"),
        location = citationData.location or "Unknown",
    }
    
    -- Give to officer
    if Config.PhysicalItems.Citation.giveToOfficer then
        GivePhysicalItem(src, Config.PhysicalItems.Citation, metadata)
    end
    
    -- Give to suspect
    if Config.PhysicalItems.Citation.giveToSuspect and citationData.suspectId then
        local Suspect = RSGCore.Functions.GetPlayer(citationData.suspectId)
        if Suspect then
            GivePhysicalItem(citationData.suspectId, Config.PhysicalItems.Citation, metadata)
            TriggerClientEvent('RSGCore:Notify', citationData.suspectId, 'You received a citation ticket', 'error')
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- WARRANT CREATION
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:items:giveWarrant', function(warrantData)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player or not Config.PhysicalItems.Warrant.enabled then return end
    
    local metadata = {
        warrantId = warrantData.id or 0,
        suspect = warrantData.suspectName or "Unknown",
        charges = warrantData.charges or "Unknown",
        judge = warrantData.judge or "County Judge",
        officer = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
        date = os.date("%Y-%m-%d %H:%M:%S"),
    }
    
    if Config.PhysicalItems.Warrant.giveToOfficer then
        local success = GivePhysicalItem(src, Config.PhysicalItems.Warrant, metadata)
        if success then
            TriggerClientEvent('RSGCore:Notify', src, 'You received an arrest warrant', 'success')
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- BOUNTY POSTER CREATION
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:items:giveBountyPoster', function(bountyData)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player or not Config.PhysicalItems.BountyPoster.enabled then return end
    
    local metadata = {
        bountyId = bountyData.id or 0,
        wanted = bountyData.name or "Unknown Outlaw",
        reward = bountyData.amount or 0,
        crimes = bountyData.crimes or "Various Crimes",
        deadOrAlive = bountyData.deadOrAlive or "Dead or Alive",
        issuer = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
        date = os.date("%Y-%m-%d %H:%M:%S"),
    }
    
    if Config.PhysicalItems.BountyPoster.giveToOfficer then
        local success = GivePhysicalItem(src, Config.PhysicalItems.BountyPoster, metadata)
        if success then
            TriggerClientEvent('RSGCore:Notify', src, 'You received a wanted poster', 'success')
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- EVIDENCE BAG CREATION
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:items:giveEvidenceBag', function(evidenceData)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player or not Config.PhysicalItems.EvidenceBag.enabled then return end
    
    local evidenceType = evidenceData.type or "blood"
    local evidenceConfig = Config.PhysicalItems.EvidenceBag.types[evidenceType]
    
    if not evidenceConfig then
        evidenceConfig = Config.PhysicalItems.EvidenceBag
    end
    
    local metadata = {
        evidenceId = evidenceData.id or 0,
        type = evidenceType,
        location = evidenceData.location or "Unknown",
        collector = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
        date = os.date("%Y-%m-%d %H:%M:%S"),
        caseNumber = evidenceData.caseNumber or "N/A",
        description = evidenceData.description or "",
    }
    
    if Config.PhysicalItems.EvidenceBag.giveToOfficer then
        local itemConfig = {
            enabled = true,
            itemName = evidenceConfig.itemName,
            label = evidenceConfig.label,
            unique = true,
        }
        
        local success = GivePhysicalItem(src, itemConfig, metadata)
        if success then
            TriggerClientEvent('RSGCore:Notify', src, 'Evidence collected: ' .. evidenceConfig.label, 'success')
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- SEARCH RECEIPT CREATION
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:items:giveSearchReceipt', function(searchData)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player or not Config.PhysicalItems.SearchReceipt.enabled then return end
    
    local metadata = {
        searchId = searchData.id or 0,
        suspect = searchData.suspectName or "Unknown",
        itemsConfiscated = searchData.items or {},
        officer = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
        date = os.date("%Y-%m-%d %H:%M:%S"),
        location = searchData.location or "Unknown",
    }
    
    -- Give to officer
    if Config.PhysicalItems.SearchReceipt.giveToOfficer then
        GivePhysicalItem(src, Config.PhysicalItems.SearchReceipt, metadata)
    end
    
    -- Give to suspect
    if Config.PhysicalItems.SearchReceipt.giveToSuspect and searchData.suspectId then
        local Suspect = RSGCore.Functions.GetPlayer(searchData.suspectId)
        if Suspect then
            GivePhysicalItem(searchData.suspectId, Config.PhysicalItems.SearchReceipt, metadata)
            TriggerClientEvent('RSGCore:Notify', searchData.suspectId, 'You received a search receipt', 'primary')
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- INVESTIGATION NOTES CREATION
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:items:giveInvestigationNotes', function(notesData)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player or not Config.PhysicalItems.InvestigationNotes.enabled then return end
    
    local metadata = {
        caseNumber = notesData.caseNumber or "N/A",
        notes = notesData.notes or "",
        detective = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
        date = os.date("%Y-%m-%d %H:%M:%S"),
    }
    
    if Config.PhysicalItems.InvestigationNotes.giveToOfficer then
        local success = GivePhysicalItem(src, Config.PhysicalItems.InvestigationNotes, metadata)
        if success then
            TriggerClientEvent('RSGCore:Notify', src, 'Investigation notes added to your inventory', 'success')
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- TELEGRAPH MESSAGE CREATION
-- ══════════════════════════════════════════════════════════════
RegisterNetEvent('lxr-police:items:giveTelegraphMessage', function(messageData)
    local src = source
    
    if not Config.PhysicalItems.TelegraphMessage.enabled then return end
    
    local metadata = {
        message = messageData.message or "",
        sender = messageData.sender or "Telegraph Office",
        date = os.date("%Y-%m-%d %H:%M:%S"),
        priority = messageData.priority or "normal",
    }
    
    if Config.PhysicalItems.TelegraphMessage.giveToOfficer then
        local success = GivePhysicalItem(src, Config.PhysicalItems.TelegraphMessage, metadata)
        if success then
            TriggerClientEvent('RSGCore:Notify', src, 'Telegraph message received', 'primary')
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- EXPORTS
-- ══════════════════════════════════════════════════════════════
exports('GivePhysicalItem', GivePhysicalItem)
exports('GiveIncidentReport', function(src, data) TriggerEvent('lxr-police:items:giveIncidentReport', data) end)
exports('GiveArrestReport', function(src, data) TriggerEvent('lxr-police:items:giveArrestReport', data) end)
exports('GiveCitation', function(src, data) TriggerEvent('lxr-police:items:giveCitation', data) end)
exports('GiveWarrant', function(src, data) TriggerEvent('lxr-police:items:giveWarrant', data) end)
exports('GiveBountyPoster', function(src, data) TriggerEvent('lxr-police:items:giveBountyPoster', data) end)
exports('GiveEvidenceBag', function(src, data) TriggerEvent('lxr-police:items:giveEvidenceBag', data) end)

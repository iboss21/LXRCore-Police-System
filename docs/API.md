# 📚 API Documentation

## The Land of Wolves RP - Law Enforcement System

Complete API reference for developers integrating with the system.

---

## 📋 Table of Contents

1. [Client Exports](#client-exports)
2. [Server Exports](#server-exports)
3. [Events](#events)
4. [Callbacks](#callbacks)
5. [Database Schema](#database-schema)
6. [Integration Guide](#integration-guide)

---

## 🖥️ Client Exports

### Arrest System

#### IsCuffed
Check if local player is cuffed.

```lua
local isCuffed = exports['lxr-police']:IsCuffed()
-- Returns: boolean
```

#### IsBeingDragged
Check if local player is being dragged.

```lua
local isDragged = exports['lxr-police']:IsBeingDragged()
-- Returns: boolean
```

#### GetArrestState
Get full arrest state for local player.

```lua
local state = exports['lxr-police']:GetArrestState()
-- Returns: table {cuffed = bool, cuffType = string, draggedBy = number}
```

### Jail System

#### IsInJail
Check if local player is in jail.

```lua
local inJail = exports['lxr-police']:IsInJail()
-- Returns: boolean
```

#### GetJailTime
Get remaining jail time in seconds.

```lua
local timeLeft = exports['lxr-police']:GetJailTime()
-- Returns: number (seconds)
```

### UI System

#### OpenMDT
Open the MDT interface.

```lua
exports['lxr-police']:OpenMDT()
```

#### CloseMDT
Close the MDT interface.

```lua
exports['lxr-police']:CloseMDT()
```

#### OpenDispatch
Open the dispatch interface.

```lua
exports['lxr-police']:OpenDispatch()
```

### Attachment System

#### AttachItem
Attach an item to player model.

```lua
exports['lxr-police']:AttachItem(itemName)
-- Parameters:
--   itemName (string): Name of item from Config.WearableItems
-- Returns: boolean (success)

-- Example:
exports['lxr-police']:AttachItem("badge_sheriff")
```

#### DetachItem
Remove an attached item.

```lua
exports['lxr-police']:DetachItem(itemName)
-- Parameters:
--   itemName (string): Name of attached item
-- Returns: boolean (success)

-- Example:
exports['lxr-police']:DetachItem("badge_sheriff")
```

#### ClearAttachments
Remove all attached items.

```lua
exports['lxr-police']:ClearAttachments()
```

#### GetAttachments
Get all currently attached items.

```lua
local attachments = exports['lxr-police']:GetAttachments()
-- Returns: table {itemName = {object, config}}
```

---

## 🔧 Server Exports

### Officer System

#### IsOfficer
Check if player is a law enforcement officer.

```lua
local isOfficer = exports['lxr-police']:IsOfficer(source)
-- Parameters:
--   source (number): Player server ID
-- Returns: boolean

-- Example:
if exports['lxr-police']:IsOfficer(source) then
    print("Player is an officer")
end
```

#### GetOfficerDept
Get officer's department.

```lua
local dept = exports['lxr-police']:GetOfficerDept(source)
-- Parameters:
--   source (number): Player server ID
-- Returns: string ("sheriff", "marshal", "ranger", "lawman") or nil

-- Example:
local dept = exports['lxr-police']:GetOfficerDept(source)
if dept == "sheriff" then
    print("Player is a sheriff")
end
```

#### HasPermission
Check if officer has specific permission.

```lua
local hasPerm = exports['lxr-police']:HasPermission(source, permission)
-- Parameters:
--   source (number): Player server ID
--   permission (string): Permission name (e.g., "arrest", "warrant_issue")
-- Returns: boolean

-- Example:
if exports['lxr-police']:HasPermission(source, "warrant_issue") then
    -- Allow warrant issuance
end
```

### Player System

#### GetPlayer
Get player data object.

```lua
local player = exports['lxr-police']:GetPlayer(source)
-- Parameters:
--   source (number): Player server ID
-- Returns: table (player data) or nil
```

#### IsCuffed
Check if player is cuffed (server-side).

```lua
local isCuffed = exports['lxr-police']:IsCuffed(source)
-- Parameters:
--   source (number): Player server ID
-- Returns: boolean
```

#### IsInJail
Check if player is in jail (server-side).

```lua
local inJail = exports['lxr-police']:IsInJail(source)
-- Parameters:
--   source (number): Player server ID
-- Returns: boolean
```

#### GetPrisonerData
Get prisoner's jail data.

```lua
local data = exports['lxr-police']:GetPrisonerData(source)
-- Parameters:
--   source (number): Player server ID
-- Returns: table {sentence, timeLeft, crimes, cell} or nil
```

### Evidence System

#### CreateEvidence
Create a new evidence item.

```lua
local evidenceId = exports['lxr-police']:CreateEvidence(evidenceType, data, officer)
-- Parameters:
--   evidenceType (string): Type of evidence
--   data (table): Evidence data
--   officer (number): Officer who collected it
-- Returns: string (evidence ID)

-- Example:
local evidenceId = exports['lxr-police']:CreateEvidence('blood', {
    dna = "AB-CD-EF-12",
    location = coords,
    suspect = identifier
}, source)
```

#### GetEvidence
Get evidence by ID.

```lua
local evidence = exports['lxr-police']:GetEvidence(evidenceId)
-- Parameters:
--   evidenceId (string): Evidence ID
-- Returns: table (evidence data) or nil
```

#### AnalyzeEvidence
Analyze evidence in forensics lab.

```lua
exports['lxr-police']:AnalyzeEvidence(evidenceId, analyst)
-- Parameters:
--   evidenceId (string): Evidence ID
--   analyst (number): Officer performing analysis
-- Returns: table (analysis results)
```

### Bounty System

#### GetActiveBounties
Get all active bounties.

```lua
local bounties = exports['lxr-police']:GetActiveBounties()
-- Returns: table (array of bounty objects)
```

#### HasBounty
Check if identifier has active bounty.

```lua
local hasBounty = exports['lxr-police']:HasBounty(identifier)
-- Parameters:
--   identifier (string): Citizen ID
-- Returns: boolean
```

#### GetBountyAmount
Get bounty amount for identifier.

```lua
local amount = exports['lxr-police']:GetBountyAmount(identifier)
-- Parameters:
--   identifier (string): Citizen ID
-- Returns: number (bounty amount)
```

### Posse System

#### IsInPosse
Check if player is in a posse.

```lua
local inPosse = exports['lxr-police']:IsInPosse(source)
-- Parameters:
--   source (number): Player server ID
-- Returns: boolean
```

#### GetPosse
Get posse data for player.

```lua
local posse = exports['lxr-police']:GetPosse(source)
-- Parameters:
--   source (number): Player server ID
-- Returns: table (posse data) or nil
```

### Dispatch System

#### GetActiveDispatches
Get all active dispatch calls.

```lua
local dispatches = exports['lxr-police']:GetActiveDispatches()
-- Returns: table (array of dispatch objects)
```

### Audit System

#### logAudit
Log an action for audit trail.

```lua
exports['lxr-police']:logAudit(officer, action, entity_type, entity_id, details)
-- Parameters:
--   officer (number): Officer ID
--   action (string): Action performed
--   entity_type (string): Type of entity
--   entity_id (string): Entity ID
--   details (string): Additional details
```

---

## 📡 Events

### Client Events

#### Arrest Events

```lua
-- Player was cuffed
RegisterNetEvent('tlw-law:arrest:softCuff')
AddEventHandler('tlw-law:arrest:softCuff', function()
    -- Handle soft cuff
end)

-- Player was hard cuffed
RegisterNetEvent('tlw-law:arrest:hardCuff')
AddEventHandler('tlw-law:arrest:hardCuff', function()
    -- Handle hard cuff
end)

-- Player was uncuffed
RegisterNetEvent('tlw-law:arrest:uncuff')
AddEventHandler('tlw-law:arrest:uncuff', function()
    -- Handle uncuff
end)

-- Player is being dragged
RegisterNetEvent('tlw-law:arrest:drag')
AddEventHandler('tlw-law:arrest:drag', function(draggerId)
    -- Handle drag (draggerId is officer dragging)
end)

-- Stop being dragged
RegisterNetEvent('tlw-law:arrest:stopDrag')
AddEventHandler('tlw-law:arrest:stopDrag', function()
    -- Handle stop drag
end)
```

#### Jail Events

```lua
-- Sentence started
RegisterNetEvent('tlw-law:jail:startSentence')
AddEventHandler('tlw-law:jail:startSentence', function(data)
    -- data = {time, crimes, cell, location}
end)

-- Released from jail
RegisterNetEvent('tlw-law:jail:release')
AddEventHandler('tlw-law:jail:release', function()
    -- Handle release
end)

-- Time remaining updated
RegisterNetEvent('tlw-law:jail:updateTime')
AddEventHandler('tlw-law:jail:updateTime', function(timeLeft)
    -- Update UI with time
end)
```

#### Evidence Events

```lua
-- Blood evidence created nearby
RegisterNetEvent('tlw-law:evidence:createBlood')
AddEventHandler('tlw-law:evidence:createBlood', function(coords, data)
    -- Create blood marker at coords
end)

-- Casing evidence created
RegisterNetEvent('tlw-law:evidence:createCasing')
AddEventHandler('tlw-law:evidence:createCasing', function(coords, data)
    -- Create casing marker
end)
```

#### Bounty Events

```lua
-- New wanted poster created
RegisterNetEvent('tlw-law:bounty:newPoster')
AddEventHandler('tlw-law:bounty:newPoster', function(poster)
    -- poster = {id, name, bounty, crimes, etc}
end)

-- Poster was claimed
RegisterNetEvent('tlw-law:bounty:posterClaimed')
AddEventHandler('tlw-law:bounty:posterClaimed', function(posterId)
    -- Handle poster claimed
end)

-- Receive active bounties list
RegisterNetEvent('tlw-law:bounty:activeList')
AddEventHandler('tlw-law:bounty:activeList', function(bounties)
    -- Handle bounties list
end)
```

#### Posse Events

```lua
-- Posse created
RegisterNetEvent('tlw-law:posse:created')
AddEventHandler('tlw-law:posse:created', function(posse)
    -- posse = {id, name, leader, members}
end)

-- Invitation received
RegisterNetEvent('tlw-law:posse:inviteReceived')
AddEventHandler('tlw-law:posse:inviteReceived', function(invite)
    -- invite = {posseId, leader, name}
end)

-- Member joined posse
RegisterNetEvent('tlw-law:posse:memberJoined')
AddEventHandler('tlw-law:posse:memberJoined', function(data)
    -- data = {playerId, posse}
end)

-- Member left posse
RegisterNetEvent('tlw-law:posse:memberLeft')
AddEventHandler('tlw-law:posse:memberLeft', function(data)
    -- data = {playerId, posse}
end)

-- Posse disbanded
RegisterNetEvent('tlw-law:posse:disbanded')
AddEventHandler('tlw-law:posse:disbanded', function()
    -- Handle disbandment
end)

-- Posse chat message
RegisterNetEvent('tlw-law:posse:chatMessage')
AddEventHandler('tlw-law:posse:chatMessage', function(data)
    -- data = {sender, message}
end)
```

#### Dispatch Events

```lua
-- Dispatch alert received
RegisterNetEvent('tlw-law:dispatch:alert')
AddEventHandler('tlw-law:dispatch:alert', function(dispatch)
    -- dispatch = {id, type, message, location, sender}
end)

-- Backup request
RegisterNetEvent('tlw-law:dispatch:backup')
AddEventHandler('tlw-law:dispatch:backup', function(dispatch)
    -- High priority backup needed
end)

-- Officer responding
RegisterNetEvent('tlw-law:dispatch:officerResponding')
AddEventHandler('tlw-law:dispatch:officerResponding', function(data)
    -- data = {dispatchId, officer}
end)

-- Dispatch completed
RegisterNetEvent('tlw-law:dispatch:completed')
AddEventHandler('tlw-law:dispatch:completed', function(dispatchId)
    -- Handle completion
end)
```

### Server Events

#### Trigger Events (Server-Side)

```lua
-- Arrest player
TriggerEvent('tlw-law:arrest:softCuff', targetId, officerId)
TriggerEvent('tlw-law:arrest:hardCuff', targetId, officerId)
TriggerEvent('tlw-law:arrest:uncuff', targetId, officerId)

-- Search player
TriggerEvent('tlw-law:arrest:search', targetId, officerId)

-- Jail player
TriggerEvent('tlw-law:jail:sentence', targetId, charges, reason)

-- Release player
TriggerEvent('tlw-law:jail:release', targetId, reason)

-- Place bounty
TriggerEvent('tlw-law:bounty:place', targetId, amount, crimes, description)

-- Create dispatch
TriggerEvent('tlw-law:dispatch:create', data)
```

---

## 🗄️ Database Schema

### mdt_citizens
Stores citizen records.

```sql
CREATE TABLE mdt_citizens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(64) NOT NULL UNIQUE,
    name VARCHAR(128) NOT NULL,
    dob DATE,
    description TEXT,
    mugshot TEXT,
    fingerprint VARCHAR(64),
    dna VARCHAR(128),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX(identifier)
);
```

### mdt_warrants
Stores active warrants.

```sql
CREATE TABLE mdt_warrants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    warrant_id VARCHAR(20) NOT NULL UNIQUE,
    identifier VARCHAR(64) NOT NULL,
    type ENUM('arrest','search','seizure') NOT NULL,
    reason TEXT NOT NULL,
    issued_by INT NOT NULL,
    issued_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active','executed','expired') DEFAULT 'active',
    INDEX(identifier),
    INDEX(status)
);
```

### mdt_bounties
Stores bounties and wanted posters.

```sql
CREATE TABLE mdt_bounties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    poster_id VARCHAR(20) NOT NULL UNIQUE,
    identifier VARCHAR(64) NOT NULL,
    name VARCHAR(128) NOT NULL,
    bounty INT NOT NULL DEFAULT 0,
    crimes TEXT,
    description TEXT,
    placed_by INT NOT NULL,
    placed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active','claimed','expired') DEFAULT 'active',
    captured_by INT NULL,
    captured_at DATETIME NULL,
    reward_paid INT NULL,
    INDEX(identifier),
    INDEX(status)
);
```

### mdt_evidence
Stores evidence items.

```sql
CREATE TABLE mdt_evidence (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evidence_id VARCHAR(20) NOT NULL UNIQUE,
    type VARCHAR(32) NOT NULL,
    data TEXT,
    collected_by INT NOT NULL,
    collected_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    location TEXT,
    case_id VARCHAR(20),
    status ENUM('collected','analyzed','stored','court') DEFAULT 'collected',
    INDEX(evidence_id),
    INDEX(type),
    INDEX(case_id)
);
```

### mdt_dispatch
Stores dispatch calls.

```sql
CREATE TABLE mdt_dispatch (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dispatch_id VARCHAR(20) NOT NULL UNIQUE,
    type VARCHAR(10) NOT NULL,
    message TEXT NOT NULL,
    location TEXT,
    sender INT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active','responding','completed','cancelled') DEFAULT 'active',
    completed_by INT NULL,
    completed_at DATETIME NULL,
    INDEX(status),
    INDEX(timestamp)
);
```

---

## 🔗 Integration Guide

### Integrating with Your Framework

```lua
-- In your framework's player loading
RegisterNetEvent('YourFramework:Server:OnPlayerLoaded')
AddEventHandler('YourFramework:Server:OnPlayerLoaded', function(source, player)
    -- Notify law enforcement system
    TriggerEvent('tlw-law:player:loaded', source, player)
end)

-- In your framework's player unloading
RegisterNetEvent('YourFramework:Server:OnPlayerUnload')
AddEventHandler('YourFramework:Server:OnPlayerUnload', function(source)
    -- Notify law enforcement system
    TriggerEvent('tlw-law:player:unloaded', source)
end)
```

### Integrating with Inventory

```lua
-- When player uses an item
RegisterNetEvent('YourInventory:Server:UseItem')
AddEventHandler('YourInventory:Server:UseItem', function(source, item)
    if item.name == "handcuffs" then
        -- Trigger cuff menu
        TriggerClientEvent('tlw-law:client:openCuffMenu', source)
    elseif item.name == "evidence_bag" then
        -- Open evidence collection
        TriggerClientEvent('tlw-law:client:collectEvidence', source)
    end
end)
```

### Integrating with Target System

```lua
-- Add law enforcement targets
exports['rsg-target']:AddTargetModel({`p_desk01x`}, {
    options = {
        {
            type = "client",
            event = "tlw-law:client:openMDT",
            icon = "fas fa-book",
            label = "Access Records",
            job = {"sheriff", "marshal", "ranger", "lawman"}
        }
    },
    distance = 2.5
})
```

---

## 📞 Support

For additional API support:
- Discord: discord.gg/wolves
- GitHub: github.com/iboss21/LXRCore-Police-System
- Website: www.wolves.land

---

**Last Updated**: December 11, 2024  
**Version**: 1.0.0

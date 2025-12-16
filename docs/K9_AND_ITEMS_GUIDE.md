# 🐕 K9 Unit & Physical Items System Documentation

## The Land of Wolves RP - Law Enforcement System
### Complete Police System with K9 Dogs and Physical Evidence Items

---

## 📋 Table of Contents
1. [K9 Unit System](#k9-unit-system)
2. [Physical Items System](#physical-items-system)
3. [Installation](#installation)
4. [Configuration](#configuration)
5. [Commands](#commands)
6. [Integration Guide](#integration-guide)

---

## 🐕 K9 Unit System

### Overview
The K9 Unit System brings period-accurate police dogs to your 1899 Western law enforcement operations. Officers can deploy trained dogs for tracking suspects, searching for evidence, and apprehending criminals.

### Features

#### 🐕 Period-Accurate Dog Breeds
- **Bloodhound** - Expert tracker with incredible scent tracking (100 tracking skill)
- **Coonhound** - Versatile hunting dog, excellent for searching (90 search skill)
- **Shepherd** - Loyal and protective, best for apprehension (95 apprehension skill)

#### 🎯 K9 Commands
- `/k9` or `/k9menu` - Open K9 Unit Menu
- `/k9spawn [breed]` - Spawn your K9 partner (1=Bloodhound, 2=Coonhound, 3=Shepherd)
- `/k9dismiss` - Send K9 back to kennel
- `/k9follow` - Order K9 to follow you
- `/k9stay` - Order K9 to stay in place
- `/k9track` - Order K9 to track nearby suspect (scent tracking)
- `/k9search` - Order K9 to search for evidence in area
- `/k9attack` - Order K9 to subdue suspect (non-lethal)

#### 📊 K9 Stats System
Each K9 has the following attributes:
- **Health** - Can take damage, regenerates over time
- **Stamina** - Depletes during activities, regenerates when idle
- **Tracking Skill** - Effectiveness at finding suspects
- **Search Skill** - Effectiveness at finding evidence
- **Apprehension Skill** - Effectiveness at subduing suspects
- **Speed** - How fast the K9 moves
- **Level** - K9 training level (1-5)
- **XP** - Experience points for leveling up

#### 🎓 K9 Training Levels
1. **Level 1: Basic Obedience** (0 XP)
   - Commands: Follow, Stay
   - Bonus: +5 Speed

2. **Level 2: Tracking Certified** (500 XP)
   - Commands: Follow, Stay, Track
   - Bonus: +10 Tracking, +10 Speed

3. **Level 3: Search Certified** (1,000 XP)
   - Commands: Follow, Stay, Track, Search
   - Bonus: +10 Search, +10 Stamina

4. **Level 4: Apprehension Certified** (2,000 XP)
   - Commands: Follow, Stay, Track, Search, Attack
   - Bonus: +15 Apprehension, +20 Health

5. **Level 5: Master K9** (5,000 XP)
   - Commands: All commands including vehicle entry
   - Bonus: +20 All Skills, +20 Speed, +20 Stamina, +30 Health

#### 🏆 Gaining K9 XP
- Spawn K9: +1 XP
- Follow command: +2 XP
- Track suspect: +10 XP
- Successful track: +25 XP
- Search for evidence: +15 XP
- Find evidence: +30 XP
- Attack suspect: +20 XP
- Successful subdue: +50 XP

### K9 Tracking System
When you order your K9 to track:
1. K9 picks up the scent of the closest player within range
2. K9 will follow the scent trail for up to 30 seconds
3. When K9 gets within 10 meters of suspect, you're notified
4. Stamina depletes during tracking
5. Success rate depends on K9 breed and training level

### K9 Search System
When you order your K9 to search:
1. K9 searches a 25-meter radius for evidence
2. Search takes 20 seconds
3. Success chance depends on K9 breed (80-90%)
4. Can find: Blood, casings, tracks, weapons
5. Evidence items are added to your inventory

### K9 Apprehension System
When you order your K9 to attack:
1. K9 targets closest player within 5 meters
2. Attack deals 25 damage
3. Chance to knock down suspect (60-90% based on breed)
4. Suspect is ragdolled for 5 seconds if subdued
5. 10-second cooldown after attack

### K9 Health & Stamina
- **Max Health**: 200 HP
- **Health Regen**: 2 HP/second when idle
- **Max Stamina**: 100
- **Stamina Depletion**:
  - Walking: 0.5/second
  - Running: 2.0/second
  - Tracking: 1.5/second
  - Searching: 1.0/second
  - Attacking: 3.0/second
- **Stamina Regen**: 5/second when idle

### K9 Spawn Locations
K9s can be spawned at these sheriff office kennels:
- Valentine Sheriff Kennel
- Rhodes Sheriff Kennel
- Blackwater Sheriff Kennel
- Strawberry Sheriff Kennel
- Saint Denis Police Kennel

---

## 📄 Physical Items System

### Overview
The Physical Items System gives tangible documents and evidence items for all police activities. Every report, citation, warrant, and evidence collection creates a physical item that can be held, traded, or stored.

### Physical Item Types

#### 📋 Incident Report
- **Item Name**: `incident_report`
- **Given**: When creating incident report
- **Metadata**: Report ID, title, officer name, location, date, description
- **Who Gets It**: Officer creating the report

#### 🚨 Arrest Report
- **Item Name**: `arrest_report`
- **Given**: When arresting a suspect
- **Metadata**: Report ID, suspect name, charges, officer name, location, date
- **Who Gets It**: Officer AND suspect (both get copies)

#### 🎫 Citation Ticket
- **Item Name**: `citation_ticket`
- **Given**: When issuing citation
- **Metadata**: Citation ID, violation, fine amount, officer name, location, date
- **Who Gets It**: Officer AND suspect

#### ⚖️ Arrest Warrant
- **Item Name**: `arrest_warrant`
- **Given**: When issuing arrest warrant
- **Metadata**: Warrant ID, suspect name, charges, judge name, officer, date
- **Who Gets It**: Officer only

#### 🎯 Wanted Poster
- **Item Name**: `wanted_poster`
- **Given**: When creating bounty
- **Metadata**: Bounty ID, wanted person, reward amount, crimes, "Dead or Alive", date
- **Who Gets It**: Officer
- **Special**: Can print multiple copies (max 10)

#### 🔬 Evidence Items
Multiple evidence bag types:
- `evidence_blood` - Blood sample from crime scene
- `evidence_casing` - Shell casing from firearm
- `evidence_fingerprint` - Lifted fingerprint
- `evidence_tracks` - Footprint or hoofprint cast
- `evidence_photo` - Crime scene photograph
- `evidence_weapon` - Confiscated weapon

**Metadata**: Evidence ID, type, location, collector name, date, case number

#### 📝 Investigation Notes
- **Item Name**: `investigation_notes`
- **Given**: During detective work
- **Metadata**: Case number, notes, detective name, date

#### 📄 Search Receipt
- **Item Name**: `search_receipt`
- **Given**: After searching someone
- **Metadata**: Search ID, suspect name, items confiscated, officer, location, date
- **Who Gets It**: Officer AND suspect

#### 📦 Property Receipt
- **Item Name**: `property_receipt`
- **Given**: When confiscating prisoner property
- **Metadata**: Items confiscated, officer, date
- **Who Gets It**: Officer AND prisoner

#### 📬 Court Summons
- **Item Name**: `court_summons`
- **Given**: When summoning to court
- **Metadata**: Court date, charges, location
- **Who Gets It**: Suspect only

#### 📡 Telegraph Message
- **Item Name**: `telegraph_message`
- **Given**: From telegraph dispatch
- **Metadata**: Message content, sender, date, priority
- **Who Gets It**: Receiving officer

#### 👤 Witness Statement
- **Item Name**: `witness_statement`
- **Given**: After witness interview
- **Metadata**: Witness name, statement, officer, date

---

## 🔧 Installation

### 1. Database Setup
Run the K9 system migration:
```sql
-- Located in sql/migrations/014_k9_system.sql
-- Creates leo_k9_data and leo_k9_activity tables
```

### 2. Inventory Items Setup
Add all physical items to your `rsg-inventory/shared/items.lua`:
```lua
-- See config/physical_items.lua for complete item definitions
-- Copy the item definitions from the bottom of that file
```

### 3. Item Images
Create or add these images to your inventory images folder:
```
incident_report.png
arrest_report.png
citation_ticket.png
arrest_warrant.png
wanted_poster.png
evidence_bag.png
evidence_blood.png
evidence_casing.png
evidence_fingerprint.png
evidence_tracks.png
evidence_photo.png
evidence_weapon.png
investigation_notes.png
search_receipt.png
property_receipt.png
court_summons.png
telegraph_message.png
witness_statement.png
k9_bloodhound.png
k9_coonhound.png
k9_shepherd.png
```

### 4. Resource Configuration
Ensure in your `server.cfg`:
```cfg
ensure rsg-core
ensure rsg-inventory
ensure oxmysql
ensure lxr-police  # or tlw-lawman
```

---

## ⚙️ Configuration

### K9 System Configuration
Located in `config/k9_system.lua`:

```lua
Config.K9.Enabled = true
Config.K9.RequiredGrade = 2 -- Minimum rank (Sergeant+)
Config.K9.MaxDistance = 50.0 -- Max distance from handler
```

### Physical Items Configuration
Located in `config/physical_items.lua`:

```lua
Config.PhysicalItems.Enabled = true
Config.PhysicalItems.RequireInventorySpace = true
Config.PhysicalItems.AutoRemoveOnUse = true
```

### Enabling/Disabling Individual Items
```lua
-- In config/physical_items.lua
Config.PhysicalItems.IncidentReport.enabled = true -- Enable/disable
Config.PhysicalItems.ArrestReport.enabled = true
Config.PhysicalItems.Citation.enabled = true
-- etc...
```

---

## 🎮 Commands Reference

### K9 Commands
| Command | Description | Permission |
|---------|-------------|------------|
| `/k9` | Open K9 menu | Rank 2+ |
| `/k9spawn [1-3]` | Spawn K9 (1=Bloodhound, 2=Coonhound, 3=Shepherd) | Rank 2+ |
| `/k9dismiss` | Dismiss K9 | Rank 2+ |
| `/k9follow` | Order K9 to follow | Rank 2+ |
| `/k9stay` | Order K9 to stay | Rank 2+ |
| `/k9track` | Track suspect | Rank 2+ |
| `/k9search` | Search for evidence | Rank 2+ |
| `/k9attack` | Subdue suspect | Rank 2+ |

### Automatic Item Triggers
Physical items are automatically given when:
- Creating incident reports in MDT
- Arresting suspects
- Issuing citations
- Creating warrants
- Placing bounties
- Collecting evidence
- Searching players
- Conducting investigations

---

## 🔗 Integration Guide

### Triggering Physical Items from Your Scripts

#### Give Incident Report
```lua
-- Server-side
TriggerEvent('lxr-police:items:giveIncidentReport', {
    id = reportId,
    title = "Bank Robbery",
    location = "Valentine Bank",
    description = "Armed robbery in progress"
})
```

#### Give Arrest Report
```lua
-- Server-side
TriggerEvent('lxr-police:items:giveArrestReport', {
    id = arrestId,
    suspectId = targetPlayerId,
    suspectName = "John Doe",
    charges = {"Murder", "Robbery"},
    location = "Valentine"
})
```

#### Give Citation
```lua
-- Server-side
TriggerEvent('lxr-police:items:giveCitation', {
    id = citationId,
    suspectId = targetPlayerId,
    violation = "Disturbing the Peace",
    fine = 50,
    location = "Valentine Saloon"
})
```

#### Give Evidence Bag
```lua
-- Server-side
TriggerEvent('lxr-police:items:giveEvidenceBag', {
    id = evidenceId,
    type = "blood", -- blood, casing, fingerprint, tracks, photo, weapon
    location = "Crime Scene Alpha",
    caseNumber = "CASE-001",
    description = "Blood found at scene"
})
```

### Using K9 in Your Scripts

#### Check if Player Has K9
```lua
-- Client-side
if k9Active then
    -- Player has K9 active
end
```

#### Trigger K9 Actions
```lua
-- Server-side
TriggerClientEvent('lxr-police:k9:track', playerId)
TriggerClientEvent('lxr-police:k9:search', playerId)
```

### Exports

#### Physical Items Exports
```lua
-- Server-side
exports['lxr-police']:GivePhysicalItem(playerId, itemConfig, metadata)
exports['lxr-police']:GiveIncidentReport(playerId, data)
exports['lxr-police']:GiveArrestReport(playerId, data)
exports['lxr-police']:GiveCitation(playerId, data)
exports['lxr-police']:GiveWarrant(playerId, data)
exports['lxr-police']:GiveBountyPoster(playerId, data)
exports['lxr-police']:GiveEvidenceBag(playerId, data)
```

#### K9 Exports
```lua
-- Server-side
exports['lxr-police']:SaveK9Data(citizenid, k9Data)
exports['lxr-police']:LoadK9Data(citizenid, callback)
```

---

## 🎯 Roleplay Guidelines

### K9 Unit Roleplay
1. **Handler Certification**: Only rank 2+ officers can be K9 handlers
2. **Training**: Start with basic commands, progress through training
3. **K9 Care**: Monitor health and stamina, don't overwork your K9
4. **Realistic Usage**: Use appropriate breed for the task
5. **Documentation**: Create reports when K9 finds evidence or tracks suspect

### Physical Items Roleplay
1. **Evidence Chain**: Keep evidence items in evidence locker
2. **Documentation**: Physical items serve as proof of police work
3. **Court Evidence**: Present physical evidence items in court trials
4. **Record Keeping**: Store important documents in office filing cabinets
5. **Receipts**: Always give citizens receipts when searching/confiscating

---

## 📊 Statistics & Tracking

### K9 Activity Logging
All K9 activities are logged in `leo_k9_activity` table:
- Track attempts and successes
- Search attempts and findings
- Attack actions and subdues
- XP gains per activity

### Item Usage Tracking
Monitor physical item creation and distribution through audit logs.

---

## 🐛 Troubleshooting

### K9 Not Spawning
1. Check if you have required grade (default: Rank 2+)
2. Ensure you're on duty
3. Check if you already have a K9 active
4. Verify K9 system is enabled in config

### Items Not Being Given
1. Check `Config.PhysicalItems.Enabled = true`
2. Verify specific item is enabled in config
3. Ensure player has inventory space
4. Check rsg-inventory integration

### K9 Commands Not Working
1. Verify K9 is spawned and active
2. Check stamina level (needs >5% for actions)
3. Ensure target is within range
4. Check cooldown hasn't expired

---

## 🆕 What's New in This Update

### ✨ New Features
- **Complete K9 Unit System** with 3 period-accurate breeds
- **K9 Training & Progression** with 5 levels and XP system
- **Physical Evidence Items** for all police activities
- **Automatic Document Generation** for reports and citations
- **Evidence Collection Items** for crime scene investigation
- **K9 Health & Stamina** management system
- **Database Tracking** for K9 activities and stats

### 🔧 Improvements
- Enhanced inventory bridge for rsg-inventory
- Better integration with existing MDT system
- Period-accurate 1899 items and equipment
- Realistic K9 behaviors and commands
- Comprehensive configuration options

### 🎨 Authentic 1899 Experience
- Bloodhounds and tracking dogs used in 1899
- Period-accurate evidence collection methods
- Authentic law enforcement procedures
- No modern technology or anachronisms

---

## 📝 Credits

- **The Land of Wolves RP** - Original concept and development
- **Rexshack-RedM** - rsg-lawman inspiration
- **RSG Core Team** - Framework support
- **Community** - Testing and feedback

---

## 📞 Support

For issues, questions, or suggestions:
- **Discord**: discord.gg/wolves
- **GitHub**: github.com/iboss21/LXRCore-Police-System
- **Website**: www.wolves.land

---

<div align="center">

**The Land of Wolves RP - Law Enforcement System**

*The most complete and authentic 1899 Western law enforcement system for RedM*

🐕 K9 Unit | 📄 Physical Items | 🔍 Investigation | ⚖️ Justice

</div>

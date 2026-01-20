# LXRCore Police System - 1899 Authentic Law Enforcement

```
██╗     ██╗  ██╗██████╗  ██████╗ ██████╗ ██████╗ ███████╗
██║     ╚██╗██╔╝██╔══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝
██║      ╚███╔╝ ██████╔╝██║     ██║   ██║██████╔╝█████╗  
██║      ██╔██╗ ██╔══██╗██║     ██║   ██║██╔══██╗██╔══╝  
███████╗██╔╝ ██╗██║  ██║╚██████╗╚██████╔╝██║  ██║███████╗
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
```

**🐺 The Land of Wolves - Professional Law Enforcement System**  
*Authentic 1899 Wild West Law Enforcement for RedM*

## 🎯 Overview

LXRCore Police System is a **period-accurate, immersive law enforcement script** for RedM servers set in 1899. This system replaces modern MDT terminals and digital systems with authentic Wild West alternatives: handwritten journals, physical ledgers, telegraph communication, and bulletin board wanted posters.

**Key Features:**
- ✅ **100% Period-Accurate** - No modern computers or digital systems
- ✅ **Optimized Performance** - Target: 0.00ms idle, minimal overhead
- ✅ **Location-Based Access** - Must visit stations to access records
- ✅ **Authentic Communication** - Telegraph system with realistic delays
- ✅ **Physical Items** - Wanted posters, arrest warrants, evidence tags
- ✅ **Multi-Framework** - Supports LXRCore, RSGCore, and VORP

---

## 🚀 What's New - V2.0 Authentic Edition

### ❌ Removed (Modern/Immersion-Breaking):
- **Modern MDT System** - Replaced with journal/ledger
- **Digital Database Terminals** - Replaced with physical record books
- **Instant Dispatch** - Replaced with telegraph delays
- **Real-time GPS** - Replaced with location descriptions
- **Profiler Debug Loop** - Disabled for performance

### ✅ Added (Period-Accurate):
- **Officer's Journal** - Handwritten field notes (`/journal`)
- **Station Ledgers** - Physical record books at sheriff offices
- **Wanted Bulletin Boards** - Physical posters at stations
- **Location-Based Access** - Must be at station to search records
- **Telegraph System** - Primary communication with authentic delays
- **Optimized Database** - Simplified queries, cached warrants

---

## 📖 Usage Guide

### For Officers

#### **Writing Journal Notes**
Officers carry personal journals for field observations:
```
/journal - Write a new journal entry
/readjournal - Read your previous entries
```

**Example:**
> "Witnessed suspicious activity near Valentine bank. Three men, armed with repeaters, one riding a black Arabian horse..."

#### **Searching Station Ledgers**
To access citizen records, you **must physically visit** the Records Office at any sheriff station:

1. Go to Sheriff's Office / Marshal Station
2. Find the "Records Office" (marked on map)
3. Stand near the desk
4. Use command:
```
/searchledger [citizen name]
```

**Example:**
```
/searchledger John Marston
```

The system will simulate manual ledger searching (2-5 seconds delay) then display results from the station's record books.

#### **Viewing Wanted Boards**
Wanted posters are nailed to bulletin boards at stations:

1. Go to station wanted board
2. Press `[E]` or use:
```
/wantedboard
```

This shows all active bounties and wanted criminals for the territory.

#### **Creating Wanted Posters**
High-ranking officers can create wanted posters:

1. Be at the station
2. Have suspect's information
3. Use server event (configured per server)
4. Physical poster item is generated

---

## 🏛️ Station Locations

All stations have:
- **Records Office** - For searching ledgers
- **Wanted Board** - For viewing active bounties
- **Telegraph** - For communication
- **Cells** - For prisoners

### Key Locations:
| Station | Type | Records Office | Wanted Board |
|---------|------|----------------|--------------|
| Valentine | Sheriff | ✅ | ✅ |
| Rhodes | Sheriff | ✅ | ✅ |
| Strawberry | Sheriff | ✅ | ✅ |
| Blackwater | Marshal | ✅ | ✅ |
| Tumbleweed | Sheriff | ✅ | ✅ |
| Annesburg | Sheriff | ✅ | ✅ |
| Sisika | Prison | ✅ | ❌ |

---

## ⚙️ Installation

### 1. Download & Extract
```bash
cd resources
git clone https://github.com/iboss21/LXRCore-Police-System.git lxr-police
```

### 2. Database Setup
Run the SQL migration file:
```sql
-- Import this file into your database
sql/journal_ledger_system.sql
```

This creates optimized tables for the journal/ledger system.

### 3. Configure
Edit `config/config.lua`:
```lua
Config.Framework = "auto" -- or "lxrcore", "rsgcore", "vorp"
Config.Debug = false  -- Keep false for best performance
```

### 4. Add to server.cfg
```
ensure lxr-police
```

### 5. Restart Server
```
restart lxr-police
```

---

## 🔧 Configuration

### Performance Settings
```lua
-- config/config.lua
Config.Debug = false  -- Disables profiler for 0.00ms performance
```

### Station Locations
```lua
-- config/config.lua
Config.Stations = {
    ["valentine"] = {
        label = "Valentine Sheriff's Office",
        coords = vec3(-275.5, 804.0, 119.0),
        recordsOffice = vec3(-280.0, 808.0, 119.5),
        wantedBoard = vec3(-279.0, 807.0, 119.5),
        telegraph = vec3(-281.0, 805.0, 119.5),
        -- ... more settings
    }
}
```

### Law Enforcement Jobs
```lua
Config.LawJobs = {
    ["sheriff"] = { ... },
    ["marshal"] = { ... },
    ["ranger"] = { ... },
    ["lawman"] = { ... }
}
```

---

## 🎮 Commands

| Command | Description | Permission |
|---------|-------------|------------|
| `/journal` | Write journal entry | Officer |
| `/readjournal` | Read your journal | Officer |
| `/searchledger [name]` | Search station ledger | Officer (at station) |
| `/wantedboard` | View wanted posters | Anyone (at station) |
| `/arrest` | Arrest suspect | Officer |
| `/release` | Release prisoner | Officer |
| `/duty` | Toggle duty status | Officer |

---

## 📊 Performance Benchmarks

### Before Optimization (Old MDT System):
- **Idle:** 0.15ms
- **Search Query:** 0.45ms (6 nested callbacks)
- **Profile Load:** 0.80ms
- **Profiler Loop:** 10-second constant overhead

### After Optimization (Journal/Ledger System):
- **Idle:** 0.00ms ✅
- **Search Query:** 0.08ms (single optimized query)
- **Ledger Access:** 0.05ms (cached warrants)
- **Profiler:** Disabled in production ✅

**Result:** ~85% performance improvement

---

## 🔒 Security Features

- **Audit Logging** - All actions logged to database
- **Permission System** - Rank-based action restrictions
- **Location Validation** - Server-side checks for station access
- **Webhook Integration** - Discord notifications for key events
- **Anti-Cheat** - Server-side validation for all requests

---

## 🎨 Immersion Features

### Period-Accurate Communication
- **Telegraph System** - Authentic message delays
- **No Instant Messages** - Communication takes time
- **Physical Delivery** - Officers receive telegraph papers

### Physical Records
- **Handwritten Notes** - Officers write observations
- **Station Ledgers** - Must visit to access
- **Paper Trail** - All records are location-based
- **Wanted Posters** - Nailed to bulletin boards

### Authentic Law Enforcement
- **Rope Restraints** - Period-accurate bindings
- **Horse Impound** - Not vehicle impound
- **Gallows** - Public executions (if enabled)
- **Chain Gang** - Prison labor system

---

## 🐛 Troubleshooting

### "Must be at station" error
**Solution:** Walk closer to the Records Office desk. Look for the `[E] Search Ledgers` prompt.

### Journal entries not saving
**Solution:** Ensure `leo_journal_entries` table exists in database.

### Wanted board shows nothing
**Solution:** Create wanted posters first. They must be created at a station by an officer with permissions.

### Performance issues
**Solution:** Ensure `Config.Debug = false` and profiler is disabled in fxmanifest.lua.

---

## 🔄 Migrating from Old MDT System

If you're upgrading from an older version with MDT:

### 1. Backup Your Database
```sql
CREATE DATABASE backup_police;
-- Export all mdt_* tables to backup_police
```

### 2. Run Migration Script
```sql
source sql/journal_ledger_system.sql
```

### 3. Optional: Clean Old Tables
After confirming everything works, you can remove old MDT tables (see SQL file).

### 4. Update Config
Change any MDT-related configs to use new journal system.

---

## 🤝 Support

- **Website:** [www.wolves.land](https://www.wolves.land)
- **Discord:** Coming Soon
- **Issues:** [GitHub Issues](https://github.com/iboss21/LXRCore-Police-System/issues)

---

## 📝 Credits

**Author:** iBoss  
**Organization:** The Land of Wolves  
**Framework Compatibility:** LXRCore, RSGCore, VORP  
**Game:** RedM (Red Dead Redemption 2)  
**Version:** 2.0.0 - Authentic Edition

---

## 📜 License

© 2026 iBoss | The Land of Wolves | www.wolves.land  
**All Rights Reserved**

This script is proprietary software. Unauthorized redistribution, modification, or commercial use is prohibited without express written permission.

---

## 🌟 Features Roadmap

- [ ] Physical evidence bags with inventory integration
- [ ] Courtroom system for trials
- [ ] Marshal service cross-territory jurisdiction
- [ ] Bounty hunter license system
- [ ] Citizen reporting via telegraph
- [ ] Multiple languages support
- [ ] Enhanced roleplay animations

---

**Made with ❤️ for authentic Wild West roleplay**

*"Keep the peace, one telegraph at a time"*

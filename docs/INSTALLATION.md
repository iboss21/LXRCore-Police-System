# 📥 Installation Guide

## The Land of Wolves RP - Law Enforcement System

This guide will walk you through installing the most advanced law enforcement system for RedM.

---

## Prerequisites

Before installing, ensure you have:

### Server Requirements
- ✅ **RedM Server** (Latest build recommended)
- ✅ **Minimum 8GB RAM** (16GB recommended for production)
- ✅ **MySQL/MariaDB Database**
- ✅ **Basic server administration knowledge**

### Framework Requirements
Choose one of the following:
- ✅ **RSG-Core** (Recommended) - Latest version
- ✅ **LXRCore** - Latest version
- ✅ **VORP** - With compatibility layer

### Dependencies
- ✅ **oxmysql** or **mysql-async**
- ✅ **rsg-target** (Optional, for targeting system)
- ✅ **rsg-inventory** or compatible inventory system

---

## Step 1: Download the Resource

### Method 1: Git Clone (Recommended)

```bash
cd resources/[law]
git clone https://github.com/iboss21/LXRCore-Police-System.git tlw-lawman
```

### Method 2: Manual Download

1. Go to [Releases](https://github.com/iboss21/LXRCore-Police-System/releases)
2. Download the latest `tlw-lawman.zip`
3. Extract to `resources/[law]/tlw-lawman/`

---

## Step 2: Database Setup

### Import SQL Migrations

Import all SQL files in the correct order:

```bash
# Navigate to the SQL directory
cd tlw-lawman/sql/migrations/

# Import in order
mysql -u your_username -p your_database < 001_mdt_citizens.sql
mysql -u your_username -p your_database < 002_mdt_warrants.sql
mysql -u your_username -p your_database < 003_mdt_bolos.sql
mysql -u your_username -p your_database < 004_mdt_reports.sql
mysql -u your_username -p your_database < 005_mdt_evidence.sql
mysql -u your_username -p your_database < 006_mdt_audit.sql
mysql -u your_username -p your_database < 007_leo_citations.sql
mysql -u your_username -p your_database < 008_leo_jail.sql
mysql -u your_username -p your_database < 009_leo_impound.sql
mysql -u your_username -p your_database < 010_leo_roster.sql
```

### Verify Tables

Run this query to verify all tables were created:

```sql
SHOW TABLES LIKE 'mdt_%';
SHOW TABLES LIKE 'leo_%';
```

You should see 10 tables total.

---

## Step 3: Framework Configuration

### For RSG-Core

#### 1. Add Jobs

Edit `rsg-core/shared/jobs.lua`:

```lua
['sheriff'] = {
    label = 'Sheriff Office',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Auxiliary Deputy', payment = 50 },
        ['1'] = { name = 'Deputy Sheriff', payment = 75 },
        ['2'] = { name = 'Senior Deputy', payment = 100 },
        ['3'] = { name = 'Under-Sheriff', payment = 125 },
        ['4'] = { name = 'Sheriff', payment = 150 },
    },
},
['marshal'] = {
    label = 'US Marshal',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Deputy Marshal', payment = 75 },
        ['1'] = { name = 'Field Marshal', payment = 100 },
        ['2'] = { name = 'Senior Marshal', payment = 125 },
        ['3'] = { name = 'Chief Marshal', payment = 175 },
        ['4'] = { name = 'US Marshal', payment = 200 },
    },
},
['ranger'] = {
    label = 'State Rangers',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Ranger Recruit', payment = 60 },
        ['1'] = { name = 'Ranger', payment = 85 },
        ['2'] = { name = 'Senior Ranger', payment = 110 },
        ['3'] = { name = 'Ranger Captain', payment = 150 },
        ['4'] = { name = 'Ranger Commander', payment = 180 },
    },
},
['lawman'] = {
    label = 'Town Marshal',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Constable', payment = 45 },
        ['1'] = { name = 'Deputy Marshal', payment = 65 },
        ['2'] = { name = 'Town Marshal', payment = 90 },
        ['3'] = { name = 'Chief Marshal', payment = 120 },
        ['4'] = { name = 'Marshal', payment = 140 },
    },
},
```

#### 2. Add Items

Edit `rsg-core/shared/items.lua`:

```lua
-- Law Enforcement Items
['lawman_badge'] = {
    name = 'lawman_badge',
    label = 'Lawman Badge',
    weight = 100,
    type = 'item',
    image = 'lawman_badge.png',
    unique = true,
    useable = true,
    shouldClose = true,
    description = 'Official law enforcement badge'
},
['temp_deputy_badge'] = {
    name = 'temp_deputy_badge',
    label = 'Temporary Deputy Badge',
    weight = 100,
    type = 'item',
    image = 'temp_badge.png',
    unique = true,
    useable = false,
    shouldClose = true,
    description = 'Temporary deputization badge'
},
['evidence_bag'] = {
    name = 'evidence_bag',
    label = 'Evidence Bag',
    weight = 50,
    type = 'item',
    image = 'evidence_bag.png',
    unique = true,
    useable = true,
    shouldClose = true,
    description = 'Bag for collecting evidence'
},
['investigation_journal'] = {
    name = 'investigation_journal',
    label = 'Investigation Journal',
    weight = 200,
    type = 'item',
    image = 'journal.png',
    unique = true,
    useable = true,
    shouldClose = true,
    description = 'Journal for documenting investigations'
},
['wanted_poster'] = {
    name = 'wanted_poster',
    label = 'Wanted Poster',
    weight = 50,
    type = 'item',
    image = 'wanted_poster.png',
    unique = true,
    useable = true,
    shouldClose = true,
    description = 'Wanted poster with criminal information'
},
['telegraph_paper'] = {
    name = 'telegraph_paper',
    label = 'Telegraph Message',
    weight = 10,
    type = 'item',
    image = 'telegram.png',
    unique = true,
    useable = true,
    shouldClose = true,
    description = 'Telegraph message paper'
},
['rope'] = {
    name = 'rope',
    label = 'Rope',
    weight = 500,
    type = 'item',
    image = 'rope.png',
    unique = false,
    useable = true,
    shouldClose = true,
    description = 'Strong hemp rope for restraining'
},
```

### For LXRCore

Similar process - edit the equivalent files in your LXRCore installation.

---

## Step 4: Resource Configuration

### 1. Basic Configuration

Edit `config/config_main.lua`:

```lua
-- Set your server information
Config.Branding = {
    ServerName = "Your Server Name",
    Website = "www.yourserver.com",
    Discord = "discord.gg/yourserver",
}

-- Set your framework
Config.Framework = {
    Type = "rsgcore", -- or "lxrcore"
}

-- Configure your Discord webhook
Config.Logging = {
    Webhook = "https://discord.com/api/webhooks/your_webhook_here",
}
```

### 2. Station Configuration

Adjust station locations if needed in `config/config_main.lua`:

```lua
Config.Stations = {
    ["valentine"] = {
        Enabled = true, -- Enable/disable stations
        Coords = vec3(-275.5, 804.0, 119.0),
        -- ... other settings
    },
}
```

### 3. Crime Configuration

Customize crimes, fines, and jail times in `config/config_main.lua`:

```lua
Config.Crimes = {
    ["murder"] = {
        Enabled = true,
        JailTime = 3600,  -- Adjust time
        Fine = 500,       -- Adjust fine
        Bounty = 1000,    -- Adjust bounty
    },
}
```

### 4. UI Configuration

Customize the UI theme in `config/config_main.lua`:

```lua
Config.UI = {
    Theme = "western_authentic",
    Colors = {
        Primary = "#8B7355",
        -- ... customize colors
    },
}
```

---

## Step 5: Server.cfg Setup

Add the resource to your `server.cfg`:

```cfg
# Framework (if not already loaded)
ensure rsg-core

# Dependencies
ensure oxmysql
ensure rsg-target

# Law Enforcement System
ensure tlw-lawman
```

**Important**: Make sure `tlw-lawman` loads AFTER your framework and dependencies.

---

## Step 6: Permissions & Admin Setup

### Grant Admin Access

Use your framework's admin commands to set yourself as sheriff:

#### RSG-Core
```
/job sheriff 4
```

#### In-Game Console
```lua
/setjob [your_id] sheriff 4
```

### Test Basic Functions

1. Go on duty at Valentine Sheriff's Office
2. Test opening the MDT (`/mdt`)
3. Test arresting a player (`/cuff [id]`)
4. Test the jail system (`/jail [id] 300`)

---

## Step 7: Item Images

### Add Item Images

Place item images in your inventory resource:

```
rsg-inventory/html/images/
├── lawman_badge.png
├── temp_badge.png
├── evidence_bag.png
├── investigation_journal.png
├── wanted_poster.png
├── telegram.png
└── rope.png
```

Download images from: `tlw-lawman/images/items/`

---

## Step 8: Verify Installation

### Checklist

- [ ] Database tables created successfully
- [ ] Jobs added to framework
- [ ] Items added to framework
- [ ] Resource starts without errors
- [ ] Can go on/off duty
- [ ] MDT opens correctly
- [ ] Can arrest players
- [ ] Jail system works
- [ ] Evidence collection works
- [ ] UI displays correctly

### Check Logs

Monitor your server console for:

```
[TLoW] Law Enforcement Configuration Loaded Successfully!
[TLoW] Version: 1.0.0
[TLoW] Website: www.wolves.land
```

---

## Troubleshooting

### Resource Won't Start

**Problem**: Resource fails to start

**Solutions**:
1. Check for syntax errors in config files
2. Ensure all dependencies are loaded
3. Verify framework is running
4. Check server console for specific errors

### Database Errors

**Problem**: SQL errors in console

**Solutions**:
1. Verify all migration files were imported
2. Check database credentials
3. Ensure database user has proper permissions
4. Run migrations again in correct order

### Items Not Working

**Problem**: Items don't show up or work

**Solutions**:
1. Verify items were added to framework
2. Check item images are in correct folder
3. Restart inventory resource
4. Clear client cache

### UI Not Showing

**Problem**: MDT UI doesn't open

**Solutions**:
1. Check browser console (F8 → Console)
2. Verify HTML/CSS files are present
3. Check NUI callback registrations
4. Try `/mdt` command again

### Permission Issues

**Problem**: Can't use certain features

**Solutions**:
1. Verify you have correct job and grade
2. Check `Config.Permissions` settings
3. Ensure rank meets minimum requirement
4. Use `/duty` to go on duty

---

## Next Steps

After successful installation:

1. Read the [Configuration Guide](CONFIGURATION.md)
2. Review [Commands & Features](FEATURES.md)
3. Set up additional stations
4. Configure crimes for your server
5. Train your staff on the system
6. Join our [Discord](https://discord.gg/wolves) for support

---

## Getting Help

If you encounter issues:

1. Check the [Troubleshooting](#troubleshooting) section
2. Search [GitHub Issues](https://github.com/iboss21/LXRCore-Police-System/issues)
3. Join our [Discord Server](https://discord.gg/wolves)
4. Create a [New Issue](https://github.com/iboss21/LXRCore-Police-System/issues/new)

---

<div align="center">

**Installation Complete!** 🎉

Welcome to **The Land of Wolves RP - Law Enforcement System**

*The world's most advanced law enforcement system for RedM*

[⬅ Back to README](README.md) | [Configuration Guide ➡](CONFIGURATION.md)

</div>

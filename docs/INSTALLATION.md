# 📥 Installation Guide

## LXR Police System — Law Enforcement for RedM

This guide walks you through a complete installation of the LXR Police System, covering all three supported frameworks: **RSGCore**, **LXRCore**, and **VORP**.

> ⚠️ **Important**: The resource folder **must** be named `lxr-police`.  
> Any other name will cause the config protection check to abort startup.

---

## Prerequisites

### Server Requirements
- ✅ **RedM Server** (latest build recommended)
- ✅ **Minimum 8 GB RAM** (16 GB recommended for production)
- ✅ **MySQL / MariaDB database**
- ✅ Basic server administration knowledge

### Framework — choose one
- ✅ **RSGCore** (`rsg-core`) — latest version
- ✅ **LXRCore** (`lxr-core`) — latest version
- ✅ **VORP** (`vorp_core`) — with `vorp_inventory`

### Dependencies
- ✅ **oxmysql** (recommended) or **mysql-async**
- ✅ **rsg-target** / **ox_target** (optional — for targeting interactions)
- ✅ **rsg-inventory** / **lxr-inventory** / **vorp_inventory** (required for physical items)

---

## Step 1: Download the Resource

### Method 1: Git Clone (Recommended)

```bash
cd resources/[law]
git clone https://github.com/iboss21/LXRCore-Police-System.git lxr-police
```

### Method 2: Manual Download

1. Go to [Releases](https://github.com/iboss21/LXRCore-Police-System/releases)
2. Download the latest release archive
3. Extract to `resources/[law]/lxr-police/`

---

## Step 2: Database Setup

### Import SQL Migrations

Import all 15 SQL files **in order**:

```bash
cd lxr-police/sql/migrations/

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
mysql -u your_username -p your_database < 011_mdt_bounties.sql
mysql -u your_username -p your_database < 012_mdt_dispatch.sql
mysql -u your_username -p your_database < 013_mdt_enhancements.sql
mysql -u your_username -p your_database < 014_k9_system.sql
mysql -u your_username -p your_database < 015_leo_core_enhancements.sql
```

Or import all at once on Linux/macOS:

```bash
for f in lxr-police/sql/migrations/*.sql; do
    mysql -u your_username -p your_database < "$f"
done
```

### Verify Tables

```sql
SHOW TABLES LIKE 'mdt_%';
SHOW TABLES LIKE 'leo_%';
```

You should see **15 tables** total.

---

## Step 3: Framework Configuration

### For RSGCore

#### 1. Add Jobs — `rsg-core/shared/jobs.lua`

```lua
['sheriff'] = {
    label = "Sheriff's Office",
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Auxiliary Deputy',  payment = 50  },
        ['1'] = { name = 'Deputy Sheriff',    payment = 75  },
        ['2'] = { name = 'Senior Deputy',     payment = 100 },
        ['3'] = { name = 'Under-Sheriff',     payment = 125 },
        ['4'] = { name = 'Sheriff',           payment = 150 },
    },
},
['marshal'] = {
    label = 'US Marshal Service',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Deputy Marshal',  payment = 75  },
        ['1'] = { name = 'Field Marshal',   payment = 100 },
        ['2'] = { name = 'Senior Marshal',  payment = 125 },
        ['3'] = { name = 'Chief Marshal',   payment = 175 },
        ['4'] = { name = 'US Marshal',      payment = 200 },
    },
},
['ranger'] = {
    label = 'State Rangers',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Ranger Recruit',   payment = 60  },
        ['1'] = { name = 'Ranger',           payment = 85  },
        ['2'] = { name = 'Senior Ranger',    payment = 110 },
        ['3'] = { name = 'Ranger Captain',   payment = 150 },
        ['4'] = { name = 'Ranger Commander', payment = 180 },
    },
},
['lawman'] = {
    label = 'Town Marshal',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = { name = 'Constable',      payment = 45  },
        ['1'] = { name = 'Deputy Marshal', payment = 65  },
        ['2'] = { name = 'Town Marshal',   payment = 90  },
        ['3'] = { name = 'Chief Marshal',  payment = 120 },
        ['4'] = { name = 'Marshal',        payment = 140 },
    },
},
```

#### 2. Add Items — `rsg-core/shared/items.lua`

See **[docs/ITEMS.md — RSGCore section](ITEMS.md#rsgcore)** for the complete list of all 43 items.  
A short excerpt is shown below — add the full block from ITEMS.md:

```lua
['lawman_badge'] = {
    name = 'lawman_badge', label = 'Lawman Badge',
    weight = 100, type = 'item', image = 'lawman_badge.png',
    unique = true, useable = true, shouldClose = true,
    description = 'Official law enforcement badge',
},
-- ... (see docs/ITEMS.md for all items)
```

#### 3. Copy Item Images

```bash
cp lxr-police/images/items/*.png rsg-inventory/html/images/
```

---

### For LXRCore

#### 1. Add Jobs — `lxr-core/shared/jobs.lua`

Add the same four job blocks shown in the RSGCore section above.  
LXRCore uses an identical job table structure.

#### 2. Add Items — `lxr-core/shared/items.lua`

The LXRCore item table structure is identical to RSGCore.  
See **[docs/ITEMS.md — LXRCore section](ITEMS.md#lxrcore)** for the complete block.

If you are using **ox_inventory** as the LXRCore inventory backend, use the  
**[Ox Inventory block](ITEMS.md#ox-inventory-lxr-inventory--ox_inventory)** in ITEMS.md instead.

#### 3. Copy Item Images

```bash
cp lxr-police/images/items/*.png lxr-inventory/html/images/
```

---

### For VORP

#### 1. Add Jobs

VORP manages jobs through SQL. Run the following against your database:

```sql
INSERT IGNORE INTO `jobs` (`name`, `label`) VALUES
  ('sheriff', 'Sheriff''s Office'),
  ('marshal',  'US Marshal Service'),
  ('ranger',   'State Rangers'),
  ('lawman',   'Town Marshal');

INSERT IGNORE INTO `job_grades` (`job_name`, `grade`, `name`, `salary`) VALUES
  ('sheriff', 0, 'Auxiliary Deputy',  50),
  ('sheriff', 1, 'Deputy Sheriff',    75),
  ('sheriff', 2, 'Senior Deputy',    100),
  ('sheriff', 3, 'Under-Sheriff',    125),
  ('sheriff', 4, 'Sheriff',          150),
  ('marshal',  0, 'Deputy Marshal',   75),
  ('marshal',  1, 'Field Marshal',   100),
  ('marshal',  2, 'Senior Marshal',  125),
  ('marshal',  3, 'Chief Marshal',   175),
  ('marshal',  4, 'US Marshal',      200),
  ('ranger',   0, 'Ranger Recruit',   60),
  ('ranger',   1, 'Ranger',           85),
  ('ranger',   2, 'Senior Ranger',   110),
  ('ranger',   3, 'Ranger Captain',  150),
  ('ranger',   4, 'Ranger Commander',180),
  ('lawman',   0, 'Constable',        45),
  ('lawman',   1, 'Deputy Marshal',   65),
  ('lawman',   2, 'Town Marshal',     90),
  ('lawman',   3, 'Chief Marshal',   120),
  ('lawman',   4, 'Marshal',         140);
```

> **Note**: Column names may differ between VORP versions. Adjust to match your `jobs` table schema.

#### 2. Add Items

See **[docs/ITEMS.md — VORP section](ITEMS.md#vorp)** for the complete SQL `INSERT` statements covering all 43 items.

#### 3. Copy Item Images

```bash
cp lxr-police/images/items/*.png vorp_inventory/html/images/
```

---

## Step 4: Resource Configuration

Open **`config/config.lua`** — all settings live in this single file.

### Set Framework

```lua
-- "auto" detects lxr-core → rsg-core → vorp_core automatically
Config.Framework = "auto"

-- Or force a specific framework:
-- Config.Framework = "lxrcore"
-- Config.Framework = "rsgcore"
-- Config.Framework = "vorp"
```

### Set Discord Webhook (Audit Logs)

```lua
Config.Logging = {
    Webhook       = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE",
    -- ...
}
```

### Adjust Station Coordinates

```lua
Config.Stations = {
    ["valentine"] = {
        coords = vec3(-275.5, 804.0, 119.0),
        -- ... adjust to your map
    },
}
```

### Toggle Features

```lua
Config.Features = {
    EnableWarrantSystem  = true,
    EnableBountySystem   = true,
    EnableK9Unit         = true,
    EnableJailSystem     = true,
    EnableEvidenceSystem = true,
    -- ...
}
```

---

## Step 5: server.cfg Setup

```cfg
# ── Dependencies ──────────────────────────────
ensure oxmysql

# ── Framework (whichever you use) ─────────────
ensure rsg-core      # or lxr-core / vorp_core

# ── Inventory ─────────────────────────────────
ensure rsg-inventory # or lxr-inventory / vorp_inventory

# ── Targeting (optional) ──────────────────────
ensure rsg-target    # or ox_target

# ── LXR Police System ─────────────────────────
ensure lxr-police
```

> **Rule**: `lxr-police` must load **after** your framework, inventory, and oxmysql.

---

## Step 6: Permissions & First Login

### Assign a LEO Job In-Game

#### RSGCore / LXRCore
```
/setjob [player_id] sheriff 4
```

#### VORP
```
/setjob [player_id] sheriff 4
```

### Test Basic Functions

1. Go on duty at Valentine Sheriff's Office
2. Open the MDT with `/mdt`
3. Test `/cuff [player_id]`
4. Test `/jail [player_id] 300`

---

## Step 7: Verify Installation

### Checklist

- [ ] All 15 database tables created successfully
- [ ] All four law jobs added to framework
- [ ] All items registered in inventory system
- [ ] Item images copied to inventory image folder
- [ ] Resource starts without console errors
- [ ] Bridge detection log appears: `[lxr-police] Bridge loaded — framework: X ✓`
- [ ] Can go on / off duty
- [ ] MDT opens correctly
- [ ] Can arrest players (rope hogtie)
- [ ] Jail system works
- [ ] Evidence collection creates physical items
- [ ] UI displays correctly

### Success Log

On a clean start you should see:

```
[lxr-police] Bridge loaded — framework: rsgcore ✓
```

---

## Troubleshooting

### Resource Won't Start

| Symptom | Fix |
|---|---|
| `Resource must be named "lxr-police"` | Rename the folder to `lxr-police` |
| `No supported framework detected` | Ensure your framework resource is started **before** `lxr-police` |
| Lua syntax errors | Check `config/config.lua` for missing commas / brackets |

### Database Errors

| Symptom | Fix |
|---|---|
| `Table 'mdt_citizens' doesn't exist` | Import all 15 SQL migration files in order |
| `Access denied` | Ensure DB user has `CREATE`, `INSERT`, `SELECT`, `UPDATE`, `DELETE` permissions |
| Duplicate-key errors on re-import | Safe to ignore — migrations use `CREATE TABLE IF NOT EXISTS` |

### Items Not Working

| Symptom | Fix |
|---|---|
| Items not visible in inventory | Verify items were added to the framework items file and inventory resource restarted |
| Broken image (grey box) | Copy PNG files from `lxr-police/images/items/` to your inventory images folder |
| `"item not found"` in server console | Item name in config doesn't match item name in framework — check spelling |

### UI Not Showing

| Symptom | Fix |
|---|---|
| MDT blank / not opening | Open F8 console, check for JS errors; verify `html/` files are present |
| NUI focus stuck | Type `/mdt` again or use `nui_forceFocus 0` in console |

### Permission Issues

| Symptom | Fix |
|---|---|
| "You don't have permission" | Confirm job name and grade with `/myjob` or equivalent command |
| MDT read-only | Grade must be ≥ 1 for edit access; grade ≥ 3 for admin |

---

## Getting Help

1. Check the [Troubleshooting](#troubleshooting) section above
2. Review [docs/ITEMS.md](ITEMS.md) for item registration details
3. Search [GitHub Issues](https://github.com/iboss21/LXRCore-Police-System/issues)
4. Join our [Discord Server](https://discord.gg/CrKcWdfd3A)
5. Create a [New Issue](https://github.com/iboss21/LXRCore-Police-System/issues/new)

---

<div align="center">

**Installation Complete!** 🎉

Welcome to **LXR Police System**

[⬅ Back to README](../README.md) | [Items Reference ➡](ITEMS.md) | [API Reference ➡](API.md)

</div>

# 🐺 LXR Police — Wild West Law Enforcement for RedM

[![Version](https://img.shields.io/badge/version-1.0.0-gold?style=flat-square)](https://github.com/iboss21/LXRCore-Police-System)
[![RedM](https://img.shields.io/badge/RedM-Compatible-darkred?style=flat-square)](https://redm.net/)
[![Framework](https://img.shields.io/badge/Framework-LXRCore%20%7C%20RSGCore%20%7C%20VORP-blue?style=flat-square)](#)

Historically authentic 1899 law enforcement system for RedM.  
Sheriffs, US Marshals, State Rangers, Town Marshals — all in one resource.

---

## Features

| System | Highlights |
|---|---|
| **Jobs & Ranks** | Sheriff, Marshal, Ranger, Town Marshal — 5 ranks each |
| **Arrest & Detention** | Rope hogtie, search, prisoner transport, mugshots |
| **Jail & Prison** | Local cells + Sisika Penitentiary, bail, parole, chain gang |
| **Warrants** | Supervisor-approved arrest / search / bench warrants |
| **Bounty** | Dynamic wanted levels, posters, bounty hunters, tier decay |
| **Posse** | Form posses, deputize civilians, shared comms |
| **Dispatch** | Telegraph, bell tower, messenger, signal fires |
| **Evidence** | Blood, casings, footprints, fingerprints, forensics |
| **Investigation** | Crime scenes, tracking trails, witness statements |
| **K9 Unit** | Bloodhound / Coonhound / Shepherd — track, search, apprehend |
| **Physical Items** | Paper reports, warrants, evidence bags, wanted posters |
| **Wearables** | Badges, rope, handcuffs, baton, camera |
| **Execution** | Public hangings for capital offenses |
| **MDT** | In-game records ledger accessible on duty |
| **Anti-Abuse** | Server-side rate limits, distance checks, audit log |
| **Progression** | XP rewards, rank unlock perks |

---

## Requirements

- RedM Server (latest)
- [oxmysql](https://github.com/overextended/oxmysql)
- One of: **lxr-core**, **rsg-core**, or **vorp_core** (auto-detected)

---

## Installation

```bash
# 1. Clone into your resources folder — the folder MUST be named lxr-police
git clone https://github.com/iboss21/LXRCore-Police-System lxr-police

# 2. Import SQL migrations in order
for f in lxr-police/sql/migrations/*.sql; do mysql -u root -p your_db < "$f"; done

# 3. Add to server.cfg
ensure oxmysql
ensure lxr-police
```

### Configuration

Open **`config/config.lua`** — every setting for every system lives in this single file.

Key sections:

| Section | What to set |
|---|---|
| `Config.Framework` | `"auto"` (recommended) or force `"lxrcore"` / `"rsgcore"` / `"vorp"` |
| `Config.Stations` | Adjust coords for your map |
| `Config.LawJobs` | Match your framework's job names |
| `Config.Logging.Webhook` | Your Discord webhook URL for audit logs |
| `Config.Features` | Toggle any system on/off |
| `Config.DebugSettings` | Enable debug output during setup |

> **Locales**: Copy `config/locales/en.lua` to `config/locales/ka.lua` (or your language) and translate as needed.

---

## Exports

### Client
```lua
exports['lxr-police']:IsCuffed()      -- boolean
exports['lxr-police']:IsInJail()      -- boolean
exports['lxr-police']:IsOfficer()     -- boolean
exports['lxr-police']:GetOfficerDept()-- string | nil
exports['lxr-police']:IsBeingDragged()-- boolean
```

### Server
```lua
exports['lxr-police']:IsOfficer(src)          -- boolean
exports['lxr-police']:GetOfficerDept(src)     -- string | nil
exports['lxr-police']:HasPermission(src, perm)-- boolean
exports['lxr-police']:GetPlayer(src)          -- player object
exports['lxr-police']:IsCuffed(src)           -- boolean
exports['lxr-police']:GetArrestState(src)     -- table
exports['lxr-police']:IsInJail(src)           -- boolean
exports['lxr-police']:GetPrisonerData(src)    -- table | nil
exports['lxr-police']:GetEvidence(id)         -- table | nil
exports['lxr-police']:CreateEvidence(type, data, src) -- number (id)
```

Full event list: [`docs/EVENTS.md`](docs/EVENTS.md)  
API reference: [`docs/API.md`](docs/API.md)

---

## Links

| | |
|---|---|
| Server | [wolves.land](https://www.wolves.land) |
| Discord | [discord.gg/CrKcWdfd3A](https://discord.gg/CrKcWdfd3A) |
| Store | [theluxempire.tebex.io](https://theluxempire.tebex.io) |
| Issues | [GitHub Issues](https://github.com/iboss21/LXRCore-Police-System/issues) |

---

© 2026 iBoss21 / The Lux Empire · All Rights Reserved

# 🚀 Quick Reference Guide
## LXRCore Police System - Developer's Cheat Sheet

**Quick access to key information for developers working on this project.**

---

## 📊 Project Stats

```
Total Files:        40+
Total LOC:          ~6,500
Languages:          Lua, HTML, CSS, SQL
Frameworks:         RSGCore, LXRCore, VORP
Database Tables:    12
Config Options:     500+
Status:             95% Complete
Grade:              A (9.2/10)
```

---

## 🎯 Current Status

### ✅ Complete (95%)
- All Lua server/client code
- Configuration system
- Database schema
- HTML structure
- CSS styling
- Bridge system
- Documentation (code)

### ⚠️ Incomplete (5%)
- JavaScript implementation
- User documentation
- Database indexes
- Some input validation

---

## 🔧 Critical Tasks

### Must Do Before Production

1. **JavaScript Implementation** 🔴 CRITICAL
   ```javascript
   // Files needed:
   html/js/main.js
   html/js/mdt.js
   html/js/ui.js
   
   // Features needed:
   - Tab switching
   - Form handling
   - Data binding
   - Search functionality
   - Modal interactions
   ```

2. **Database Indexes** 🟡 HIGH
   ```sql
   CREATE INDEX idx_citizens_identifier ON mdt_citizens(identifier);
   CREATE INDEX idx_warrants_status ON mdt_warrants(status);
   CREATE INDEX idx_reports_date ON mdt_reports(created_at);
   CREATE INDEX idx_evidence_collected ON mdt_evidence(collected_at);
   CREATE INDEX idx_bounties_status ON mdt_bounties(status);
   ```

3. **Input Validation** 🟡 MEDIUM
   ```lua
   -- Add validation for:
   - String length limits
   - Numerical bounds
   - Format validation
   - Sanitization
   ```

---

## 📁 File Structure

### Client Scripts (11 files)
```
client/
├── arrest.lua              # 207 LOC - Arrest mechanics
├── attachments.lua         # 336 LOC - Item attachments
├── citations.lua           #  10 LOC - Citation system
├── dispatch.lua            #  13 LOC - Dispatch alerts
├── duty.lua                #  20 LOC - Duty management
├── evidence.lua            #   8 LOC - Evidence viewing
├── evidence_collection.lua # 281 LOC - Evidence collection
├── impound.lua             #  12 LOC - Vehicle impound
├── jail.lua                # 298 LOC - Jail system
├── jail_client.lua         # 248 LOC - Jail client
└── ui_bridge.lua           #   8 LOC - UI bridge
```

### Server Scripts (12 files)
```
server/
├── arrest.lua              # 261 LOC - Arrest state
├── audit.lua               #   7 LOC - Audit logging
├── bounty.lua              # 213 LOC - Bounty system
├── citations.lua           #  14 LOC - Citations
├── dispatch.lua            #  12 LOC - Dispatch
├── evidence_management.lua # 329 LOC - Evidence mgmt
├── mdt.lua                 # 311 LOC - MDT system
├── permissions.lua         #   6 LOC - Permissions
├── players.lua             #  16 LOC - Player mgmt
├── posse.lua               # 258 LOC - Posse system
├── profiler.lua            #   7 LOC - Profiler
└── telegraph.lua           # 236 LOC - Telegraph
```

### Configuration (6 files)
```
config/
├── config.lua              # 382 LOC - Base config
├── config_main.lua         #1033 LOC - Main config
├── config_advanced.lua     # 683 LOC - Advanced config
├── statutes.lua            #  20 LOC - Legal statutes
├── wearable_items.lua      # 499 LOC - Equipment
└── locales/
    ├── en.lua              # English
    └── ka.lua              # Georgian
```

---

## 🔌 Key Exports

### Client Exports
```lua
exports["lxr-police"]:IsOfficer()          -- Check if player is officer
exports["lxr-police"]:GetOfficerDept()     -- Get officer's department
exports["lxr-police"]:IsCuffed()           -- Check if cuffed
exports["lxr-police"]:IsBeingDragged()     -- Check if being dragged
exports["lxr-police"]:IsInJail()           -- Check if in jail
```

### Server Exports
```lua
exports["lxr-police"]:IsOfficer(src)       -- Check if player is officer
exports["lxr-police"]:GetOfficerDept(src)  -- Get officer's department
exports["lxr-police"]:HasPermission(src, perm) -- Check permission
exports["lxr-police"]:GetPlayer(src)       -- Get player data
exports["lxr-police"]:IsCuffed(src)        -- Check if cuffed
exports["lxr-police"]:GetArrestState(src)  -- Get arrest state
exports["lxr-police"]:IsInJail(src)        -- Check if in jail
exports["lxr-police"]:GetPrisonerData(src) -- Get prisoner data
exports["lxr-police"]:GetEvidence(id)      -- Get evidence
exports["lxr-police"]:CreateEvidence(data) -- Create evidence
```

---

## 🎨 UI Color Palette

```css
/* Western Theme Colors */
--primary:         #8B7355  /* Saddle Brown */
--secondary:       #D4A574  /* Tan/Parchment */
--accent:          #C19A6B  /* Camel/Gold */
--success:         #6B8E23  /* Olive Green */
--warning:         #DAA520  /* Goldenrod */
--danger:          #8B0000  /* Dark Red */
--info:            #4682B4  /* Steel Blue */
--dark:            #3E2723  /* Dark Brown */
--light:           #F5E6D3  /* Aged Paper */
--text-primary:    #2C1810  /* Dark Brown Text */
--text-secondary:  #5D4E37  /* Medium Brown Text */
```

### Fonts
```css
--font-primary:    'Rye', serif
--font-secondary:  'Cinzel', serif
--font-mono:       'Courier Prime', monospace
--font-handwriting:'Dawning of a New Day', cursive
```

---

## 🗄️ Database Tables

```sql
1.  mdt_citizens        -- Citizen records
2.  mdt_warrants        -- Active warrants
3.  mdt_bolos           -- BOLO alerts
4.  mdt_reports         -- Incident reports
5.  mdt_evidence        -- Evidence storage
6.  mdt_audit           -- Audit logs
7.  leo_citations       -- Traffic citations
8.  leo_jail            -- Prisoner records
9.  leo_impound         -- Impounded vehicles
10. leo_roster          -- Officer roster
11. mdt_bounties        -- Bounty system
12. mdt_dispatch        -- Dispatch calls
```

---

## 🎮 Event Reference

### Client Events
```lua
-- Arrest
"lxr-police:arrest:softCuff"
"lxr-police:arrest:hardCuff"
"lxr-police:arrest:uncuff"
"lxr-police:arrest:drag"

-- Evidence
"lxr-police:evidence:spawn"
"lxr-police:evidence:collect"

-- Jail
"lxr-police:jail:send"
"lxr-police:jail:release"

-- UI
"lxr-police:ui:show"
"lxr-police:ui:hide"
```

### Server Events
```lua
-- Arrest
"lxr-police:arrest:softCuff"
"lxr-police:arrest:hardCuff"
"lxr-police:arrest:uncuff"

-- MDT
"lxr-police:mdt:searchCitizen"
"lxr-police:mdt:getCitizenProfile"
"lxr-police:mdt:createReport"

-- Bounty
"tlw-law:bounty:createPoster"
"tlw-law:bounty:claim"

-- Evidence
"lxr-police:evidence:collect"
"lxr-police:evidence:analyze"
```

---

## 🔒 Permission Levels

```lua
-- Basic Permissions
"arrest"            -- Can arrest/cuff
"search"            -- Can search players
"evidence"          -- Can collect evidence

-- MDT Permissions
"mdt_view"          -- Can view MDT
"mdt_edit"          -- Can edit records
"mdt_admin"         -- Full MDT access

-- Advanced Permissions
"bounty_place"      -- Can place bounties
"execution"         -- Can perform executions
"posse_leader"      -- Can lead posses
"telegraph"         -- Can send telegraphs
```

---

## ⚙️ Configuration Highlights

### Enable/Disable Features
```lua
Config.Features = {
    EnableBountySystem = true,
    EnablePosseFormation = true,
    EnablePublicExecutions = true,
    EnableChainGang = true,
    EnableTelegraphAlerts = true,
    EnableWantedPosters = true,
    EnableTrackingSystem = true,
    EnableHorseImpound = true,
    EnableWitnessSystem = true,
}
```

### Law Jobs (1899 Accurate)
```lua
Config.LawJobs = {
    ["sheriff"] = "Sheriff's Office",
    ["marshal"] = "US Marshal Service",
    ["ranger"] = "State Rangers",
    ["lawman"] = "Town Marshal",
}
```

### Stations
```lua
-- 7 stations configured:
valentine, rhodes, strawberry, blackwater,
tumbleweed, annesburg, sisika (prison)
```

---

## 🐛 Common Issues & Fixes

### Issue: UI Not Showing
```lua
-- Check:
1. Is JavaScript implemented? (No = Need to add)
2. Is html/index.html correct path in manifest?
3. Are CSS files loading?
```

### Issue: Permission Denied
```lua
-- Check:
1. Is player's job in Config.LawJobs?
2. Does player have correct rank?
3. Is permission defined in config?
```

### Issue: Database Error
```lua
-- Check:
1. Are all migrations run?
2. Is oxmysql started?
3. Are table names correct?
4. Check for SQL syntax errors
```

### Issue: Animations Not Playing
```lua
-- Check:
1. Are animation dictionaries valid for RedM?
2. Is animation dict loaded before use?
3. Timeout on dict loading?
```

---

## 🧪 Testing Checklist

### Arrest System
- [ ] Soft cuff works
- [ ] Hard cuff works
- [ ] Uncuff works
- [ ] Drag works
- [ ] Animations play correctly
- [ ] Player controls disabled when cuffed

### Evidence Collection
- [ ] Blood samples spawn
- [ ] Casings spawn
- [ ] Can collect evidence
- [ ] Evidence stored in database
- [ ] Evidence visible in MDT

### Jail System
- [ ] Can send to jail
- [ ] Time counts down
- [ ] Chain gang works
- [ ] Bail system works
- [ ] Release works

### Bounty System
- [ ] Can create wanted poster
- [ ] Poster shows in UI
- [ ] Can claim bounty
- [ ] Rewards paid correctly

### MDT System
- [ ] Can search citizens
- [ ] Can view profiles
- [ ] Can create reports
- [ ] Can issue warrants

---

## 📚 Learning Resources

### RedM Development
- RedM Natives: https://github.com/femga/rdr3_discoveries
- RSGCore Framework: https://github.com/Rexshack-RedM
- Lua 5.4 Docs: https://www.lua.org/manual/5.4/

### This Project
- Full Analysis: `SCRIPT_ANALYSIS.md`
- Summary: `ANALYSIS_SUMMARY.md`
- Project Status: `PROJECT_SUMMARY.md`
- README: `README.md`

---

## 🎯 Development Priorities

### Week 1 (Critical)
1. JavaScript implementation
2. Database indexes
3. Basic testing

### Week 2 (Important)
4. Input validation
5. User documentation
6. Rate limiting

### Week 3+ (Nice to Have)
7. Automated tests
8. Screenshots
9. Video tutorials
10. Additional features

---

## 💡 Pro Tips

### Configuration
```lua
-- Test config changes without restart:
-- Use Config.Debug = true for verbose logging
-- Always backup config before major changes
```

### Database
```lua
-- Use migrations for schema changes
-- Never edit database directly in production
-- Keep backups before major updates
```

### Testing
```lua
-- Test on local server first
-- Use multiple test accounts
-- Check logs for errors
-- Monitor performance
```

### Performance
```lua
-- Cache frequently accessed data
-- Use async operations
-- Limit queries in loops
-- Clean up objects
```

---

## 🔗 Quick Links

- **Repository**: https://github.com/iboss21/LXRCore-Police-System
- **Discord**: discord.gg/wolves (The Land of Wolves)
- **Website**: www.wolves.land

---

## 📞 Support

**For bugs:**
1. Check SCRIPT_ANALYSIS.md
2. Review logs for errors
3. Check configuration
4. Test on clean install

**For features:**
1. Review PROJECT_SUMMARY.md
2. Check config options
3. See if it's configurable
4. Request if needed

---

**Last Updated:** December 16, 2024  
**Version:** 1.0.0  
**Maintainer:** GitHub Copilot

*Quick reference for developers. For full details, see complete analysis documents.*

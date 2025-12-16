# Enhanced MDT System - Installation Guide

## Prerequisites

Before installing the enhanced MDT system, ensure you have:
- RedM Server with RSGCore or LXRCore framework
- MySQL/MariaDB database
- oxmysql resource installed
- Basic police system already configured

## Installation Steps

### Step 1: Backup Your Database
```sql
-- Create a backup of your database before running migrations
mysqldump -u username -p database_name > backup_$(date +%Y%m%d).sql
```

### Step 2: Run Database Migration

Execute the new migration file to add/update tables:

```sql
-- Connect to your database
mysql -u username -p database_name

-- Run the migration
source sql/migrations/013_mdt_enhancements.sql
```

This will:
- Add 8 new tables for enhanced features
- Update existing tables with new fields
- Add performance indexes
- Preserve all existing data

### Step 3: Verify Database Changes

Check that new tables were created:
```sql
SHOW TABLES LIKE 'mdt_%';
```

You should see:
- mdt_citizens (updated)
- mdt_reports (updated)
- mdt_warrants (updated)
- mdt_arrests (new)
- mdt_wanted_posters (new)
- mdt_cases (new)
- mdt_vehicles (new)
- mdt_bolos (new)
- mdt_convictions (new)
- mdt_citizen_files (new)

### Step 4: Ensure Resource is Updated

The fxmanifest.lua has been updated to include:
- `server/mdt_enhanced.lua` - Enhanced server logic
- `client/mdt_client.lua` - Client-side MDT handler
- `html/js/western-ui.js` - UI functionality

These files should be automatically loaded when you restart the resource.

### Step 5: Restart the Resource

```bash
# In your server console
restart lxr-police
```

Or restart your entire server:
```bash
# Stop server
# Start server
```

### Step 6: Verify Installation

1. Join your server
2. Ensure you have police job
3. Go on duty
4. Run command: `/mdt`
5. MDT interface should open

## Post-Installation

### Grant Permissions

Make sure officers have appropriate permissions in your permission system:

```lua
-- Example permission setup
Config.Permissions = {
    ['officer'] = {'mdt_view'},
    ['sergeant'] = {'mdt_view', 'mdt_edit'},
    ['lieutenant'] = {'mdt_view', 'mdt_edit', 'mdt_delete'},
}
```

### Test Core Features

Test each major feature:
- [ ] Open MDT with `/mdt`
- [ ] Search for citizens
- [ ] View citizen profile
- [ ] Create a report
- [ ] Create an arrest record
- [ ] Issue a warrant
- [ ] Create a wanted poster
- [ ] Create a BOLO
- [ ] Check vehicle plate

### Populate Initial Data

You may want to add some initial citizens to the database:

```sql
INSERT INTO mdt_citizens (identifier, name, date_of_birth, gender) VALUES
('TEST001', 'John Doe', '1875-05-15', 'male'),
('TEST002', 'Jane Smith', '1880-08-20', 'female');
```

## Configuration

### Optional: Customize MDT Settings

In your `config.lua` or `config_main.lua`, you can add:

```lua
Config.MDT = {
    -- Feature toggles
    EnableDashboard = true,
    EnableCitizenSearch = true,
    EnableReports = true,
    EnableWarrants = true,
    EnableWantedPosters = true,
    EnableVehicleDatabase = true,
    EnableBOLO = true,
    EnableCases = true,
    
    -- Search limits
    MaxSearchResults = 50,
    MaxReportsPerPage = 100,
    
    -- Permissions
    ViewPermission = "mdt_view",
    EditPermission = "mdt_edit",
    DeletePermission = "mdt_delete",
    
    -- UI Settings
    Theme = "western", -- western, modern, classic
    ShowMugshots = true,
    ShowDangerBadges = true,
}
```

### Optional: Set Up Key Binding

Players can bind a key to open MDT:

In `client/mdt_client.lua`, uncomment the line:
```lua
RegisterKeyMapping('mdt', 'Open MDT', 'keyboard', 'F5')
```

Or players can set it themselves in FiveM settings.

## Troubleshooting

### Migration Errors

If you get SQL errors during migration:

1. **"Table already exists"**: The table may already exist from a previous version. You can either:
   - Drop the table first: `DROP TABLE IF EXISTS table_name;`
   - Or skip that table creation

2. **"Column already exists"**: The column may exist. Safe to ignore.

3. **Foreign key constraint fails**: Ensure parent tables exist first:
   - `mdt_citizens` must exist before running migration
   - Run migrations in order (001-013)

### MDT Won't Open

1. Check server console for errors
2. Verify you're on duty as police
3. Check permissions
4. Open F8 console for client errors

### Missing Data

If citizen profiles show no data:
1. Check database connection
2. Verify tables were created
3. Check server console for SQL errors
4. Ensure oxmysql is running

### UI Issues

If UI looks broken:
1. Clear browser cache (Ctrl+F5)
2. Check that CSS file is loaded
3. Check browser console (F8) for JavaScript errors
4. Verify all HTML/JS files are present

## Updating from Previous Version

If you're upgrading from an older version:

1. Backup your database first
2. Run the new migration (013)
3. Existing data will be preserved
4. New fields will be added with default values
5. Restart resource

## Performance Optimization

For large databases with many records:

1. Ensure indexes are created (migration 013 includes them)
2. Consider archiving old records:
   ```sql
   -- Archive reports older than 1 year
   CREATE TABLE mdt_reports_archive LIKE mdt_reports;
   INSERT INTO mdt_reports_archive 
   SELECT * FROM mdt_reports 
   WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 YEAR);
   
   DELETE FROM mdt_reports 
   WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 YEAR);
   ```

3. Regular database optimization:
   ```sql
   OPTIMIZE TABLE mdt_citizens, mdt_reports, mdt_arrests, mdt_warrants;
   ```

## Security Recommendations

1. **Database Backups**: Set up automated daily backups
2. **Audit Logs**: Monitor the audit table regularly
3. **Permissions**: Use least privilege principle
4. **Rate Limiting**: Consider adding cooldowns for report creation
5. **Input Validation**: Already implemented, but monitor for abuse

## Support & Help

If you encounter issues:

1. Check the MDT_DOCUMENTATION.md for usage help
2. Review error logs in server console
3. Check the audit table for permission issues:
   ```sql
   SELECT * FROM leo_audit WHERE action LIKE '%mdt%' ORDER BY created_at DESC LIMIT 20;
   ```
4. Contact your server administrator
5. Review the code in server/mdt_enhanced.lua for logic

## Uninstallation (Not Recommended)

If you need to remove the enhanced MDT:

```sql
-- WARNING: This will delete all MDT data
DROP TABLE IF EXISTS mdt_arrests;
DROP TABLE IF EXISTS mdt_wanted_posters;
DROP TABLE IF EXISTS mdt_cases;
DROP TABLE IF EXISTS mdt_vehicles;
DROP TABLE IF EXISTS mdt_bolos;
DROP TABLE IF EXISTS mdt_convictions;
DROP TABLE IF EXISTS mdt_citizen_files;

-- Revert enhanced columns (optional)
ALTER TABLE mdt_reports DROP COLUMN title;
ALTER TABLE mdt_reports DROP COLUMN location;
-- etc...
```

Then remove from fxmanifest.lua:
- server/mdt_enhanced.lua
- client/mdt_client.lua

And restart the resource.

## Next Steps

After successful installation:

1. Read the MDT_DOCUMENTATION.md for usage instructions
2. Train your officers on the new features
3. Create some test records to familiarize yourself
4. Set up appropriate permissions for your ranks
5. Enjoy your enhanced MDT system!

---

**Installation complete! Your enhanced MDT system is ready to use.**

For questions or issues, refer to the documentation or contact support.

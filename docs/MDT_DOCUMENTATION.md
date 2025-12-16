# Enhanced MDT System - Documentation

## Overview

The Enhanced Mobile Data Terminal (MDT) system provides comprehensive law enforcement record-keeping and management capabilities. This system allows officers to search citizens, create reports, manage arrest records, issue warrants, create wanted posters, and much more.

## Features

### 1. **Citizen Records Management**
- **Search Citizens**: Search by name or citizen ID
- **View Profiles**: Comprehensive citizen profiles with:
  - Personal information (name, DOB, gender, address, phone)
  - Mugshot photos
  - Notes and tags
  - Complete history of interactions
- **Edit Records**: Update citizen information
- **File Attachments**: Add documents, photos, notes to citizen records

### 2. **Report System**
- **Report Types**:
  - Incident Reports
  - Arrest Reports
  - Citations
- **Report Features**:
  - Create detailed reports with title, location, description
  - Link reports to citizens and evidence
  - Add charges to reports
  - Edit existing reports
  - Delete reports (with proper permissions)
  - View report history

### 3. **Arrest Records**
- **Create Arrest Records**: Document arrests with:
  - Arresting officer
  - Location and date
  - Charges filed
  - Bail and fine amounts
  - Jail time sentenced
  - Notes
- **Track Convictions**: Record plea and conviction status
- **Arrest History**: View complete arrest history for any citizen

### 4. **Warrant Management**
- **Issue Warrants**: Create warrants with:
  - Warrant type (arrest, search, bench)
  - Charges
  - Bail amount
  - Description
- **Execute Warrants**: Mark warrants as served/executed
- **Cancel Warrants**: Cancel expired or invalid warrants
- **Active Warrant Tracking**: See all active warrants

### 5. **Wanted Posters**
- **Create Wanted Posters**: Generate official wanted posters with:
  - Citizen photo
  - Charges and description
  - Reward amount
  - Danger level (Low, Medium, High, Extreme)
  - Last known location
  - Physical description
  - Known associates
- **Wanted Board**: View all active wanted posters
- **Mark as Captured**: Update poster status when suspect is apprehended

### 6. **Case Management**
- **Create Cases**: Open investigation case files
- **Case Types**: Investigation, Criminal, Civil, Missing Person
- **Assign Officers**: Assign lead and supporting officers
- **Track Evidence**: Link evidence items to cases
- **Case Status**: Open, Active, Closed, Cold

### 7. **Vehicle Database**
- **Vehicle Lookup**: Search by license plate
- **Vehicle Registration**: Register vehicles with owner info
- **Registration Status**: Track valid, expired, suspended, revoked
- **Insurance Tracking**: Monitor insurance status
- **Flags and Notes**: Add alerts for stolen vehicles

### 8. **BOLO System**
- **Create BOLOs**: Be On the Lookout alerts for:
  - Persons
  - Vehicles
  - Items
- **BOLO Details**: Description, last seen location, danger level
- **Active BOLO List**: All officers see active BOLOs
- **Resolve BOLOs**: Mark as resolved when found

### 9. **Dashboard**
- Real-time statistics:
  - Active officers on duty
  - Current prisoners
  - Active warrants
  - Total bounties

## Commands

### Primary Commands
- `/mdt` - Open/close the MDT interface
- `/lookup [name]` - Quick citizen search
- `/platecheck [plate]` - Quick vehicle lookup

## Permissions

The MDT system uses a hierarchical permission system:

### Permission Levels
- `mdt_view` - View records and search (all officers)
- `mdt_edit` - Create and edit records (sergeants+)
- `mdt_delete` - Delete records (lieutenants+)
- `arrest` - Execute warrants and arrests (all officers)

## Database Schema

### New Tables Created
- `mdt_arrests` - Arrest records
- `mdt_wanted_posters` - Wanted posters
- `mdt_cases` - Investigation cases
- `mdt_vehicles` - Vehicle registry
- `mdt_bolos` - BOLO alerts
- `mdt_convictions` - Conviction records
- `mdt_citizen_files` - File attachments

### Enhanced Tables
- `mdt_reports` - Added title, location, charges fields
- `mdt_warrants` - Added warrant type, bail, execution tracking
- `mdt_citizens` - Added DOB, gender, address, phone, licenses

## Usage Examples

### Creating a Report
1. Open MDT with `/mdt`
2. Navigate to **Reports** tab
3. Click **New Report**
4. Fill in report details:
   - Select report type
   - Enter citizen ID
   - Add title and description
   - Specify location
   - List charges (if applicable)
5. Click **Create Report**

### Issuing a Warrant
1. Search for citizen in **Records** tab
2. Click on citizen to view profile
3. Click **Issue Warrant**
4. Fill in warrant details:
   - Select warrant type
   - List charges
   - Set bail amount
   - Add description
5. Click **Create Warrant**
6. All officers are notified

### Creating a Wanted Poster
1. Search for citizen
2. View citizen profile
3. Click **Wanted Poster**
4. Fill in poster details:
   - Title (e.g., "Armed Robbery Suspect")
   - Select danger level
   - Set reward amount
   - List charges
   - Add last known location
   - Physical description
5. Click **Create Poster**
6. Poster appears on Wanted Board

### Recording an Arrest
1. After arresting a suspect
2. Search for citizen
3. Click **Record Arrest**
4. Fill in arrest details:
   - Location of arrest
   - Charges
   - Bail/fine amounts
   - Jail time
   - Add notes
5. Click **Create Arrest Record**

## Server Events

### Client → Server
```lua
TriggerServerEvent('lxr-police:mdt:searchCitizens', {query = "name"})
TriggerServerEvent('lxr-police:mdt:getCitizenProfile', citizenId)
TriggerServerEvent('lxr-police:mdt:createReport', reportData)
TriggerServerEvent('lxr-police:mdt:createArrest', arrestData)
TriggerServerEvent('lxr-police:mdt:createWarrant', warrantData)
TriggerServerEvent('lxr-police:mdt:createWantedPoster', posterData)
```

### Server → Client
```lua
TriggerClientEvent('lxr-police:mdt:searchResults', src, results)
TriggerClientEvent('lxr-police:mdt:citizenProfile', src, profile)
TriggerClientEvent('lxr-police:mdt:reportList', src, reports)
```

## Exports

### Client Exports
```lua
-- Open MDT programmatically
exports['lxr-police']:OpenMDT()

-- Check if MDT is open
local isOpen = exports['lxr-police']:IsMDTOpen()
```

### Server Exports
```lua
-- Search for citizen
local citizens = exports['lxr-police']:SearchCitizen("John")

-- Get citizen by identifier
local citizen = exports['lxr-police']:GetCitizenByIdentifier("ABC123")
```

## Integration with Existing Systems

The enhanced MDT integrates seamlessly with existing systems:

- **Arrest System**: Arrests automatically create arrest records
- **Jail System**: Jail entries link to arrest records
- **Evidence System**: Evidence can be attached to reports and cases
- **Dispatch System**: BOLOs and warrants notify dispatch
- **Audit System**: All MDT actions are logged

## Configuration

Configuration options in `config.lua`:

```lua
Config.MDT = {
    EnableDashboard = true,
    EnableCitizenSearch = true,
    EnableReports = true,
    EnableWarrants = true,
    EnableWantedPosters = true,
    EnableVehicleDatabase = true,
    EnableBOLO = true,
    EnableCases = true,
    
    -- Permissions
    ViewPermission = "mdt_view",
    EditPermission = "mdt_edit",
    DeletePermission = "mdt_delete",
    
    -- Limits
    MaxSearchResults = 50,
    MaxReportsPerPage = 100,
}
```

## Best Practices

### For Officers
1. **Always create reports** for significant incidents
2. **Keep notes updated** on citizen profiles
3. **Link evidence** to reports when collecting
4. **Execute warrants promptly** and mark as executed
5. **Update BOLO status** when resolved

### For Supervisors
1. **Review reports regularly** for accuracy
2. **Audit warrant usage** to prevent abuse
3. **Monitor wanted poster creation**
4. **Ensure proper case assignment**

### For Admins
1. **Regular database backups** (important!)
2. **Monitor audit logs** for suspicious activity
3. **Train officers** on proper MDT usage
4. **Set appropriate permissions** by rank

## Troubleshooting

### MDT Won't Open
- Check if you have officer permissions
- Verify you're on duty
- Check browser console for errors (F8)

### Can't Create Records
- Verify you have `mdt_edit` permission
- Ensure citizen exists in database
- Check all required fields are filled

### Search Returns No Results
- Check spelling of search query
- Citizen may not exist in database yet
- Minimum 2 characters required for search

### Performance Issues
- Database may need indexes (run migration 013)
- Clear old records periodically
- Increase server resources if needed

## Security Considerations

- All MDT actions are logged in audit table
- Permission checks on every action
- Input validation prevents SQL injection
- Rate limiting prevents spam (recommended)
- Sensitive data should be restricted to supervisors

## Future Enhancements

Potential additions for future versions:
- Photo upload for mugshots
- Document scanning and attachment
- Report templates
- Advanced search filters
- Export to PDF
- Multi-language support
- Mobile/tablet responsive view
- Real-time updates with websockets

## Support

For issues or questions:
- Check this documentation first
- Review error logs in server console
- Check audit logs for permission issues
- Contact server admin or developer

## Version History

### v2.0.0 (Current)
- Complete MDT overhaul
- Added arrest records system
- Added wanted posters
- Added case management
- Added vehicle database
- Added BOLO system
- Enhanced UI with Western theme
- Comprehensive database schema

### v1.0.0
- Basic MDT functionality
- Citizen search
- Simple reports
- Warrant system

---

**The Land of Wolves RP - Law Enforcement System**  
*The World's Most Advanced & Authentic 1899 Wild West Law Enforcement System for RedM*

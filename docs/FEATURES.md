# 🎯 Complete Features List

## The Land of Wolves RP - Law Enforcement System

This document provides a comprehensive breakdown of every feature in the system.

---

## 📋 Table of Contents

1. [Law Enforcement Jobs](#law-enforcement-jobs)
2. [Arrest & Detention](#arrest--detention)
3. [Evidence System](#evidence-system)
4. [Jail & Prison](#jail--prison)
5. [Bounty System](#bounty-system)
6. [Posse System](#posse-system)
7. [Investigation](#investigation)
8. [Telegraph Dispatch](#telegraph-dispatch)
9. [Records & MDT](#records--mdt)
10. [Justice System](#justice-system)
11. [Property Management](#property-management)
12. [UI Features](#ui-features)

---

## 🏛️ Law Enforcement Jobs

### Sheriff's Office
**Historical Context**: County-level law enforcement, elected position

**Features**:
- 5 Ranks: Auxiliary Deputy → Deputy → Senior Deputy → Under-Sheriff → Sheriff
- County-wide jurisdiction
- Can deputize civilians
- Operates local jail
- Elected by citizens (can be RP element)
- Tax collection duties (optional RP)

**Loadout by Rank**:
- Rank 0: Cattleman Revolver, Carbine Repeater, Rope, Notebook
- Rank 1: Schofield Revolver, Carbine, Pump Shotgun, Lantern
- Rank 2: Schofield, Lancaster Repeater, Pump Shotgun, Binoculars
- Rank 3: Navy Revolver, Lancaster, Pump Shotgun, Springfield, Camera
- Rank 4: Navy Revolver, Evans Repeater, Pump Shotgun, Bolt-Action, Camera, Lockpick

**Vehicles**:
- Tennessee Walker horses
- Morgan horses
- Turkoman horses (higher ranks)
- Police wagons
- Prison wagons (Sheriff only)

---

### US Marshal Service
**Historical Context**: Federal law enforcement, presidential appointment

**Features**:
- 5 Ranks: Deputy Marshal → Field Marshal → Senior Marshal → Chief Marshal → US Marshal
- Territory-wide jurisdiction
- Federal crime pursuit
- Can cross county lines
- Higher authority than Sheriff
- Elite reputation

**Loadout by Rank**:
- Rank 0: Schofield Revolver, Carbine, Rope, Notebook, Lantern
- Rank 1: Navy Revolver, Lancaster, Pump Shotgun, Binoculars
- Rank 2: Navy, Lancaster, Pump Shotgun, Camera
- Rank 3: Navy, Evans Repeater, Pump Shotgun, Bolt-Action, Lockpick
- Rank 4: Navy, Evans, Repeating Shotgun, Bolt-Action, Rolling Block Sniper

**Vehicles**:
- Tennessee Walker, Turkoman
- Missouri Fox Trotter (higher ranks)
- Arabian horses (US Marshal)
- Armored wagons (Chief Marshal+)

---

### State Rangers
**Historical Context**: Elite state law enforcement, frontier protection

**Features**:
- 5 Ranks: Recruit → Ranger → Senior Ranger → Captain → Commander
- State-wide jurisdiction
- Wilderness operations
- Tracking expertise
- Military-style organization
- Legendary status

**Loadout by Rank**:
- Rank 0: Cattleman, Carbine, Rope, Compass
- Rank 1: Schofield, Lancaster, Bow, Compass, Binoculars, Lantern
- Rank 2: Navy, Lancaster, Springfield, Bow, Compass, Tent
- Rank 3: Navy, Evans, Bolt-Action, Bow, Camera, Tent
- Rank 4: Navy, Evans, Bolt-Action, Rolling Block, Hunting Kit

**Vehicles**:
- Tennessee Walker, Morgan
- Turkoman, Missouri Fox Trotter
- Arabian (Commander)
- Supply wagons

---

### Town Marshal
**Historical Context**: Municipal law enforcement, mayor-appointed

**Features**:
- 5 Ranks: Constable → Deputy → Town Marshal → Chief → Marshal
- Town jurisdiction only
- Local ordinances enforcement
- Town council reports
- Less prestigious than Sheriff
- Quick promotions possible

**Loadout by Rank**:
- Rank 0: Cattleman, Rope, Notebook
- Rank 1: Cattleman, Carbine, Rope, Bandages
- Rank 2: Schofield, Carbine, Double-Barrel Shotgun, Lantern
- Rank 3: Navy, Lancaster, Pump Shotgun, Binoculars
- Rank 4: Navy, Lancaster, Pump Shotgun, Springfield, Camera

**Vehicles**:
- Tennessee Walker
- Morgan (Deputy+)
- Turkoman (Town Marshal+)
- Arabian (Marshal)

---

## 🔗 Arrest & Detention

### Restraint System
**Feature**: Rope-based restraints (period-accurate, no handcuffs)

**Types**:
1. **Soft Cuff**: Restricts movement, can still walk
2. **Hard Cuff**: Complete arrest, frozen in place
3. **Hogtie**: Full restraint on ground

**Animations** (RedM-specific):
- `hogtie_on_ground` - Player hogtied
- `cuffed_idle` - Standing cuffed position
- `surrender` - Hands up surrender
- `grab_drag` - Being dragged by officer

**Commands**:
- `/cuff [id]` - Apply soft cuffs
- `/hardcuff [id]` - Full arrest
- `/uncuff [id]` - Remove restraints
- `/surrender` - Player surrenders

### Prisoner Transport
**Feature**: Move arrested suspects

**Methods**:
1. **Drag**: Officer drags cuffed player
2. **Horse**: Player on officer's horse
3. **Wagon**: Load into prison wagon
4. **Walk**: Escort while cuffed

**Animations**:
- Attach to officer entity
- Vehicle entry forced
- Cannot escape without breaking free

### Mugshot System
**Feature**: Period-accurate photography (1899 cameras)

**Process**:
1. Position player against wall
2. Officer uses camera item
3. Photo captured and stored
4. Added to citizen record
5. Used for wanted posters

**Technical**:
- Screenshot capture
- Base64 encoding
- Database storage
- Display in MDT

### Fingerprinting
**Feature**: New technology in 1899

**Process**:
1. Take player to fingerprint station
2. Progress bar (30 seconds)
3. Generate unique print ID
4. Store in database
5. Match against evidence

**Data Generated**:
- Fingerprint pattern (Whorl/Loop/Arch)
- Unique identifier
- Date collected
- Officer name

### DNA Collection
**Feature**: Basic forensics (bleeding-edge 1899 science)

**Process**:
1. Collect blood sample
2. Analysis time (60 seconds)
3. Generate DNA profile
4. Database entry
5. Evidence matching

**Profile Format**:
```
DNA-AB-CD-EF-12-34-56-78
```

### Property Seizure
**Feature**: Legal confiscation during arrest

**Seizeable Items**:
- Weapons
- Contraband
- Illegal items
- Cash (with limit)
- Evidence

**Process**:
1. Search command
2. Show inventory
3. Select items
4. Transfer to evidence
5. Receipt generated

**Requirements**:
- Player must be cuffed
- Officer rank 1+
- Logged in audit trail

---

## 🔍 Evidence System

### Collection Types

#### 1. Blood Samples
- **Expires**: 30 minutes
- **Weather affected**: Yes (rain washes away)
- **Collection time**: 5 seconds
- **Analysis**: DNA matching
- **Model**: `p_bloodsplat01x`

#### 2. Bullet Casings
- **Expires**: 1 hour
- **Weather affected**: No
- **Collection time**: 3 seconds
- **Analysis**: Ballistics matching
- **Model**: `w_pistol_cartridge01`

#### 3. Fingerprints
- **Expires**: 2 hours
- **Weather affected**: No
- **Collection time**: 8 seconds
- **Analysis**: Pattern matching
- **Quality**: 50-100%

#### 4. Footprints
- **Expires**: 15 minutes
- **Weather affected**: Yes
- **Collection time**: 5 seconds
- **Analysis**: Boot pattern, size
- **Tracking**: Can follow trail

#### 5. Weapon Evidence
- **Expires**: Never
- **Weather affected**: No
- **Collection time**: 4 seconds
- **Analysis**: Serial number, ballistics
- **Registration**: Check ownership

#### 6. Document Evidence
- **Expires**: Never
- **Weather affected**: Yes
- **Collection time**: 3 seconds
- **Analysis**: Handwriting, content
- **Authentication**: Verify signatures

### Crime Scene Management

**Crime Scene Tape**:
- Place with command `/crime-tape`
- Creates restricted zone (15m radius)
- Players cannot enter
- Lasts 30 minutes
- Remove with `/remove-tape`

**Evidence Markers**:
- Auto-placed when evidence created
- Visible only to law enforcement
- Yellow glowing markers
- Show evidence type on approach
- Collect with E key

**Photo Evidence**:
- Use camera item
- Captures scene
- Timestamped
- GPS coordinates
- Stored in evidence room

### Forensic Analysis

**DNA Analysis**:
1. Collect blood sample
2. Transport to lab
3. Analysis (30 seconds)
4. Generate profile
5. Search database
6. Match confidence %

**Ballistics Matching**:
1. Collect casing/bullet
2. Examine firing pin marks
3. Calculate caliber
4. Match against weapons
5. Link to registered guns

**Fingerprint Matching**:
1. Dust for prints
2. Lift print
3. Analyze pattern
4. Search database
5. Identify matches

### Chain of Custody

**Every evidence item tracks**:
- Collection officer
- Collection time
- Collection location
- Analysis officer
- Analysis time
- Transfer history
- Current location

**Evidence Transfer**:
```
Officer A → Evidence Room → Lab → Court
```

All transfers logged with:
- From officer
- To officer/location
- Reason for transfer
- Time and date
- Authorization

### Evidence Storage

**Evidence Room**:
- Secure storage lockers
- Access logged
- Grade 1+ required
- 100 item slots
- Weight limited

**Evidence Bags**:
- Item: `evidence_bag`
- Holds one piece of evidence
- Sealed with ID number
- Tamper-evident
- Court-admissible

---

## 🔒 Jail & Prison

### Facilities

#### Local Jails
- **Valentine Sheriff's Office**: 2 cells
- **Rhodes Sheriff's Office**: 1 cell
- **Strawberry Sheriff's Office**: 1 cell
- **Blackwater Marshal's Office**: 2 cells
- **Tumbleweed Sheriff's Office**: 1 cell
- **Annesburg Sheriff's Office**: 1 cell

**Local Jail Use**: Sentences under 10 minutes

#### Sisika Penitentiary
- **Capacity**: 5 cells
- **Type**: Territorial prison
- **Use**: Sentences 10+ minutes
- **Features**:
  - Chain gang work area
  - Workyard
  - Visitation room
  - Release point
  - Guard towers

### Sentencing

**Sentence Calculation**:
```lua
Total Time = Sum of all crime jail times
Total Fine = Sum of all crime fines
```

**Limits**:
- Minimum: 60 seconds
- Maximum: 3600 seconds (1 hour)
- Fine: Based on crimes

**Factors**:
- Crime severity
- Previous offenses
- Officer discretion
- Judge orders

### Parole System

**Eligibility**: 50% of sentence served

**Process**:
1. Serve 50% of time
2. Parole button appears
3. Pay parole fee (50% of fine)
4. Immediate release
5. Clean record notation

**Parole Fee Calculation**:
```
Parole Fee = Original Fine × 0.5
```

**Example**:
- Original: 10 minutes, $500 fine
- Parole at: 5 minutes
- Parole fee: $250

### Bail System

**Availability**: Not for capital crimes

**Bail Amount**:
```
Bail = Fine × 3
```

**Process**:
1. Pay bail (bank money)
2. Immediate release
3. Must report to court
4. Warrant if don't appear

**Restrictions**:
- Cannot bail for murder
- Cannot bail for horse theft
- Cannot bail if execution pending

### Chain Gang Labor

**Jobs Available**:
1. **Rock Breaking**: 15s work, -30s sentence
2. **Laundry Service**: 20s work, -45s sentence
3. **Kitchen Duty**: 25s work, -60s sentence
4. **Wood Chopping**: 18s work, -35s sentence
5. **Cleaning Cells**: 12s work, -25s sentence

**Process**:
1. Open prison jobs menu
2. Select job
3. Complete progress bar
4. Receive time reduction
5. Can repeat

**Animations**:
- Mining animation
- Washing animation
- Cooking animation
- Chopping animation
- Sweeping animation

### Visitation

**Rules**:
- Hours: 8 AM - 5 PM
- Duration: 5 minutes
- Distance: 5 meters max
- Supervised

**Process**:
1. Visitor requests visit
2. Prisoner accepts
3. Both tp to visitation
4. 5 minute timer
5. Auto-end

### Prison Escape

**Enabled**: Configurable

**Consequences**:
- Wanted level +5 stars
- Bounty +$500
- Alert all lawmen
- Track for 1000m

**Methods**:
- Lockpick cell (if obtained)
- Break window (loud)
- Tunnel dig (long time)
- Guard bribe (expensive)

---

## 💰 Bounty System

### Wanted Posters

**Creation**:
1. Officer uses `/bounty` command
2. Enter citizen ID
3. Set bounty amount ($50-$5000)
4. Select crimes
5. Add description
6. Generate poster

**Poster Information**:
- Name
- Mugshot (if available)
- Bounty amount
- Crimes list
- Last known location
- Distinguishing features
- "Dead or Alive" status

**Distribution**:
- Posted at all stations
- Posted at general stores
- Telegraph notification
- Newspaper mention

**Poster Boards**:
- Valentine Sheriff
- Rhodes Sheriff
- Strawberry Sheriff
- Blackwater Marshal
- Tumbleweed Sheriff
- Annesburg Sheriff
- General stores

### Bounty Hunters

**License**:
- Cost: $250
- Obtain at Sheriff
- Renewable yearly
- Required for claiming bounties

**Permissions**:
- View wanted posters
- Track bounties
- Capture suspects
- Claim rewards

**Restrictions**:
- Cannot enter private property
- Must present evidence
- Cannot kill unless resisting
- Subject to law if excessive force

### Bounty Capture

**Alive Capture**:
- Reward: 150% of bounty
- Hogtie suspect
- Deliver to any lawman
- Provide poster ID
- Collect reward

**Dead "Capture"**:
- Reward: 50% of bounty
- Must have poster
- Deliver body
- Explain circumstances
- Reduced reward

**Process**:
1. Locate wanted person
2. Attempt arrest
3. Subdue (alive preferred)
4. Transport to law enforcement
5. Present poster
6. Claim reward

### Bounty Tiers

**Petty Criminal** ($0-$100):
- Minor offenses
- White poster color
- Low priority

**Wanted** ($101-$300):
- Multiple offenses
- Gold poster color
- Medium priority

**Dangerous** ($301-$600):
- Serious crimes
- Orange poster color
- High priority

**Most Wanted** ($601-$1000):
- Very dangerous
- Red poster color
- Very high priority

**Dead or Alive** ($1000+):
- Capital crimes
- Dark red poster
- Maximum priority
- Shoot on sight authorized

### Bounty Decay

**System**: Bounties reduce over time

**Rate**: 10% per day

**Example**:
- Day 1: $1000
- Day 2: $900
- Day 3: $810
- Day 10: $349

**Purpose**: Encourages quick capture

---

## 👥 Posse System

### Formation

**Requirements**:
- Rank 2+ to form
- Law enforcement job
- Not already in posse

**Process**:
1. Use `/posse create [name]`
2. Posse formed
3. Can invite members
4. Max 8 members

### Invitations

**Invite Members**:
1. `/posse invite [id]`
2. Target receives invite
3. They accept/decline
4. Join posse

**Restrictions**:
- Must be law enforcement
- Or civilian deputy
- Not in another posse
- Posse not full

### Temporary Deputies

**Feature**: Deputize civilians

**Process**:
1. Sheriff/Marshal uses `/deputize [id]`
2. Civilian receives temp badge
3. Duration: 1 hour
4. Limited permissions
5. Auto-expires

**Permissions**:
- Can arrest
- Cannot access armory
- Cannot issue warrants
- Can respond to calls

### Posse Benefits

**Experience Bonus**: +25% XP

**Payment Bonus**: +15% salary

**Capture Bonus**: +20% bounty rewards

**Coordination**:
- Shared blips on map
- Shared waypoints
- Private radio channel
- Posse chat

### Posse Commands

- `/posse create [name]` - Form posse
- `/posse invite [id]` - Invite player
- `/posse kick [id]` - Remove member
- `/posse leave` - Leave posse
- `/posse disband` - Disband posse
- `/posse chat [msg]` - Posse chat

### Posse Chat

**Channel**: Private posse only

**Features**:
- Text chat
- Voice radio (if supported)
- Location sharing
- Waypoint sharing

**Command**:
```
/posse chat Need backup at Valentine!
```

---

## 📯 Telegraph Dispatch

### System Overview

**Historical Context**: Telegraph was the fastest communication in 1899

**Features**:
- Territory-wide alerts
- 30-second delivery delay (realistic)
- Priority system
- Officer status tracking

### Call Types

**10-Codes** (adapted for 1899):

| Code | Description | Priority | Color |
|------|-------------|----------|-------|
| 10-00 | Officer Needs Assistance | 1 | Red |
| 10-10 | Fight in Progress | 2 | Orange |
| 10-16 | Domestic Disturbance | 3 | Yellow |
| 10-31 | Breaking and Entering | 2 | Orange |
| 10-32 | Armed Robbery | 1 | Red |
| 10-50 | Horseback Chase | 2 | Orange |
| 10-55 | Intoxicated Person | 4 | Blue |
| 10-60 | Suspicious Activity | 3 | Yellow |
| 10-70 | Shots Fired | 1 | Red |
| 10-90 | Murder | 1 | Red |

### Sending Alerts

**Civilian Method**:
1. Go to telegraph office
2. Pay $5 fee
3. Write message
4. Select type
5. Send telegraph

**Officer Method**:
1. Use radio `/dispatch [message]`
2. Auto-includes location
3. Free for law enforcement
4. Instant to other officers

**Anonymous Reports**:
- Don't include name
- Don't show exact location
- Lower priority
- Can be false

### Responding

**Officer Response**:
1. Receive telegraph alert
2. View on dispatch board
3. `/respond [dispatch-id]`
4. Navigate to location
5. Handle situation
6. `/complete [dispatch-id]`

**Tracking**:
- Who's responding
- ETA estimates
- Status updates
- Completion

### Backup Requests

**Emergency Backup**:
1. Officer in danger
2. Presses emergency button (`K` key)
3. Priority 1 alert sent
4. All officers notified
5. Location marked
6. Nearest responds

**Message**:
```
[EMERGENCY]
Officer [name] needs assistance!
Location: Valentine Main Street
RESPOND IMMEDIATELY
```

### Telegraph Offices

**Locations**:
- Each sheriff station
- General stores
- Train stations
- Post offices

**Operating Hours**:
- 24/7 for law enforcement
- 6 AM - 10 PM for civilians

---

## 📖 Records & MDT

### Mobile Data Terminal

**Access**:
- Command: `/mdt`
- Or interaction at station
- Officers only
- On-duty required

### Citizen Records

**Search**:
- By name
- By identifier
- By description
- Fuzzy matching

**Profile Contains**:
- Full name
- Date of birth
- Physical description
- Mugshot
- Address
- Occupation
- Known associates
- Criminal history
- Active warrants
- Parole status

**History Types**:
- Arrests
- Citations
- Incidents
- Warrants
- Court appearances
- Sentences served

### Report Writing

**Report Types**:
1. **Incident Report**: General incidents
2. **Arrest Report**: Arrests made
3. **Investigation Report**: Active investigations
4. **Citation**: Traffic/minor violations
5. **Property Report**: Seizures
6. **Witness Statement**: Interview notes

**Report Template**:
```
INCIDENT REPORT

Report #: IR-000123
Date: 1899-03-15
Time: 14:30
Location: Valentine Main Street
Officer: Deputy John Smith

NARRATIVE:
[Detailed description]

SUSPECTS:
[List of suspects]

EVIDENCE:
[Evidence collected]

DISPOSITION:
[Resolution]

Submitted: Deputy John Smith
Reviewed: Sheriff William Roberts
```

### Warrant System

**Warrant Types**:
1. **Arrest Warrant**: Authorized arrest
2. **Search Warrant**: Property search
3. **Seizure Warrant**: Property confiscation

**Issuance**:
- Rank 2+ required
- Must have probable cause
- Enter details
- Judge approval (optional config)
- Active immediately

**Execution**:
- View active warrants
- Select warrant
- Execute on sight
- Update status
- Court notification

### BOLO System

**Be On the Lookout**

**Types**:
- Person BOLO
- Vehicle (horse/wagon) BOLO
- Property BOLO

**Information**:
- Description
- Last seen location
- Reason (crime)
- Approach instructions
- Priority level

**Distribution**:
- All law enforcement
- Can be territorial
- Can be national

---

## ⚖️ Justice System

### Court System

**Roles**:
- Judge (player or NPC)
- Prosecutor (Marshal/Sheriff)
- Defense (Lawyer player or NPC)
- Jury (optional, players)
- Bailiff (Deputy)

**Process**:
1. Arraignment
2. Plea
3. Trial (if not guilty plea)
4. Verdict
5. Sentencing

### Public Trials

**Location**: Town hall or courthouse

**Spectators**: Allowed

**Duration**: 15-30 minutes

**Outcome**:
- Guilty: Sentence
- Not guilty: Release
- Hung jury: Retrial

### Public Executions

**For**: Capital crimes only

**Types**:
1. **Hanging**: Most common
2. **Firing Squad**: Military/federal crimes

**Procedure**:
1. Sentencing by judge
2. 10-minute notice period
3. Last words (1 minute)
4. Execution
5. Body to undertaker

**Locations**:
- Valentine gallows
- Blackwater gallows
- Tumbleweed gallows
- Sisika prison yard

**Spectators**: Encouraged (public deterrent)

**Appeals**:
- Can appeal within 5 minutes
- Costs $500
- Judge reviews
- Can grant stay

---

## 🐴 Property Management

### Horse Impound

**Reasons**:
- Stolen horse
- Abandoned horse
- Court order
- Unpaid fines

**Process**:
1. Locate horse
2. Use `/impound-horse`
3. Horse teleported to impound
4. Owner notified
5. Can retrieve for $50

**Impound Lots**:
- Valentine stable
- Rhodes stable
- Strawberry stable
- Blackwater stable
- Tumbleweed stable
- Annesburg stable

**Duration**: 24 hours, then sold

### Wagon Impound

**Process**: Same as horse

**Cost**: $100 to retrieve

**Storage**: Wagon yards at stations

### Evidence Storage

**Secure Rooms**:
- Each station has evidence room
- Requires keycard/key
- Access logged
- Climate controlled (RP)

**Organization**:
- By case number
- By type
- By date
- Alphabetical

**Retrieval**:
- Log what was accessed
- Log why
- Log who
- Log when

---

## 🎨 UI Features

### Dashboard

**Displays**:
- Active officers count
- Prisoners count
- Active warrants
- Total bounties
- Recent activity feed
- Active calls list

**Real-time Updates**: Yes

### Records Ledger

**Features**:
- Search citizens
- View profiles
- See criminal history
- Check warrants
- View reports

**Design**: Aged paper, handwritten font

### Wanted Board

**Features**:
- Grid of posters
- Filter by bounty
- Filter by location
- Click to view details
- Print poster

**Design**: Cork board with pinned posters

### Evidence Room

**Features**:
- List all evidence
- Filter by type
- Filter by case
- View chain of custody
- Request analysis

**Design**: Filing cabinet style

### Telegraph Dispatch

**Features**:
- Active calls list
- Officer status board
- Send telegraph
- Respond to calls
- Complete calls

**Design**: Telegraph office theme

### Officer Roster

**Features**:
- All officers list
- Filter by department
- Filter by status
- View details
- Send message

**Design**: Military roster style

---

## 🎮 Commands Reference

### Player Commands
- `/surrender` - Surrender to law enforcement
- `/911 [message]` - Call for help

### Officer Commands
- `/duty` - Toggle on/off duty
- `/cuff [id]` - Cuff player
- `/uncuff [id]` - Uncuff player
- `/drag [id]` - Drag player
- `/search [id]` - Search player
- `/jail [id] [time]` - Send to jail
- `/unjail [id]` - Release from jail
- `/mdt` - Open MDT
- `/dispatch [msg]` - Send dispatch
- `/warrant [id]` - Issue warrant
- `/bounty [id] [amount]` - Place bounty
- `/posse [action]` - Manage posse
- `/evidence [action]` - Handle evidence
- `/impound-horse` - Impound horse
- `/impound-wagon` - Impound wagon

### Admin Commands
- `/setlaw [id] [job] [rank]` - Set law job
- `/clearwarrants [id]` - Clear warrants
- `/clearbounty [id]` - Clear bounty
- `/lawgod` - Invincible mode

---

**This document is comprehensive but may be updated as new features are added.**

**Last Updated**: December 11, 2024  
**Version**: 1.0.0  
**System**: The Land of Wolves RP - Law Enforcement System

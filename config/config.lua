--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝
    ██████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

    🐺 LXR Core - Police System  ·  Supreme Configuration
    ═══════════════════════════════════════════════════════════════
    Single source of truth for the entire police system.
    All settings, systems, items, statutes, and K9 live here.
    ═══════════════════════════════════════════════════════════════

    Server:    The Land of Wolves 🐺
    Tagline:   Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Type:      Serious Hardcore Roleplay  ·  Discord & Whitelisted

    Developer: iBoss21 / The Lux Empire
    Website:   https://www.wolves.land
    Discord:   https://discord.gg/CrKcWdfd3A
    GitHub:    https://github.com/iBoss21
    Store:     https://theluxempire.tebex.io

    Version:   1.0.0
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ─────────────────────────────────────────────────────────────
-- RESOURCE-NAME PROTECTION
-- ─────────────────────────────────────────────────────────────
local REQUIRED_RESOURCE_NAME <const> = 'lxr-police'
local currentResourceName = GetCurrentResourceName()
if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format(
        '\n[lxr-police] Resource must be named "%s" — found "%s". Rename the folder and restart.',
        REQUIRED_RESOURCE_NAME, currentResourceName
    ))
end

-- ─────────────────────────────────────────────────────────────
-- ROOT TABLE
-- ─────────────────────────────────────────────────────────────
Config = Config or {}

-- ══════════════════════════════════════════════════════════════
-- § 1  SERVER & FRAMEWORK
-- ══════════════════════════════════════════════════════════════

Config.Framework  = "auto"       -- "lxrcore" | "rsgcore" | "vorp" | "auto"
Config.UseTarget  = true         -- Use targeting system (rsg-target / ox_target)
Config.Debug      = false        -- Master debug toggle

Config.ServerInfo = {
    name        = 'The Land of Wolves 🐺',
    tagline     = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!',
    type        = 'Serious Hardcore Roleplay',
    website     = 'https://www.wolves.land',
    discord     = 'https://discord.gg/CrKcWdfd3A',
    github      = 'https://github.com/iBoss21',
    store       = 'https://theluxempire.tebex.io',
    listing     = 'https://servers.redm.net/servers/detail/8gj7eb',
    developer   = 'iBoss21 / The Lux Empire',
    version     = '1.0.0',
}

-- Framework per-resource settings (used by shared/bridge.lua)
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource = 'lxr-core', notifications = 'ox_lib', inventory = 'lxr-inventory', target = 'ox_target',
        events = { server = 'lxr-core:server:%s', client = 'lxr-core:client:%s', callback = 'lxr-core:callback:%s' },
    },
    ['rsg-core'] = {
        resource = 'rsg-core', notifications = 'ox_lib', inventory = 'rsg-inventory', target = 'ox_target',
        events = { server = 'RSGCore:Server:%s', client = 'RSGCore:Client:%s', callback = 'RSGCore:Callback:%s' },
    },
    ['vorp_core'] = {
        resource = 'vorp_core', notifications = 'vorp', inventory = 'vorp_inventory', target = 'vorp_core',
        events = { server = 'vorp:server:%s', client = 'vorp:client:%s' },
    },
    ['standalone'] = { notifications = 'print', inventory = 'none', target = 'none' },
}

-- ══════════════════════════════════════════════════════════════
-- § 2  LAW ENFORCEMENT JOBS (1899 Period-Accurate)
-- ══════════════════════════════════════════════════════════════

Config.LawJobs = {
    ["sheriff"] = {
        label = "Sheriff's Office", type = "local", jurisdiction = "county",
        ranks = { [0]="Auxiliary Deputy",[1]="Deputy Sheriff",[2]="Senior Deputy",[3]="Under-Sheriff",[4]="Sheriff" },
    },
    ["marshal"] = {
        label = "US Marshal Service", type = "federal", jurisdiction = "territory",
        ranks = { [0]="Deputy Marshal",[1]="Field Marshal",[2]="Senior Marshal",[3]="Chief Marshal",[4]="US Marshal" },
    },
    ["ranger"] = {
        label = "State Rangers", type = "state", jurisdiction = "state",
        ranks = { [0]="Ranger Recruit",[1]="Ranger",[2]="Senior Ranger",[3]="Ranger Captain",[4]="Ranger Commander" },
    },
    ["lawman"] = {
        label = "Town Marshal", type = "municipal", jurisdiction = "town",
        ranks = { [0]="Constable",[1]="Deputy Marshal",[2]="Town Marshal",[3]="Chief Marshal",[4]="Marshal" },
    },
}

-- ══════════════════════════════════════════════════════════════
-- § 3  STATIONS & LOCATIONS
-- ══════════════════════════════════════════════════════════════

Config.Stations = {
    ["valentine"] = {
        label = "Valentine Sheriff's Office", type = "sheriff",
        coords = vec3(-275.5, 804.0, 119.0),
        cells = { vec3(-272.4, 812.1, 118.4), vec3(-276.8, 812.1, 118.4) },
        recordsOffice = vec3(-280.0, 808.0, 119.5), armory = vec3(-278.0, 803.0, 119.5),
        stables = vec3(-282.0, 800.0, 119.5), gallows = vec3(-270.0, 820.0, 118.0),
        telegraph = vec3(-281.0, 805.0, 119.5), wantedBoard = vec3(-279.0, 807.0, 119.5),
    },
    ["rhodes"] = {
        label = "Rhodes Sheriff's Office", type = "sheriff",
        coords = vec3(1360.5, -1301.0, 77.0),
        cells = { vec3(1363.0, -1298.0, 77.0) },
        recordsOffice = vec3(1358.0, -1303.0, 77.0), armory = vec3(1362.0, -1305.0, 77.0),
        stables = vec3(1370.0, -1310.0, 76.5), telegraph = vec3(1359.0, -1302.0, 77.0),
        wantedBoard = vec3(1361.0, -1300.0, 77.0),
    },
    ["strawberry"] = {
        label = "Strawberry Sheriff's Office", type = "sheriff",
        coords = vec3(-1810.0, -354.0, 164.0),
        cells = { vec3(-1812.0, -351.0, 164.0) },
        recordsOffice = vec3(-1808.0, -356.0, 164.0), armory = vec3(-1813.0, -355.0, 164.0),
        stables = vec3(-1820.0, -360.0, 163.5), telegraph = vec3(-1809.0, -355.0, 164.0),
        wantedBoard = vec3(-1811.0, -353.0, 164.0),
    },
    ["blackwater"] = {
        label = "Blackwater Marshal's Office", type = "marshal",
        coords = vec3(-761.0, -1268.0, 44.0),
        cells = { vec3(-758.0, -1265.0, 44.0), vec3(-764.0, -1265.0, 44.0) },
        recordsOffice = vec3(-763.0, -1270.0, 44.0), armory = vec3(-759.0, -1272.0, 44.0),
        stables = vec3(-770.0, -1275.0, 43.5), telegraph = vec3(-762.0, -1269.0, 44.0),
        wantedBoard = vec3(-760.0, -1267.0, 44.0),
    },
    ["tumbleweed"] = {
        label = "Tumbleweed Sheriff's Office", type = "sheriff",
        coords = vec3(-5527.0, -2950.0, -2.0),
        cells = { vec3(-5524.0, -2948.0, -2.0) },
        recordsOffice = vec3(-5529.0, -2952.0, -2.0), armory = vec3(-5525.0, -2954.0, -2.0),
        stables = vec3(-5535.0, -2960.0, -2.5), telegraph = vec3(-5528.0, -2951.0, -2.0),
        wantedBoard = vec3(-5526.0, -2949.0, -2.0),
    },
    ["annesburg"] = {
        label = "Annesburg Sheriff's Office", type = "sheriff",
        coords = vec3(2906.0, 1308.0, 45.0),
        cells = { vec3(2908.0, 1310.0, 45.0) },
        recordsOffice = vec3(2904.0, 1306.0, 45.0), armory = vec3(2909.0, 1307.0, 45.0),
        stables = vec3(2915.0, 1300.0, 44.5), telegraph = vec3(2905.0, 1307.0, 45.0),
        wantedBoard = vec3(2907.0, 1309.0, 45.0),
    },
    ["sisika"] = {
        label = "Sisika Penitentiary", type = "prison",
        coords = vec3(3328.0, -670.0, 45.0),
        cells = {
            vec3(3330.0, -668.0, 45.0), vec3(3332.0, -668.0, 45.0),
            vec3(3334.0, -668.0, 45.0), vec3(3336.0, -668.0, 45.0), vec3(3338.0, -668.0, 45.0),
        },
        chainGangArea = vec3(3340.0, -680.0, 45.0), workyard = vec3(3345.0, -675.0, 45.0),
        releasePoint = vec3(3325.0, -665.0, 45.0),
    },
}

-- ══════════════════════════════════════════════════════════════
-- § 4  JAIL & PRISON
-- ══════════════════════════════════════════════════════════════

Config.Jail = {
    MinimumSentence    = 60,
    MaximumSentence    = 3600,
    ParoleEligibility  = 0.5,   -- 50 % of sentence
    ChainGangReduction = 30,    -- Seconds per job completed
    BailMultiplier     = 3,     -- Bail = 3× fine
    PrisonLocation     = "sisika",
    LocalJailThreshold = 600,   -- Under 10 min → local jail
}

-- ══════════════════════════════════════════════════════════════
-- § 5  DUTY SYSTEM
-- ══════════════════════════════════════════════════════════════

Config.Duty = {
    RequireOnDutyForMDT      = true,
    RequireOnDutyForArrest   = true,
    RequireOnDutyForWeapons  = true,
    RequireOnDutyForVehicles = true,
    RequireUniformOnDuty     = true,
    AutoChangeUniform        = true,
    AFKTimeoutMinutes        = 15,
    AFKWarningMinutes        = 12,
    AFKCheckInterval         = 60,
    TrackDutyTime            = true,
    PayrollInterval          = 3600, -- Seconds between pay
    PayrollDatabase          = true,
}

-- ══════════════════════════════════════════════════════════════
-- § 6  STATUTES & SENTENCING  (used as global `Statutes`)
-- ══════════════════════════════════════════════════════════════

Statutes = {
    -- ─── MISDEMEANORS ───────────────────────────────────────
    ["DISORDERLY_CONDUCT"]   = { label="Disorderly Conduct",             category="Misdemeanor", severity=1, fine_min=10,  fine_max=50,   jail_min=0,   jail_max=5,   bail_eligible=true  },
    ["PUBLIC_INTOXICATION"]  = { label="Public Intoxication",            category="Misdemeanor", severity=1, fine_min=15,  fine_max=30,   jail_min=0,   jail_max=3,   bail_eligible=true  },
    ["TRESPASSING"]          = { label="Trespassing",                    category="Misdemeanor", severity=2, fine_min=25,  fine_max=75,   jail_min=0,   jail_max=10,  bail_eligible=true  },
    ["VAGRANCY"]             = { label="Vagrancy",                       category="Misdemeanor", severity=1, fine_min=5,   fine_max=20,   jail_min=0,   jail_max=5,   bail_eligible=true  },
    ["BRANDISHING"]          = { label="Brandishing a Weapon",           category="Misdemeanor", severity=2, fine_min=25,  fine_max=75,   jail_min=5,   jail_max=15,  bail_eligible=true  },
    ["ILLEGAL_DISCHARGE"]    = { label="Illegal Discharge of Firearm",   category="Misdemeanor", severity=3, fine_min=50,  fine_max=100,  jail_min=10,  jail_max=20,  bail_eligible=true  },
    ["VANDALISM"]            = { label="Vandalism",                      category="Misdemeanor", severity=2, fine_min=25,  fine_max=100,  jail_min=5,   jail_max=15,  bail_eligible=true  },
    ["MOONSHINING"]          = { label="Moonshining",                    category="Misdemeanor", severity=2, fine_min=50,  fine_max=150,  jail_min=5,   jail_max=20,  bail_eligible=true,  contraband=true },
    ["RESISTING_ARREST"]     = { label="Resisting Arrest",               category="Misdemeanor", severity=3, fine_min=50,  fine_max=100,  jail_min=10,  jail_max=20,  bail_eligible=true  },
    -- ─── FELONIES ────────────────────────────────────────────
    ["HORSE_THEFT"]          = { label="Horse Theft",                    category="Felony",      severity=4, fine_min=150, fine_max=300,  jail_min=15,  jail_max=30,  bail_eligible=true,  contraband=true },
    ["CATTLE_RUSTLING"]      = { label="Cattle Rustling",                category="Felony",      severity=4, fine_min=200, fine_max=500,  jail_min=20,  jail_max=45,  bail_eligible=true,  contraband=true },
    ["ROBBERY"]              = { label="Robbery",                        category="Felony",      severity=4, fine_min=100, fine_max=300,  jail_min=15,  jail_max=40,  bail_eligible=true  },
    ["BANK_ROBBERY"]         = { label="Bank Robbery",                   category="Felony",      severity=5, fine_min=500, fine_max=1000, jail_min=45,  jail_max=90,  bail_eligible=false, contraband=true },
    ["TRAIN_ROBBERY"]        = { label="Train Robbery",                  category="Federal",     severity=5, fine_min=750, fine_max=1500, jail_min=60,  jail_max=120, bail_eligible=false, contraband=true },
    ["ASSAULT"]              = { label="Assault",                        category="Felony",      severity=3, fine_min=50,  fine_max=150,  jail_min=10,  jail_max=25,  bail_eligible=true  },
    ["ASSAULT_PEACE_OFFICER"]= { label="Assault on Peace Officer",       category="Felony",      severity=4, fine_min=150, fine_max=400,  jail_min=30,  jail_max=60,  bail_eligible=true  },
    ["ATTEMPTED_MURDER"]     = { label="Attempted Murder",               category="Felony",      severity=5, fine_min=400, fine_max=800,  jail_min=60,  jail_max=120, bail_eligible=false },
    ["BURGLARY"]             = { label="Burglary",                       category="Felony",      severity=4, fine_min=100, fine_max=250,  jail_min=20,  jail_max=40,  bail_eligible=true,  contraband=true },
    ["ARSON"]                = { label="Arson",                          category="Felony",      severity=5, fine_min=300, fine_max=750,  jail_min=40,  jail_max=80,  bail_eligible=false },
    ["FRAUD"]                = { label="Fraud",                          category="Felony",      severity=3, fine_min=100, fine_max=500,  jail_min=15,  jail_max=35,  bail_eligible=true  },
    ["EVADING"]              = { label="Evading Law Enforcement",        category="Felony",      severity=3, fine_min=75,  fine_max=200,  jail_min=15,  jail_max=30,  bail_eligible=true  },
    ["ESCAPE"]               = { label="Escape from Custody",            category="Felony",      severity=4, fine_min=200, fine_max=400,  jail_min=30,  jail_max=60,  bail_eligible=false },
    ["BRIBERY"]              = { label="Bribery",                        category="Felony",      severity=4, fine_min=200, fine_max=500,  jail_min=25,  jail_max=50,  bail_eligible=true  },
    ["CLAIM_JUMPING"]        = { label="Claim Jumping",                  category="Felony",      severity=4, fine_min=150, fine_max=400,  jail_min=20,  jail_max=45,  bail_eligible=true  },
    -- ─── FEDERAL / CAPITAL ───────────────────────────────────
    ["COUNTERFEITING"]       = { label="Counterfeiting",                 category="Federal",     severity=5, fine_min=500, fine_max=1000, jail_min=60,  jail_max=120, bail_eligible=false, contraband=true },
    ["MURDER"]               = { label="Murder",                         category="Capital",     severity=5, fine_min=0,   fine_max=0,    jail_min=180, jail_max=999, bail_eligible=false, execution_eligible=true  },
    ["MURDER_PEACE_OFFICER"] = { label="Murder of Peace Officer",        category="Capital",     severity=5, fine_min=0,   fine_max=0,    jail_min=999, jail_max=999, bail_eligible=false, execution_eligible=true, mandatory_execution=true },
    ["TREASON"]              = { label="Treason",                        category="Capital",     severity=5, fine_min=0,   fine_max=0,    jail_min=999, jail_max=999, bail_eligible=false, execution_eligible=true, mandatory_execution=true },
}

-- Sentence calculator (charge-stacking with diminishing multiplier)
local _STACKING_MULT  = 0.75
local _BAIL_MULT      = 5.0

function CalculateSentence(charges)
    if not charges or #charges == 0 then
        return { total_time=0, total_fine=0, bail_amount=0, bail_eligible=true, execution=false }
    end
    local ch        = Config.LEOCore and Config.LEOCore.Charges
    local stackMult = (ch and ch.StackingMultiplier)  or _STACKING_MULT
    local bailMult  = (ch and ch.BailMultiplier)      or _BAIL_MULT
    local doStack   = ch and ch.AllowChargeStacking
    local bailOn    = ch and ch.BailEnabled

    local total_time, total_fine, bail_eligible, execution, highest = 0, 0, true, false, 0
    for i, code in ipairs(charges) do
        local s = Statutes[code]
        if s then
            local m = (i > 1 and doStack) and stackMult or 1.0
            total_time = total_time + ((s.jail_min + s.jail_max) / 2) * m
            total_fine = total_fine + (s.fine_min + s.fine_max) / 2
            if not s.bail_eligible               then bail_eligible = false end
            if s.execution_eligible              then execution = s.mandatory_execution or false end
            if s.severity > highest              then highest = s.severity end
        end
    end
    local bail = (bail_eligible and bailOn) and (total_fine * bailMult) or 0
    return {
        total_time   = math.floor(total_time),
        total_fine   = math.floor(total_fine),
        bail_amount  = math.floor(bail),
        bail_eligible = bail_eligible,
        execution    = execution,
        severity     = highest,
        charge_count = #charges,
    }
end

-- ══════════════════════════════════════════════════════════════
-- § 7  WARRANTS
-- ══════════════════════════════════════════════════════════════

Config.Warrants = {
    RequireSupervisorApproval = true,
    MinApprovalRank           = 3,
    RequireProbableCause      = true,
    MinCauseLength            = 50,
    Types = {
        ["arrest"] = { label="Arrest Warrant",  requireApproval=true,  expiryDays=30  },
        ["search"] = { label="Search Warrant",  requireApproval=true,  expiryDays=7, requireLocation=true },
        ["bench"]  = { label="Bench Warrant",   requireApproval=false, expiryDays=90  },
    },
    NotifyOnline = true,
    NotifyDelay  = 300,
}

-- ══════════════════════════════════════════════════════════════
-- § 8  BOUNTY SYSTEM
-- ══════════════════════════════════════════════════════════════

Config.Bounty = {
    Enabled              = true,
    AllowBountyHunters   = true,
    BountyHunterJob      = "bountyhunter",
    BountyHunterLicense  = "bounty_license",
    LicenseCost          = 250,
    MinimumBounty        = 50,
    MaximumBounty        = 5000,
    BountyDecayEnabled   = true,
    BountyDecayRate      = 0.10,   -- 10 % per day
    BountyDecayInterval  = 86400,
    WantedPosterEnabled  = true,
    WantedPosterCost     = 25,
    WantedPosterLocations = {
        vec3(-275.0, 807.0, 119.5), vec3(1361.0, -1300.0, 77.0),
        vec3(-1811.0, -353.0, 164.0), vec3(-760.0, -1267.0, 44.0),
        vec3(-5526.0, -2949.0, -2.0), vec3(2907.0, 1309.0, 45.0),
    },
    CaptureAliveBonus    = 1.5,
    CaptureDeadPenalty   = 0.5,
    Tiers = {
        { min=0,    max=100,   label="Petty Criminal", color="#FFFFFF" },
        { min=101,  max=300,   label="Wanted",         color="#FFD700" },
        { min=301,  max=600,   label="Dangerous",      color="#FFA500" },
        { min=601,  max=1000,  label="Most Wanted",    color="#FF4500" },
        { min=1001, max=99999, label="Dead or Alive",  color="#DC143C" },
    },
}

-- ══════════════════════════════════════════════════════════════
-- § 9  POSSE SYSTEM
-- ══════════════════════════════════════════════════════════════

Config.Posse = {
    Enabled              = true,
    MaxPosseSize         = 8,
    MinRankToForm        = 2,
    PosseFormationTime   = 5000,
    AllowTempDeputies    = true,
    TempDeputyDuration   = 3600,
    TempDeputyBadge      = "temp_deputy_badge",
    SharedBlips          = true,
    SharedWaypoints      = true,
    PosseChat            = true,
    PosseRadioChannel    = "law_radio",
    ExperienceBonus      = 0.25,
    PaymentBonus         = 0.15,
    CaptureBonus         = 0.20,
}

-- ══════════════════════════════════════════════════════════════
-- § 10  DISPATCH & COMMUNICATION
-- ══════════════════════════════════════════════════════════════

Config.Dispatch = {
    Enabled  = true,
    Methods  = {
        telegraph    = { enabled=true, range=9999, delay=30 },
        messenger    = { enabled=true, range=1000, delay=60 },
        bell         = { enabled=true, range=500,  delay=5  },
        signal_fire  = { enabled=true, range=2000, delay=10 },
        whistle      = { enabled=true, range=200,  delay=2  },
    },
    CallTypes = {
        { code="10-00", label="Officer Needs Assistance",  priority=1, color="red"    },
        { code="10-10", label="Fight in Progress",          priority=2, color="orange" },
        { code="10-16", label="Domestic Disturbance",       priority=3, color="yellow" },
        { code="10-31", label="Breaking and Entering",      priority=2, color="orange" },
        { code="10-32", label="Armed Robbery",              priority=1, color="red"    },
        { code="10-50", label="Horseback Chase",            priority=2, color="orange" },
        { code="10-55", label="Intoxicated Person",         priority=4, color="blue"   },
        { code="10-60", label="Suspicious Activity",        priority=3, color="yellow" },
        { code="10-70", label="Shots Fired",                priority=1, color="red"    },
        { code="10-90", label="Murder",                     priority=1, color="red"    },
    },
    AutoAssignNearest       = true,
    ShowBlipOnMap           = true,
    BlipDuration            = 300,
    NotifyAllOfficers       = true,
    RequireResponse         = true,
    ResponseTimeout         = 180,
    AllowCivilianReports    = true,
    CivilianReportMethod    = "telegraph",
    AnonymousReports        = true,
    FalseReportPenalty      = { fine=25, jailTime=60 },
}

-- ══════════════════════════════════════════════════════════════
-- § 11  INVESTIGATION & EVIDENCE
-- ══════════════════════════════════════════════════════════════

Config.Investigation = {
    Enabled      = true,
    EvidenceTypes = {
        blood       = { label="Blood Sample",    collectTime=5000, expireTime=1800, weatherAffected=true  },
        casing      = { label="Bullet Casing",   collectTime=3000, expireTime=3600, weatherAffected=false },
        footprint   = { label="Footprint",       collectTime=5000, expireTime=900,  weatherAffected=true  },
        fingerprint = { label="Fingerprint",     collectTime=8000, expireTime=7200, weatherAffected=false },
        weapon      = { label="Weapon Evidence", collectTime=4000, expireTime=9999999, weatherAffected=false },
    },
    CrimeSceneTape          = true,
    TapeModel               = `p_rope01x`,
    TapeDistance            = 15.0,
    ProtectedZoneDuration   = 1800,
    TrackingEnabled         = true,
    TrackingDistance        = 500,
    TrackingDuration        = 600,
    TrackTypes              = { footprints=true, hoofprints=true, bloodtrail=true, vehicle_tracks=true },
    ForensicsLabRequired    = true,
    ForensicsTime           = 30000,
    WitnessEnabled          = true,
    WitnessMemoryDuration   = 1800,
    WitnessReliability      = 0.7,
    InterrogationTime       = 60000,
}

-- ══════════════════════════════════════════════════════════════
-- § 12  EXECUTION SYSTEM
-- ══════════════════════════════════════════════════════════════

Config.Execution = {
    Enabled          = true,
    Types = {
        hanging = {
            enabled=true, label="Hanging", requiredCrime="capital", animation="mech_hanging",
            locations = {
                vec3(-270.0, 820.0, 118.0),    -- Valentine
                vec3(-760.0, -1265.0, 44.0),   -- Blackwater
                vec3(-5525.0, -2948.0, -2.0),  -- Tumbleweed
            },
        },
        firing_squad = { enabled=false, label="Firing Squad", requiredCrime="capital", animation="execution_shot",
            locations = { vec3(3330.0, -675.0, 45.0) },
        },
    },
    PublicExecution  = true,
    RequireJudgeApproval = true,
    JudgeJobs        = { "judge", "magistrate" },
    NoticeTime       = 600,
    AllowLastWords   = true,
    LastWordsDuration = 60,
    AllowSpectators  = true,
    SpectatorRadius  = 50.0,
    NotifyTerritory  = true,
    AllowAppeal      = true,
    AppealTimeLimit  = 300,
    AppealCost       = 500,
}

-- ══════════════════════════════════════════════════════════════
-- § 13  PROPERTY SEIZURE & IMPOUND
-- ══════════════════════════════════════════════════════════════

Config.Seizure = {
    Enabled = true,
    HorseImpound = {
        enabled=true, cost=50, duration=86400,
        locations = {
            vec3(-282.0, 800.0, 119.5), vec3(1370.0, -1310.0, 76.5),
            vec3(-1820.0, -360.0, 163.5), vec3(-770.0, -1275.0, 43.5),
        },
    },
    WagonImpound = {
        enabled=true, cost=100, duration=86400,
        locations = { vec3(-280.0, 798.0, 119.0), vec3(1368.0, -1308.0, 76.5) },
    },
    PropertySeizure = {
        enabled=true, requiredRank=2, requiresWarrant=true,
        items_seizable = { "weapon_*", "lockpick", "illegal_*", "contraband_*" },
        money_seizable=true, max_cash_seizure=1000,
    },
}

-- ══════════════════════════════════════════════════════════════
-- § 14  ITEMS & EQUIPMENT
-- ══════════════════════════════════════════════════════════════

Config.Items = {
    -- Core law enforcement items
    Badge          = "lawman_badge",
    TempBadge      = "temp_deputy_badge",
    Rope           = "rope",
    Handcuffs      = "handcuffs",
    EvidenceBag    = "evidence_bag",
    EvidenceMarker = "evidence_marker",
    Notebook       = "investigation_journal",
    Camera         = "weapon_kit_camera",
    Binoculars     = "weapon_kit_binoculars",
    Lantern        = "weapon_melee_lantern",
    Compass        = "compass",
    Telegraph      = "telegraph_paper",
    WantedPoster   = "wanted_poster",
    Whistle        = "police_whistle",

    -- Period-appropriate weapons
    Weapons = {
        Pistol   = { "weapon_pistol_volcanic", "weapon_revolver_cattleman", "weapon_revolver_doubleaction" },
        Revolver = { "weapon_revolver_schofield", "weapon_revolver_navy", "weapon_revolver_lemat" },
        Rifle    = { "weapon_repeater_carbine", "weapon_repeater_lancaster", "weapon_rifle_springfield", "weapon_rifle_boltaction" },
        Shotgun  = { "weapon_shotgun_doublebarrel", "weapon_shotgun_pump", "weapon_shotgun_repeating" },
        Sniper   = { "weapon_sniperrifle_carcano", "weapon_sniperrifle_rollingblock" },
    },

    -- Ammo
    Ammo = { "ammo_pistol", "ammo_rifle", "ammo_repeater", "ammo_revolver", "ammo_shotgun" },

    -- Horse
    HorseBrush   = "horsebrush",
    HorseMedicine = "horse_reviver",
}

-- Physical paper items (given to players in inventory)
Config.PhysicalItems = {
    Enabled                 = true,
    RequireInventorySpace   = true,
    AutoRemoveOnUse         = true,

    IncidentReport  = { itemName="incident_report",     label="Incident Report",         weight=0.1, unique=true, useable=true, giveToOfficer=true, giveToSuspect=false },
    ArrestReport    = { itemName="arrest_report",        label="Arrest Report",           weight=0.1, unique=true, useable=true, giveToOfficer=true, giveToSuspect=true  },
    Citation        = { itemName="citation_ticket",      label="Citation Ticket",         weight=0.05,unique=true, useable=true, giveToOfficer=true, giveToSuspect=true  },
    Warrant         = { itemName="arrest_warrant",       label="Arrest Warrant",          weight=0.1, unique=true, useable=true, giveToOfficer=true, giveToSuspect=false },
    BountyPoster    = { itemName="wanted_poster",         label="Wanted Poster",           weight=0.05,unique=true, useable=true, giveToOfficer=true, giveToSuspect=false, canDuplicate=true, maxCopies=10 },
    EvidenceBag     = { itemName="evidence_bag",          label="Evidence Bag",            weight=0.5, unique=true, useable=true, giveToOfficer=true,
        types = {
            blood       = { itemName="evidence_blood",       label="Blood Evidence"       },
            casing      = { itemName="evidence_casing",      label="Bullet Casing"        },
            fingerprint = { itemName="evidence_fingerprint", label="Fingerprint Evidence" },
            tracks      = { itemName="evidence_tracks",      label="Track Evidence"       },
            photo       = { itemName="evidence_photo",       label="Crime Scene Photo"    },
            weapon      = { itemName="evidence_weapon",      label="Weapon Evidence"      },
        },
    },
    SearchReceipt   = { itemName="search_receipt",       label="Search Receipt",          weight=0.05,unique=true, useable=true, giveToOfficer=true, giveToSuspect=true },
    PropertyReceipt = { itemName="property_receipt",     label="Property Receipt",        weight=0.05,unique=true, useable=true, giveToOfficer=true, giveToSuspect=true },
    CourtSummons    = { itemName="court_summons",         label="Court Summons",           weight=0.1, unique=true, useable=true, giveToOfficer=false,giveToSuspect=true },
    TelegraphMsg    = { itemName="telegraph_message",     label="Telegraph Message",       weight=0.01,unique=true, useable=true, giveToOfficer=true },
    WitnessStatement= { itemName="witness_statement",     label="Witness Statement",       weight=0.05,unique=true, useable=true, giveToOfficer=true },
}

-- Wearable / attachment items
Config.WearableItems = {
    Badges = {
        ["badge_sheriff_star"]    = { label="Sheriff's Star Badge",   model=`p_cs_badge01x`, attachment="chest_left", value=50,  rare=true,  jobs={"sheriff"}  },
        ["badge_deputy_shield"]   = { label="Deputy Shield Badge",    model=`p_cs_badge02x`, attachment="chest_left", value=30,              jobs={"sheriff"}  },
        ["badge_us_marshal"]      = { label="US Marshal Badge",       model=`p_cs_badge03x`, attachment="chest_left", value=100, rare=true,  jobs={"marshal"}  },
        ["badge_texas_ranger"]    = { label="Texas Ranger Badge",     model=`p_cs_badge04x`, attachment="chest_left", value=150, rare=true,  jobs={"ranger"}   },
        ["badge_constable"]       = { label="Constable Badge",        model=`p_cs_badge05x`, attachment="chest_left", value=25,              jobs={"lawman"}   },
        ["badge_temporary_deputy"]= { label="Temporary Deputy Badge", model=`p_cs_badge02x`, attachment="chest_left", value=10,  temporary=true, duration=3600 },
    },
    BeltItems = {
        ["handcuffs_iron"]  = { label="Iron Handcuffs", model=`p_cs_cuffs01x`, attachment="belt_left",  value=15, weight=500, usable=true },
        ["rope_lasso"]      = { label="Coiled Rope",    model=`p_rope01x`,     attachment="belt_right", value=5,  weight=800, usable=true },
        ["baton_wood"]      = { label="Wooden Baton",   model=`w_melee_club01`,attachment="belt_back",  value=8,  weight=600, usable=true, rank_required=2 },
        ["baton_metal"]     = { label="Metal Baton",    model=`w_melee_club02`,attachment="belt_back",  value=12, weight=800, usable=true, rank_required=3 },
        ["keys_jail"]       = { label="Jail Cell Keys", model=`p_key01x`,      attachment="belt_left",  value=20, weight=100, rank_required=1 },
    },
    InvestigationTools = {
        ["camera_1899"]      = { label="Box Camera",        model=`p_camera01x`, value=150, weight=2000, usable=true, rank_required=3, film_capacity=12 },
        ["fingerprint_kit"]  = { label="Fingerprint Kit",   model=`p_case01x`,   value=75,  weight=1500, usable=true, rank_required=2, uses=20 },
        ["magnifying_glass"] = { label="Magnifying Glass",  model=`p_magnify01x`,value=25,  weight=150,  usable=true, rank_required=2 },
        ["measuring_tape"]   = { label="Measuring Tape",    model=`p_tape01x`,   value=10,  weight=200,  usable=true },
        ["notebook_leather"] = { label="Leather Notebook",  model=`p_notebook01x`,value=10, weight=300,  usable=true, pages=100 },
    },
}

-- Attachment bone config (for wearable system)
Config.AttachmentBones = {
    ["chest_left"]  = { bone="SKEL_Spine3",     offset={x=0.12,  y=0.05,  z=0.0}  },
    ["chest_right"] = { bone="SKEL_Spine3",     offset={x=-0.12, y=0.05,  z=0.0}  },
    ["belt_left"]   = { bone="SKEL_Pelvis",     offset={x=-0.15, y=-0.05, z=0.0}  },
    ["belt_right"]  = { bone="SKEL_Pelvis",     offset={x=0.15,  y=-0.05, z=0.0}  },
    ["belt_back"]   = { bone="SKEL_Pelvis",     offset={x=0.0,   y=-0.15, z=0.0}  },
    ["back"]        = { bone="SKEL_Spine_Root", offset={x=0.0,   y=-0.15, z=0.05} },
    ["hand_left"]   = { bone="SKEL_L_Hand",     offset={x=0.05,  y=0.0,   z=0.0}  },
    ["hand_right"]  = { bone="SKEL_R_Hand",     offset={x=0.05,  y=0.0,   z=0.0}  },
    ["vest_pocket"] = { bone="SKEL_Spine2",     offset={x=0.15,  y=0.05,  z=0.0}  },
    ["head"]        = { bone="SKEL_Head",       offset={x=0.0,   y=0.0,   z=0.0}  },
}

-- Default loadouts by job/rank
Config.DefaultLoadouts = {
    ["sheriff"] = {
        [0]={  "badge_deputy_shield","rope_lasso","whistle_brass","notebook_leather"                                             },
        [1]={  "badge_deputy_shield","rope_lasso","handcuffs_iron","notebook_leather"                                            },
        [2]={  "badge_deputy_shield","rope_lasso","handcuffs_iron","baton_wood","magnifying_glass"                               },
        [3]={  "badge_deputy_shield","rope_lasso","handcuffs_iron","baton_metal","camera_1899","fingerprint_kit"                 },
        [4]={  "badge_sheriff_star","rope_lasso","handcuffs_iron","baton_metal","camera_1899","fingerprint_kit","keys_jail"      },
    },
    ["marshal"] = {
        [0]={  "badge_us_marshal","rope_lasso","handcuffs_iron","notebook_leather"                                               },
        [1]={  "badge_us_marshal","rope_lasso","handcuffs_iron","baton_wood","magnifying_glass"                                  },
        [2]={  "badge_us_marshal","rope_lasso","handcuffs_iron","baton_metal","camera_1899","fingerprint_kit"                    },
        [3]={  "badge_us_marshal","rope_lasso","handcuffs_iron","baton_metal","camera_1899","fingerprint_kit"                    },
        [4]={  "badge_us_marshal","rope_lasso","handcuffs_iron","baton_metal","camera_1899","fingerprint_kit","keys_jail"        },
    },
    ["ranger"]  = {
        [0]={  "badge_texas_ranger","rope_lasso","notebook_leather"              },
        [1]={  "badge_texas_ranger","rope_lasso","handcuffs_iron","notebook_leather"                                             },
        [2]={  "badge_texas_ranger","rope_lasso","handcuffs_iron","baton_wood","magnifying_glass"                                },
        [3]={  "badge_texas_ranger","rope_lasso","handcuffs_iron","baton_metal","camera_1899"                                    },
        [4]={  "badge_texas_ranger","rope_lasso","handcuffs_iron","baton_metal","camera_1899"                                    },
    },
    ["lawman"]  = {
        [0]={  "badge_constable","rope_lasso","notebook_leather"                 },
        [1]={  "badge_constable","rope_lasso","handcuffs_iron","notebook_leather"},
        [2]={  "badge_constable","rope_lasso","handcuffs_iron","baton_wood"      },
        [3]={  "badge_constable","rope_lasso","handcuffs_iron","baton_wood","magnifying_glass" },
        [4]={  "badge_constable","rope_lasso","handcuffs_iron","baton_metal","camera_1899"     },
    },
}

-- ══════════════════════════════════════════════════════════════
-- § 15  K9 SYSTEM
-- ══════════════════════════════════════════════════════════════

Config.K9 = {
    Enabled           = true,
    RequiredGrade     = 2,
    MaxDistance       = 50.0,
    FollowDistance    = 2.5,
    CommandDistance   = 10.0,

    Breeds = {
        { name="Bloodhound", model="A_C_DogBloodhound_01", label="Bloodhound", specialty="tracking",
          trackingSkill=100, searchSkill=80,  apprehensionSkill=60,  speed=85, stamina=90, health=100 },
        { name="Coonhound",  model="A_C_DogHound_01",      label="Coonhound",  specialty="searching",
          trackingSkill=85,  searchSkill=90,  apprehensionSkill=70,  speed=90, stamina=85, health=95  },
        { name="Shepherd",   model="A_C_ShepherdDog_01",   label="Shepherd Dog",specialty="apprehension",
          trackingSkill=75,  searchSkill=75,  apprehensionSkill=95,  speed=95, stamina=90, health=110 },
    },

    Commands = {
        spawn   = { command="/k9spawn",   label="Spawn K9",           requiresDuty=true, cooldown=5000                   },
        dismiss = { command="/k9dismiss", label="Dismiss K9",         requiresDuty=true, cooldown=1000                   },
        follow  = { command="/k9follow",  label="K9 Follow",          requiresDuty=true, cooldown=1000                   },
        stay    = { command="/k9stay",    label="K9 Stay",            requiresDuty=true, cooldown=1000                   },
        track   = { command="/k9track",   label="K9 Track",           requiresDuty=true, cooldown=3000,  duration=30000, range=100.0 },
        search  = { command="/k9search",  label="K9 Search",          requiresDuty=true, cooldown=5000,  duration=20000, range=25.0  },
        attack  = { command="/k9attack",  label="K9 Attack",          requiresDuty=true, cooldown=10000, damage=25, subdueChance=75, requiresTarget=true },
        vehicle = { command="/k9vehicle", label="K9 Enter/Exit Vehicle",requiresDuty=true,cooldown=2000                  },
    },

    Tracking = {
        enabled=true, maxTrackAge=300000, trackDecayRate=0.1, minScentStrength=0.3,
        trackUpdateInterval=2000, showTrackBlips=true, alertRadius=10.0,
        successRate = { bloodhound=95, coonhound=85, shepherd=75 },
    },

    Apprehension = {
        enabled=true, attackRange=5.0, attackDamage=25,
        subdueChance = { bloodhound=60, coonhound=70, shepherd=90 },
        subdueRagdoll=true, subdueTime=5000, cooldownAfterAttack=10000,
        canAttackArmed=true, warningBark=true, rewardXP=50,
    },

    Health = {
        enabled=true, maxHealth=200, regenRate=2, canBeInjured=true,
        canDie=true, respawnTime=300000,
    },

    Stamina = {
        enabled=true, maxStamina=100,
        depletionRate = { walking=0.5, running=2.0, tracking=1.5, searching=1.0, attacking=3.0 },
        regenRate=5, lowStaminaThreshold=20, exhaustedThreshold=5,
    },

    Training = {
        enabled=true, requireTraining=true,
        trainingLevels = {
            { level=1, name="Basic Obedience",       xpRequired=0,    commands={"follow","stay"},                              bonus={speed=5}                                           },
            { level=2, name="Tracking Certified",    xpRequired=500,  commands={"follow","stay","track"},                      bonus={trackingSkill=10,speed=10}                         },
            { level=3, name="Search Certified",      xpRequired=1000, commands={"follow","stay","track","search"},             bonus={searchSkill=10,stamina=10}                         },
            { level=4, name="Apprehension Certified",xpRequired=2000, commands={"follow","stay","track","search","attack"},    bonus={apprehensionSkill=15,health=20}                    },
            { level=5, name="Master K9",             xpRequired=5000, commands={"follow","stay","track","search","attack","vehicle"}, bonus={trackingSkill=20,searchSkill=20,apprehensionSkill=20,speed=20,stamina=20,health=30} },
        },
        xpGainRate = { spawn=1, follow=2, track=10, trackSuccess=25, search=15, searchSuccess=30, attack=20, attackSuccess=50 },
    },

    SpawnLocations = {
        { name="Valentine Sheriff Kennel",  coords=vector3(-280.0,  800.0,  119.0), heading=90,  blip=true },
        { name="Rhodes Sheriff Kennel",     coords=vector3(1360.0, -1300.0,  77.0), heading=180, blip=true },
        { name="Blackwater Sheriff Kennel", coords=vector3(-760.0, -1270.0,  44.0), heading=270, blip=true },
        { name="Strawberry Sheriff Kennel", coords=vector3(-1810.0, -355.0, 164.0), heading=0,   blip=true },
    },

    Items = {
        { itemName="dog_treat",   label="Dog Treat",              effect="restoreStamina",  amount=25 },
        { itemName="dog_medicine",label="Dog Medicine",           effect="restoreHealth",   amount=50 },
        { itemName="k9_vest",     label="K9 Protective Vest",     effect="increaseHealth",  amount=50 },
        { itemName="k9_collar",   label="K9 Tracking Collar",     effect="increaseTracking",amount=10 },
    },
}

-- ══════════════════════════════════════════════════════════════
-- § 16  ANIMATIONS
-- ══════════════════════════════════════════════════════════════

Config.Animations = {
    Hogtie      = { dict="script_rc@cldn@ig@rsc2@ig@p2",           anim="hogtie_on_ground",    flag=1, duration=5000  },
    Cuffed      = { dict="script_rc@prhud@ig@player_rest@1h@1@base",anim="base",               flag=1, duration=-1    },
    Search      = { dict="script_rc@rsc2@ig@p2",                    anim="p_search_grab_player",flag=1, duration=5000  },
    Drag        = { dict="script_rc@cldn@ig@rsc2@ig@p2",           anim="grab_drag",           flag=1, duration=-1    },
    TakePhoto   = { dict="script_rc@act2@ig@photos",                anim="take_photo",          flag=1, duration=3000  },
    WriteNotes  = { dict="script_rc@rsc2@ig@p2",                    anim="write_notes",         flag=1, duration=5000  },
    Examine     = { dict="script_rc@rsc2@ig@p2",                    anim="inspect_ground",      flag=1, duration=8000  },
    Collect     = { dict="script_rc@rsc2@ig@p2",                    anim="pickup_object",       flag=1, duration=3000  },
    Hanging     = { dict="mech_hanging",                            anim="hanging_idle",        flag=1, duration=-1    },
    Surrender   = { dict="script_rc@cldn@ig@rsc2@ig@p2",           anim="surrender",           flag=1, duration=-1    },
}

-- ══════════════════════════════════════════════════════════════
-- § 17  PERMISSIONS & ANTI-ABUSE
-- ══════════════════════════════════════════════════════════════

Config.Permissions = {
    -- Grade thresholds for common actions
    Actions = {
        arrest=0, search=0, evidence_collect=0, evidence_analyze=1,
        warrant_issue=2, warrant_execute=1, bounty_place=2, posse_form=2,
        execution_perform=3, records_edit=1, records_seal=3,
        impound_vehicle=1, seize_property=2, deputize=3, hire_fire=4,
    },
    -- Grade thresholds for area access
    Access = { armory=0, evidence_room=1, records_office=0, cells=1, telegraph=0, stables=0 },
}

Config.AntiAbuse = {
    EnableRateLimiting = true,
    RateLimits = {
        arrests      = { max=5,  window=300 },
        searches     = { max=10, window=300 },
        warrants     = { max=3,  window=600 },
        reports      = { max=5,  window=600 },
        mdt_queries  = { max=50, window=60  },
    },
    DetectSuspicious = true,
    SuspiciousThresholds = { rapid_arrests=3, rapid_releases=3, rapid_warrants=2 },
    OnAbuse           = "warn",   -- "warn" | "kick" | "ban" | "log"
    BanDuration       = 86400,
    NotifyAdmins      = true,
    MaxArrestDistance = 3.0,
    MaxSearchDistance = 2.0,
    MaxInteractDistance = 5.0,
}

-- ══════════════════════════════════════════════════════════════
-- § 18  EXPERIENCE & PROGRESSION
-- ══════════════════════════════════════════════════════════════

Config.Experience = {
    Enabled = true,
    Rewards = {
        arrest=50, citation=15, evidence_collect=10, case_solve=200,
        bounty_capture_alive=150, bounty_capture_dead=75,
        backup_response=25, patrol_hour=10,
    },
    RankXP  = { [0]=0, [1]=500, [2]=1500, [3]=3500, [4]=7500 },
    Perks = {
        [1] = { "better_tracking", "evidence_bonus"           },
        [2] = { "posse_leader",    "faster_investigation"     },
        [3] = { "interrogation_expert", "warrant_authority"   },
        [4] = { "master_detective", "legendary_lawman"        },
    },
}

-- ══════════════════════════════════════════════════════════════
-- § 19  NOTIFICATIONS, KEYBINDS, SOUND
-- ══════════════════════════════════════════════════════════════

Config.Notifications = {
    Type     = "rsg",      -- "rsg" | "ox_lib" | "custom"
    Duration = 5000,
    Position = "top-right",
    Messages = {
        OnDuty            = "You are now on duty as a %s",
        OffDuty           = "You are now off duty",
        ArrestMade        = "Suspect arrested: %s",
        EvidenceCollected = "Evidence collected: %s",
        WarrantIssued     = "Warrant issued for %s",
        BountyPlaced      = "Bounty placed: $%s on %s",
        DispatchAlert     = "[DISPATCH] %s - %s",
        BackupRequested   = "Backup requested at your location",
    },
    Sounds = {
        Alert        = "CHECKPOINT_PERFECT",
        Success      = "HSTBLE_FOCUS_COMPLETE",
        Error        = "CHECKPOINT_MISSED",
        Notification = "CHECKPOINT_NORMAL",
    },
}

Config.Keybinds = {
    OpenMenu      = 0x7F8D09B8,  -- F9
    QuickAction   = 0xCEFD9220,  -- E
    OpenRecords   = 0xC7B5340A,  -- F10
    RadioMenu     = 0xF3830D8E,  -- J
    EmergencyBackup= 0x8FD015D8, -- K
}

-- ══════════════════════════════════════════════════════════════
-- § 20  LOGGING / AUDIT
-- ══════════════════════════════════════════════════════════════

Config.Logging = {
    Enabled        = true,
    Webhook        = "",            -- Discord webhook URL
    DatabaseLog    = true,
    LogRetention   = 2592000,       -- 30 days

    Events = {
        duty_change=true, arrest=true, release=true, evidence=true,
        warrant=true, execution=true, bounty=true, property_seizure=true, abuse=true,
    },

    DiscordColors = {
        arrest=15158332, warrant=15105570, duty=3447003,
        internal_affairs=10038562, suspicious=16776960,
    },
    RetentionDays = 90,
}

-- ══════════════════════════════════════════════════════════════
-- § 21  MDT SETTINGS
-- ══════════════════════════════════════════════════════════════

Config.MDT = {
    AccessMethods  = { keybind=true, vehicle=true, terminal=true, tablet=false },
    SearchDebounce = 500,
    MaxSearchResults = 50,
    CacheTimeout   = 300,
    BatchSize      = 10,
    Modules = {
        persons=true, criminals=true, warrants=true, vehicles=true,
        reports=true, bolos=true, jail=true, evidence=true, internal_affairs=true,
    },
}

-- ══════════════════════════════════════════════════════════════
-- § 22  FEATURES TOGGLE
-- ══════════════════════════════════════════════════════════════

Config.Features = {
    EnableBountySystem      = true,
    EnablePosseFormation    = true,
    EnablePublicExecutions  = true,
    EnableChainGang         = true,
    EnableTelegraphAlerts   = true,
    EnableWantedPosters     = true,
    EnableTrackingSystem    = true,
    EnableHorseImpound      = true,
    EnableWitnessSystem     = true,
    EnableInvestigations    = true,
    EnableForensics         = true,
    EnableCrimeScenes       = true,
    EnablePropertySeizure   = true,
    EnableCivilianReports   = true,
    EnableDeputization      = true,
    EnableExperience        = true,
    EnableRankProgression   = true,
    EnableK9                = true,
    EnableWearableItems     = true,
}

-- ══════════════════════════════════════════════════════════════
-- § 23  OPTIMIZATION & DEBUG
-- ══════════════════════════════════════════════════════════════

Config.Optimization = {
    DistanceCheck          = 50.0,
    RefreshRate            = 1000,
    MaxEvidenceMarkers     = 100,
    EvidenceCleanupInterval= 300,
    CacheDuration          = 600,
}

Config.DebugSettings = {
    Enabled            = false,
    PrintToConsole     = false,
    ShowMarkers        = false,
    ShowBlips          = true,
    BypassPermissions  = false,
    FastExperience     = false,
    TestMode           = false,
}

-- Backward-compat alias used by some scripts
Config.LEOCore = {
    Duty         = Config.Duty,
    Warrants     = Config.Warrants,
    AntiAbuse    = Config.AntiAbuse,
    Logging      = Config.Logging,
    MDT          = Config.MDT,
    Charges = {
        AllowChargeStacking  = true,
        StackingMultiplier   = _STACKING_MULT,
        MaxCharges           = 10,
        AutoCalculate        = true,
        BailEnabled          = true,
        BailMultiplier       = _BAIL_MULT,
        BailDeniedCategories = { "Murder", "Treason", "Capital" },
        MinuteToRealSecond   = 1,
        ParoleEligibility    = 0.5,
        GoodBehaviorReduction= 0.15,
    },
    Permissions  = {
        Definitions = {
            ["duty_toggle"]        = { label="Clock In/Out",            minRank=0                         },
            ["mdt_access"]         = { label="MDT Access",              minRank=0, requireDuty=true        },
            ["arrest_detain"]      = { label="Detain Suspect",          minRank=0, requireDuty=true, cooldown=5  },
            ["arrest_cuff"]        = { label="Arrest Suspect",          minRank=0, requireDuty=true, cooldown=5  },
            ["arrest_search"]      = { label="Search Suspect",          minRank=0, requireDuty=true        },
            ["mdt_create_report"]  = { label="Create Report",           minRank=0, requireDuty=true        },
            ["mdt_edit_report"]    = { label="Edit Report",             minRank=1, requireDuty=true        },
            ["mdt_delete_report"]  = { label="Delete Report",           minRank=3, requireDuty=true, auditLog=true },
            ["warrant_request"]    = { label="Request Warrant",         minRank=1, requireDuty=true        },
            ["warrant_approve"]    = { label="Approve Warrant",         minRank=3, requireDuty=true, auditLog=true },
            ["warrant_execute"]    = { label="Execute Warrant",         minRank=0, requireDuty=true        },
            ["jail_sentence"]      = { label="Sentence to Jail",        minRank=1, requireDuty=true, auditLog=true },
            ["jail_release"]       = { label="Release Prisoner",        minRank=1, requireDuty=true, auditLog=true },
            ["jail_modify"]        = { label="Modify Sentence",         minRank=2, requireDuty=true, auditLog=true },
            ["evidence_collect"]   = { label="Collect Evidence",        minRank=0, requireDuty=true        },
            ["evidence_analyze"]   = { label="Analyze Evidence",        minRank=1, requireDuty=true        },
            ["bolo_create"]        = { label="Create BOLO",             minRank=0, requireDuty=true        },
            ["officer_manage"]     = { label="Manage Officers",         minRank=3, requireDuty=true, auditLog=true },
            ["internal_affairs"]   = { label="Internal Affairs",        minRank=4, requireDuty=true, auditLog=true },
        },
        Cooldowns = { arrest_detain=5, arrest_cuff=5, arrest_search=10, warrant_request=30, jail_sentence=10, bolo_create=15 },
    },
    Jurisdiction = {
        EnforceJurisdiction = true,
        Levels = {
            ["sheriff"] = { zones={"county"},             canAssist={"lawman","ranger"}, priority=1 },
            ["lawman"]  = { zones={"town"},               canAssist={"sheriff"},         priority=2 },
            ["marshal"] = { zones={"territory","federal"},canAssist={"all"},             priority=3 },
            ["ranger"]  = { zones={"state","wilderness"}, canAssist={"sheriff","marshal"},priority=3 },
        },
        AllowCrossJurisdiction = true,
        RequirePermission      = true,
        AutoGrantIfEmergency   = true,
    },
}

-- ══════════════════════════════════════════════════════════════
-- STARTUP BANNER
-- ══════════════════════════════════════════════════════════════

CreateThread(function()
    Wait(1500)
    print(([[

        ═══════════════════════════════════════════════════════════════
            🐺  LXR-POLICE  ·  Supreme Config  ·  v%s
            Server: %s
            Website: %s  ·  Discord: %s
        ═══════════════════════════════════════════════════════════════
    ]]):format(
        Config.ServerInfo.version,
        Config.ServerInfo.name,
        Config.ServerInfo.website,
        Config.ServerInfo.discord
    ))
end)

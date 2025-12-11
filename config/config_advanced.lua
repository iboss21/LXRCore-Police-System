--[[
    ╔════════════════════════════════════════════════════════════╗
    ║  The Land of Wolves RP - Law Enforcement System           ║
    ║  SUPREME OMNI-LEVEL CONFIGURATION (Part 2)                ║
    ║  www.wolves.land                                          ║
    ╚════════════════════════════════════════════════════════════╝
]]

-- ══════════════════════════════════════════════════════════════
-- BOUNTY SYSTEM (1899 Wild West)
-- ══════════════════════════════════════════════════════════════
Config.Bounty = {
    Enabled = true,
    
    -- Bounty Hunters
    AllowBountyHunters = true,
    BountyHunterJob = "bountyhunter",
    BountyHunterLicense = "bounty_license",
    LicenseCost = 250,
    
    -- Bounty Rules
    MinimumBounty = 50,
    MaximumBounty = 5000,
    BountyDecayEnabled = true,
    BountyDecayRate = 0.10, -- 10% per day
    BountyDecayInterval = 86400, -- 24 hours
    
    -- Wanted Posters
    WantedPosterEnabled = true,
    WantedPosterCost = 25, -- Cost to print poster
    WantedPosterLocations = {
        vec3(-275.0, 807.0, 119.5), -- Valentine
        vec3(1361.0, -1300.0, 77.0), -- Rhodes
        vec3(-1811.0, -353.0, 164.0), -- Strawberry
        vec3(-760.0, -1267.0, 44.0), -- Blackwater
        vec3(-5526.0, -2949.0, -2.0), -- Tumbleweed
        vec3(2907.0, 1309.0, 45.0), -- Annesburg
    },
    
    -- Capture Rewards
    CaptureAliveBonus = 1.5, -- 150% bounty if captured alive
    CaptureDeadPenalty = 0.5, -- 50% bounty if brought in dead
    
    -- Bounty Tiers
    Tiers = {
        {min = 0, max = 100, label = "Petty Criminal", color = "#FFFFFF"},
        {min = 101, max = 300, label = "Wanted", color = "#FFD700"},
        {min = 301, max = 600, label = "Dangerous", color = "#FFA500"},
        {min = 601, max = 1000, label = "Most Wanted", color = "#FF4500"},
        {min = 1001, max = 99999, label = "Dead or Alive", color = "#DC143C"},
    }
}

-- ══════════════════════════════════════════════════════════════
-- POSSE SYSTEM
-- ══════════════════════════════════════════════════════════════
Config.Posse = {
    Enabled = true,
    
    -- Formation
    MaxPosseSize = 8,
    MinRankToForm = 2, -- Rank 2+ can form posse
    PosseFormationTime = 5000, -- 5 seconds
    
    -- Deputization
    AllowTempDeputies = true,
    TempDeputyDuration = 3600, -- 1 hour
    TempDeputyBadge = "temp_deputy_badge",
    
    -- Coordination
    SharedBlips = true,
    SharedWaypoints = true,
    PosseChat = true,
    PosseRadioChannel = "law_radio",
    
    -- Bonuses
    ExperienceBonus = 0.25, -- 25% more XP in posse
    PaymentBonus = 0.15, -- 15% more pay
    CaptureBonus = 0.20, -- 20% more bounty reward
}

-- ══════════════════════════════════════════════════════════════
-- INVESTIGATION & DETECTIVE WORK
-- ══════════════════════════════════════════════════════════════
Config.Investigation = {
    Enabled = true,
    
    -- Evidence Collection
    EvidenceTypes = {
        blood = {
            label = "Blood Sample",
            model = `p_bloodsplat01x`,
            collectTime = 5000,
            expireTime = 1800, -- 30 minutes
            weatherAffected = true,
        },
        casing = {
            label = "Bullet Casing",
            model = `w_pistol_cartridge01`,
            collectTime = 3000,
            expireTime = 3600, -- 1 hour
            weatherAffected = false,
        },
        footprint = {
            label = "Footprint",
            model = nil,
            collectTime = 5000,
            expireTime = 900, -- 15 minutes
            weatherAffected = true,
        },
        fingerprint = {
            label = "Fingerprint",
            model = nil,
            collectTime = 8000,
            expireTime = 7200, -- 2 hours
            weatherAffected = false,
        },
        weapon = {
            label = "Weapon Evidence",
            model = nil,
            collectTime = 4000,
            expireTime = 9999999,
            weatherAffected = false,
        },
    },
    
    -- Crime Scene
    CrimeSceneTape = true,
    TapeModel = `p_rope01x`,
    TapeDistance = 15.0,
    ProtectedZoneDuration = 1800, -- 30 minutes
    
    -- Tracking System
    TrackingEnabled = true,
    TrackingSkillRequired = false,
    TrackingDistance = 500, -- Max tracking distance
    TrackingDuration = 600, -- 10 minutes before trail goes cold
    TrackTypes = {
        footprints = true,
        hoofprints = true,
        bloodtrail = true,
        vehicle_tracks = true,
    },
    
    -- Forensics
    ForensicsLabRequired = true,
    ForensicsTime = 30000, -- 30 seconds to analyze
    DNAMatchingEnabled = true,
    FingerprintMatchingEnabled = true,
    BallisticsMatchingEnabled = true,
    
    -- Witness System
    WitnessEnabled = true,
    WitnessMemoryDuration = 1800, -- 30 minutes
    WitnessReliability = 0.7, -- 70% accuracy
    InterrogationTime = 60000, -- 1 minute
}

-- ══════════════════════════════════════════════════════════════
-- RECORDS SYSTEM (Ledger/Telegraph Based)
-- ══════════════════════════════════════════════════════════════
Config.Records = {
    Enabled = true,
    
    -- Database
    UseLedger = true, -- Physical ledger books
    UseTelegraph = true, -- Telegraph for warrants
    
    -- Citizen Records
    AutoCreateRecords = true,
    RequirePhotograph = true,
    RequireFingerprints = true,
    
    -- Reporting
    ReportTypes = {
        incident = {label = "Incident Report", icon = "document"},
        arrest = {label = "Arrest Report", icon = "handcuffs"},
        investigation = {label = "Investigation Report", icon = "magnifying_glass"},
        citation = {label = "Citation", icon = "ticket"},
        property = {label = "Property Report", icon = "bag"},
        witness = {label = "Witness Statement", icon = "speech"},
    },
    
    -- Warrants
    WarrantTypes = {
        arrest = {label = "Arrest Warrant", expiry = 2592000}, -- 30 days
        search = {label = "Search Warrant", expiry = 86400}, -- 1 day
        seizure = {label = "Seizure Warrant", expiry = 172800}, -- 2 days
    },
    
    -- Telegraph System
    TelegraphCost = 5, -- Cost per message
    TelegraphRange = "territory", -- "local", "county", "territory", "national"
    TelegraphDelay = 30, -- 30 seconds delivery time
}

-- ══════════════════════════════════════════════════════════════
-- DISPATCH & COMMUNICATION (1899 Style)
-- ══════════════════════════════════════════════════════════════
Config.Dispatch = {
    Enabled = true,
    
    -- Alert Methods
    Methods = {
        telegraph = {enabled = true, range = 9999, delay = 30},
        messenger = {enabled = true, range = 1000, delay = 60},
        bell = {enabled = true, range = 500, delay = 5},
        signal_fire = {enabled = true, range = 2000, delay = 10},
        whistle = {enabled = true, range = 200, delay = 2},
    },
    
    -- Call Types
    CallTypes = {
        {code = "10-00", label = "Officer Needs Assistance", priority = 1, color = "red"},
        {code = "10-10", label = "Fight in Progress", priority = 2, color = "orange"},
        {code = "10-16", label = "Domestic Disturbance", priority = 3, color = "yellow"},
        {code = "10-31", label = "Breaking and Entering", priority = 2, color = "orange"},
        {code = "10-32", label = "Armed Robbery", priority = 1, color = "red"},
        {code = "10-50", label = "Horseback Chase", priority = 2, color = "orange"},
        {code = "10-55", label = "Intoxicated Person", priority = 4, color = "blue"},
        {code = "10-60", label = "Suspicious Activity", priority = 3, color = "yellow"},
        {code = "10-70", label = "Shots Fired", priority = 1, color = "red"},
        {code = "10-90", label = "Murder", priority = 1, color = "red"},
    },
    
    -- Response
    AutoAssignNearest = true,
    ShowBlipOnMap = true,
    BlipDuration = 300, -- 5 minutes
    NotifyAllOfficers = true,
    RequireResponse = true,
    ResponseTimeout = 180, -- 3 minutes
    
    -- Civilian Reports
    AllowCivilianReports = true,
    CivilianReportMethod = "telegraph", -- "telegraph", "person"
    AnonymousReports = true,
    FalseReportPenalty = {fine = 25, jailTime = 60},
}

-- ══════════════════════════════════════════════════════════════
-- EXECUTION SYSTEM (Public Hanging)
-- ══════════════════════════════════════════════════════════════
Config.Execution = {
    Enabled = true,
    
    -- Execution Types
    Types = {
        hanging = {
            enabled = true,
            label = "Hanging",
            requiredCrime = "capital",
            animation = "mech_hanging",
            locations = {
                vec3(-270.0, 820.0, 118.0), -- Valentine
                vec3(-760.0, -1265.0, 44.0), -- Blackwater
                vec3(-5525.0, -2948.0, -2.0), -- Tumbleweed
            }
        },
        firing_squad = {
            enabled = false,
            label = "Firing Squad",
            requiredCrime = "capital",
            animation = "execution_shot",
            locations = {
                vec3(3330.0, -675.0, 45.0), -- Sisika
            }
        }
    },
    
    -- Procedure
    PublicExecution = true,
    RequireJudgeApproval = true,
    JudgeJobs = {"judge", "magistrate"},
    NoticeTime = 600, -- 10 minutes notice
    AllowLastWords = true,
    LastWordsDuration = 60, -- 1 minute
    
    -- Spectators
    AllowSpectators = true,
    SpectatorRadius = 50.0,
    NotifyTerritory = true,
    
    -- Appeal
    AllowAppeal = true,
    AppealTimeLimit = 300, -- 5 minutes before execution
    AppealCost = 500,
}

-- ══════════════════════════════════════════════════════════════
-- PROPERTY SEIZURE & IMPOUND
-- ══════════════════════════════════════════════════════════════
Config.Seizure = {
    Enabled = true,
    
    -- Horse Impound
    HorseImpound = {
        enabled = true,
        cost = 50,
        duration = 86400, -- 24 hours
        locations = {
            vec3(-282.0, 800.0, 119.5), -- Valentine
            vec3(1370.0, -1310.0, 76.5), -- Rhodes
            vec3(-1820.0, -360.0, 163.5), -- Strawberry
            vec3(-770.0, -1275.0, 43.5), -- Blackwater
        }
    },
    
    -- Wagon Impound
    WagonImpound = {
        enabled = true,
        cost = 100,
        duration = 86400,
        locations = {
            vec3(-280.0, 798.0, 119.0), -- Valentine
            vec3(1368.0, -1308.0, 76.5), -- Rhodes
        }
    },
    
    -- Property Seizure
    PropertySeizure = {
        enabled = true,
        requiredRank = 2,
        requiresWarrant = true,
        items_seizable = {
            "weapon_*",
            "lockpick",
            "illegal_*",
            "contraband_*",
        },
        money_seizable = true,
        max_cash_seizure = 1000,
    }
}

-- ══════════════════════════════════════════════════════════════
-- ITEMS & EQUIPMENT (RSG-Core Compatible)
-- ══════════════════════════════════════════════════════════════
Config.Items = {
    -- Law Enforcement Items
    Badge = "lawman_badge",
    TempBadge = "temp_deputy_badge",
    Rope = "rope",
    Handcuffs = "handcuffs", -- If available
    EvidenceBag = "evidence_bag",
    EvidenceMarker = "evidence_marker",
    
    -- Investigation Tools
    Notebook = "investigation_journal",
    Camera = "weapon_kit_camera",
    CameraAdvanced = "weapon_kit_camera_advanced",
    Binoculars = "weapon_kit_binoculars",
    BinocularsImproved = "weapon_kit_binoculars_improved",
    Lantern = "weapon_melee_lantern",
    Compass = "compass",
    
    -- Communication
    Telegraph = "telegraph_paper",
    WantedPoster = "wanted_poster",
    Whistle = "police_whistle",
    
    -- Weapons (Period Appropriate)
    Weapons = {
        Pistol = {
            "weapon_pistol_volcanic",
            "weapon_revolver_cattleman",
            "weapon_revolver_doubleaction",
        },
        Revolver = {
            "weapon_revolver_schofield",
            "weapon_revolver_navy",
            "weapon_revolver_lemat",
        },
        Rifle = {
            "weapon_repeater_carbine",
            "weapon_repeater_lancaster",
            "weapon_repeater_evans",
            "weapon_rifle_springfield",
            "weapon_rifle_boltaction",
        },
        Shotgun = {
            "weapon_shotgun_doublebarrel",
            "weapon_shotgun_pump",
            "weapon_shotgun_repeating",
        },
        Sniper = {
            "weapon_sniperrifle_carcano",
            "weapon_sniperrifle_rollingblock",
        },
        Throwable = {
            "weapon_thrown_dynamite",
            "weapon_thrown_molotov",
            "weapon_thrown_throwing_knives",
        }
    },
    
    -- Ammo
    Ammo = {
        "ammo_pistol",
        "ammo_rifle",
        "ammo_repeater",
        "ammo_revolver",
        "ammo_shotgun",
        "ammo_arrow",
    },
    
    -- Consumables
    Bandages = "bandage",
    HealthTonic = "consumable_medicine",
    StaminaTonic = "consumable_potent_tonic",
    
    -- Horse Equipment
    HorseBrush = "horsebrush",
    HorseMedicine = "horse_reviver",
}

-- ══════════════════════════════════════════════════════════════
-- ANIMATIONS (RedM Specific)
-- ══════════════════════════════════════════════════════════════
Config.Animations = {
    -- Arrest Animations
    Hogtie = {
        dict = "script_rc@cldn@ig@rsc2@ig@p2",
        anim = "hogtie_on_ground",
        flag = 1,
        duration = 5000,
    },
    Cuffed = {
        dict = "script_rc@prhud@ig@player_rest@1h@1@base",
        anim = "base",
        flag = 1,
        duration = -1,
    },
    Search = {
        dict = "script_rc@rsc2@ig@p2",
        anim = "p_search_grab_player",
        flag = 1,
        duration = 5000,
    },
    Drag = {
        dict = "script_rc@cldn@ig@rsc2@ig@p2",
        anim = "grab_drag",
        flag = 1,
        duration = -1,
    },
    
    -- Investigation Animations
    TakePhoto = {
        dict = "script_rc@act2@ig@photos",
        anim = "take_photo",
        flag = 1,
        duration = 3000,
    },
    WriteNotes = {
        dict = "script_rc@rsc2@ig@p2",
        anim = "write_notes",
        flag = 1,
        duration = 5000,
    },
    ExamineEvidence = {
        dict = "script_rc@rsc2@ig@p2",
        anim = "inspect_ground",
        flag = 1,
        duration = 8000,
    },
    CollectEvidence = {
        dict = "script_rc@rsc2@ig@p2",
        anim = "pickup_object",
        flag = 1,
        duration = 3000,
    },
    
    -- Execution Animations
    Hanging = {
        dict = "mech_hanging",
        anim = "hanging_idle",
        flag = 1,
        duration = -1,
    },
    
    -- Other
    Surrender = {
        dict = "script_rc@cldn@ig@rsc2@ig@p2",
        anim = "surrender",
        flag = 1,
        duration = -1,
    },
    Kneel = {
        dict = "script_rc@rsc2@ig@p2",
        anim = "kneel",
        flag = 1,
        duration = -1,
    },
}

-- ══════════════════════════════════════════════════════════════
-- NOTIFICATIONS & MESSAGES
-- ══════════════════════════════════════════════════════════════
Config.Notifications = {
    Type = "rsg", -- "rsg", "ox_lib", "custom"
    Duration = 5000,
    Position = "top-right",
    
    -- Custom Messages
    Messages = {
        OnDuty = "You are now on duty as a %s",
        OffDuty = "You are now off duty",
        ArrestMade = "Suspect arrested: %s",
        EvidenceCollected = "Evidence collected: %s",
        WarrantIssued = "Warrant issued for %s",
        BountyPlaced = "Bounty placed: $%s on %s",
        DispatchAlert = "[DISPATCH] %s - %s",
        BackupRequested = "Backup requested at your location",
    },
    
    -- Sound Effects
    Sounds = {
        Alert = "CHECKPOINT_PERFECT",
        Success = "HSTBLE_FOCUS_COMPLETE",
        Error = "CHECKPOINT_MISSED",
        Notification = "CHECKPOINT_NORMAL",
    }
}

-- ══════════════════════════════════════════════════════════════
-- KEYBINDS
-- ══════════════════════════════════════════════════════════════
Config.Keybinds = {
    OpenMenu = 0x7F8D09B8, -- F9
    QuickAction = 0xCEFD9220, -- E
    OpenRecords = 0xC7B5340A, -- F10
    RadioMenu = 0xF3830D8E, -- J
    EmergencyBackup = 0x8FD015D8, -- K
}

-- ══════════════════════════════════════════════════════════════
-- PERMISSIONS & RANKS
-- ══════════════════════════════════════════════════════════════
Config.Permissions = {
    -- Action Permissions
    Actions = {
        arrest = 0,
        search = 0,
        evidence_collect = 0,
        evidence_analyze = 1,
        warrant_issue = 2,
        warrant_execute = 1,
        bounty_place = 2,
        posse_form = 2,
        execution_perform = 3,
        records_edit = 1,
        records_seal = 3,
        impound_vehicle = 1,
        seize_property = 2,
        deputize = 3,
        hire_fire = 4,
    },
    
    -- Access Permissions
    Access = {
        armory = 0,
        evidence_room = 1,
        records_office = 0,
        cells = 1,
        telegraph = 0,
        stables = 0,
    }
}

-- ══════════════════════════════════════════════════════════════
-- EXPERIENCE & PROGRESSION
-- ══════════════════════════════════════════════════════════════
Config.Experience = {
    Enabled = true,
    
    -- XP Rewards
    Rewards = {
        arrest = 50,
        citation = 15,
        evidence_collect = 10,
        case_solve = 200,
        bounty_capture_alive = 150,
        bounty_capture_dead = 75,
        backup_response = 25,
        patrol_hour = 10,
    },
    
    -- Ranks
    RankXP = {
        [0] = 0,
        [1] = 500,
        [2] = 1500,
        [3] = 3500,
        [4] = 7500,
    },
    
    -- Perks (Unlocked by Rank)
    Perks = {
        [1] = {"better_tracking", "evidence_bonus"},
        [2] = {"posse_leader", "faster_investigation"},
        [3] = {"interrogation_expert", "warrant_authority"},
        [4] = {"master_detective", "legendary_lawman"},
    }
}

-- ══════════════════════════════════════════════════════════════
-- LOGGING & AUDIT
-- ══════════════════════════════════════════════════════════════
Config.Logging = {
    Enabled = true,
    
    -- Discord Webhook
    Webhook = "https://discord.com/api/webhooks/yourwebhook",
    
    -- Log Events
    Events = {
        duty_change = true,
        arrest = true,
        release = true,
        evidence = true,
        warrant = true,
        execution = true,
        bounty = true,
        property_seizure = true,
        abuse = true,
    },
    
    -- Database Logging
    DatabaseLog = true,
    LogRetention = 2592000, -- 30 days
}

-- ══════════════════════════════════════════════════════════════
-- FEATURES TOGGLE
-- ══════════════════════════════════════════════════════════════
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
    EnableInvestigations = true,
    EnableForensics = true,
    EnableCrimeScenes = true,
    EnablePropertySeizure = true,
    EnableCivilianReports = true,
    EnableDeputization = true,
    EnableExperience = true,
    EnableRankProgression = true,
}

-- ══════════════════════════════════════════════════════════════
-- DEBUG & DEVELOPMENT
-- ══════════════════════════════════════════════════════════════
Config.Debug = {
    Enabled = false,
    PrintToConsole = false,
    ShowMarkers = false,
    ShowBlips = true,
    GodModeInJail = false,
    BypassPermissions = false,
    FastExperience = false,
    TestMode = false,
}

-- ══════════════════════════════════════════════════════════════
-- OPTIMIZATION
-- ══════════════════════════════════════════════════════════════
Config.Optimization = {
    DistanceCheck = 50.0, -- Distance to check for interactions
    RefreshRate = 1000, -- Milliseconds between checks
    MaxEvidenceMarkers = 100,
    EvidenceCleanupInterval = 300, -- 5 minutes
    CacheDuration = 600, -- 10 minutes
}

print("^2[The Land of Wolves RP]^7 Law Enforcement Configuration Loaded Successfully!")
print("^3[TLoW]^7 Version: " .. Config.Branding.Version)
print("^3[TLoW]^7 Website: " .. Config.Branding.Website)

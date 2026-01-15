--[[
    ╔════════════════════════════════════════════════════════════╗
    ║  LEO Core Configuration - PRD Compliant                   ║
    ║  Server-Authoritative, Abuse-Resistant System             ║
    ║  RedM Law Enforcement with MDT                            ║
    ╚════════════════════════════════════════════════════════════╝
]]

Config.LEOCore = {}

-- ══════════════════════════════════════════════════════════════
-- DUTY SYSTEM - Hard Enforcement
-- No MDT, No Arrests, No Powers Off-Duty
-- ══════════════════════════════════════════════════════════════
Config.LEOCore.Duty = {
    -- Strict duty enforcement
    RequireOnDutyForMDT = true,          -- Cannot access MDT off-duty
    RequireOnDutyForArrest = true,       -- Cannot arrest off-duty
    RequireOnDutyForWeapons = true,      -- Cannot spawn weapons off-duty
    RequireOnDutyForVehicles = true,     -- Cannot spawn police vehicles off-duty
    
    -- Uniform enforcement
    RequireUniformOnDuty = true,         -- Must wear proper uniform
    AutoChangeUniform = true,            -- Auto-equip uniform when going on duty
    
    -- AFK Prevention
    AFKTimeoutMinutes = 15,              -- Kick from duty after 15 min AFK
    AFKWarningMinutes = 12,              -- Warn at 12 minutes
    AFKCheckInterval = 60,               -- Check every 60 seconds
    
    -- Duty time tracking for payroll
    TrackDutyTime = true,
    PayrollInterval = 3600,              -- Pay every hour (seconds)
    PayrollDatabase = true,              -- Store in database for audit
}

-- ══════════════════════════════════════════════════════════════
-- RANK-BASED PERMISSIONS SYSTEM
-- Granular Control Per Agency and Rank
-- ══════════════════════════════════════════════════════════════
Config.LEOCore.Permissions = {
    -- Permission definitions
    Definitions = {
        -- Basic Operations
        ["duty_toggle"] = {
            label = "Clock In/Out",
            description = "Toggle on/off duty status",
            minRank = 0,
        },
        ["mdt_access"] = {
            label = "MDT Access",
            description = "Open and view MDT",
            minRank = 0,
            requireDuty = true,
        },
        ["mdt_search"] = {
            label = "MDT Search",
            description = "Search citizen records",
            minRank = 0,
            requireDuty = true,
        },
        
        -- Arrest Powers
        ["arrest_detain"] = {
            label = "Detain Suspect",
            description = "Soft cuff / escort suspect",
            minRank = 0,
            requireDuty = true,
            cooldown = 5, -- seconds between uses
        },
        ["arrest_cuff"] = {
            label = "Arrest Suspect",
            description = "Hard cuff and formal arrest",
            minRank = 0,
            requireDuty = true,
            cooldown = 5,
        },
        ["arrest_search"] = {
            label = "Search Suspect",
            description = "Search person for contraband",
            minRank = 0,
            requireDuty = true,
        },
        
        -- Records Management
        ["mdt_create_report"] = {
            label = "Create Report",
            description = "Write incident reports",
            minRank = 0,
            requireDuty = true,
        },
        ["mdt_edit_report"] = {
            label = "Edit Report",
            description = "Modify existing reports",
            minRank = 1,
            requireDuty = true,
        },
        ["mdt_delete_report"] = {
            label = "Delete Report",
            description = "Remove reports from system",
            minRank = 3,
            requireDuty = true,
            auditLog = true,
        },
        
        -- Warrant System
        ["warrant_request"] = {
            label = "Request Warrant",
            description = "Submit warrant for approval",
            minRank = 1,
            requireDuty = true,
        },
        ["warrant_approve"] = {
            label = "Approve Warrant",
            description = "Approve pending warrants",
            minRank = 3, -- Supervisor+
            requireDuty = true,
            auditLog = true,
        },
        ["warrant_execute"] = {
            label = "Execute Warrant",
            description = "Serve arrest/search warrants",
            minRank = 0,
            requireDuty = true,
        },
        
        -- Jail & Sentencing
        ["jail_sentence"] = {
            label = "Sentence to Jail",
            description = "Send suspect to jail",
            minRank = 1,
            requireDuty = true,
            auditLog = true,
        },
        ["jail_release"] = {
            label = "Release Prisoner",
            description = "Release from custody",
            minRank = 1,
            requireDuty = true,
            auditLog = true,
        },
        ["jail_modify"] = {
            label = "Modify Sentence",
            description = "Change sentence time",
            minRank = 2,
            requireDuty = true,
            auditLog = true,
        },
        
        -- Evidence
        ["evidence_collect"] = {
            label = "Collect Evidence",
            description = "Gather crime scene evidence",
            minRank = 0,
            requireDuty = true,
        },
        ["evidence_analyze"] = {
            label = "Analyze Evidence",
            description = "Process forensic evidence",
            minRank = 1,
            requireDuty = true,
        },
        ["evidence_delete"] = {
            label = "Delete Evidence",
            description = "Remove evidence from system",
            minRank = 3,
            requireDuty = true,
            auditLog = true,
        },
        
        -- BOLO System
        ["bolo_create"] = {
            label = "Create BOLO",
            description = "Issue person/vehicle BOLO",
            minRank = 0,
            requireDuty = true,
        },
        ["bolo_delete"] = {
            label = "Delete BOLO",
            description = "Remove active BOLO",
            minRank = 1,
            requireDuty = true,
        },
        
        -- Administrative
        ["officer_manage"] = {
            label = "Manage Officers",
            description = "Add/remove officers",
            minRank = 3,
            requireDuty = true,
            auditLog = true,
        },
        ["internal_affairs"] = {
            label = "Internal Affairs",
            description = "Access IA investigations",
            minRank = 4, -- Chief/Sheriff only
            requireDuty = true,
            auditLog = true,
        },
    },
    
    -- Anti-spam cooldowns (seconds)
    Cooldowns = {
        arrest_detain = 5,
        arrest_cuff = 5,
        arrest_search = 10,
        warrant_request = 30,
        jail_sentence = 10,
        bolo_create = 15,
    },
}

-- ══════════════════════════════════════════════════════════════
-- WARRANT SYSTEM - Supervisor Approval Required
-- ══════════════════════════════════════════════════════════════
Config.LEOCore.Warrants = {
    -- Approval workflow
    RequireSupervisorApproval = true,    -- Warrants need approval
    MinApprovalRank = 3,                 -- Rank 3+ (Sergeant/Lt) can approve
    
    -- Probable cause
    RequireProbableCause = true,         -- Must provide reason
    MinCauseLength = 50,                 -- Minimum 50 characters
    
    -- Types
    Types = {
        ["arrest"] = {
            label = "Arrest Warrant",
            description = "Authority to arrest on sight",
            requireApproval = true,
            expiryDays = 30,
        },
        ["search"] = {
            label = "Search Warrant",
            description = "Authority to search property",
            requireApproval = true,
            expiryDays = 7,
            requireLocation = true,
        },
        ["bench"] = {
            label = "Bench Warrant",
            description = "Issued by judge for missed court",
            requireApproval = false, -- Judge-issued
            expiryDays = 90,
        },
    },
    
    -- Notification
    NotifyOnline = true,                 -- Notify target if online
    NotifyDelay = 300,                   -- Delay 5 minutes before notifying
}

-- ══════════════════════════════════════════════════════════════
-- CHARGES & SENTENCING - Automatic Calculation
-- ══════════════════════════════════════════════════════════════
Config.LEOCore.Charges = {
    -- Charge stacking
    AllowChargeStacking = true,
    StackingMultiplier = 0.75,          -- Each additional charge is 75% time
    MaxCharges = 10,                    -- Limit to 10 charges per arrest
    
    -- Sentence calculation
    AutoCalculate = true,               -- Auto-calculate based on charges
    JudgeOverride = true,               -- Allow judge to modify
    
    -- Bail system
    BailEnabled = true,
    BailMultiplier = 5,                 -- Bail = 5x fine amount
    BailDeniedCategories = {            -- Cannot bail for these
        "Murder",
        "Treason",
        "Capital",
    },
    
    -- Time served
    MinuteToRealSecond = 1,            -- 1 jail minute = 1 real second
    ParoleEligibility = 0.5,           -- Eligible after 50% served
    GoodBehaviorReduction = 0.15,      -- 15% reduction for good behavior
}

-- ══════════════════════════════════════════════════════════════
-- ANTI-ABUSE SYSTEM
-- Server-Side Validation and Rate Limiting
-- ══════════════════════════════════════════════════════════════
Config.LEOCore.AntiAbuse = {
    -- Rate limiting
    EnableRateLimiting = true,
    
    -- Maximum actions per time period
    RateLimits = {
        arrests = {max = 5, window = 300},      -- 5 arrests per 5 min
        searches = {max = 10, window = 300},    -- 10 searches per 5 min
        warrants = {max = 3, window = 600},     -- 3 warrants per 10 min
        reports = {max = 5, window = 600},      -- 5 reports per 10 min
        mdt_queries = {max = 50, window = 60},  -- 50 MDT searches per min
    },
    
    -- Suspicious activity detection
    DetectSuspicious = true,
    SuspiciousThresholds = {
        rapid_arrests = 3,              -- 3 arrests in 30 seconds = suspicious
        rapid_releases = 3,             -- 3 releases in 30 seconds
        rapid_warrants = 2,             -- 2 warrants in 30 seconds
    },
    
    -- Actions on abuse detection
    OnAbuse = "warn",                   -- "warn", "kick", "ban", "log"
    BanDuration = 86400,                -- 24 hours
    BanEventName = "qb-admin:server:ban", -- Configurable ban event
    NotifyAdmins = true,
    
    -- Distance checks
    MaxArrestDistance = 3.0,            -- Must be within 3 meters
    MaxSearchDistance = 2.0,            -- Must be within 2 meters
    MaxInteractDistance = 5.0,          -- General interaction range
}

-- ══════════════════════════════════════════════════════════════
-- AUDIT & LOGGING
-- Everything Logged for Admin Review
-- ══════════════════════════════════════════════════════════════
Config.LEOCore.Audit = {
    -- What to log
    LogDutyChanges = true,
    LogArrests = true,
    LogWarrants = true,
    LogMDTAccess = true,
    LogMDTEdits = true,
    LogEvidence = true,
    LogJail = true,
    LogUseOfForce = true,               -- Flag violent arrests
    
    -- Log retention
    RetentionDays = 90,                 -- Keep logs for 90 days
    
    -- Discord webhook
    DiscordWebhook = "",                -- Set in your config
    DiscordColors = {
        arrest = 15158332,              -- Red
        warrant = 15105570,             -- Orange
        duty = 3447003,                 -- Blue
        internal_affairs = 10038562,    -- Dark red
        suspicious = 16776960,          -- Yellow
    },
}

-- ══════════════════════════════════════════════════════════════
-- MDT CONFIGURATION
-- Single Source of Truth
-- ══════════════════════════════════════════════════════════════
Config.LEOCore.MDT = {
    -- Access methods
    AccessMethods = {
        keybind = true,                 -- Keybind to open
        vehicle = true,                 -- Dashboard in vehicle
        terminal = true,                -- Station terminals
        tablet = false,                 -- Tablet item (optional)
    },
    
    -- Search settings
    SearchDebounce = 500,               -- 500ms debounce
    MaxSearchResults = 50,
    LazyLoadRecords = true,             -- Load on demand
    
    -- Performance
    CacheTimeout = 300,                 -- Cache for 5 minutes
    BatchSize = 10,                     -- Load 10 records at a time
    
    -- Modules enabled
    Modules = {
        persons = true,
        criminals = true,
        warrants = true,
        vehicles = true,
        reports = true,
        bolos = true,
        jail = true,
        evidence = true,
        internal_affairs = true,
    },
}

-- ══════════════════════════════════════════════════════════════
-- JURISDICTION RULES
-- Agency Authority Boundaries
-- ══════════════════════════════════════════════════════════════
Config.LEOCore.Jurisdiction = {
    EnforceJurisdiction = true,
    
    -- Agency jurisdiction levels
    Levels = {
        ["sheriff"] = {
            zones = {"county"},
            canAssist = {"lawman", "ranger"},
            priority = 1,
        },
        ["lawman"] = {
            zones = {"town"},
            canAssist = {"sheriff"},
            priority = 2,
        },
        ["marshal"] = {
            zones = {"territory", "federal"},
            canAssist = {"all"},
            priority = 3,
        },
        ["ranger"] = {
            zones = {"state", "wilderness"},
            canAssist = {"sheriff", "marshal"},
            priority = 3,
        },
    },
    
    -- Cross-jurisdiction
    AllowCrossJurisdiction = true,      -- Can operate outside with permission
    RequirePermission = true,           -- Need supervisor approval
    AutoGrantIfEmergency = true,        -- Auto-grant in emergency
}

return Config.LEOCore

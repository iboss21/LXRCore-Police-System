--[[
    ╔════════════════════════════════════════════════════════════╗
    ║  The Land of Wolves RP - Law Enforcement System           ║
    ║  1899 Wild West Authentic Police System                   ║
    ║  www.wolves.land                                          ║
    ║  © 2024 Land of Wolves RP Community                       ║
    ╚════════════════════════════════════════════════════════════╝
]]

Config = {}

-- Framework Configuration
Config.Framework = "auto" -- "lxrcore", "rsgcore", "vorp", "auto"
Config.UseTarget = true -- Use targeting system (rsg-target/ox_target)
Config.ServerName = "The Land of Wolves RP"
Config.ServerWebsite = "www.wolves.land"

-- Branding
Config.Branding = {
    Name = "The Land of Wolves RP - Law Enforcement System",
    ShortName = "TLoW Law",
    Version = "1.0.0",
    Year = "1899",
    Discord = "discord.gg/wolves",
}

-- Logging & Discord
Config.Logging = {
    Webhook = "https://discord.com/api/webhooks/yourwebhookhere",
    EnableAuditLog = true,
    LogActions = {
        arrest = true,
        release = true,
        evidence = true,
        warrant = true,
        execution = true,
        bounty = true,
    }
}

-- Law Enforcement Jobs (1899 Period-Accurate)
Config.LawJobs = {
    ["sheriff"] = {
        label = "Sheriff's Office",
        type = "local", -- Town/County law enforcement
        jurisdiction = "county",
        ranks = {
            [0] = "Auxiliary Deputy",
            [1] = "Deputy Sheriff",
            [2] = "Senior Deputy",
            [3] = "Under-Sheriff",
            [4] = "Sheriff",
        }
    },
    ["marshal"] = {
        label = "US Marshal Service",
        type = "federal", -- Federal law enforcement
        jurisdiction = "territory",
        ranks = {
            [0] = "Deputy Marshal",
            [1] = "Field Marshal",
            [2] = "Senior Marshal",
            [3] = "Chief Marshal",
            [4] = "US Marshal",
        }
    },
    ["ranger"] = {
        label = "State Rangers",
        type = "state", -- State/territorial rangers
        jurisdiction = "state",
        ranks = {
            [0] = "Ranger Recruit",
            [1] = "Ranger",
            [2] = "Senior Ranger",
            [3] = "Ranger Captain",
            [4] = "Ranger Commander",
        }
    },
    ["lawman"] = {
        label = "Town Marshal",
        type = "municipal", -- Town law enforcement
        jurisdiction = "town",
        ranks = {
            [0] = "Constable",
            [1] = "Deputy Marshal",
            [2] = "Town Marshal",
            [3] = "Chief Marshal",
            [4] = "Marshal",
        }
    }
}

-- Sheriff's Offices & Marshal Stations (1899 Locations)
Config.Stations = {
    ["valentine"] = {
        label = "Valentine Sheriff's Office",
        type = "sheriff",
        coords = vec3(-275.5, 804.0, 119.0),
        cells = {
            vec3(-272.4, 812.1, 118.4),
            vec3(-276.8, 812.1, 118.4),
        },
        recordsOffice = vec3(-280.0, 808.0, 119.5),
        armory = vec3(-278.0, 803.0, 119.5),
        stables = vec3(-282.0, 800.0, 119.5),
        gallows = vec3(-270.0, 820.0, 118.0), -- Public execution
        telegraph = vec3(-281.0, 805.0, 119.5),
        wantedBoard = vec3(-279.0, 807.0, 119.5),
    },
    ["rhodes"] = {
        label = "Rhodes Sheriff's Office",
        type = "sheriff",
        coords = vec3(1360.5, -1301.0, 77.0),
        cells = {
            vec3(1363.0, -1298.0, 77.0),
        },
        recordsOffice = vec3(1358.0, -1303.0, 77.0),
        armory = vec3(1362.0, -1305.0, 77.0),
        stables = vec3(1370.0, -1310.0, 76.5),
        telegraph = vec3(1359.0, -1302.0, 77.0),
        wantedBoard = vec3(1361.0, -1300.0, 77.0),
    },
    ["strawberry"] = {
        label = "Strawberry Sheriff's Office",
        type = "sheriff",
        coords = vec3(-1810.0, -354.0, 164.0),
        cells = {
            vec3(-1812.0, -351.0, 164.0),
        },
        recordsOffice = vec3(-1808.0, -356.0, 164.0),
        armory = vec3(-1813.0, -355.0, 164.0),
        stables = vec3(-1820.0, -360.0, 163.5),
        telegraph = vec3(-1809.0, -355.0, 164.0),
        wantedBoard = vec3(-1811.0, -353.0, 164.0),
    },
    ["blackwater"] = {
        label = "Blackwater Marshal's Office",
        type = "marshal",
        coords = vec3(-761.0, -1268.0, 44.0),
        cells = {
            vec3(-758.0, -1265.0, 44.0),
            vec3(-764.0, -1265.0, 44.0),
        },
        recordsOffice = vec3(-763.0, -1270.0, 44.0),
        armory = vec3(-759.0, -1272.0, 44.0),
        stables = vec3(-770.0, -1275.0, 43.5),
        telegraph = vec3(-762.0, -1269.0, 44.0),
        wantedBoard = vec3(-760.0, -1267.0, 44.0),
    },
    ["tumbleweed"] = {
        label = "Tumbleweed Sheriff's Office",
        type = "sheriff",
        coords = vec3(-5527.0, -2950.0, -2.0),
        cells = {
            vec3(-5524.0, -2948.0, -2.0),
        },
        recordsOffice = vec3(-5529.0, -2952.0, -2.0),
        armory = vec3(-5525.0, -2954.0, -2.0),
        stables = vec3(-5535.0, -2960.0, -2.5),
        telegraph = vec3(-5528.0, -2951.0, -2.0),
        wantedBoard = vec3(-5526.0, -2949.0, -2.0),
    },
    ["annesburg"] = {
        label = "Annesburg Sheriff's Office",
        type = "sheriff",
        coords = vec3(2906.0, 1308.0, 45.0),
        cells = {
            vec3(2908.0, 1310.0, 45.0),
        },
        recordsOffice = vec3(2904.0, 1306.0, 45.0),
        armory = vec3(2909.0, 1307.0, 45.0),
        stables = vec3(2915.0, 1300.0, 44.5),
        telegraph = vec3(2905.0, 1307.0, 45.0),
        wantedBoard = vec3(2907.0, 1309.0, 45.0),
    },
    ["sisika"] = {
        label = "Sisika Penitentiary",
        type = "prison",
        coords = vec3(3328.0, -670.0, 45.0),
        cells = {
            vec3(3330.0, -668.0, 45.0),
            vec3(3332.0, -668.0, 45.0),
            vec3(3334.0, -668.0, 45.0),
            vec3(3336.0, -668.0, 45.0),
            vec3(3338.0, -668.0, 45.0),
        },
        chainGangArea = vec3(3340.0, -680.0, 45.0),
        workyard = vec3(3345.0, -675.0, 45.0),
        releasePoint = vec3(3325.0, -665.0, 45.0),
    }
}

-- Jail & Prison System
Config.Jail = {
    MinimumSentence = 60, -- 1 minute minimum
    MaximumSentence = 3600, -- 1 hour maximum
    ParoleEligibility = 0.5, -- 50% of sentence
    ChainGangReduction = 30, -- Seconds reduced per job completed
    BailMultiplier = 3, -- Bail is 3x the fine
    PrisonLocation = "sisika", -- Sisika Penitentiary for long sentences
    LocalJailThreshold = 600, -- Under 10 minutes = local jail
}

-- Crime Categories (1899 Wild West Laws)
Config.Crimes = {
    -- Capital Offenses (Hanging)
    ["murder"] = {
        label = "Murder",
        category = "capital",
        jailTime = 3600,
        fine = 500,
        description = "Unlawful killing of another person",
        execution = true,
    },
    ["horse_theft"] = {
        label = "Horse Theft",
        category = "capital",
        jailTime = 1800,
        fine = 300,
        description = "Stealing a horse (capital offense in 1899)",
        execution = true,
    },
    ["train_robbery"] = {
        label = "Train Robbery",
        category = "capital",
        jailTime = 2400,
        fine = 1000,
        description = "Robbing a railroad train",
        execution = false,
    },
    
    -- Felonies
    ["bank_robbery"] = {
        label = "Bank Robbery",
        category = "felony",
        jailTime = 1800,
        fine = 800,
        description = "Robbing a bank or financial institution",
    },
    ["cattle_rustling"] = {
        label = "Cattle Rustling",
        category = "felony",
        jailTime = 900,
        fine = 400,
        description = "Stealing cattle or livestock",
    },
    ["stage_robbery"] = {
        label = "Stagecoach Robbery",
        category = "felony",
        jailTime = 1200,
        fine = 600,
        description = "Robbing a stagecoach",
    },
    ["claim_jumping"] = {
        label = "Claim Jumping",
        category = "felony",
        jailTime = 600,
        fine = 200,
        description = "Illegally occupying someone's mining claim",
    },
    ["arson"] = {
        label = "Arson",
        category = "felony",
        jailTime = 1200,
        fine = 500,
        description = "Intentionally setting fire to property",
    },
    
    -- Misdemeanors
    ["disturbing_peace"] = {
        label = "Disturbing the Peace",
        category = "misdemeanor",
        jailTime = 180,
        fine = 25,
        description = "Creating public disturbance",
    },
    ["public_intoxication"] = {
        label = "Public Intoxication",
        category = "misdemeanor",
        jailTime = 120,
        fine = 15,
        description = "Being drunk in public",
    },
    ["brawling"] = {
        label = "Brawling",
        category = "misdemeanor",
        jailTime = 240,
        fine = 50,
        description = "Fighting in public",
    },
    ["trespassing"] = {
        label = "Trespassing",
        category = "misdemeanor",
        jailTime = 300,
        fine = 75,
        description = "Unlawfully entering private property",
    },
    ["illegal_gambling"] = {
        label = "Illegal Gambling",
        category = "misdemeanor",
        jailTime = 180,
        fine = 40,
        description = "Participating in unlawful gambling",
    },
    ["moonshining"] = {
        label = "Moonshining",
        category = "misdemeanor",
        jailTime = 600,
        fine = 150,
        description = "Illegal alcohol production",
    },
    ["weapons_in_town"] = {
        label = "Brandishing Weapons",
        category = "misdemeanor",
        jailTime = 120,
        fine = 30,
        description = "Carrying weapons within town limits",
    },
}

-- Period-Accurate Equipment
Config.Equipment = {
    -- Badges (worn on vest)
    badges = {
        ["badge_sheriff"] = {label = "Sheriff's Star", model = `p_cs_badge01x`},
        ["badge_deputy"] = {label = "Deputy's Badge", model = `p_cs_badge02x`},
        ["badge_marshal"] = {label = "Marshal's Badge", model = `p_cs_badge03x`},
        ["badge_ranger"] = {label = "Ranger's Badge", model = `p_cs_badge04x`},
    },
    
    -- Restraints (rope, not handcuffs)
    restraints = {
        ["rope"] = {label = "Hemp Rope", model = `p_rope01x`},
        ["chain"] = {label = "Iron Chains", model = `p_chain01x`},
    },
    
    -- Period Weapons
    weapons = {
        ["weapon_revolver_cattleman"] = "Cattleman Revolver",
        ["weapon_revolver_schofield"] = "Schofield Revolver",
        ["weapon_pistol_volcanic"] = "Volcanic Pistol",
        ["weapon_repeater_carbine"] = "Carbine Repeater",
        ["weapon_rifle_springfield"] = "Springfield Rifle",
        ["weapon_shotgun_pump"] = "Pump Shotgun",
        ["weapon_shotgun_doublebarrel"] = "Double-Barrel Shotgun",
    },
}

-- Items
Config.Items = {
    EvidenceBag = "evidence_bag",
    Rope = "rope",
    Badge = "lawman_badge",
    Notebook = "investigation_journal",
    Camera = "camera_1899",
    Telegraph = "telegraph_paper",
    WantedPoster = "wanted_poster",
}

-- Features
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

-- Animations (RedM specific)
Config.Animations = {
    hogtie = {dict = "script_rc@cldn@ig@rsc2@ig@p2", anim = "hogtie"},
    cuffed = {dict = "script_rc@prhud@ig@player_rest@1h@1@base", anim = "base"},
    search = {dict = "script_rc@rsc2@ig@p2", anim = "p_search_grab_player"},
    hang = {dict = "mech_hanging", anim = "hanging_idle"},
    photograph = {dict = "script_rc@act2@ig@photos", anim = "take_photo"},
}

-- Debug Mode
Config.Debug = false
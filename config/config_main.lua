--[[
    ╔════════════════════════════════════════════════════════════╗
    ║  The Land of Wolves RP - Law Enforcement System           ║
    ║  SUPREME OMNI-LEVEL CONFIGURATION                         ║
    ║  Everything Configurable - No Code Editing Required       ║
    ║  www.wolves.land                                          ║
    ╚════════════════════════════════════════════════════════════╝
]]

Config = {}

-- ══════════════════════════════════════════════════════════════
-- BRANDING & SERVER IDENTITY
-- ══════════════════════════════════════════════════════════════
Config.Branding = {
    ServerName = "The Land of Wolves RP",
    SystemName = "Law Enforcement System",
    ShortName = "TLoW Law",
    Version = "1.0.0",
    Year = "1899",
    Website = "www.wolves.land",
    Discord = "discord.gg/wolves",
    Logo = "https://i.imgur.com/yourlogo.png", -- Your server logo
    ShowBranding = true, -- Show branding in UI
    WatermarkPosition = "bottom-right", -- "top-left", "top-right", "bottom-left", "bottom-right"
}

-- ══════════════════════════════════════════════════════════════
-- FRAMEWORK CONFIGURATION
-- ══════════════════════════════════════════════════════════════
Config.Framework = {
    Type = "auto", -- "lxrcore", "rsgcore", "vorp", "redemrp", "auto"
    UseTarget = true, -- Enable target system (rsg-target, ox_target)
    TargetResource = "rsg-target", -- Target resource name
    UseInventory = "rsg-inventory", -- "rsg-inventory", "ox_inventory", "qs-inventory"
    UsePhone = false, -- 1899 doesn't have phones, use telegraph instead
    UseTelegraph = true, -- Period-accurate communication
}

-- ══════════════════════════════════════════════════════════════
-- UI THEME & APPEARANCE (Western Aesthetic)
-- ══════════════════════════════════════════════════════════════
Config.UI = {
    Theme = "western_authentic", -- "western_authentic", "modern_western", "dark_western", "classic"
    
    -- Color Palette (Sepia/Aged Paper Theme)
    Colors = {
        Primary = "#8B7355", -- Saddle Brown
        Secondary = "#D4A574", -- Tan/Parchment
        Accent = "#C19A6B", -- Camel/Gold
        Success = "#6B8E23", -- Olive Green
        Warning = "#DAA520", -- Goldenrod
        Danger = "#8B0000", -- Dark Red
        Info = "#4682B4", -- Steel Blue
        Dark = "#3E2723", -- Dark Brown
        Light = "#F5E6D3", -- Aged Paper
        TextPrimary = "#2C1810", -- Dark Brown Text
        TextSecondary = "#5D4E37", -- Medium Brown Text
    },
    
    -- Typography (Western Style Fonts)
    Fonts = {
        Primary = "Rye", -- Western style font
        Secondary = "Cinzel", -- Elegant serif
        Monospace = "Courier Prime", -- For ledgers
        Handwriting = "Dawning of a New Day", -- For notes
    },
    
    -- Backgrounds & Textures
    Backgrounds = {
        Pattern = "aged_paper", -- "aged_paper", "leather", "wood", "wanted_poster"
        Texture = "grunge", -- "grunge", "scratches", "stains", "clean"
        Opacity = 0.95,
        Blur = true,
        BlurAmount = 3,
    },
    
    -- Border & Frame Styles
    Borders = {
        Style = "ornate", -- "ornate", "simple", "wanted_poster", "badge"
        Width = 3,
        Color = "#8B7355",
        CornerStyle = "carved", -- "carved", "rounded", "sharp"
        ShowShadow = true,
    },
    
    -- Animations & Effects
    Animations = {
        OpenAnimation = "fade_slide", -- "fade", "slide", "fade_slide", "scale", "none"
        OpenDuration = 400, -- milliseconds
        CloseAnimation = "fade_slide_up",
        CloseDuration = 300,
        HoverEffect = "lift_glow", -- "lift", "glow", "lift_glow", "none"
        TransitionSpeed = 200,
    },
    
    -- Sound Effects (Period Appropriate)
    Sounds = {
        Enable = true,
        Volume = 0.5,
        OpenSound = "book_open", -- Sound when opening UI
        CloseSound = "book_close",
        ClickSound = "pen_click",
        SuccessSound = "bell_ding",
        ErrorSound = "scratch",
        NotificationSound = "telegraph_beep",
    },
    
    -- Icons & Imagery
    Icons = {
        Style = "western", -- "western", "vintage", "modern"
        UseBadgeIcons = true,
        ShowStarRatings = true,
        UseWantedPosterFrames = true,
    },
    
    -- Layout & Spacing
    Layout = {
        MaxWidth = 1400,
        Padding = 24,
        BorderRadius = 8,
        CardSpacing = 16,
        SectionSpacing = 32,
        ResponsiveBreakpoint = 1024,
    },
    
    -- Custom CSS Override (Advanced Users)
    CustomCSS = "",
    
    -- Screenshot Settings
    Screenshots = {
        Quality = 0.95,
        Format = "jpg", -- "jpg", "png"
        WatermarkScreenshots = true,
    }
}

-- ══════════════════════════════════════════════════════════════
-- LAW ENFORCEMENT STRUCTURE (1899 Period-Accurate)
-- ══════════════════════════════════════════════════════════════
Config.LawJobs = {
    ["sheriff"] = {
        Enabled = true,
        Label = "Sheriff's Office",
        Type = "local",
        Jurisdiction = "county",
        Color = "#8B7355",
        Icon = "star_sheriff",
        Description = "County law enforcement, elected position",
        
        Ranks = {
            [0] = {name = "Auxiliary Deputy", pay = 5, permissions = {"arrest", "search", "patrol"}},
            [1] = {name = "Deputy Sheriff", pay = 8, permissions = {"arrest", "search", "patrol", "evidence"}},
            [2] = {name = "Senior Deputy", pay = 12, permissions = {"arrest", "search", "patrol", "evidence", "investigate"}},
            [3] = {name = "Under-Sheriff", pay = 18, permissions = {"arrest", "search", "patrol", "evidence", "investigate", "warrant"}},
            [4] = {name = "Sheriff", pay = 25, permissions = {"all"}},
        },
        
        Uniforms = {
            [0] = {male = "deputy_outfit_1", female = "deputy_outfit_1"},
            [1] = {male = "deputy_outfit_2", female = "deputy_outfit_2"},
            [2] = {male = "deputy_outfit_3", female = "deputy_outfit_3"},
            [3] = {male = "undersheriff_outfit", female = "undersheriff_outfit"},
            [4] = {male = "sheriff_outfit", female = "sheriff_outfit"},
        },
        
        Vehicles = {
            [0] = {"horse_tennessee", "horse_morgan"},
            [1] = {"horse_tennessee", "horse_morgan", "wagon_police"},
            [2] = {"horse_tennessee", "horse_morgan", "horse_turkoman", "wagon_police"},
            [3] = {"horse_turkoman", "horse_missouri", "wagon_police", "wagon_prison"},
            [4] = {"horse_arabian", "horse_missouri", "wagon_police", "wagon_prison"},
        },
        
        Loadout = {
            Weapons = {
                [0] = {"weapon_revolver_cattleman", "weapon_repeater_carbine"},
                [1] = {"weapon_revolver_schofield", "weapon_repeater_carbine", "weapon_shotgun_pump"},
                [2] = {"weapon_revolver_schofield", "weapon_repeater_lancaster", "weapon_shotgun_pump"},
                [3] = {"weapon_revolver_navy", "weapon_repeater_lancaster", "weapon_shotgun_pump", "weapon_rifle_springfield"},
                [4] = {"weapon_revolver_navy", "weapon_repeater_evans", "weapon_shotgun_pump", "weapon_rifle_boltaction"},
            },
            Items = {
                [0] = {"rope", "notebook", "bandages"},
                [1] = {"rope", "notebook", "bandages", "lantern"},
                [2] = {"rope", "notebook", "bandages", "lantern", "binoculars"},
                [3] = {"rope", "notebook", "bandages", "lantern", "binoculars", "camera"},
                [4] = {"rope", "notebook", "bandages", "lantern", "binoculars", "camera", "lockpick"},
            }
        }
    },
    
    ["marshal"] = {
        Enabled = true,
        Label = "US Marshal Service",
        Type = "federal",
        Jurisdiction = "territory",
        Color = "#4682B4",
        Icon = "star_marshal",
        Description = "Federal law enforcement, presidential appointment",
        
        Ranks = {
            [0] = {name = "Deputy Marshal", pay = 10, permissions = {"arrest", "search", "patrol", "evidence"}},
            [1] = {name = "Field Marshal", pay = 15, permissions = {"arrest", "search", "patrol", "evidence", "investigate"}},
            [2] = {name = "Senior Marshal", pay = 20, permissions = {"arrest", "search", "patrol", "evidence", "investigate", "warrant"}},
            [3] = {name = "Chief Marshal", pay = 28, permissions = {"arrest", "search", "patrol", "evidence", "investigate", "warrant", "execute"}},
            [4] = {name = "US Marshal", pay = 35, permissions = {"all"}},
        },
        
        Uniforms = {
            [0] = {male = "marshal_deputy_outfit", female = "marshal_deputy_outfit"},
            [1] = {male = "marshal_field_outfit", female = "marshal_field_outfit"},
            [2] = {male = "marshal_senior_outfit", female = "marshal_senior_outfit"},
            [3] = {male = "marshal_chief_outfit", female = "marshal_chief_outfit"},
            [4] = {male = "us_marshal_outfit", female = "us_marshal_outfit"},
        },
        
        Vehicles = {
            [0] = {"horse_tennessee", "horse_turkoman"},
            [1] = {"horse_turkoman", "horse_missouri", "wagon_police"},
            [2] = {"horse_missouri", "horse_arabian", "wagon_police"},
            [3] = {"horse_arabian", "wagon_police", "wagon_prison"},
            [4] = {"horse_arabian_rose", "wagon_police", "wagon_prison", "wagon_armored"},
        },
        
        Loadout = {
            Weapons = {
                [0] = {"weapon_revolver_schofield", "weapon_repeater_carbine"},
                [1] = {"weapon_revolver_navy", "weapon_repeater_lancaster", "weapon_shotgun_pump"},
                [2] = {"weapon_revolver_navy", "weapon_repeater_lancaster", "weapon_shotgun_pump"},
                [3] = {"weapon_revolver_navy", "weapon_repeater_evans", "weapon_shotgun_pump", "weapon_rifle_boltaction"},
                [4] = {"weapon_revolver_navy", "weapon_repeater_evans", "weapon_shotgun_repeating", "weapon_rifle_boltaction", "weapon_sniperrifle_rollingblock"},
            },
            Items = {
                [0] = {"rope", "notebook", "bandages", "lantern"},
                [1] = {"rope", "notebook", "bandages", "lantern", "binoculars"},
                [2] = {"rope", "notebook", "bandages", "lantern", "binoculars", "camera"},
                [3] = {"rope", "notebook", "bandages", "lantern", "binoculars", "camera", "lockpick"},
                [4] = {"rope", "notebook", "bandages", "lantern", "binoculars", "camera", "lockpick", "safe_cracker"},
            }
        }
    },
    
    ["ranger"] = {
        Enabled = true,
        Label = "State Rangers",
        Type = "state",
        Jurisdiction = "state",
        Color = "#6B8E23",
        Icon = "star_ranger",
        Description = "State law enforcement and frontier protection",
        
        Ranks = {
            [0] = {name = "Ranger Recruit", pay = 8, permissions = {"arrest", "search", "patrol"}},
            [1] = {name = "Ranger", pay = 14, permissions = {"arrest", "search", "patrol", "evidence", "investigate"}},
            [2] = {name = "Senior Ranger", pay = 20, permissions = {"arrest", "search", "patrol", "evidence", "investigate", "warrant"}},
            [3] = {name = "Ranger Captain", pay = 26, permissions = {"arrest", "search", "patrol", "evidence", "investigate", "warrant", "command"}},
            [4] = {name = "Ranger Commander", pay = 32, permissions = {"all"}},
        },
        
        Uniforms = {
            [0] = {male = "ranger_recruit_outfit", female = "ranger_recruit_outfit"},
            [1] = {male = "ranger_outfit", female = "ranger_outfit"},
            [2] = {male = "ranger_senior_outfit", female = "ranger_senior_outfit"},
            [3] = {male = "ranger_captain_outfit", female = "ranger_captain_outfit"},
            [4] = {male = "ranger_commander_outfit", female = "ranger_commander_outfit"},
        },
        
        Vehicles = {
            [0] = {"horse_tennessee", "horse_morgan"},
            [1] = {"horse_turkoman", "horse_missouri"},
            [2] = {"horse_missouri", "horse_arabian"},
            [3] = {"horse_arabian", "wagon_supply"},
            [4] = {"horse_arabian_rose", "wagon_supply", "wagon_armored"},
        },
        
        Loadout = {
            Weapons = {
                [0] = {"weapon_revolver_cattleman", "weapon_repeater_carbine"},
                [1] = {"weapon_revolver_schofield", "weapon_repeater_lancaster", "weapon_bow"},
                [2] = {"weapon_revolver_navy", "weapon_repeater_lancaster", "weapon_rifle_springfield", "weapon_bow"},
                [3] = {"weapon_revolver_navy", "weapon_repeater_evans", "weapon_rifle_boltaction", "weapon_bow"},
                [4] = {"weapon_revolver_navy", "weapon_repeater_evans", "weapon_rifle_boltaction", "weapon_sniperrifle_rollingblock"},
            },
            Items = {
                [0] = {"rope", "notebook", "bandages", "compass"},
                [1] = {"rope", "notebook", "bandages", "compass", "binoculars", "lantern"},
                [2] = {"rope", "notebook", "bandages", "compass", "binoculars", "lantern", "tent"},
                [3] = {"rope", "notebook", "bandages", "compass", "binoculars", "lantern", "tent", "camera"},
                [4] = {"rope", "notebook", "bandages", "compass", "binoculars", "lantern", "tent", "camera", "hunting_kit"},
            }
        }
    },
    
    ["lawman"] = {
        Enabled = true,
        Label = "Town Marshal",
        Type = "municipal",
        Jurisdiction = "town",
        Color = "#DAA520",
        Icon = "star_town",
        Description = "Town law enforcement, appointed by mayor",
        
        Ranks = {
            [0] = {name = "Constable", pay = 6, permissions = {"arrest", "search", "patrol"}},
            [1] = {name = "Deputy Marshal", pay = 10, permissions = {"arrest", "search", "patrol", "evidence"}},
            [2] = {name = "Town Marshal", pay = 16, permissions = {"arrest", "search", "patrol", "evidence", "investigate", "warrant"}},
            [3] = {name = "Chief Marshal", pay = 22, permissions = {"all"}},
            [4] = {name = "Marshal", pay = 28, permissions = {"all"}},
        },
        
        Uniforms = {
            [0] = {male = "constable_outfit", female = "constable_outfit"},
            [1] = {male = "town_deputy_outfit", female = "town_deputy_outfit"},
            [2] = {male = "town_marshal_outfit", female = "town_marshal_outfit"},
            [3] = {male = "chief_marshal_outfit", female = "chief_marshal_outfit"},
            [4] = {male = "marshal_outfit", female = "marshal_outfit"},
        },
        
        Vehicles = {
            [0] = {"horse_tennessee"},
            [1] = {"horse_morgan", "horse_tennessee"},
            [2] = {"horse_turkoman", "wagon_police"},
            [3] = {"horse_missouri", "wagon_police"},
            [4] = {"horse_arabian", "wagon_police"},
        },
        
        Loadout = {
            Weapons = {
                [0] = {"weapon_revolver_cattleman"},
                [1] = {"weapon_revolver_cattleman", "weapon_repeater_carbine"},
                [2] = {"weapon_revolver_schofield", "weapon_repeater_carbine", "weapon_shotgun_doublebarrel"},
                [3] = {"weapon_revolver_navy", "weapon_repeater_lancaster", "weapon_shotgun_pump"},
                [4] = {"weapon_revolver_navy", "weapon_repeater_lancaster", "weapon_shotgun_pump", "weapon_rifle_springfield"},
            },
            Items = {
                [0] = {"rope", "notebook"},
                [1] = {"rope", "notebook", "bandages"},
                [2] = {"rope", "notebook", "bandages", "lantern"},
                [3] = {"rope", "notebook", "bandages", "lantern", "binoculars"},
                [4] = {"rope", "notebook", "bandages", "lantern", "binoculars", "camera"},
            }
        }
    }
}

-- ══════════════════════════════════════════════════════════════
-- SHERIFF'S OFFICES & MARSHAL STATIONS
-- ══════════════════════════════════════════════════════════════
Config.Stations = {
    ["valentine"] = {
        Enabled = true,
        Label = "Valentine Sheriff's Office",
        Type = "sheriff",
        Coords = vec3(-275.5, 804.0, 119.0),
        Heading = 100.0,
        BlipSprite = `blip_proc_sheriff`,
        BlipColor = "WHITE",
        ShowBlip = true,
        
        -- Interaction Points
        Locations = {
            DutyToggle = {coords = vec3(-275.0, 803.5, 119.0), heading = 180.0},
            Armory = {coords = vec3(-278.0, 803.0, 119.5), heading = 90.0},
            RecordsOffice = {coords = vec3(-280.0, 808.0, 119.5), heading = 270.0},
            Telegraph = {coords = vec3(-281.0, 805.0, 119.5), heading = 0.0},
            WantedBoard = {coords = vec3(-279.0, 807.0, 119.5), heading = 90.0},
            EvidenceRoom = {coords = vec3(-277.5, 809.0, 119.5), heading = 180.0},
            Stables = {coords = vec3(-282.0, 800.0, 119.5), heading = 45.0},
            Cells = {
                {coords = vec3(-272.4, 812.1, 118.4), heading = 270.0, occupied = false},
                {coords = vec3(-276.8, 812.1, 118.4), heading = 270.0, occupied = false},
            },
            Gallows = {coords = vec3(-270.0, 820.0, 118.0), heading = 0.0},
            ProcessingDesk = {coords = vec3(-274.0, 806.0, 119.0), heading = 270.0},
        },
        
        -- Storage
        Storage = {
            Armory = {slots = 50, weight = 100000, job = "sheriff", grade = 0},
            Evidence = {slots = 100, weight = 50000, job = "sheriff", grade = 0},
            Personal = {slots = 20, weight = 20000, job = "sheriff", grade = 0},
        },
        
        -- Access Control
        AccessLevel = {
            DutyToggle = 0,
            Armory = 0,
            Records = 0,
            Evidence = 1,
            Telegraph = 0,
            Cells = 1,
            Processing = 1,
        }
    },
    
    ["rhodes"] = {
        Enabled = true,
        Label = "Rhodes Sheriff's Office",
        Type = "sheriff",
        Coords = vec3(1360.5, -1301.0, 77.0),
        Heading = 340.0,
        BlipSprite = `blip_proc_sheriff`,
        BlipColor = "WHITE",
        ShowBlip = true,
        
        Locations = {
            DutyToggle = {coords = vec3(1360.0, -1300.5, 77.0), heading = 180.0},
            Armory = {coords = vec3(1362.0, -1305.0, 77.0), heading = 90.0},
            RecordsOffice = {coords = vec3(1358.0, -1303.0, 77.0), heading = 270.0},
            Telegraph = {coords = vec3(1359.0, -1302.0, 77.0), heading = 0.0},
            WantedBoard = {coords = vec3(1361.0, -1300.0, 77.0), heading = 90.0},
            EvidenceRoom = {coords = vec3(1357.0, -1304.0, 77.0), heading = 180.0},
            Stables = {coords = vec3(1370.0, -1310.0, 76.5), heading = 45.0},
            Cells = {
                {coords = vec3(1363.0, -1298.0, 77.0), heading = 270.0, occupied = false},
            },
            ProcessingDesk = {coords = vec3(1359.5, -1301.0, 77.0), heading = 270.0},
        },
        
        Storage = {
            Armory = {slots = 40, weight = 80000, job = "sheriff", grade = 0},
            Evidence = {slots = 80, weight = 40000, job = "sheriff", grade = 0},
            Personal = {slots = 20, weight = 20000, job = "sheriff", grade = 0},
        },
        
        AccessLevel = {
            DutyToggle = 0,
            Armory = 0,
            Records = 0,
            Evidence = 1,
            Telegraph = 0,
            Cells = 1,
            Processing = 1,
        }
    },
    
    ["strawberry"] = {
        Enabled = true,
        Label = "Strawberry Sheriff's Office",
        Type = "sheriff",
        Coords = vec3(-1810.0, -354.0, 164.0),
        Heading = 120.0,
        BlipSprite = `blip_proc_sheriff`,
        BlipColor = "WHITE",
        ShowBlip = true,
        
        Locations = {
            DutyToggle = {coords = vec3(-1809.5, -353.5, 164.0), heading = 180.0},
            Armory = {coords = vec3(-1813.0, -355.0, 164.0), heading = 90.0},
            RecordsOffice = {coords = vec3(-1808.0, -356.0, 164.0), heading = 270.0},
            Telegraph = {coords = vec3(-1809.0, -355.0, 164.0), heading = 0.0},
            WantedBoard = {coords = vec3(-1811.0, -353.0, 164.0), heading = 90.0},
            EvidenceRoom = {coords = vec3(-1812.5, -357.0, 164.0), heading = 180.0},
            Stables = {coords = vec3(-1820.0, -360.0, 163.5), heading = 45.0},
            Cells = {
                {coords = vec3(-1812.0, -351.0, 164.0), heading = 270.0, occupied = false},
            },
            ProcessingDesk = {coords = vec3(-1810.0, -354.5, 164.0), heading = 270.0},
        },
        
        Storage = {
            Armory = {slots = 35, weight = 70000, job = "sheriff", grade = 0},
            Evidence = {slots = 60, weight = 30000, job = "sheriff", grade = 0},
            Personal = {slots = 20, weight = 20000, job = "sheriff", grade = 0},
        },
        
        AccessLevel = {
            DutyToggle = 0,
            Armory = 0,
            Records = 0,
            Evidence = 1,
            Telegraph = 0,
            Cells = 1,
            Processing = 1,
        }
    },
    
    ["blackwater"] = {
        Enabled = true,
        Label = "Blackwater Marshal's Office",
        Type = "marshal",
        Coords = vec3(-761.0, -1268.0, 44.0),
        Heading = 180.0,
        BlipSprite = `blip_proc_law`,
        BlipColor = "BLUE",
        ShowBlip = true,
        
        Locations = {
            DutyToggle = {coords = vec3(-760.5, -1267.5, 44.0), heading = 180.0},
            Armory = {coords = vec3(-759.0, -1272.0, 44.0), heading = 90.0},
            RecordsOffice = {coords = vec3(-763.0, -1270.0, 44.0), heading = 270.0},
            Telegraph = {coords = vec3(-762.0, -1269.0, 44.0), heading = 0.0},
            WantedBoard = {coords = vec3(-760.0, -1267.0, 44.0), heading = 90.0},
            EvidenceRoom = {coords = vec3(-764.0, -1271.0, 44.0), heading = 180.0},
            Stables = {coords = vec3(-770.0, -1275.0, 43.5), heading = 45.0},
            Cells = {
                {coords = vec3(-758.0, -1265.0, 44.0), heading = 270.0, occupied = false},
                {coords = vec3(-764.0, -1265.0, 44.0), heading = 270.0, occupied = false},
            },
            ProcessingDesk = {coords = vec3(-761.5, -1268.5, 44.0), heading = 270.0},
        },
        
        Storage = {
            Armory = {slots = 60, weight = 120000, job = "marshal", grade = 0},
            Evidence = {slots = 120, weight = 60000, job = "marshal", grade = 0},
            Personal = {slots = 25, weight = 25000, job = "marshal", grade = 0},
        },
        
        AccessLevel = {
            DutyToggle = 0,
            Armory = 0,
            Records = 0,
            Evidence = 1,
            Telegraph = 0,
            Cells = 1,
            Processing = 1,
        }
    },
    
    ["tumbleweed"] = {
        Enabled = true,
        Label = "Tumbleweed Sheriff's Office",
        Type = "sheriff",
        Coords = vec3(-5527.0, -2950.0, -2.0),
        Heading = 90.0,
        BlipSprite = `blip_proc_sheriff`,
        BlipColor = "WHITE",
        ShowBlip = true,
        
        Locations = {
            DutyToggle = {coords = vec3(-5526.5, -2949.5, -2.0), heading = 180.0},
            Armory = {coords = vec3(-5525.0, -2954.0, -2.0), heading = 90.0},
            RecordsOffice = {coords = vec3(-5529.0, -2952.0, -2.0), heading = 270.0},
            Telegraph = {coords = vec3(-5528.0, -2951.0, -2.0), heading = 0.0},
            WantedBoard = {coords = vec3(-5526.0, -2949.0, -2.0), heading = 90.0},
            EvidenceRoom = {coords = vec3(-5530.0, -2953.0, -2.0), heading = 180.0},
            Stables = {coords = vec3(-5535.0, -2960.0, -2.5), heading = 45.0},
            Cells = {
                {coords = vec3(-5524.0, -2948.0, -2.0), heading = 270.0, occupied = false},
            },
            ProcessingDesk = {coords = vec3(-5527.5, -2950.5, -2.0), heading = 270.0},
        },
        
        Storage = {
            Armory = {slots = 30, weight = 60000, job = "sheriff", grade = 0},
            Evidence = {slots = 50, weight = 25000, job = "sheriff", grade = 0},
            Personal = {slots = 15, weight = 15000, job = "sheriff", grade = 0},
        },
        
        AccessLevel = {
            DutyToggle = 0,
            Armory = 0,
            Records = 0,
            Evidence = 1,
            Telegraph = 0,
            Cells = 1,
            Processing = 1,
        }
    },
    
    ["annesburg"] = {
        Enabled = true,
        Label = "Annesburg Sheriff's Office",
        Type = "sheriff",
        Coords = vec3(2906.0, 1308.0, 45.0),
        Heading = 60.0,
        BlipSprite = `blip_proc_sheriff`,
        BlipColor = "WHITE",
        ShowBlip = true,
        
        Locations = {
            DutyToggle = {coords = vec3(2905.5, 1307.5, 45.0), heading = 180.0},
            Armory = {coords = vec3(2909.0, 1307.0, 45.0), heading = 90.0},
            RecordsOffice = {coords = vec3(2904.0, 1306.0, 45.0), heading = 270.0},
            Telegraph = {coords = vec3(2905.0, 1307.0, 45.0), heading = 0.0},
            WantedBoard = {coords = vec3(2907.0, 1309.0, 45.0), heading = 90.0},
            EvidenceRoom = {coords = vec3(2903.0, 1305.0, 45.0), heading = 180.0},
            Stables = {coords = vec3(2915.0, 1300.0, 44.5), heading = 45.0},
            Cells = {
                {coords = vec3(2908.0, 1310.0, 45.0), heading = 270.0, occupied = false},
            },
            ProcessingDesk = {coords = vec3(2906.5, 1308.5, 45.0), heading = 270.0},
        },
        
        Storage = {
            Armory = {slots = 35, weight = 70000, job = "sheriff", grade = 0},
            Evidence = {slots = 60, weight = 30000, job = "sheriff", grade = 0},
            Personal = {slots = 20, weight = 20000, job = "sheriff", grade = 0},
        },
        
        AccessLevel = {
            DutyToggle = 0,
            Armory = 0,
            Records = 0,
            Evidence = 1,
            Telegraph = 0,
            Cells = 1,
            Processing = 1,
        }
    },
    
    ["sisika"] = {
        Enabled = true,
        Label = "Sisika Penitentiary",
        Type = "prison",
        Coords = vec3(3328.0, -670.0, 45.0),
        Heading = 0.0,
        BlipSprite = `blip_proc_home`,
        BlipColor = "RED",
        ShowBlip = true,
        
        Locations = {
            DutyToggle = {coords = vec3(3327.5, -669.5, 45.0), heading = 180.0},
            Armory = {coords = vec3(3326.0, -672.0, 45.0), heading = 90.0},
            RecordsOffice = {coords = vec3(3330.0, -671.0, 45.0), heading = 270.0},
            Cells = {
                {coords = vec3(3330.0, -668.0, 45.0), heading = 270.0, occupied = false},
                {coords = vec3(3332.0, -668.0, 45.0), heading = 270.0, occupied = false},
                {coords = vec3(3334.0, -668.0, 45.0), heading = 270.0, occupied = false},
                {coords = vec3(3336.0, -668.0, 45.0), heading = 270.0, occupied = false},
                {coords = vec3(3338.0, -668.0, 45.0), heading = 270.0, occupied = false},
            },
            ChainGangArea = {coords = vec3(3340.0, -680.0, 45.0), heading = 0.0},
            WorkYard = {coords = vec3(3345.0, -675.0, 45.0), heading = 90.0},
            ReleasePoint = {coords = vec3(3325.0, -665.0, 45.0), heading = 180.0},
            Visitation = {coords = vec3(3329.0, -673.0, 45.0), heading = 0.0},
        },
        
        Storage = {
            Armory = {slots = 40, weight = 80000, job = "sheriff", grade = 2},
            Evidence = {slots = 100, weight = 50000, job = "sheriff", grade = 1},
            Property = {slots = 200, weight = 100000, job = "sheriff", grade = 0},
        },
        
        AccessLevel = {
            DutyToggle = 0,
            Armory = 2,
            Records = 1,
            Cells = 0,
            ChainGang = 1,
        }
    }
}

-- ══════════════════════════════════════════════════════════════
-- JAIL & PRISON SYSTEM
-- ══════════════════════════════════════════════════════════════
Config.Jail = {
    Enabled = true,
    
    -- Sentence Parameters
    MinimumSentence = 60, -- 1 minute minimum
    MaximumSentence = 3600, -- 1 hour maximum
    LocalJailThreshold = 600, -- Under 10 minutes = local jail, over = Sisika
    
    -- Parole & Release
    ParoleEligibility = 0.5, -- 50% of sentence served
    ParoleChance = 0.7, -- 70% chance of parole approval
    BailMultiplier = 3, -- Bail is 3x the fine
    AllowBailForCapital = false, -- No bail for capital crimes
    
    -- Chain Gang Work
    ChainGangEnabled = true,
    ChainGangReduction = 30, -- Seconds reduced per job
    ChainGangJobs = {
        {name = "Rock Breaking", time = 15000, reduction = 30, difficulty = "easy"},
        {name = "Laundry Service", time = 20000, reduction = 45, difficulty = "medium"},
        {name = "Kitchen Duty", time = 25000, reduction = 60, difficulty = "medium"},
        {name = "Wood Chopping", time = 18000, reduction = 35, difficulty = "easy"},
        {name = "Cleaning Cells", time = 12000, reduction = 25, difficulty = "easy"},
    },
    
    -- Prisoner Management
    ClothingChange = true, -- Change to prison clothes
    RemoveWeapons = true,
    RemoveItems = {
        "weapon_*", -- All weapons
        "lockpick",
        "rope",
        -- Add items to remove
    },
    ReturnItemsOnRelease = true,
    
    -- Visitation
    VisitationEnabled = true,
    VisitationHours = {start = 8, finish = 17}, -- 8 AM to 5 PM
    VisitationDuration = 300, -- 5 minutes
    VisitationDistance = 5.0, -- Meters
    
    -- Escape System
    EscapeEnabled = true,
    EscapeWantedLevel = 5, -- Stars added for escape
    EscapeBounty = 500, -- Bounty added
    EscapeAlertRadius = 1000, -- Meters to alert lawmen
    
    -- Prison Riot
    RiotEnabled = false,
    RiotChance = 0.01, -- 1% chance per hour
}

-- ══════════════════════════════════════════════════════════════
-- WILD WEST CRIMES & VIOLATIONS (1899 Laws)
-- ══════════════════════════════════════════════════════════════
Config.Crimes = {
    -- ════════════════════════════════════════════════════════
    -- CAPITAL OFFENSES (Hanging/Execution)
    -- ════════════════════════════════════════════════════════
    ["murder_first"] = {
        Enabled = true,
        Label = "Murder in the First Degree",
        Category = "capital",
        JailTime = 3600, -- 1 hour
        Fine = 500,
        Bounty = 1000,
        Description = "Premeditated unlawful killing of another person",
        Execution = true,
        ExecutionMethod = "hanging", -- "hanging", "firing_squad"
        AllowBail = false,
        Historical = true, -- Historically accurate crime
    },
    
    ["murder_second"] = {
        Enabled = true,
        Label = "Murder in the Second Degree",
        Category = "capital",
        JailTime = 2400,
        Fine = 350,
        Bounty = 750,
        Description = "Unlawful killing without premeditation",
        Execution = false,
        AllowBail = false,
        Historical = true,
    },
    
    ["horse_theft"] = {
        Enabled = true,
        Label = "Horse Theft",
        Category = "capital",
        JailTime = 1800,
        Fine = 300,
        Bounty = 600,
        Description = "Stealing a horse (capital offense in 1899)",
        Execution = true,
        ExecutionMethod = "hanging",
        AllowBail = false,
        Historical = true,
        Note = "Horse theft was often punishable by death in the Old West"
    },
    
    ["train_robbery"] = {
        Enabled = true,
        Label = "Train Robbery",
        Category = "capital",
        JailTime = 2400,
        Fine = 1000,
        Bounty = 1500,
        Description = "Robbing a railroad train",
        Execution = false,
        AllowBail = false,
        Historical = true,
    },
    
    ["bank_robbery"] = {
        Enabled = true,
        Label = "Bank Robbery",
        Category = "capital",
        JailTime = 1800,
        Fine = 800,
        Bounty = 1200,
        Description = "Robbing a bank or financial institution",
        Execution = false,
        AllowBail = false,
        Historical = true,
    },
    
    -- ════════════════════════════════════════════════════════
    -- FELONIES
    -- ════════════════════════════════════════════════════════
    ["cattle_rustling"] = {
        Enabled = true,
        Label = "Cattle Rustling",
        Category = "felony",
        JailTime = 900,
        Fine = 400,
        Bounty = 500,
        Description = "Stealing cattle or livestock",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["stage_robbery"] = {
        Enabled = true,
        Label = "Stagecoach Robbery",
        Category = "felony",
        JailTime = 1200,
        Fine = 600,
        Bounty = 800,
        Description = "Robbing a stagecoach",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["claim_jumping"] = {
        Enabled = true,
        Label = "Claim Jumping",
        Category = "felony",
        JailTime = 600,
        Fine = 200,
        Bounty = 300,
        Description = "Illegally occupying someone's mining claim",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["arson"] = {
        Enabled = true,
        Label = "Arson",
        Category = "felony",
        JailTime = 1200,
        Fine = 500,
        Bounty = 700,
        Description = "Intentionally setting fire to property",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["kidnapping"] = {
        Enabled = true,
        Label = "Kidnapping",
        Category = "felony",
        JailTime = 1500,
        Fine = 600,
        Bounty = 900,
        Description = "Unlawfully abducting a person",
        Execution = false,
        AllowBail = false,
        Historical = true,
    },
    
    ["forgery"] = {
        Enabled = true,
        Label = "Forgery",
        Category = "felony",
        JailTime = 600,
        Fine = 250,
        Bounty = 350,
        Description = "Creating or altering false documents",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["counterfeiting"] = {
        Enabled = true,
        Label = "Counterfeiting",
        Category = "felony",
        JailTime = 900,
        Fine = 400,
        Bounty = 600,
        Description = "Creating false currency",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    -- ════════════════════════════════════════════════════════
    -- MISDEMEANORS
    -- ════════════════════════════════════════════════════════
    ["disturbing_peace"] = {
        Enabled = true,
        Label = "Disturbing the Peace",
        Category = "misdemeanor",
        JailTime = 180,
        Fine = 25,
        Bounty = 0,
        Description = "Creating public disturbance",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["public_intoxication"] = {
        Enabled = true,
        Label = "Public Intoxication",
        Category = "misdemeanor",
        JailTime = 120,
        Fine = 15,
        Bounty = 0,
        Description = "Being drunk in public",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["brawling"] = {
        Enabled = true,
        Label = "Brawling",
        Category = "misdemeanor",
        JailTime = 240,
        Fine = 50,
        Bounty = 0,
        Description = "Fighting in public",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["trespassing"] = {
        Enabled = true,
        Label = "Trespassing",
        Category = "misdemeanor",
        JailTime = 300,
        Fine = 75,
        Bounty = 100,
        Description = "Unlawfully entering private property",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["illegal_gambling"] = {
        Enabled = true,
        Label = "Illegal Gambling",
        Category = "misdemeanor",
        JailTime = 180,
        Fine = 40,
        Bounty = 0,
        Description = "Participating in unlawful gambling",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["moonshining"] = {
        Enabled = true,
        Label = "Moonshining",
        Category = "misdemeanor",
        JailTime = 600,
        Fine = 150,
        Bounty = 200,
        Description = "Illegal alcohol production",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["weapons_in_town"] = {
        Enabled = true,
        Label = "Brandishing Weapons",
        Category = "misdemeanor",
        JailTime = 120,
        Fine = 30,
        Bounty = 0,
        Description = "Carrying weapons within town limits",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["petty_theft"] = {
        Enabled = true,
        Label = "Petty Theft",
        Category = "misdemeanor",
        JailTime = 300,
        Fine = 100,
        Bounty = 150,
        Description = "Stealing property of low value",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["vagrancy"] = {
        Enabled = true,
        Label = "Vagrancy",
        Category = "misdemeanor",
        JailTime = 60,
        Fine = 10,
        Bounty = 0,
        Description = "Loitering without visible means of support",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["indecent_exposure"] = {
        Enabled = true,
        Label = "Indecent Exposure",
        Category = "misdemeanor",
        JailTime = 180,
        Fine = 35,
        Bounty = 0,
        Description = "Public nudity or lewd behavior",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["resisting_arrest"] = {
        Enabled = true,
        Label = "Resisting Arrest",
        Category = "misdemeanor",
        JailTime = 300,
        Fine = 100,
        Bounty = 150,
        Description = "Resisting lawful detention",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
    
    ["contempt_of_court"] = {
        Enabled = true,
        Label = "Contempt of Court",
        Category = "misdemeanor",
        JailTime = 240,
        Fine = 75,
        Bounty = 0,
        Description = "Disrespecting the court",
        Execution = false,
        AllowBail = true,
        Historical = true,
    },
}

-- ══════════════════════════════════════════════════════════════
-- CONTINUE IN NEXT FILE DUE TO LENGTH...
-- ══════════════════════════════════════════════════════════════

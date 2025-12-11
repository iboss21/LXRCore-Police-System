-- Additional Law Enforcement Tools & Items Configuration

-- This file defines all wearable and usable items for lawmen in 1899

Config.WearableItems = {
    -- ════════════════════════════════════════════════════════
    -- BADGES (Worn on Chest/Vest)
    -- ════════════════════════════════════════════════════════
    Badges = {
        ["badge_sheriff_star"] = {
            label = "Sheriff's Star Badge",
            model = `p_cs_badge01x`,
            attachment = "chest_left",
            description = "Five-pointed star badge, county sheriff",
            value = 50,
            rare = true,
            jobs = {"sheriff"}
        },
        ["badge_deputy_shield"] = {
            label = "Deputy Shield Badge",
            model = `p_cs_badge02x`,
            attachment = "chest_left",
            description = "Shield-style deputy badge",
            value = 30,
            jobs = {"sheriff"}
        },
        ["badge_us_marshal"] = {
            label = "US Marshal Badge",
            model = `p_cs_badge03x`,
            attachment = "chest_left",
            description = "Federal marshal badge with eagle",
            value = 100,
            rare = true,
            jobs = {"marshal"}
        },
        ["badge_texas_ranger"] = {
            label = "Texas Ranger Badge",
            model = `p_cs_badge04x`,
            attachment = "chest_left",
            description = "Legendary ranger badge in circle",
            value = 150,
            rare = true,
            jobs = {"ranger"}
        },
        ["badge_constable"] = {
            label = "Constable Badge",
            model = `p_cs_badge05x`,
            attachment = "chest_left",
            description = "Town constable badge",
            value = 25,
            jobs = {"lawman"}
        },
        ["badge_temporary_deputy"] = {
            label = "Temporary Deputy Badge",
            model = `p_cs_badge02x`,
            attachment = "chest_left",
            description = "Temporary deputization badge",
            value = 10,
            temporary = true,
            duration = 3600 -- 1 hour
        },
    },
    
    -- ════════════════════════════════════════════════════════
    -- BELT ITEMS (Worn on Waist/Hip)
    -- ════════════════════════════════════════════════════════
    BeltItems = {
        ["handcuffs_iron"] = {
            label = "Iron Handcuffs",
            model = `p_cs_cuffs01x`,
            attachment = "belt_left",
            description = "Heavy iron handcuffs with chain",
            value = 15,
            weight = 500,
            usable = true
        },
        ["rope_lasso"] = {
            label = "Coiled Rope",
            model = `p_rope01x`,
            attachment = "belt_right",
            description = "Hemp rope for restraining suspects",
            value = 5,
            weight = 800,
            usable = true
        },
        ["baton_wood"] = {
            label = "Wooden Baton",
            model = `w_melee_club01`,
            attachment = "belt_back",
            description = "Hardwood police baton",
            value = 8,
            weight = 600,
            usable = true,
            rank_required = 2
        },
        ["baton_metal"] = {
            label = "Metal Baton",
            model = `w_melee_club02`,
            attachment = "belt_back",
            description = "Metal reinforced baton",
            value = 12,
            weight = 800,
            usable = true,
            rank_required = 3
        },
        ["keys_jail"] = {
            label = "Jail Cell Keys",
            model = `p_key01x`,
            attachment = "belt_left",
            description = "Keys to jail cells",
            value = 20,
            weight = 100,
            rank_required = 1
        },
        ["holster_leather"] = {
            label = "Leather Gun Belt",
            model = `p_holster01x`,
            attachment = "belt_center",
            description = "Leather gun belt with holster",
            value = 25,
            weight = 1000
        },
    },
    
    -- ════════════════════════════════════════════════════════
    -- POCKET/VEST ITEMS (Worn on Upper Body)
    -- ════════════════════════════════════════════════════════
    PocketItems = {
        ["pocket_watch_brass"] = {
            label = "Brass Pocket Watch",
            model = `p_pocketwatch01x`,
            attachment = "vest_pocket",
            description = "Brass pocket watch with chain",
            value = 35,
            weight = 200,
            usable = true
        },
        ["pocket_watch_silver"] = {
            label = "Silver Pocket Watch",
            model = `p_pocketwatch02x`,
            attachment = "vest_pocket",
            description = "Silver pocket watch, engraved",
            value = 75,
            weight = 250,
            usable = true,
            rank_required = 3
        },
        ["whistle_brass"] = {
            label = "Police Whistle",
            model = `p_whistle01x`,
            attachment = "vest_chain",
            description = "Brass whistle for signaling",
            value = 5,
            weight = 50,
            usable = true
        },
        ["compass_brass"] = {
            label = "Brass Compass",
            model = `p_compass01x`,
            attachment = "vest_pocket",
            description = "Navigation compass",
            value = 20,
            weight = 150,
            usable = true,
            jobs = {"ranger"}
        },
    },
    
    -- ════════════════════════════════════════════════════════
    -- HAND TOOLS (Held in Hand)
    -- ════════════════════════════════════════════════════════
    HandTools = {
        ["notebook_leather"] = {
            label = "Leather Notebook",
            model = `p_notebook01x`,
            attachment = "hand_left",
            description = "Leather-bound investigation journal",
            value = 10,
            weight = 300,
            usable = true,
            pages = 100
        },
        ["pencil"] = {
            label = "Pencil",
            model = `p_pencil01x`,
            attachment = "hand_right",
            description = "Writing pencil",
            value = 1,
            weight = 10,
            usable = true
        },
        ["lantern_oil"] = {
            label = "Oil Lantern",
            model = `p_cs_lantern01x`,
            attachment = "hand_left",
            description = "Kerosene lantern for night work",
            value = 15,
            weight = 800,
            usable = true,
            fuel_capacity = 100
        },
        ["torch"] = {
            label = "Wooden Torch",
            model = `p_torch01x`,
            attachment = "hand_left",
            description = "Burning torch for light",
            value = 2,
            weight = 400,
            usable = true,
            duration = 300 -- 5 minutes
        },
        ["magnifying_glass"] = {
            label = "Magnifying Glass",
            model = `p_magnify01x`,
            attachment = "hand_right",
            description = "For examining evidence closely",
            value = 25,
            weight = 150,
            usable = true,
            rank_required = 2
        },
    },
    
    -- ════════════════════════════════════════════════════════
    -- BACK ITEMS (Worn on Back/Shoulder)
    -- ════════════════════════════════════════════════════════
    BackItems = {
        ["rifle_carbine_back"] = {
            label = "Carbine Repeater (Back)",
            model = `w_repeater_carbine01`,
            attachment = "back",
            description = "Carbine stored on back",
            value = 0,
            weight = 3500,
            visual_only = true
        },
        ["shotgun_pump_back"] = {
            label = "Pump Shotgun (Back)",
            model = `w_shotgun_pump01`,
            attachment = "back",
            description = "Shotgun stored on back",
            value = 0,
            weight = 4000,
            visual_only = true
        },
        ["rifle_bolt_back"] = {
            label = "Bolt-Action Rifle (Back)",
            model = `w_rifle_boltaction01`,
            attachment = "back",
            description = "Rifle stored on back",
            value = 0,
            weight = 4200,
            visual_only = true,
            rank_required = 3
        },
        ["satchel_leather"] = {
            label = "Leather Satchel",
            model = `p_satchel01x`,
            attachment = "back",
            description = "Leather bag for carrying items",
            value = 30,
            weight = 500,
            storage_slots = 10
        },
    },
    
    -- ════════════════════════════════════════════════════════
    -- HEAD ITEMS (Worn on Head)
    -- ════════════════════════════════════════════════════════
    HeadItems = {
        ["hat_sheriff"] = {
            label = "Sheriff's Hat",
            model = `p_hat01x`,
            attachment = "head",
            description = "Wide-brim sheriff's hat",
            value = 20,
            weight = 200,
            jobs = {"sheriff"}
        },
        ["hat_marshal"] = {
            label = "Marshal's Hat",
            model = `p_hat02x`,
            attachment = "head",
            description = "Federal marshal's hat",
            value = 30,
            weight = 250,
            jobs = {"marshal"}
        },
        ["hat_ranger"] = {
            label = "Ranger's Hat",
            model = `p_hat03x`,
            attachment = "head",
            description = "Ranger's campaign hat",
            value = 25,
            weight = 220,
            jobs = {"ranger"}
        },
    },
    
    -- ════════════════════════════════════════════════════════
    -- INVESTIGATION TOOLS (Specialized)
    -- ════════════════════════════════════════════════════════
    InvestigationTools = {
        ["camera_1899"] = {
            label = "Box Camera",
            model = `p_camera01x`,
            attachment = "hand_held",
            description = "1899 box camera for evidence photos",
            value = 150,
            weight = 2000,
            usable = true,
            rank_required = 3,
            film_capacity = 12
        },
        ["fingerprint_kit"] = {
            label = "Fingerprint Kit",
            model = `p_case01x`,
            attachment = "hand_held",
            description = "Kit for collecting fingerprints",
            value = 75,
            weight = 1500,
            usable = true,
            rank_required = 2,
            uses = 20
        },
        ["evidence_bag"] = {
            label = "Evidence Bag",
            model = `p_bag01x`,
            attachment = "hand_held",
            description = "Bag for collecting evidence",
            value = 2,
            weight = 50,
            usable = true,
            stackable = true
        },
        ["measuring_tape"] = {
            label = "Measuring Tape",
            model = `p_tape01x`,
            attachment = "belt",
            description = "Tape measure for crime scenes",
            value = 10,
            weight = 200,
            usable = true
        },
        ["specimen_jar"] = {
            label = "Specimen Jar",
            model = `p_jar01x`,
            attachment = "hand_held",
            description = "Glass jar for samples",
            value = 5,
            weight = 300,
            usable = true,
            stackable = true
        },
    },
    
    -- ════════════════════════════════════════════════════════
    -- DOCUMENT ITEMS (Papers)
    -- ════════════════════════════════════════════════════════
    Documents = {
        ["warrant_arrest"] = {
            label = "Arrest Warrant",
            model = `p_paper01x`,
            attachment = "pocket",
            description = "Official arrest warrant",
            value = 5,
            weight = 10,
            usable = true,
            stackable = true
        },
        ["warrant_search"] = {
            label = "Search Warrant",
            model = `p_paper01x`,
            attachment = "pocket",
            description = "Property search warrant",
            value = 5,
            weight = 10,
            usable = true,
            stackable = true
        },
        ["wanted_poster"] = {
            label = "Wanted Poster",
            model = `p_poster01x`,
            attachment = "hand_held",
            description = "Wanted poster for criminal",
            value = 2,
            weight = 25,
            usable = true,
            stackable = true
        },
        ["citation_form"] = {
            label = "Citation Form",
            model = `p_paper01x`,
            attachment = "pocket",
            description = "Blank citation form",
            value = 1,
            weight = 10,
            usable = true,
            stackable = true
        },
        ["telegraph_paper"] = {
            label = "Telegraph Message",
            model = `p_telegram01x`,
            attachment = "pocket",
            description = "Telegraph message paper",
            value = 1,
            weight = 5,
            usable = true,
            stackable = true
        },
    },
    
    -- ════════════════════════════════════════════════════════
    -- MEDICAL ITEMS (First Aid)
    -- ════════════════════════════════════════════════════════
    Medical = {
        ["bandage_cloth"] = {
            label = "Cloth Bandage",
            model = `p_bandage01x`,
            attachment = "belt_pouch",
            description = "Cloth bandage for wounds",
            value = 5,
            weight = 100,
            usable = true,
            stackable = true,
            heals = 20
        },
        ["medicine_bottle"] = {
            label = "Medicine Bottle",
            model = `p_bottle01x`,
            attachment = "belt_pouch",
            description = "Medicinal tonic",
            value = 15,
            weight = 200,
            usable = true,
            stackable = true,
            heals = 50
        },
        ["first_aid_kit"] = {
            label = "First Aid Kit",
            model = `p_case02x`,
            attachment = "satchel",
            description = "Complete first aid supplies",
            value = 50,
            weight = 1000,
            usable = true,
            uses = 5,
            rank_required = 2
        },
    },
}

-- Attachment bone configuration
Config.AttachmentBones = {
    ["chest_left"] = {bone = "SKEL_Spine3", offset = {x = 0.12, y = 0.05, z = 0.0}},
    ["chest_right"] = {bone = "SKEL_Spine3", offset = {x = -0.12, y = 0.05, z = 0.0}},
    ["belt_left"] = {bone = "SKEL_Pelvis", offset = {x = -0.15, y = -0.05, z = 0.0}},
    ["belt_right"] = {bone = "SKEL_Pelvis", offset = {x = 0.15, y = -0.05, z = 0.0}},
    ["belt_back"] = {bone = "SKEL_Pelvis", offset = {x = 0.0, y = -0.15, z = 0.0}},
    ["belt_center"] = {bone = "SKEL_Pelvis", offset = {x = 0.0, y = 0.05, z = 0.0}},
    ["back"] = {bone = "SKEL_Spine_Root", offset = {x = 0.0, y = -0.15, z = 0.05}},
    ["hand_left"] = {bone = "SKEL_L_Hand", offset = {x = 0.05, y = 0.0, z = 0.0}},
    ["hand_right"] = {bone = "SKEL_R_Hand", offset = {x = 0.05, y = 0.0, z = 0.0}},
    ["vest_pocket"] = {bone = "SKEL_Spine2", offset = {x = 0.15, y = 0.05, z = 0.0}},
    ["vest_chain"] = {bone = "SKEL_Spine2", offset = {x = 0.08, y = 0.08, z = 0.0}},
    ["head"] = {bone = "SKEL_Head", offset = {x = 0.0, y = 0.0, z = 0.0}},
}

-- Default loadouts by job and rank
Config.DefaultLoadouts = {
    ["sheriff"] = {
        [0] = {"badge_deputy_shield", "rope_lasso", "whistle_brass", "notebook_leather"},
        [1] = {"badge_deputy_shield", "rope_lasso", "handcuffs_iron", "whistle_brass", "notebook_leather", "lantern_oil"},
        [2] = {"badge_deputy_shield", "rope_lasso", "handcuffs_iron", "baton_wood", "notebook_leather", "magnifying_glass"},
        [3] = {"badge_deputy_shield", "rope_lasso", "handcuffs_iron", "baton_metal", "camera_1899", "fingerprint_kit"},
        [4] = {"badge_sheriff_star", "rope_lasso", "handcuffs_iron", "baton_metal", "pocket_watch_silver", "camera_1899", "keys_jail"},
    },
    ["marshal"] = {
        [0] = {"badge_us_marshal", "rope_lasso", "handcuffs_iron", "notebook_leather", "lantern_oil"},
        [1] = {"badge_us_marshal", "rope_lasso", "handcuffs_iron", "baton_wood", "notebook_leather", "magnifying_glass"},
        [2] = {"badge_us_marshal", "rope_lasso", "handcuffs_iron", "baton_metal", "camera_1899", "fingerprint_kit"},
        [3] = {"badge_us_marshal", "rope_lasso", "handcuffs_iron", "baton_metal", "camera_1899", "fingerprint_kit", "pocket_watch_silver"},
        [4] = {"badge_us_marshal", "rope_lasso", "handcuffs_iron", "baton_metal", "camera_1899", "fingerprint_kit", "pocket_watch_silver", "keys_jail"},
    },
    ["ranger"] = {
        [0] = {"badge_texas_ranger", "rope_lasso", "notebook_leather", "compass_brass"},
        [1] = {"badge_texas_ranger", "rope_lasso", "handcuffs_iron", "notebook_leather", "compass_brass", "lantern_oil"},
        [2] = {"badge_texas_ranger", "rope_lasso", "handcuffs_iron", "baton_wood", "compass_brass", "magnifying_glass"},
        [3] = {"badge_texas_ranger", "rope_lasso", "handcuffs_iron", "baton_metal", "compass_brass", "camera_1899"},
        [4] = {"badge_texas_ranger", "rope_lasso", "handcuffs_iron", "baton_metal", "compass_brass", "camera_1899", "pocket_watch_brass"},
    },
    ["lawman"] = {
        [0] = {"badge_constable", "rope_lasso", "notebook_leather"},
        [1] = {"badge_constable", "rope_lasso", "handcuffs_iron", "notebook_leather"},
        [2] = {"badge_constable", "rope_lasso", "handcuffs_iron", "baton_wood", "lantern_oil"},
        [3] = {"badge_constable", "rope_lasso", "handcuffs_iron", "baton_wood", "magnifying_glass"},
        [4] = {"badge_constable", "rope_lasso", "handcuffs_iron", "baton_metal", "camera_1899"},
    },
}

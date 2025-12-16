--[[
    ╔════════════════════════════════════════════════════════════╗
    ║  The Land of Wolves RP - Law Enforcement System           ║
    ║  K9 DOG SYSTEM CONFIGURATION                               ║
    ║  Period-Accurate 1899 Police Dogs                          ║
    ║  www.wolves.land                                          ║
    ╚════════════════════════════════════════════════════════════╝
]]

Config.K9 = {}

-- ══════════════════════════════════════════════════════════════
-- K9 SYSTEM SETTINGS
-- ══════════════════════════════════════════════════════════════
Config.K9.Enabled = true
Config.K9.RequiredGrade = 2 -- Minimum rank to handle K9
Config.K9.MaxDistance = 50.0 -- Max distance from handler
Config.K9.FollowDistance = 2.5 -- Distance to follow handler
Config.K9.CommandDistance = 10.0 -- Max distance for commands

-- ══════════════════════════════════════════════════════════════
-- PERIOD-ACCURATE DOG BREEDS (1899)
-- ══════════════════════════════════════════════════════════════
Config.K9.Breeds = {
    {
        name = "Bloodhound",
        model = "A_C_DogBloodhound_01", -- RedM bloodhound model
        label = "Bloodhound",
        description = "Expert tracker with incredible scent tracking ability",
        specialty = "tracking", -- tracking, searching, apprehension
        trackingSkill = 100, -- 0-100
        searchSkill = 80,
        apprehensionSkill = 60,
        speed = 85,
        stamina = 90,
        health = 100,
        image = "k9_bloodhound.png",
    },
    {
        name = "Coonhound",
        model = "A_C_DogHound_01", -- RedM hound model
        label = "Coonhound",
        description = "Versatile hunting dog, good for tracking and searching",
        specialty = "searching",
        trackingSkill = 85,
        searchSkill = 90,
        apprehensionSkill = 70,
        speed = 90,
        stamina = 85,
        health = 95,
        image = "k9_coonhound.png",
    },
    {
        name = "Shepherd",
        model = "A_C_ShepherdDog_01", -- RedM shepherd model
        label = "Shepherd Dog",
        description = "Loyal and protective, excellent for apprehension",
        specialty = "apprehension",
        trackingSkill = 75,
        searchSkill = 75,
        apprehensionSkill = 95,
        speed = 95,
        stamina = 90,
        health = 110,
        image = "k9_shepherd.png",
    },
}

-- ══════════════════════════════════════════════════════════════
-- K9 COMMANDS
-- ══════════════════════════════════════════════════════════════
Config.K9.Commands = {
    spawn = {
        command = "/k9spawn",
        label = "Spawn K9",
        description = "Call your K9 partner",
        requiresDuty = true,
        cooldown = 5000, -- 5 seconds
    },
    dismiss = {
        command = "/k9dismiss",
        label = "Dismiss K9",
        description = "Send K9 away",
        requiresDuty = true,
        cooldown = 1000,
    },
    follow = {
        command = "/k9follow",
        label = "K9 Follow",
        description = "Order K9 to follow you",
        requiresDuty = true,
        cooldown = 1000,
    },
    stay = {
        command = "/k9stay",
        label = "K9 Stay",
        description = "Order K9 to stay in place",
        requiresDuty = true,
        cooldown = 1000,
    },
    track = {
        command = "/k9track",
        label = "K9 Track",
        description = "Order K9 to track nearby suspect",
        requiresDuty = true,
        cooldown = 3000,
        duration = 30000, -- 30 seconds tracking time
        range = 100.0, -- Track range in meters
    },
    search = {
        command = "/k9search",
        label = "K9 Search",
        description = "Order K9 to search for evidence",
        requiresDuty = true,
        cooldown = 5000,
        duration = 20000, -- 20 seconds search time
        range = 25.0, -- Search range in meters
    },
    attack = {
        command = "/k9attack",
        label = "K9 Attack",
        description = "Order K9 to subdue suspect",
        requiresDuty = true,
        cooldown = 10000,
        damage = 25, -- Damage per attack
        subdueChance = 75, -- % chance to knock down
        requiresTarget = true,
    },
    vehicle = {
        command = "/k9vehicle",
        label = "K9 Enter/Exit Vehicle",
        description = "Order K9 to enter or exit vehicle",
        requiresDuty = true,
        cooldown = 2000,
    },
}

-- ══════════════════════════════════════════════════════════════
-- K9 TRACKING SYSTEM
-- ══════════════════════════════════════════════════════════════
Config.K9.Tracking = {
    enabled = true,
    maxTrackAge = 300000, -- 5 minutes (300 seconds)
    trackDecayRate = 0.1, -- Scent decay per second
    minScentStrength = 0.3, -- Minimum scent to track
    trackUpdateInterval = 2000, -- Update every 2 seconds
    showTrackBlips = true, -- Show blips during tracking
    trackBlipColor = "red",
    trackMarkerType = 1, -- Ground marker type
    alertRadius = 10.0, -- Alert when target within range
    successRate = {
        bloodhound = 95, -- % success rate
        coonhound = 85,
        shepherd = 75,
    },
}

-- ══════════════════════════════════════════════════════════════
-- K9 SEARCH SYSTEM (Evidence Search)
-- ══════════════════════════════════════════════════════════════
Config.K9.Search = {
    enabled = true,
    searchRadius = 25.0,
    searchTime = 20000, -- 20 seconds
    successChance = {
        bloodhound = 80,
        coonhound = 90,
        shepherd = 75,
    },
    evidenceTypes = {
        "blood",
        "casing",
        "tracks",
        "weapon",
    },
    alertOnFind = true,
    showMarkers = true,
    rewardXP = 25, -- XP for successful search
}

-- ══════════════════════════════════════════════════════════════
-- K9 APPREHENSION SYSTEM
-- ══════════════════════════════════════════════════════════════
Config.K9.Apprehension = {
    enabled = true,
    attackRange = 5.0,
    attackDamage = 25,
    subdueChance = {
        bloodhound = 60,
        coonhound = 70,
        shepherd = 90,
    },
    subdueRagdoll = true, -- Ragdoll on subdue
    subdueTime = 5000, -- 5 seconds on ground
    cooldownAfterAttack = 10000, -- 10 second cooldown
    canAttackArmed = true, -- Can attack armed suspects
    warningBark = true, -- Bark before attack
    rewardXP = 50, -- XP for successful apprehension
}

-- ══════════════════════════════════════════════════════════════
-- K9 HEALTH & STAMINA
-- ══════════════════════════════════════════════════════════════
Config.K9.Health = {
    enabled = true,
    maxHealth = 200,
    regenRate = 2, -- HP per second when idle
    canBeInjured = true,
    canDie = true,
    respawnTime = 300000, -- 5 minutes if killed
    veterinaryRequired = false, -- Require vet to heal
    feedingRequired = false, -- Require feeding (optional realism)
}

Config.K9.Stamina = {
    enabled = true,
    maxStamina = 100,
    depletionRate = {
        walking = 0.5, -- Per second
        running = 2.0,
        tracking = 1.5,
        searching = 1.0,
        attacking = 3.0,
    },
    regenRate = 5, -- Per second when idle
    lowStaminaThreshold = 20, -- Alert at 20%
    exhaustedThreshold = 5, -- Can't perform actions below 5%
}

-- ══════════════════════════════════════════════════════════════
-- K9 TRAINING SYSTEM
-- ══════════════════════════════════════════════════════════════
Config.K9.Training = {
    enabled = true,
    requireTraining = true,
    trainingLevels = {
        {
            level = 1,
            name = "Basic Obedience",
            xpRequired = 0,
            commands = {"follow", "stay"},
            bonus = { speed = 5 },
        },
        {
            level = 2,
            name = "Tracking Certified",
            xpRequired = 500,
            commands = {"follow", "stay", "track"},
            bonus = { trackingSkill = 10, speed = 10 },
        },
        {
            level = 3,
            name = "Search Certified",
            xpRequired = 1000,
            commands = {"follow", "stay", "track", "search"},
            bonus = { searchSkill = 10, stamina = 10 },
        },
        {
            level = 4,
            name = "Apprehension Certified",
            xpRequired = 2000,
            commands = {"follow", "stay", "track", "search", "attack"},
            bonus = { apprehensionSkill = 15, health = 20 },
        },
        {
            level = 5,
            name = "Master K9",
            xpRequired = 5000,
            commands = {"follow", "stay", "track", "search", "attack", "vehicle"},
            bonus = { trackingSkill = 20, searchSkill = 20, apprehensionSkill = 20, speed = 20, stamina = 20, health = 30 },
        },
    },
    xpGainRate = {
        spawn = 1,
        follow = 2,
        track = 10,
        trackSuccess = 25,
        search = 15,
        searchSuccess = 30,
        attack = 20,
        attackSuccess = 50,
    },
}

-- ══════════════════════════════════════════════════════════════
-- K9 ANIMATIONS & BEHAVIORS
-- ══════════════════════════════════════════════════════════════
Config.K9.Animations = {
    idle = "idle",
    walk = "move_ped_scenario",
    run = "move_fast",
    track = "sniff_ground",
    search = "dig",
    attack = "attack",
    sit = "sit",
    laydown = "laydown",
    bark = "bark",
    wag_tail = "happy",
}

Config.K9.Sounds = {
    enabled = true,
    bark = "DOG_BARK",
    growl = "DOG_GROWL",
    whine = "DOG_WHINE",
    panting = "DOG_PANT",
}

-- ══════════════════════════════════════════════════════════════
-- K9 SPAWN LOCATIONS (Kennels)
-- ══════════════════════════════════════════════════════════════
Config.K9.SpawnLocations = {
    {
        name = "Valentine Sheriff Kennel",
        coords = vector3(-280.0, 800.0, 119.0),
        heading = 90.0,
        jobAccess = "vallaw",
        blip = true,
        blipSprite = "blip_shop_dog",
    },
    {
        name = "Rhodes Sheriff Kennel",
        coords = vector3(1360.0, -1300.0, 77.0),
        heading = 180.0,
        jobAccess = "rholaw",
        blip = true,
        blipSprite = "blip_shop_dog",
    },
    {
        name = "Blackwater Sheriff Kennel",
        coords = vector3(-760.0, -1270.0, 44.0),
        heading = 270.0,
        jobAccess = "blklaw",
        blip = true,
        blipSprite = "blip_shop_dog",
    },
    {
        name = "Strawberry Sheriff Kennel",
        coords = vector3(-1810.0, -355.0, 164.0),
        heading = 0.0,
        jobAccess = "strlaw",
        blip = true,
        blipSprite = "blip_shop_dog",
    },
    {
        name = "Saint Denis Police Kennel",
        coords = vector3(2505.0, -1300.0, 48.0),
        heading = 90.0,
        jobAccess = "stdenlaw",
        blip = true,
        blipSprite = "blip_shop_dog",
    },
}

-- ══════════════════════════════════════════════════════════════
-- K9 UI & NOTIFICATIONS
-- ══════════════════════════════════════════════════════════════
Config.K9.UI = {
    showHealthBar = true,
    showStaminaBar = true,
    showCommandFeedback = true,
    showTrainingProgress = true,
    notifyOnLowHealth = true,
    notifyOnLowStamina = true,
    notifyOnLevelUp = true,
}

-- ══════════════════════════════════════════════════════════════
-- K9 INTEGRATION SETTINGS
-- ══════════════════════════════════════════════════════════════
Config.K9.Integration = {
    useRSGInventory = true, -- Integrate with rsg-inventory for treats/items
    useProgression = true, -- Track K9 progression
    useDatabase = true, -- Save K9 data to database
    shareWithPosse = false, -- Allow posse members to use K9
    requireCertification = true, -- Require handler certification
}

-- ══════════════════════════════════════════════════════════════
-- K9 ITEMS (Optional - Dog Treats, Toys, etc.)
-- ══════════════════════════════════════════════════════════════
Config.K9.Items = {
    {
        itemName = "dog_treat",
        label = "Dog Treat",
        description = "Reward for your K9 partner",
        effect = "restoreStamina",
        amount = 25,
    },
    {
        itemName = "dog_medicine",
        label = "Dog Medicine",
        description = "Medicine to heal your K9",
        effect = "restoreHealth",
        amount = 50,
    },
    {
        itemName = "k9_vest",
        label = "K9 Protective Vest",
        description = "Protective vest for K9",
        effect = "increaseHealth",
        amount = 50,
    },
    {
        itemName = "k9_collar",
        label = "K9 Tracking Collar",
        description = "Collar with badge and tracker",
        effect = "increaseTracking",
        amount = 10,
    },
}

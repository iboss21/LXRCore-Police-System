--[[
    ╔════════════════════════════════════════════════════════════╗
    ║  Law Book - 1899 Authentic Charges                        ║
    ║  Centralized Charge Configuration                         ║
    ║  Severity, Time, Fines, Bail Eligibility                  ║
    ╚════════════════════════════════════════════════════════════╝
]]

Statutes = {
    -- ══════════════════════════════════════════════════════════
    -- MISDEMEANORS (Minor Offenses)
    -- ══════════════════════════════════════════════════════════
    ["DISORDERLY_CONDUCT"] = {
        label = "Disorderly Conduct",
        description = "Creating public disturbance",
        category = "Misdemeanor",
        severity = 1,                    -- 1-5 scale
        fine_min = 10,
        fine_max = 50,
        jail_min = 0,
        jail_max = 5,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    ["PUBLIC_INTOXICATION"] = {
        label = "Public Intoxication",
        description = "Drunk and disorderly in public",
        category = "Misdemeanor",
        severity = 1,
        fine_min = 15,
        fine_max = 30,
        jail_min = 0,
        jail_max = 3,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    ["TRESPASSING"] = {
        label = "Trespassing",
        description = "Unlawful entry onto property",
        category = "Misdemeanor",
        severity = 2,
        fine_min = 25,
        fine_max = 75,
        jail_min = 0,
        jail_max = 10,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    ["VAGRANCY"] = {
        label = "Vagrancy",
        description = "Loitering without visible means of support",
        category = "Misdemeanor",
        severity = 1,
        fine_min = 5,
        fine_max = 20,
        jail_min = 0,
        jail_max = 5,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    
    -- ══════════════════════════════════════════════════════════
    -- FELONIES (Serious Crimes)
    -- ══════════════════════════════════════════════════════════
    ["HORSE_THEFT"] = {
        label = "Horse Theft",
        description = "Stealing another person's horse",
        category = "Felony",
        severity = 4,
        fine_min = 150,
        fine_max = 300,
        jail_min = 15,
        jail_max = 30,
        bail_eligible = true,
        contraband = true,
        version = 1,
    },
    ["CATTLE_RUSTLING"] = {
        label = "Cattle Rustling",
        description = "Theft of livestock",
        category = "Felony",
        severity = 4,
        fine_min = 200,
        fine_max = 500,
        jail_min = 20,
        jail_max = 45,
        bail_eligible = true,
        contraband = true,
        version = 1,
    },
    ["ROBBERY"] = {
        label = "Robbery",
        description = "Theft by force or intimidation",
        category = "Felony",
        severity = 4,
        fine_min = 100,
        fine_max = 300,
        jail_min = 15,
        jail_max = 40,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    ["BANK_ROBBERY"] = {
        label = "Bank Robbery",
        description = "Armed robbery of banking institution",
        category = "Felony",
        severity = 5,
        fine_min = 500,
        fine_max = 1000,
        jail_min = 45,
        jail_max = 90,
        bail_eligible = false,
        contraband = true,
        version = 1,
    },
    ["TRAIN_ROBBERY"] = {
        label = "Train Robbery",
        description = "Federal crime - robbery of train",
        category = "Federal",
        severity = 5,
        fine_min = 750,
        fine_max = 1500,
        jail_min = 60,
        jail_max = 120,
        bail_eligible = false,
        contraband = true,
        version = 1,
    },
    
    -- ══════════════════════════════════════════════════════════
    -- VIOLENT CRIMES
    -- ══════════════════════════════════════════════════════════
    ["ASSAULT"] = {
        label = "Assault",
        description = "Physical attack on another person",
        category = "Felony",
        severity = 3,
        fine_min = 50,
        fine_max = 150,
        jail_min = 10,
        jail_max = 25,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    ["ASSAULT_PEACE_OFFICER"] = {
        label = "Assault on Peace Officer",
        description = "Attacking law enforcement",
        category = "Felony",
        severity = 4,
        fine_min = 150,
        fine_max = 400,
        jail_min = 30,
        jail_max = 60,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    ["ATTEMPTED_MURDER"] = {
        label = "Attempted Murder",
        description = "Attempt to kill another person",
        category = "Felony",
        severity = 5,
        fine_min = 400,
        fine_max = 800,
        jail_min = 60,
        jail_max = 120,
        bail_eligible = false,
        contraband = false,
        version = 1,
    },
    ["MURDER"] = {
        label = "Murder",
        description = "Unlawful killing of another person",
        category = "Capital",
        severity = 5,
        fine_min = 0,
        fine_max = 0,
        jail_min = 180,
        jail_max = 999,
        bail_eligible = false,
        contraband = false,
        execution_eligible = true,
        version = 1,
    },
    ["MURDER_PEACE_OFFICER"] = {
        label = "Murder of Peace Officer",
        description = "Killing law enforcement officer",
        category = "Capital",
        severity = 5,
        fine_min = 0,
        fine_max = 0,
        jail_min = 999,
        jail_max = 999,
        bail_eligible = false,
        contraband = false,
        execution_eligible = true,
        mandatory_execution = true,
        version = 1,
    },
    
    -- ══════════════════════════════════════════════════════════
    -- WEAPONS OFFENSES
    -- ══════════════════════════════════════════════════════════
    ["BRANDISHING"] = {
        label = "Brandishing a Weapon",
        description = "Threatening with a weapon",
        category = "Misdemeanor",
        severity = 2,
        fine_min = 25,
        fine_max = 75,
        jail_min = 5,
        jail_max = 15,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    ["ILLEGAL_DISCHARGE"] = {
        label = "Illegal Discharge of Firearm",
        description = "Firing weapon within town limits",
        category = "Misdemeanor",
        severity = 3,
        fine_min = 50,
        fine_max = 100,
        jail_min = 10,
        jail_max = 20,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    
    -- ══════════════════════════════════════════════════════════
    -- PROPERTY CRIMES
    -- ══════════════════════════════════════════════════════════
    ["BURGLARY"] = {
        label = "Burglary",
        description = "Breaking and entering with intent to steal",
        category = "Felony",
        severity = 4,
        fine_min = 100,
        fine_max = 250,
        jail_min = 20,
        jail_max = 40,
        bail_eligible = true,
        contraband = true,
        version = 1,
    },
    ["ARSON"] = {
        label = "Arson",
        description = "Willful burning of property",
        category = "Felony",
        severity = 5,
        fine_min = 300,
        fine_max = 750,
        jail_min = 40,
        jail_max = 80,
        bail_eligible = false,
        contraband = false,
        version = 1,
    },
    ["VANDALISM"] = {
        label = "Vandalism",
        description = "Willful destruction of property",
        category = "Misdemeanor",
        severity = 2,
        fine_min = 25,
        fine_max = 100,
        jail_min = 5,
        jail_max = 15,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    
    -- ══════════════════════════════════════════════════════════
    -- FRAUD & FINANCIAL CRIMES
    -- ══════════════════════════════════════════════════════════
    ["FRAUD"] = {
        label = "Fraud",
        description = "Obtaining money through deception",
        category = "Felony",
        severity = 3,
        fine_min = 100,
        fine_max = 500,
        jail_min = 15,
        jail_max = 35,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    ["COUNTERFEITING"] = {
        label = "Counterfeiting",
        description = "Producing fake currency",
        category = "Federal",
        severity = 5,
        fine_min = 500,
        fine_max = 1000,
        jail_min = 60,
        jail_max = 120,
        bail_eligible = false,
        contraband = true,
        version = 1,
    },
    
    -- ══════════════════════════════════════════════════════════
    -- OBSTRUCTION OF JUSTICE
    -- ══════════════════════════════════════════════════════════
    ["RESISTING_ARREST"] = {
        label = "Resisting Arrest",
        description = "Physically resisting lawful arrest",
        category = "Misdemeanor",
        severity = 3,
        fine_min = 50,
        fine_max = 100,
        jail_min = 10,
        jail_max = 20,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    ["EVADING"] = {
        label = "Evading Law Enforcement",
        description = "Fleeing from peace officers",
        category = "Felony",
        severity = 3,
        fine_min = 75,
        fine_max = 200,
        jail_min = 15,
        jail_max = 30,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    ["ESCAPE"] = {
        label = "Escape from Custody",
        description = "Breaking out of jail or custody",
        category = "Felony",
        severity = 4,
        fine_min = 200,
        fine_max = 400,
        jail_min = 30,
        jail_max = 60,
        bail_eligible = false,
        contraband = false,
        version = 1,
    },
    ["BRIBERY"] = {
        label = "Bribery",
        description = "Offering money to influence officer",
        category = "Felony",
        severity = 4,
        fine_min = 200,
        fine_max = 500,
        jail_min = 25,
        jail_max = 50,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    
    -- ══════════════════════════════════════════════════════════
    -- SPECIAL CRIMES (1899 Specific)
    -- ══════════════════════════════════════════════════════════
    ["MOONSHINING"] = {
        label = "Moonshining",
        description = "Illegal production of alcohol",
        category = "Misdemeanor",
        severity = 2,
        fine_min = 50,
        fine_max = 150,
        jail_min = 5,
        jail_max = 20,
        bail_eligible = true,
        contraband = true,
        version = 1,
    },
    ["CLAIM_JUMPING"] = {
        label = "Claim Jumping",
        description = "Stealing another's mining claim",
        category = "Felony",
        severity = 4,
        fine_min = 150,
        fine_max = 400,
        jail_min = 20,
        jail_max = 45,
        bail_eligible = true,
        contraband = false,
        version = 1,
    },
    ["TREASON"] = {
        label = "Treason",
        description = "Betraying the United States",
        category = "Capital",
        severity = 5,
        fine_min = 0,
        fine_max = 0,
        jail_min = 999,
        jail_max = 999,
        bail_eligible = false,
        contraband = false,
        execution_eligible = true,
        mandatory_execution = true,
        version = 1,
    },
}

-- Constants
local CHARGE_STACKING_MULTIPLIER = 0.75  -- Default multiplier for additional charges
local BAIL_MULTIPLIER = 5.0              -- Default bail = 5x fine

-- ══════════════════════════════════════════════════════════════
-- SENTENCE CALCULATOR
-- Automatic time/fine calculation with charge stacking
-- ══════════════════════════════════════════════════════════════
function CalculateSentence(charges)
    if not charges or #charges == 0 then
        return {
            total_time = 0,
            total_fine = 0,
            bail_amount = 0,
            bail_eligible = true,
            execution = false,
        }
    end
    
    local total_time = 0
    local total_fine = 0
    local bail_eligible = true
    local execution = false
    local highest_severity = 0
    
    -- Get stacking multiplier from config or use default
    local stackingMultiplier = CHARGE_STACKING_MULTIPLIER
    if Config.LEOCore and Config.LEOCore.Charges and Config.LEOCore.Charges.StackingMultiplier then
        stackingMultiplier = Config.LEOCore.Charges.StackingMultiplier
    end
    
    -- Get bail multiplier from config or use default
    local bailMultiplier = BAIL_MULTIPLIER
    if Config.LEOCore and Config.LEOCore.Charges and Config.LEOCore.Charges.BailMultiplier then
        bailMultiplier = Config.LEOCore.Charges.BailMultiplier
    end
    
    -- Process each charge
    for i, charge_code in ipairs(charges) do
        local charge = Statutes[charge_code]
        if charge then
            -- Calculate time with stacking multiplier
            local time_multiplier = 1.0
            if i > 1 and Config.LEOCore and Config.LEOCore.Charges and Config.LEOCore.Charges.AllowChargeStacking then
                time_multiplier = stackingMultiplier
            end
            
            -- Use average of min/max
            local charge_time = ((charge.jail_min + charge.jail_max) / 2) * time_multiplier
            local charge_fine = (charge.fine_min + charge.fine_max) / 2
            
            total_time = total_time + charge_time
            total_fine = total_fine + charge_fine
            
            -- Track bail eligibility
            if not charge.bail_eligible then
                bail_eligible = false
            end
            
            -- Track execution eligibility
            if charge.execution_eligible then
                execution = charge.mandatory_execution or false
            end
            
            -- Track severity
            if charge.severity > highest_severity then
                highest_severity = charge.severity
            end
        end
    end
    
    -- Calculate bail
    local bail_amount = 0
    if bail_eligible and Config.LEOCore and Config.LEOCore.Charges and Config.LEOCore.Charges.BailEnabled then
        bail_amount = total_fine * bailMultiplier
    end
    
    return {
        total_time = math.floor(total_time),
        total_fine = math.floor(total_fine),
        bail_amount = math.floor(bail_amount),
        bail_eligible = bail_eligible,
        execution = execution,
        severity = highest_severity,
        charge_count = #charges,
    }
end
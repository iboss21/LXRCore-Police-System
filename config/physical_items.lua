--[[
    ╔════════════════════════════════════════════════════════════╗
    ║  The Land of Wolves RP - Law Enforcement System           ║
    ║  PHYSICAL ITEMS CONFIGURATION                              ║
    ║  Records, Evidence, and Documentation Items                ║
    ║  www.wolves.land                                          ║
    ╚════════════════════════════════════════════════════════════╝
]]

Config.PhysicalItems = {}

-- ══════════════════════════════════════════════════════════════
-- ENABLE/DISABLE PHYSICAL ITEMS SYSTEM
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.Enabled = true
Config.PhysicalItems.RequireInventorySpace = true -- Require empty slot to receive items
Config.PhysicalItems.AutoRemoveOnUse = true -- Auto-remove item when viewing/using it

-- ══════════════════════════════════════════════════════════════
-- INCIDENT REPORT ITEMS
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.IncidentReport = {
    enabled = true,
    itemName = "incident_report", -- Item name in inventory
    label = "Incident Report",
    description = "Official law enforcement incident report document",
    weight = 0.1, -- Weight in inventory
    useable = true, -- Can be used/read
    unique = true, -- Each item has unique metadata
    image = "incident_report.png", -- Image file in inventory
    giveOnCreate = true, -- Give item when creating report
    giveToOfficer = true, -- Give to officer creating report
    giveToSuspect = false, -- Give copy to suspect
}

-- ══════════════════════════════════════════════════════════════
-- ARREST REPORT ITEMS
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.ArrestReport = {
    enabled = true,
    itemName = "arrest_report",
    label = "Arrest Report",
    description = "Official arrest documentation with charges",
    weight = 0.1,
    useable = true,
    unique = true,
    image = "arrest_report.png",
    giveOnCreate = true,
    giveToOfficer = true,
    giveToSuspect = true, -- Suspect gets copy of arrest report
}

-- ══════════════════════════════════════════════════════════════
-- CITATION ITEMS (TICKETS)
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.Citation = {
    enabled = true,
    itemName = "citation_ticket",
    label = "Citation Ticket",
    description = "Official citation for minor violations",
    weight = 0.05,
    useable = true,
    unique = true,
    image = "citation_ticket.png",
    giveOnCreate = true,
    giveToOfficer = true,
    giveToSuspect = true, -- Suspect gets the ticket
}

-- ══════════════════════════════════════════════════════════════
-- WARRANT ITEMS
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.Warrant = {
    enabled = true,
    itemName = "arrest_warrant",
    label = "Arrest Warrant",
    description = "Official warrant for arrest signed by judge",
    weight = 0.1,
    useable = true,
    unique = true,
    image = "arrest_warrant.png",
    giveOnCreate = true,
    giveToOfficer = true,
    giveToSuspect = false,
}

-- ══════════════════════════════════════════════════════════════
-- BOUNTY POSTER ITEMS
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.BountyPoster = {
    enabled = true,
    itemName = "wanted_poster",
    label = "Wanted Poster",
    description = "Dead or Alive wanted poster",
    weight = 0.05,
    useable = true,
    unique = true,
    image = "wanted_poster.png",
    giveOnCreate = true,
    giveToOfficer = true,
    giveToSuspect = false,
    canDuplicate = true, -- Can print multiple copies
    maxCopies = 10, -- Max copies per poster
}

-- ══════════════════════════════════════════════════════════════
-- EVIDENCE BAG ITEMS
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.EvidenceBag = {
    enabled = true,
    itemName = "evidence_bag",
    label = "Evidence Bag",
    description = "Sealed evidence bag with collected evidence",
    weight = 0.5,
    useable = true,
    unique = true,
    image = "evidence_bag.png",
    giveOnCreate = true,
    giveToOfficer = true,
    types = {
        blood = {
            itemName = "evidence_blood",
            label = "Blood Evidence",
            description = "Blood sample collected from crime scene",
            image = "evidence_blood.png",
        },
        casing = {
            itemName = "evidence_casing",
            label = "Bullet Casing",
            description = "Shell casing from firearm",
            image = "evidence_casing.png",
        },
        fingerprint = {
            itemName = "evidence_fingerprint",
            label = "Fingerprint Evidence",
            description = "Fingerprint lifted from crime scene",
            image = "evidence_fingerprint.png",
        },
        tracks = {
            itemName = "evidence_tracks",
            label = "Track Evidence",
            description = "Footprint or hoofprint cast",
            image = "evidence_tracks.png",
        },
        photo = {
            itemName = "evidence_photo",
            label = "Crime Scene Photo",
            description = "Photograph of crime scene",
            image = "evidence_photo.png",
        },
        weapon = {
            itemName = "evidence_weapon",
            label = "Weapon Evidence",
            description = "Confiscated weapon as evidence",
            image = "evidence_weapon.png",
        },
    }
}

-- ══════════════════════════════════════════════════════════════
-- INVESTIGATION NOTES
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.InvestigationNotes = {
    enabled = true,
    itemName = "investigation_notes",
    label = "Investigation Notes",
    description = "Detective's case notes and observations",
    weight = 0.05,
    useable = true,
    unique = true,
    image = "investigation_notes.png",
    giveOnCreate = true,
    giveToOfficer = true,
}

-- ══════════════════════════════════════════════════════════════
-- SEARCH RECEIPT
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.SearchReceipt = {
    enabled = true,
    itemName = "search_receipt",
    label = "Search Receipt",
    description = "Receipt of property search and confiscation",
    weight = 0.05,
    useable = true,
    unique = true,
    image = "search_receipt.png",
    giveOnCreate = true,
    giveToOfficer = true,
    giveToSuspect = true, -- Suspect gets receipt of what was taken
}

-- ══════════════════════════════════════════════════════════════
-- PRISONER PROPERTY RECEIPT
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.PropertyReceipt = {
    enabled = true,
    itemName = "property_receipt",
    label = "Property Receipt",
    description = "Receipt for confiscated prisoner property",
    weight = 0.05,
    useable = true,
    unique = true,
    image = "property_receipt.png",
    giveOnCreate = true,
    giveToOfficer = true,
    giveToSuspect = true,
}

-- ══════════════════════════════════════════════════════════════
-- COURT SUMMONS
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.CourtSummons = {
    enabled = true,
    itemName = "court_summons",
    label = "Court Summons",
    description = "Official summons to appear in court",
    weight = 0.1,
    useable = true,
    unique = true,
    image = "court_summons.png",
    giveOnCreate = true,
    giveToOfficer = false,
    giveToSuspect = true,
}

-- ══════════════════════════════════════════════════════════════
-- TELEGRAPH MESSAGE
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.TelegraphMessage = {
    enabled = true,
    itemName = "telegraph_message",
    label = "Telegraph Message",
    description = "Urgent telegraph dispatch message",
    weight = 0.01,
    useable = true,
    unique = true,
    image = "telegraph_message.png",
    giveOnCreate = true,
    giveToOfficer = true,
}

-- ══════════════════════════════════════════════════════════════
-- WITNESS STATEMENT
-- ══════════════════════════════════════════════════════════════
Config.PhysicalItems.WitnessStatement = {
    enabled = true,
    itemName = "witness_statement",
    label = "Witness Statement",
    description = "Written statement from witness",
    weight = 0.05,
    useable = true,
    unique = true,
    image = "witness_statement.png",
    giveOnCreate = true,
    giveToOfficer = true,
}

-- ══════════════════════════════════════════════════════════════
-- INVENTORY ITEM DEFINITIONS FOR COPY/PASTE
-- ══════════════════════════════════════════════════════════════
--[[
    Add these items to your rsg-inventory/shared/items.lua:

    ['incident_report'] = {
        ['name'] = 'incident_report',
        ['label'] = 'Incident Report',
        ['weight'] = 100,
        ['type'] = 'item',
        ['image'] = 'incident_report.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Official law enforcement incident report document'
    },

    ['arrest_report'] = {
        ['name'] = 'arrest_report',
        ['label'] = 'Arrest Report',
        ['weight'] = 100,
        ['type'] = 'item',
        ['image'] = 'arrest_report.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Official arrest documentation with charges'
    },

    ['citation_ticket'] = {
        ['name'] = 'citation_ticket',
        ['label'] = 'Citation Ticket',
        ['weight'] = 50,
        ['type'] = 'item',
        ['image'] = 'citation_ticket.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Official citation for minor violations'
    },

    ['arrest_warrant'] = {
        ['name'] = 'arrest_warrant',
        ['label'] = 'Arrest Warrant',
        ['weight'] = 100,
        ['type'] = 'item',
        ['image'] = 'arrest_warrant.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Official warrant for arrest signed by judge'
    },

    ['wanted_poster'] = {
        ['name'] = 'wanted_poster',
        ['label'] = 'Wanted Poster',
        ['weight'] = 50,
        ['type'] = 'item',
        ['image'] = 'wanted_poster.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Dead or Alive wanted poster'
    },

    ['evidence_bag'] = {
        ['name'] = 'evidence_bag',
        ['label'] = 'Evidence Bag',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'evidence_bag.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Sealed evidence bag with collected evidence'
    },

    ['evidence_blood'] = {
        ['name'] = 'evidence_blood',
        ['label'] = 'Blood Evidence',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'evidence_blood.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Blood sample collected from crime scene'
    },

    ['evidence_casing'] = {
        ['name'] = 'evidence_casing',
        ['label'] = 'Bullet Casing',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'evidence_casing.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Shell casing from firearm'
    },

    ['evidence_fingerprint'] = {
        ['name'] = 'evidence_fingerprint',
        ['label'] = 'Fingerprint Evidence',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'evidence_fingerprint.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Fingerprint lifted from crime scene'
    },

    ['evidence_tracks'] = {
        ['name'] = 'evidence_tracks',
        ['label'] = 'Track Evidence',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'evidence_tracks.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Footprint or hoofprint cast'
    },

    ['evidence_photo'] = {
        ['name'] = 'evidence_photo',
        ['label'] = 'Crime Scene Photo',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'evidence_photo.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Photograph of crime scene'
    },

    ['evidence_weapon'] = {
        ['name'] = 'evidence_weapon',
        ['label'] = 'Weapon Evidence',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'evidence_weapon.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Confiscated weapon as evidence'
    },

    ['investigation_notes'] = {
        ['name'] = 'investigation_notes',
        ['label'] = 'Investigation Notes',
        ['weight'] = 50,
        ['type'] = 'item',
        ['image'] = 'investigation_notes.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = "Detective's case notes and observations"
    },

    ['search_receipt'] = {
        ['name'] = 'search_receipt',
        ['label'] = 'Search Receipt',
        ['weight'] = 50,
        ['type'] = 'item',
        ['image'] = 'search_receipt.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Receipt of property search and confiscation'
    },

    ['property_receipt'] = {
        ['name'] = 'property_receipt',
        ['label'] = 'Property Receipt',
        ['weight'] = 50,
        ['type'] = 'item',
        ['image'] = 'property_receipt.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Receipt for confiscated prisoner property'
    },

    ['court_summons'] = {
        ['name'] = 'court_summons',
        ['label'] = 'Court Summons',
        ['weight'] = 100,
        ['type'] = 'item',
        ['image'] = 'court_summons.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Official summons to appear in court'
    },

    ['telegraph_message'] = {
        ['name'] = 'telegraph_message',
        ['label'] = 'Telegraph Message',
        ['weight'] = 10,
        ['type'] = 'item',
        ['image'] = 'telegraph_message.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Urgent telegraph dispatch message'
    },

    ['witness_statement'] = {
        ['name'] = 'witness_statement',
        ['label'] = 'Witness Statement',
        ['weight'] = 50,
        ['type'] = 'item',
        ['image'] = 'witness_statement.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Written statement from witness'
    },
]]

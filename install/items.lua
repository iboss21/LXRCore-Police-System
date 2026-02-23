--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

    🐺 LXR Core - Police System

    ═══════════════════════════════════════════════════════════════════════════════
    INSTALL — ITEMS REGISTRATION (RSG-Core / LXR-Core)
    ═══════════════════════════════════════════════════════════════════════════════

    Paste the entries below into your framework's shared items table:
      • RSG-Core  →  rsg-core/shared/items.lua
      • LXR-Core  →  lxr-core/shared/items.lua

    All items follow the standard horizontal single-line format used by both
    RSG-Core and LXR-Core.  Each category is separated by a header block.

    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-----------------------------------------------
-- CORE LEO ITEMS (LXR_POLICE_CORE)
-----------------------------------------------
lawman_badge         = { name = 'lawman_badge',         label = 'Lawman Badge',           weight = 100,  type = 'item', image = 'lawman_badge.png',         unique = true,  useable = true,  shouldClose = true,  description = 'Official law enforcement badge.' },
temp_deputy_badge    = { name = 'temp_deputy_badge',    label = 'Temporary Deputy Badge', weight = 100,  type = 'item', image = 'temp_deputy_badge.png',    unique = true,  useable = false, shouldClose = false, description = 'Temporary deputization badge.' },
rope                 = { name = 'rope',                 label = 'Rope',                   weight = 500,  type = 'item', image = 'rope.png',                 unique = false, useable = true,  shouldClose = true,  description = 'Strong hemp rope for restraining.' },
handcuffs            = { name = 'handcuffs',            label = 'Iron Handcuffs',         weight = 500,  type = 'item', image = 'handcuffs.png',            unique = false, useable = true,  shouldClose = true,  description = 'Iron restraint cuffs.' },
evidence_bag         = { name = 'evidence_bag',         label = 'Evidence Bag',           weight = 200,  type = 'item', image = 'evidence_bag.png',         unique = false, useable = true,  shouldClose = true,  description = 'Cloth bag for collecting evidence at crime scenes.' },
evidence_marker      = { name = 'evidence_marker',      label = 'Evidence Marker',        weight = 50,   type = 'item', image = 'evidence_marker.png',      unique = false, useable = true,  shouldClose = true,  description = 'Numbered card to mark evidence positions.' },
investigation_journal= { name = 'investigation_journal',label = 'Investigation Journal',  weight = 300,  type = 'item', image = 'investigation_journal.png',unique = true,  useable = true,  shouldClose = true,  description = 'Leather-bound journal for documenting investigations.' },
weapon_kit_camera    = { name = 'weapon_kit_camera',    label = 'Box Camera',             weight = 2000, type = 'item', image = 'weapon_kit_camera.png',    unique = true,  useable = true,  shouldClose = true,  description = '1899-era box camera for crime scene photography.' },
weapon_kit_binoculars= { name = 'weapon_kit_binoculars',label = 'Binoculars',             weight = 600,  type = 'item', image = 'weapon_kit_binoculars.png',unique = true,  useable = true,  shouldClose = true,  description = 'Brass field binoculars for surveillance.' },
compass              = { name = 'compass',              label = 'Compass',                weight = 100,  type = 'item', image = 'compass.png',              unique = true,  useable = true,  shouldClose = false, description = 'Brass compass for navigating the frontier.' },
telegraph_paper      = { name = 'telegraph_paper',      label = 'Telegraph Message',      weight = 10,   type = 'item', image = 'telegraph_paper.png',      unique = false, useable = true,  shouldClose = true,  description = 'Printed telegraph message paper.' },
wanted_poster        = { name = 'wanted_poster',        label = 'Wanted Poster',          weight = 50,   type = 'item', image = 'wanted_poster.png',        unique = false, useable = true,  shouldClose = true,  description = 'Printed wanted poster with criminal information and bounty.' },
police_whistle       = { name = 'police_whistle',       label = 'Police Whistle',         weight = 50,   type = 'item', image = 'police_whistle.png',       unique = true,  useable = true,  shouldClose = false, description = 'Brass whistle used to signal and alert other officers.' },

-----------------------------------------------
-- PHYSICAL DOCUMENT ITEMS (LXR_POLICE_DOCS)
-----------------------------------------------
incident_report      = { name = 'incident_report',      label = 'Incident Report',        weight = 10,   type = 'item', image = 'incident_report.png',      unique = true,  useable = true,  shouldClose = true,  description = 'Official incident report document.' },
arrest_report        = { name = 'arrest_report',        label = 'Arrest Report',          weight = 10,   type = 'item', image = 'arrest_report.png',        unique = true,  useable = true,  shouldClose = true,  description = 'Official arrest documentation.' },
citation_ticket      = { name = 'citation_ticket',      label = 'Citation Ticket',        weight = 5,    type = 'item', image = 'citation_ticket.png',      unique = true,  useable = true,  shouldClose = true,  description = 'Official citation ticket with fine details.' },
arrest_warrant       = { name = 'arrest_warrant',       label = 'Arrest Warrant',         weight = 10,   type = 'item', image = 'arrest_warrant.png',       unique = true,  useable = true,  shouldClose = true,  description = 'Court-issued arrest warrant.' },
search_receipt       = { name = 'search_receipt',       label = 'Search Receipt',         weight = 5,    type = 'item', image = 'search_receipt.png',       unique = true,  useable = true,  shouldClose = true,  description = 'Receipt of items found during a search.' },
property_receipt     = { name = 'property_receipt',     label = 'Property Receipt',       weight = 5,    type = 'item', image = 'property_receipt.png',     unique = true,  useable = true,  shouldClose = true,  description = 'Receipt for confiscated property.' },
court_summons        = { name = 'court_summons',        label = 'Court Summons',          weight = 10,   type = 'item', image = 'court_summons.png',        unique = true,  useable = true,  shouldClose = true,  description = 'Official court summons requiring appearance before a judge.' },
telegraph_message    = { name = 'telegraph_message',    label = 'Telegraph Message',      weight = 5,    type = 'item', image = 'telegraph_message.png',    unique = true,  useable = true,  shouldClose = true,  description = 'Incoming telegraph dispatch message.' },
witness_statement    = { name = 'witness_statement',    label = 'Witness Statement',      weight = 5,    type = 'item', image = 'witness_statement.png',    unique = true,  useable = true,  shouldClose = true,  description = 'Recorded witness testimony.' },

-----------------------------------------------
-- EVIDENCE ITEMS (LXR_POLICE_EVIDENCE)
-----------------------------------------------
evidence_blood       = { name = 'evidence_blood',       label = 'Blood Evidence',         weight = 50,   type = 'item', image = 'evidence_blood.png',       unique = true,  useable = false, shouldClose = false, description = 'Collected blood sample from crime scene.' },
evidence_casing      = { name = 'evidence_casing',      label = 'Bullet Casing',          weight = 10,   type = 'item', image = 'evidence_casing.png',      unique = true,  useable = false, shouldClose = false, description = 'Spent bullet casing collected as evidence.' },
evidence_fingerprint = { name = 'evidence_fingerprint', label = 'Fingerprint Evidence',   weight = 10,   type = 'item', image = 'evidence_fingerprint.png', unique = true,  useable = false, shouldClose = false, description = 'Lifted fingerprint on evidence card.' },
evidence_tracks      = { name = 'evidence_tracks',      label = 'Track Evidence',         weight = 20,   type = 'item', image = 'evidence_tracks.png',      unique = true,  useable = false, shouldClose = false, description = 'Plaster cast of footprints or hoof tracks.' },
evidence_photo       = { name = 'evidence_photo',       label = 'Crime Scene Photo',      weight = 10,   type = 'item', image = 'evidence_photo.png',       unique = true,  useable = true,  shouldClose = true,  description = 'Developed photograph of crime scene evidence.' },
evidence_weapon      = { name = 'evidence_weapon',      label = 'Weapon Evidence',        weight = 200,  type = 'item', image = 'evidence_weapon.png',      unique = true,  useable = false, shouldClose = false, description = 'Weapon collected as evidence and tagged.' },

-----------------------------------------------
-- BADGE ITEMS (LXR_POLICE_BADGES)
-----------------------------------------------
badge_sheriff_star    = { name = 'badge_sheriff_star',    label = "Sheriff's Star Badge",   weight = 100,  type = 'item', image = 'badge_sheriff_star.png',    unique = true,  useable = true,  shouldClose = false, description = "The Sheriff's official star-shaped badge." },
badge_deputy_shield   = { name = 'badge_deputy_shield',   label = 'Deputy Shield Badge',    weight = 100,  type = 'item', image = 'badge_deputy_shield.png',   unique = true,  useable = true,  shouldClose = false, description = "Deputy Sheriff's shield badge." },
badge_us_marshal      = { name = 'badge_us_marshal',      label = 'US Marshal Badge',       weight = 100,  type = 'item', image = 'badge_us_marshal.png',      unique = true,  useable = true,  shouldClose = false, description = 'United States Marshal Service badge.' },
badge_texas_ranger    = { name = 'badge_texas_ranger',    label = 'Texas Ranger Badge',     weight = 100,  type = 'item', image = 'badge_texas_ranger.png',    unique = true,  useable = true,  shouldClose = false, description = 'State Ranger star-in-circle badge.' },
badge_constable       = { name = 'badge_constable',       label = 'Constable Badge',        weight = 100,  type = 'item', image = 'badge_constable.png',       unique = true,  useable = true,  shouldClose = false, description = 'Town constable badge.' },
badge_temporary_deputy= { name = 'badge_temporary_deputy',label = 'Temporary Deputy Badge', weight = 50,   type = 'item', image = 'badge_temporary_deputy.png',unique = true,  useable = false, shouldClose = false, description = 'Temporary deputization badge — expires after 1 hour.' },

-----------------------------------------------
-- BELT & EQUIPMENT ITEMS (LXR_POLICE_BELT)
-----------------------------------------------
handcuffs_iron       = { name = 'handcuffs_iron',       label = 'Iron Handcuffs',         weight = 500,  type = 'item', image = 'handcuffs_iron.png',       unique = false, useable = true,  shouldClose = true,  description = 'Heavy iron restraint cuffs.' },
rope_lasso           = { name = 'rope_lasso',           label = 'Coiled Rope',            weight = 800,  type = 'item', image = 'rope_lasso.png',           unique = false, useable = true,  shouldClose = true,  description = 'Coiled lasso rope for restraining.' },
baton_wood           = { name = 'baton_wood',           label = 'Wooden Baton',           weight = 600,  type = 'item', image = 'baton_wood.png',           unique = false, useable = true,  shouldClose = true,  description = 'Standard-issue wooden baton.' },
baton_metal          = { name = 'baton_metal',          label = 'Metal Baton',            weight = 800,  type = 'item', image = 'baton_metal.png',          unique = false, useable = true,  shouldClose = true,  description = 'Reinforced metal baton for senior officers.' },
keys_jail            = { name = 'keys_jail',            label = 'Jail Cell Keys',         weight = 100,  type = 'item', image = 'keys_jail.png',            unique = false, useable = true,  shouldClose = true,  description = 'Iron keys to the jail cell block.' },
whistle_brass        = { name = 'whistle_brass',        label = 'Brass Whistle',          weight = 50,   type = 'item', image = 'whistle_brass.png',        unique = true,  useable = true,  shouldClose = false, description = 'A brass whistle used to summon assistance.' },

-----------------------------------------------
-- INVESTIGATION TOOL ITEMS (LXR_POLICE_INVEST)
-----------------------------------------------
camera_1899          = { name = 'camera_1899',          label = 'Box Camera (1899)',       weight = 2000, type = 'item', image = 'camera_1899.png',          unique = true,  useable = true,  shouldClose = true,  description = 'Period-accurate box camera for crime scene photography.' },
fingerprint_kit      = { name = 'fingerprint_kit',      label = 'Fingerprint Kit',        weight = 1500, type = 'item', image = 'fingerprint_kit.png',      unique = false, useable = true,  shouldClose = true,  description = 'Brush-and-powder kit for lifting fingerprints.' },
magnifying_glass     = { name = 'magnifying_glass',     label = 'Magnifying Glass',       weight = 150,  type = 'item', image = 'magnifying_glass.png',     unique = true,  useable = true,  shouldClose = true,  description = 'Brass-handled magnifying glass for close inspection.' },
measuring_tape       = { name = 'measuring_tape',       label = 'Measuring Tape',         weight = 200,  type = 'item', image = 'measuring_tape.png',       unique = false, useable = true,  shouldClose = true,  description = 'Cloth measuring tape for scene documentation.' },
notebook_leather     = { name = 'notebook_leather',     label = 'Leather Notebook',       weight = 300,  type = 'item', image = 'notebook_leather.png',     unique = false, useable = true,  shouldClose = true,  description = 'Leather-bound field notebook for recording observations.' },

# 📦 Inventory Items Installation Guide

## Adding Physical Items to rsg-inventory

This guide shows you how to add all physical law enforcement items to your rsg-inventory.

---

## 📝 Step-by-Step Installation

### 1. Open Your Inventory Items File
Navigate to: `rsg-inventory/shared/items.lua`

### 2. Add All Items
Copy and paste the following items into your items.lua file:

```lua
-- ══════════════════════════════════════════════════════════════
-- LAW ENFORCEMENT PHYSICAL ITEMS
-- ══════════════════════════════════════════════════════════════

-- REPORTS AND DOCUMENTS
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

-- EVIDENCE ITEMS
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

-- INVESTIGATION ITEMS
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

-- LEGAL DOCUMENTS
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

-- K9 ITEMS (OPTIONAL)
['dog_treat'] = {
    ['name'] = 'dog_treat',
    ['label'] = 'Dog Treat',
    ['weight'] = 50,
    ['type'] = 'item',
    ['image'] = 'dog_treat.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Reward for your K9 partner'
},

['dog_medicine'] = {
    ['name'] = 'dog_medicine',
    ['label'] = 'Dog Medicine',
    ['weight'] = 100,
    ['type'] = 'item',
    ['image'] = 'dog_medicine.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Medicine to heal your K9'
},

['k9_vest'] = {
    ['name'] = 'k9_vest',
    ['label'] = 'K9 Protective Vest',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'k9_vest.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Protective vest for K9'
},

['k9_collar'] = {
    ['name'] = 'k9_collar',
    ['label'] = 'K9 Tracking Collar',
    ['weight'] = 200,
    ['type'] = 'item',
    ['image'] = 'k9_collar.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Collar with badge and tracker'
},
```

### 3. Create Item Images

You'll need to create or obtain images for all these items. Place them in:
`rsg-inventory/html/images/`

#### Required Images:
- incident_report.png
- arrest_report.png
- citation_ticket.png
- arrest_warrant.png
- wanted_poster.png
- evidence_bag.png
- evidence_blood.png
- evidence_casing.png
- evidence_fingerprint.png
- evidence_tracks.png
- evidence_photo.png
- evidence_weapon.png
- investigation_notes.png
- search_receipt.png
- property_receipt.png
- court_summons.png
- telegraph_message.png
- witness_statement.png
- dog_treat.png (optional)
- dog_medicine.png (optional)
- k9_vest.png (optional)
- k9_collar.png (optional)

#### Image Guidelines:
- **Size**: 256x256 pixels (PNG format)
- **Style**: Period-accurate 1899 Western aesthetic
- **Background**: Transparent or aged paper texture
- **Theme**: Sepia tones, aged appearance

### 4. Restart Your Server

After adding the items, restart your server:
```
restart rsg-inventory
ensure lxr-police
```

---

## 🎨 Image Design Tips

### For Documents (Reports, Warrants, etc.):
- Use aged paper texture
- Add ink stamps or seals
- Include ornate borders
- Use Western-style fonts
- Add sheriff star watermarks

### For Evidence Items:
- Show evidence bags or containers
- Period-appropriate evidence markers
- 1899-era forensic equipment
- Authentic crime scene tools

### For K9 Items:
- Show treats appropriate for 1899
- Period-accurate medicine bottles
- Leather collars and vests
- Western badge designs

---

## 🔧 Testing Items

Test that items work correctly:

```lua
-- In-game commands (requires admin)
/giveitem [player_id] incident_report 1
/giveitem [player_id] arrest_report 1
/giveitem [player_id] citation_ticket 1
/giveitem [player_id] evidence_blood 1
```

Or test through the police system:
1. Create an incident report in MDT - should receive item
2. Arrest a suspect - both should receive arrest report
3. Issue a citation - both should receive ticket
4. Collect evidence - should receive evidence item
5. Use K9 search - should find evidence items

---

## 📊 Item Metadata

All items include metadata when given:

```lua
-- Example metadata structure
metadata = {
    created = "2024-12-16 19:51:00",
    unique = true,
    reportId = 123,
    officer = "John Smith",
    location = "Valentine",
    -- Additional item-specific metadata
}
```

This metadata is displayed when you use/inspect the item.

---

## 🐛 Troubleshooting

### Items Not Showing
1. Check item names match exactly
2. Verify images exist with correct names
3. Restart rsg-inventory
4. Clear FiveM cache

### Items Not Being Given
1. Check Config.PhysicalItems.Enabled = true
2. Verify specific item is enabled in config
3. Ensure player has inventory space
4. Check server console for errors

### Images Not Loading
1. Verify image file names match item names exactly
2. Check images are in correct folder
3. Ensure PNG format
4. Clear FiveM cache (delete cache folder)

---

## 💡 Pro Tips

1. **Organize Items**: Create a "Law Enforcement" category in your inventory
2. **Weight Balance**: Adjust weights if items feel too heavy/light
3. **Stack Limits**: Set unique = true for documents that shouldn't stack
4. **Useable Actions**: Add custom use handlers for special item interactions
5. **Trade Prevention**: Consider making evidence items non-tradeable

---

## 🔗 Related Documentation

- [K9 and Items Guide](K9_AND_ITEMS_GUIDE.md) - Complete feature guide
- [Physical Items Config](../config/physical_items.lua) - Configuration options
- [Comparison with rsg-lawman](COMPARISON_RSG_LAWMAN.md) - Feature comparison

---

## 📞 Need Help?

- **Discord**: discord.gg/wolves
- **GitHub Issues**: github.com/iboss21/LXRCore-Police-System/issues
- **Documentation**: Full guides in /docs folder

---

<div align="center">

**The Land of Wolves RP - Law Enforcement System**

*Complete physical items for authentic 1899 law enforcement*

</div>

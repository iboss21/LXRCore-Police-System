# Item Images

Place item image files here before copying them to your inventory resource.

## Required Files

All images should be **PNG format**, recommended size **64×64** or **128×128** pixels.

### Core LEO Items
- `lawman_badge.png`
- `temp_deputy_badge.png`
- `rope.png`
- `handcuffs.png`
- `evidence_bag.png`
- `evidence_marker.png`
- `investigation_journal.png`
- `weapon_kit_camera.png`
- `weapon_kit_binoculars.png`
- `compass.png`
- `telegraph_paper.png`
- `wanted_poster.png`
- `police_whistle.png`

### Physical Document Items
- `incident_report.png`
- `arrest_report.png`
- `citation_ticket.png`
- `arrest_warrant.png`
- `search_receipt.png`
- `property_receipt.png`
- `court_summons.png`
- `telegraph_message.png`
- `witness_statement.png`

### Evidence Items
- `evidence_blood.png`
- `evidence_casing.png`
- `evidence_fingerprint.png`
- `evidence_tracks.png`
- `evidence_photo.png`
- `evidence_weapon.png`

### Wearable / Badge Items
- `badge_sheriff_star.png`
- `badge_deputy_shield.png`
- `badge_us_marshal.png`
- `badge_texas_ranger.png`
- `badge_constable.png`
- `badge_temporary_deputy.png`
- `handcuffs_iron.png`
- `rope_lasso.png`
- `baton_wood.png`
- `baton_metal.png`
- `keys_jail.png`
- `camera_1899.png`
- `fingerprint_kit.png`
- `magnifying_glass.png`
- `measuring_tape.png`
- `notebook_leather.png`

## Copy to Inventory

```bash
# RSGCore
cp lxr-police/images/items/*.png rsg-inventory/html/images/

# LXRCore
cp lxr-police/images/items/*.png lxr-inventory/html/images/

# VORP
cp lxr-police/images/items/*.png vorp_inventory/html/images/

# ox_inventory
cp lxr-police/images/items/*.png ox_inventory/web/images/
```

See [`docs/ITEMS.md`](../../docs/ITEMS.md) for full item registration instructions.

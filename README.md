# vorp_imapviewtool

A developer tool to easily find, view, and toggle IPLs (Interior Proxy Lists) for RedM vorp_core.

**⚠️ WARNING: DO NOT USE THIS SCRIPT ON LIVE SERVERS - DEVELOPMENT USE ONLY**

## Features

- **Visual IPL Detection**: Automatically detects nearby IPLs and draws lines to their locations
- **Color-Coded Status**: 
  - 🔴 **Red**: IPL is inactive/removed
  - 🟢 **Green**: IPL is active/loaded
  - 🟡 **Yellow**: Currently selected IPL
- **Scrollable Selection**: Navigate through multiple nearby IPLs
- **Distance Control**: Adjust viewing distance for IPLs
- **Hex Hash Display**: Shows both decimal and hexadecimal hash values

## How to Use

### Basic Usage

1. **Activate the IPL Viewer**:
   ```
   /toggleIplView
   ```
   or with custom distance:
   ```
   /toggleIplView 30
   ```
   *(Default distance: 20 units)*

2. **Navigate Through IPLs**:
   - Press **Page left arrow key** to scroll to the previous IPL
   - Press **Page right arrow key** to scroll to the next IPL
   - The selected IPL will be highlighted in **yellow**

3. **Toggle Selected IPL**:
   - Press **G** to activate/deactivate the currently selected IPL

4. **Deactivate the Viewer**:
   ```
   /toggleIplView
   ```
   *(Toggles on/off)*

## Commands

| Command | Arguments | Description |
|---------|-----------|-------------|
| `/toggleIplView` | `[distance]` | Toggles the IPL viewer on/off. Optional distance parameter sets viewing range |
| `/iplDistanceView` | `<distance>` | Changes the viewing distance while viewer is active |
| `/removeAll` | None | Removes all IPLs currently in view |
| `/requestAll` | None | Loads/requests all IPLs currently in view |
| `/testIpl` | `<hash>` | Toggles a specific IPL by its decimal hash value |

## Understanding the Display

When the viewer is active, you'll see:
- **Lines** drawn from your character to each nearby IPL location
- **Text labels** showing:
  - Selection number (e.g., "1/5" for first of five IPLs)
  - Hexadecimal hash (e.g., "0xA9DCD9BE")
  - IPL name (if available)

### Example Display:
```
[SELECTED 1/5] | HASH: 0xA9DCD9BE | NAME: val_sheriff01
```

## Tips

- Adjust the viewing distance based on how many IPLs you want to see at once
- Use `/removeAll` to quickly clean up all loaded IPLs in the area
- The hexadecimal hash format is useful for cross-referencing with game files
- IPLs are sorted by distance from your character for easier navigation

## Notes

- This tool is intended for development and testing purposes only
- IPL changes may require map/area reload to fully take effect
- Some IPLs may be dependent on other IPLs being loaded
- to load ipls or remove from server you need to add the hashes to another script called RedM-ipls
- open f8 to copy the hashes


## Credits

rdr3discoveries for the list


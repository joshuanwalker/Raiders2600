# Raiders of the Lost Ark (Atari 2600) - Reverse Engineered Source

**Original Game (1982) by Atari, Inc.**  
**Original Designer:** Howard Scott Warshaw  
**Disassembly & Analysis:** Dennis Debro & Halkun (That's me!)

---

## Overview

This repository contains the fully reverse-engineered and commented source code for the Atari 2600 classic, *Raiders of the Lost Ark*.

Unlike a raw disassembly, this project aims to provide a **semantic understanding** of the game logic. Variables, constants, and subroutines have been renamed and heavily commented to explain *how* the game works, from the procedural flute music to the complex collision logic in the Map Room.

## Project Structure

The project has been reorganized for a clean development workflow:

*   **`src/`**: Contains the main assembly source (`raiders.asm`) and header files (`tia_constants.h`).
*   **`bin/`**: Contains build tools (DASM) and emulator executable (Stella).
*   **`out/`**: Destination for compiled binaries (`.bin`), symbol files (`.sym`), and listing files (`.lst`). (auto generated at compile time)
*   **`make.bat`**: Windows batch script to compile the project.
*   **`run.bat`**: Windows batch script to launch the compiled game.


## How to Build & Run

### Prerequisites
*   Windows OS
*   **DASM**: `dasm.exe` must be in the `bin/` folder.
*   **Stella**: `Stella.exe` and `SDL2.dll` must be in the `bin/` folder (optional, for running).

### Compiling
Run the build script from the root directory:

```cmd
make.bat
```

### Running
Launch the compiled ROM in Stella:

```cmd
run.bat
```

---

## Technical Documentation

### ROM Architecture

The game uses a **2-bank ROM** (8KB total) with bank-switching via strobes at `BANK0STROBE` (`$FFF8`) and `BANK1STROBE` (`$FFF9`). Bank switching is done through a self-modifying code technique — opcodes like `LDA_ABS` and `JMP_ABS` are written into zero-page RAM variables (`bankSwitchJMPOpcode`, `bankSwitchJMPAddr`, etc.) and executed in-place.

- **Bank 0** (`BANK0TOP` = `$1000`, reorg'd to `$D000`): Contains game logic — collision handling, inventory management, room event handlers, scoring, movement, input processing, and sound.
- **Bank 1** (`BANK1TOP` = `$2000`, reorg'd to `$F000`): Contains the display kernels, sprite data, playfield graphics, room handler dispatch, and music frequency tables.

### Display Kernels

The game uses **4 different scanline kernels** selected via `KernelJumpTableIndex` and `kernelJumpTable`:

| Index | Kernel | Rooms |
|-------|--------|-------|
| 0 | `staticSpriteKernel` | Treasure Room, Marketplace, Entrance Room, Black Market, Map Room, Mesa Side |
| 1 | `scrollingPlayfieldKernel` | Temple Entrance, Spider Room, Shining Light, Mesa Field, Valley of Poison |
| 2 | `multiplexedSpriteKernel` (thiefKernel) | Thieves' Den, Well of Souls |
| 3 | `arkPedestalKernel` | Ark Room (title/ending) |

Each kernel handles TIA register writes differently to accommodate the visual needs of those rooms — the thief kernel manages multiple P0 objects across scanlines, while the playfield kernel handles scrolling dungeon walls.

- **`staticSpriteKernel`**: P0's data stream is dual-purpose — bit 7 encodes direct TIA register writes (color/HMOVE) instead of graphics. Simplest kernel.
- **`scrollingPlayfieldKernel`**: Full PF1/PF2 rendering from pointer tables, dynamic dungeon wall segments, conventional P0/P1 drawing, ball object for timepiece. Supports scrollable rooms.
- **`multiplexedSpriteKernel`**: P0 is repositioned and redrawn multiple times per frame via coarse timing loops — classic scanline multiplexing to display several enemies from one hardware sprite.
- **`arkPedestalKernel`**: Single-purpose kernel for the title/ending screen — draws the Ark sprite and Indy on a height-adjustable pedestal.

### Room System

There are **14 rooms** defined as constants (IDs `$00`–`$0D`):

| ID | Constant | Room |
|----|----------|------|
| `$00` | `ID_TREASURE_ROOM` | Treasure Room |
| `$01` | `ID_MARKETPLACE` | Marketplace |
| `$02` | `ID_ENTRANCE_ROOM` | Entrance Room |
| `$03` | `ID_BLACK_MARKET` | Black Market |
| `$04` | `ID_MAP_ROOM` | Map Room |
| `$05` | `ID_MESA_SIDE` | Side of Mesa |
| `$06` | `ID_TEMPLE_ENTRANCE` | Temple Entrance |
| `$07` | `ID_SPIDER_ROOM` | Spider Room |
| `$08` | `ID_ROOM_OF_SHINING_LIGHT` | Room of Shining Light |
| `$09` | `ID_MESA_FIELD` | Mesa Field |
| `$0A` | `ID_VALLEY_OF_POISON` | Valley of Poison |
| `$0B` | `ID_THIEVES_DEN` | Thieves' Den |
| `$0C` | `ID_WELL_OF_SOULS` | Well of Souls |
| `$0D` | `ID_ARK_ROOM` | Ark Room (Title/End) |

Room transitions call `initRoomState` which loads per-room data from tables: `roomBGColorTable`, `roomPFColorTable`, `PFControlTable`, `objectPosXTable`, `roomObjPosYTable`, playfield graphics pointers, and sprite data.

Each room has a **handler** dispatched from `roomHandlerJmpTable` (Bank 1), which runs room-specific logic every frame.

### Inventory System

The player can carry up to **6 items** (`MAX_INVENTORY_ITEMS`). Each slot is a pair of zero-page pointers (`invSlotLo`/`invSlotHi` through `invSlotLo6`/`invSlotHi6`) that point directly to 8-byte sprite data in the `inventorySprites` table.

Item IDs are computed at assembly time as offsets from the sprite table:

```
ID = (spriteLabel - inventorySprites) / HEIGHT_ITEM_SPRITES
```

Key items and their IDs include:

| Item | Constant |
|------|----------|
| Empty | `ID_INVENTORY_EMPTY` |
| Whip | `ID_INVENTORY_WHIP` |
| Flute | `ID_INVENTORY_FLUTE` |
| Coins | `ID_INVENTORY_COINS` |
| Grenade (Market) | `ID_MARKETPLACE_GRENADE` |
| Grenade (Black Market) | `ID_BLACK_MARKET_GRENADE` |
| Key | `ID_INVENTORY_KEY` |
| Revolver | `ID_INVENTORY_REVOLVER` |
| Head of Ra | `ID_INVENTORY_HEAD_OF_RA` |
| Parachute | `ID_INVENTORY_PARACHUTE` |
| Timepiece | `ID_INVENTORY_TIME_PIECE` |
| Ankh | `ID_INVENTORY_ANKH` |
| Chai | `ID_INVENTORY_CHAI` |
| Hourglass | `ID_INVENTORY_HOUR_GLASS` |
| Shovel | `ID_INVENTORY_SHOVEL` |

Selection uses the left joystick. `selectedItemSlot` tracks the cursor position, and `selectedInventoryId` holds the current item's ID. Items are added via `placeItemInInventory` and removed via `removeItem`. Global pickup tracking uses `pickupItemsStatus` and `basketItemStatus` bitmasks.

### Scoring System

The score (`adventurePoints`) starts at `INIT_SCORE` (100) and is modified in `getFinalScore`. Lower is better — bonuses are subtracted and penalties are added.

**Bonuses (subtracted):**

| Variable | Description | Points |
|----------|-------------|--------|
| `findingArkBonus` | Found the Ark | 10 |
| `usingParachuteBonus` | Used parachute | 3 |
| `ankhUsedBonus` | Used Ankh for Mesa skip | 9 |
| `yarFoundBonus` | Found Yar easter egg | 5 |
| `mapRoomBonus` | Used Head of Ra | 14 |
| `mesaLandingBonus` | Landed on mesa | 3 |
| `livesLeft` | Remaining lives | varies |

**Penalties (added):**

| Variable | Description | Points |
|----------|-------------|--------|
| `grenadeOpeningPenalty` | Blasted wall | 2 |
| `escapePrisonPenalty` | Escaped dungeon via secret exit | 13 |
| `thiefShotPenalty` | Shot the thief | 4 |

The final value determines Indy's pedestal height in the Ark Room.

### Win Condition

Implemented in `playerHitInWellOfSouls`. All three conditions must be true:

1. `indyPosY >= $3F` — Indy is deep enough in the Well
2. `diggingState == $54` — dirt fully cleared via shovel
3. `secretArkMesaID == activeMesaID` — correct mesa (discovered via Map Room)

When all three are met, `arkRoomStateFlag` is set positive, triggering the endgame sequence in `arkPedestalKernel` which shows the Ark above Indy's pedestal.

### Key Game Mechanics

#### Grappling Hook (Mesa Field)
Calculated in `calculateMesaGrapple` — converts the hook's pixel position to a grid ID:

```
RegionY = ((HookY - 6) + ScrollOffset) / 16
RegionX = (HookX - 16) / 32
```

#### Map Room Reveal
In `mapRoomHandler`, when Indy holds the Head of Ra and the sun (driven by `timeOfDay`) is at the correct position, a beam reveals the Ark's mesa using data from `mapRoomArkLocX` / `mapRoomArkLocY`.

#### Time System
`timeOfDay` increments every ~63 frames (roughly once per second), driven in the VBLANK section. It controls the timepiece display, basket item rotation, sun position, and Head of Ra timing.

#### Scrolling (Mesa Field)
Handled in `handleMesaScroll` — the camera offset `p0OffsetPosY` shifts all object positions when Indy nears screen edges, bounded by `MESA_MAP_MAX_HEIGHT` (`$50`).

#### Sound System
Two channels with effect timers (`soundChan0EffectTimer`, `soundChan1EffectTimer`). The Raiders March plays from `raidersMarchFreqTable` when triggered with `RAIDERS_MARCH` (`$9C`). The flute melody uses `snakeCharmFreqTable` with `SNAKE_CHARM_SONG` (`$84`).

#### Easter Egg (Yar)
Triggered via `HandleEasterEgg` — finding Yar on the Flying Saucer Mesa sets `yarFoundBonus`. When combined with a high enough score, Howard Scott Warshaw's initials (`devInitialsGfx0` / `devInitialsGfx1`) appear in the inventory strip at `checkShowDevInitials`.

### Controls

- **Right joystick**: Movement + action button (use items/weapons)
- **Left joystick**: Inventory selection + drop button
- Input is read from `SWCHA` (`$0280`) and `INPT5` (fire buttons)

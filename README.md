# Raiders of the Lost Ark (Atari 2600) - Reverse Engineered Source

**Original Game (1982) by Atari, Inc.**  
**Original Designer:** Howard Scott Warshaw  
**Disassembly & Analysis:** Halkun (That's me!)

---

## Overview

This repository contains the fully reverse-engineered and commented source code for the Atari 2600 classic, *Raiders of the Lost Ark*.

## Project Structure

The project has been reorganized for a clean development workflow:

* **`src/`**: Contains the main assembly source (`raiders.asm`) and header files (`tia_constants.h`).
* **`bin/`**: Contains build tools (DASM) and emulator executable (Stella).
* **`out/`**: Destination for compiled binaries (`.bin`), symbol files (`.sym`), and listing files (`.lst`). (auto generated at compile time)
* **`make.bat`**: Windows batch script to compile the project.
* **`run.bat`**: Windows batch script to launch the compiled game.
* **`Makefile`**: Makefile to compile and launch the compiled in in Windows with Powershell or Linux with make.

## How to Build & Run

### Prerequisites

* Windows OS
* **DASM**: `dasm.exe` must be in the `bin/` folder.
* **Stella**: `Stella.exe` and `SDL2.dll` must be in the `bin/` folder (optional, for running).

* Linux
* **dasm** `dasm` must be installed on the system.
* **stella**: `stella` must be installed on the system.

### Compiling

* Windows

Run the build script from the root directory:

```cmd
make.bat
```

* Linux (or Windows PowerShell with make)

Build the rom by running make:

```cmd
make
```

### Running

* Windows

Launch the compiled ROM in Stella:

```cmd
run.bat
```

* Linux (or Windows PowerShell with make)

Launch the compiled ROM in Stella:

```cmd
make run
```

---

## Technical Documentation

### ROM Architecture

The game uses a **2-bank ROM** (8KB total) with bank-switching via strobes at `BANK0STROBE` (`$FFF8`) and `BANK1STROBE` (`$FFF9`). Bank switching is done through a self-modifying code technique where opcodes are written into zero-page RAM variables and executed in-place.

* **Bank 0** (`BANK0TOP` = `$D000`): Contains game logic — collision handling, inventory management, room event handlers, scoring, movement, input processing, and sound.
* **Bank 1** (`BANK1TOP` = `$F000`): Contains the display kernels, sprite data, playfield graphics, room handler dispatch, and music frequency tables.

### Game Loop

Like all Atari 2600 games, the program is structured around the NTSC television signal — one complete pass through the loop produces one frame of video (~60 fps). The frame is divided into four phases: **VSYNC**, **VBLANK**, **Kernel** (visible picture), and **Overscan**. Game logic is split across VBLANK and Overscan to stay within the CPU time budgets of each phase, and the two ROM banks are switched in and out at specific points every frame.

#### Frame Overview

```text
newFrame ──spin on INTIM──►
startNewFrame
  ├── VSYNC (3 scanlines)
  │     Timers, weapon clamp, RESET check
  │
  ├── VBLANK (~37 scanlines of CPU time)
  │   ├── [Bank 0] Main game logic
  │   │     Ark Room / title ── Snake AI ──
  │   │     Event checks ── Input & movement ──
  │   │     Inventory ── Item use ──
  │   │     Sprite animation ── Mesa scroll
  │   │
  │   ├── [Bank 1] Room-specific handler
  │   │     Per-room AI, physics, spawning
  │   │
  │   └── [Bank 0] Pre-kernel setup
  │         Colors, NUSIZ, CTRLPF from tables
  │         setObjPosX: position all 5 TIA objects
  │         Spin on INTIM until VBLANK expires
  │
  ├── VISIBLE KERNEL (~192 scanlines)
  │   ├── [Bank 1] drawScreen preamble (5 lines)
  │   │     Clear collisions, set initial PF, enable TIA
  │   │
  │   ├── [Bank 1] Room kernel dispatch (160 lines)
  │   │     staticSpriteKernel ──── rooms 0–5
  │   │     scrollingPlayfieldKernel ── rooms 6–10
  │   │     multiplexedSpriteKernel ── rooms 11–12
  │   │     arkPedestalKernel ──── room 13
  │   │
  │   └── [Bank 1] drawInventoryKernel (~27 lines)
  │         6-item inventory strip, selection cursor
  │
  └── OVERSCAN (~30 scanlines of CPU time)
      ├── [Bank 1] Post-kernel logic
      │     Sound/music ── Timepiece sprite ──
      │     Event animation ── Death sequence ──
      │     Inventory cycling ── Grapple state
      │
      └── [Bank 0] Collision handling
            Weapon hits ── Indy vs objects ──
            Room-specific pickups ── Idle handlers
            ──► newFrame (loop closes)
```

#### Phase 1: VSYNC (3 Scanlines)

**Entry point**: `startNewFrame`

The CPU asserts the VSYNC signal for exactly 3 scanlines, during which it performs lightweight housekeeping:

| Scanline | Work |
| -------- | ---- |
| 1 | Assert VSYNC. Clamp weapon position — if `weaponPosY` ≤ `$50`, center `weaponPosX`. Increment `frameCount`; every 64th frame (`and #$3f`) increments `timeOfDay`. If `eventTimer` is negative, decrement it (paralysis/cutscene countdown). |
| 2 | Check for game restart — if `arkRoomStateFlag` bit 7 is set (endgame state) AND the RESET switch is pressed, jump to `startGame`. |
| 3 | De-assert VSYNC. Arm the VBLANK timer: `TIM64T = VBLANK_TIME` (44). This gives 44 × 64 = 2,816 cycles ≈ 37 scanlines of CPU time for game logic. |

#### Phase 2: VBLANK (~37 Scanlines of CPU Time)

All game logic runs while the TIA outputs a blank screen. Work is spread across both ROM banks with two bank switches during this phase.

##### Bank 0 — Main Game Logic

This is the largest block of game code, executing in order every frame:

| Step | Label | Description |
| ---- | ----- | ----------- |
| 1 | `checkGameOver` | **Start logic on first scan line**: if `indyStatus` overflows to 0, call `getFinalScore` and transition to the Ark Room. |
| 2 | `checkForArkRoom` | **Ark Room / title screen**: if in the Ark Room, play Raiders March, check Yar bonus for HSW initials easter egg. Otherwise skip. |
| 3 | *(Ark Room only)* | **Pedestal elevator**: slowly lower Indy to his score height. Check fire button for restart. Set `arkRoomStateFlag` to enable RESET. |
| 4 | `checkScreenEvent` | **Cutscene check**: if `screenEventState` bit 6 is set, advance the Ark reveal sequence. |
| 5 | `updateSnakeAI` | **Snake AI**: every 4th frame, grow snake sprite, steer toward Indy using `snakePosXOffsetTable`, update `ballPosX`/`ballPosY` and `kernelRenderState`. |
| 6 | `configSnake` | **Snake kernel setup**: load `kernelDataPtrLo/Hi` and `kernelDataIndex` from `snakeMotionTable0`–`snakeMotionTable3` for the wiggling ball sprite. |
| 7 | `checkIndyStatus` | If `indyStatus` bit 7 is set (death in progress), skip to `dispatchRoomHandler` — bypass normal input. |
| 8 | `checkGameScriptTimer` | If `eventTimer` is negative (Indy paralyzed/frozen), force standing sprite and skip input. |
| 9 | `branchOnFrameParity` | **Frame parity split**: even frames run full input processing. Odd frames skip to `clearItemUseOnButtonRelease`. |
| 10 | `handleWeaponAim` | **Weapon aiming**: joystick moves the weapon crosshair (missile 1) with boundary clamping. |
| 11 | `handleIndyMove` | **Movement**: read `SWCHA` → `getMoveDir` → move Indy → check room boundary override tables (`checkRoomOverrideCondition`) → trigger room transitions if a boundary is crossed. |
| 12 | `handleInventorySelect` | **Left controller**: fire button cycles through inventory slots. Handles item drop, bullet reload (+3), and shovel placement. |
| 13 | `clearItemUseOnButtonRelease` | Clears `USING_GRENADE_OR_PARACHUTE` flag on right fire button release. |
| 14 | `handleItemUse` | **Right controller**: fire button dispatches the selected item — grenade throw/cook timer, parachute deploy, grapple hook launch, shovel dig, Ankh warp, revolver fire, whip strike. This is the largest single block in VBLANK. |
| 15 | `selectIndySprite` | **Sprite selection**: choose Indy's current sprite pointer — parachute sprite, standing sprite, or walk-cycle animation (advances frame on a timer). |
| 16 | `handleMesaScroll` | **Vertical scrolling**: in Mesa Field or Valley of Poison, shift the camera offset (`roomObjectVar`) and adjust all object Y positions to scroll the world. |

##### Bank Switch → Bank 1: Room Handlers

At `dispatchRoomHandler`, the code writes `selectRoomHandler` as the target address and jumps through the `jumpToBank1` trampoline.

`selectRoomHandler` dispatches via `roomHandlerJmpTable` — each room has its own handler that runs room-specific AI and physics:

| Room | Handler | Key Logic |
| ---- | ------- | --------- |
| Treasure Room | `treasureRoomHandler` | Item cycle timer, treasure availability, treasure spawning |
| Marketplace | *(none — immediate return)* | — |
| Entrance Room | `entranceRoomHandler` | Sets `screenEventState = $40` |
| Black Market | `blackMarketRoomHandler` | Lunatic/blocker positioning, bribe check |
| Map Room | `mapRoomHandler` | Sun height from `timeOfDay`, Head of Ra beam, movement constraints |
| Mesa Side | `mesaSideRoomHandler` | Parachute/freefall physics, gravity, horizontal input |
| Temple Entrance | `templeEntranceRoomHandler` | Timepiece placement, room graphics from `entranceRoomEventState` |
| Spider Room | `spiderRoomHandler` | Spider AI (passive→aggressive), web positioning, animation |
| Shining Light | `roomOfShiningLightHandler` | Chase AI, dungeon secret exit check |
| Mesa Field | `mesaFieldRoomHandler` | Pins P0/M0/Ball to center Y (`$7F`) for scrolling |
| Valley of Poison | `valleyOfPoisonRoomHandler` | Thief chase/escape AI, tsetse swarm spawning |
| Thieves' Den | `thievesDenRoomHandler` | Moves 5 thieves with left/right boundary bounce |
| Well of Souls | `wellOfSoulsRoomHandler` | Sets mesa landing bonus, then shares thief-movement code |

All handlers exit via `jmpSetupNewRoom`, which bank-switches back to Bank 0.

##### Bank Switch → Bank 0: Pre-Kernel Setup

`setupNewRoom` prepares the TIA for display:

1. If `screenInitFlag` ≠ 0, call `updateRoomEventState` (one-shot room initialization), then clear the flag.
2. Set `NUSIZ0` from the per-room `hmoveTable` entry.
3. Set `CTRLPF` from `roomPFControlFlags` (playfield reflection/priority/ball size).
4. Set `COLUBK`, `COLUPF`, `COLUP0`, `COLUP1` from per-room color tables.
5. If in the Thieves' Den or Well of Souls, initialize 5 thief HMOVE positions from table data.

Then `setThievesPosX` positions all 5 TIA objects (P0, P1, M0, M1, Ball) using the coarse/fine HMOVE technique. This consumes **6 scanlines** (one WSYNC per object + one for HMOVE).

Finally, `waitTime` spins on `INTIM` until the VBLANK timer expires, then bank-switches to Bank 1 for `drawScreen`.

#### Phase 3: Visible Kernel (~192 Scanlines)

**Entry point**: `drawScreen` (Bank 1)

##### Kernel Preamble (5 Scanlines)

The first few visible lines set up the display state:

* Clear horizontal motion registers (`HMCLR`) and collision latches (`CXCLR`).
* Write initial PF0/PF1/PF2 from per-room playfield tables.
* Enable TIA output (`VBLANK = 0`), zero the `scanline` counter.
* Disable the Ball sprite in the Map Room (used for the sun position mechanic).
* Read `SWCHA` → set `REFP1` for Indy sprite reflection (skipped during death/Ark Room).
* Three WSYNC+HMOVE pairs to settle object positions.
* Dispatch to the appropriate kernel via RTS-trick: push return address from `kernelJumpTable` indexed by `kernelJumpTableIndex` for the current room, then `rts`.

##### Room Kernels (160 Scanlines)

The kernel index table maps each room to one of four kernels:

| Index | Kernel | Rooms | Scanline Method |
| ----- | ------ | ----- | --------------- |
| 0 | `staticSpriteKernel` | 0–5 | 2 scanlines/iteration, 80 iterations |
| 2 | `scrollingPlayfieldKernel` | 6–10 | 2 scanlines/iteration, 80 iterations |
| 4 | `multiplexedSpriteKernel` | 11–12 | State machine, variable per thief zone |
| 6 | `arkPedestalKernel` | 13 | 1 scanline/iteration, ~160 lines |

**`staticSpriteKernel`** (Treasure Room, Marketplace, Entrance, Black Market, Map Room, Mesa Side):
Two scanlines per loop. Scanline 1: HMOVE, check snake/ball draw range, enable missiles M0 (web/swarm) and M1 (weapon) by comparing against their Y positions. Scanline 2: draw P0 sprite — bit 7 of the graphics data encodes inline TIA register writes (color/HMOVE) instead of shape data, allowing P0 to change color or position mid-frame. Enable the ball by scanline comparison.

**`scrollingPlayfieldKernel`** (Temple Entrance, Spider Room, Shining Light, Mesa Field, Valley of Poison):
Two scanlines per loop with playfield scrolling. On each iteration, the scanline is compared to `p0DrawStartLine` — above that boundary, the kernel indexes `(pf1GfxPtrLo),y` / `(pf2GfxPtrLo),y` with a scroll offset (`roomObjectVar`) to render the scrolling wall. Below that boundary, `dynamicGfxData` renders destructible dungeon wall segments or cleared passages. Both paths draw P0 and P1 (Indy) by scanline–vs–Y comparison. The ball object is driven through `(kernelDataPtrLo),y` for the snake wiggle animation.

**`multiplexedSpriteKernel`** (Thieves' Den, Well of Souls):
Displays 5 enemy thieves using a single P0 hardware sprite, repositioned between each thief's zone (~32 scanlines each). Operates as a state machine via `kernelRenderState`: **positioning phase** (bit 7) uses a coarse/fine delay loop to place RESP0, **drawing phase** (bit 6) streams `(p0GfxPtrLo),y` and `(kernelDataPtrLo),y` for sprite and color data across 16 lines. Between thief zones, P1 (Indy) is drawn using the PHP/stack trick — `txs` redirects the stack pointer so that `php` writes directly to TIA enable registers (`ENABL`/`ENAM1`/`ENAM0` at `$1F`/`$1E`/`$1D`).

**`arkPedestalKernel`** (Ark Room — title and ending screen):
Single-height scanlines (1 WSYNC per line). Lines 0–14: draw the Ark top/wings sprite with rainbow color cycling (only in win state). Lines 15–28: draw the Ark body with alternating gold patterns. Lines 29–143: draw Indy's standing sprite at the pedestal height determined by `adventurePoints` — above Indy is empty, below is the diamond-pattern `pedestalLiftSprite`. Lines 144–159: draw the pedestal base.

##### Inventory Kernel (~27 Scanlines)

All four room kernels converge at `drawInventoryKernel`, which draws the bottom-of-screen inventory strip:

1. **2 lines**: Clear all sprites, fill PF1/PF2 solid (separator bar).
2. **2 lines**: Set `NUSIZ0`/`NUSIZ1` to 3-copies-close mode, enable VDEL for both players, position P0/P1 for 48-pixel-wide multiplexed rendering.
3. **1 line**: HMOVE to fine-position, set inventory item colors (gold), position ball (selection cursor).
4. **1 line**: Clear playfield, set `COLUBK` to black.
5. **5 lines**: Burgundy background border.
6. **8 lines**: `drawInventoryItems` — render 6 inventory item sprites using the 48-pixel GRP0/GRP1 VDEL technique (write P0, P1, P0, P1, P0, P1 in rapid succession each line).
7. **4 lines**: Clear sprites, reset VDEL/NUSIZ, draw selection cursor ball.
8. **4 lines**: Final separator lines and overscan preparation.

#### Phase 4: Overscan (~30 Scanlines of CPU Time)

Immediately after the inventory kernel, the TIA is blanked (`VBLANK = $0F`) and the overscan timer is armed: `TIM64T = OVERSCAN_TIME` (36). This gives 36 × 64 = 2,304 cycles ≈ 30 scanlines. The stack pointer is also reset to `$FF` here.

##### Bank 1 — Post-Kernel Logic

| Step | Label | Description |
| ---- | ----- | ----------- |
| 1 | `updateSoundRegisters` | Process both TIA audio channels (X=1, then X=0). Set AUDC, AUDV, AUDF. Dispatch to `playRaidersMarch` (effect `$9C`) or `playFluteMelody` (effect `$84`) for sustained music playback. |
| 2 | `finishUpdateSound` | If holding the Timepiece: toggle open/closed sprite on right fire press. If holding the Flute: activate Snake Charmer song. |
| 3 | `updateEventState` | If `screenEventState` bit 7 is set: animate the on-screen event (move object toward target via `updateMoveToTarget`), update timepiece graphics pointer for the snake reveal animation. |
| 4 | `updateInvItemPos` | Position 3 inventory display objects (X=2,3,4) via `updateInvObjPos` — converts item slot sprite pointers into on-screen X positions. |
| 5 | *(death check)* | **Death dissolve sequence**: if `indyStatus` bit 7 is set, shrink `indySpriteHeight` by 1 line every 16 frames with a descending sound effect. At height < 3 (hat only), rotate the flag and pause for 60 frames. At frame 120: respawn with full height, decrement `livesLeft`. If `livesLeft` goes negative, set `indyStatus = INDY_GAMEOVER` (triggers game-over on the next frame's overflow check). |
| 6 | `invItemSelectCycle` | If not in the Ark Room: read `SWCHA` left/right to cycle inventory selection. Handle hourglass → grapple initialization in Mesa Field. Drive the grapple state machine (incrementing stages, position alignment checks). |

##### Bank Switch → Bank 0: Collision Handling

At `jmpObjHitHandeler`, the code bank-switches to Bank 0 and enters the collision dispatch chain. This reads the TIA collision registers that were latched during the kernel:

| Step | Label | Collision Register | Description |
| ---- | ----- | ------------------ | ----------- |
| 1 | `checkForObjHit` | `CXM1P` | Weapon (M1) hit player/thief → flip thief direction, clear weapon, apply `thiefShotPenalty`. |
| 2 | `checkWeaponPFHit` | `CXM1FB` | Weapon hit playfield → destroy dungeon wall segment (modify `dynamicGfxData` bitmask). |
| 3 | `checkWeaponBallHit` | `CXM1FB` bit 6 | Weapon hit ball/snake → kill the snake. |
| 4 | `checkIndyBallHit` | `CXP1FB` | Indy hit playfield/ball → timepiece pickup, flute immunity check, tsetse fly paralysis, snake death. |
| 5 | `checkMesaSideExit` | `CXM0P` | Mesa Side: M0 collision enters Well of Souls; falling off (Indy Y ≥ `$4F`) enters Valley of Poison. |
| 6 | `checkPlayerCollision` | `CXPPMM` | Player-player collision → dispatches to room-specific handlers via `playerHitJumpTable` for pickups and interactions (whip, key, baskets, shovel, parachute landing, etc.). |
| 7 | `playerHitDefault` | `CXP1FB` | Secondary dispatch → `playfieldHitJumpTable` for wall/boundary collisions and idle room logic. |
| 8 | `checkMissile0Hit` | `CXM0P` | M0-player collisions (spider web capture, tsetse swarm death), grenade detonation timer check. |

After the collision chain completes, execution falls through to `newFrame`, which spins on `INTIM` waiting for the overscan timer to expire — and the cycle begins again.

#### Bank Switching Mechanism

Both banks contain a symmetric trampoline routine (`jumpToBank1` in Bank 0, `jumpToBank0` in Bank 1). The trampoline writes self-modifying code into zero-page RAM (`temp0`–`temp5`):

```text
temp0: LDA $FFF8/$FFF9    ; reading the strobe address switches banks
temp3: JMP <target>        ; then jumps to the target address
```

The caller sets `temp4`/`temp5` to the target address before jumping to the trampoline. Executing `jmp temp0` reads the bank strobe (switching ROM) and immediately jumps to the target label in the new bank.

**Bank switches per frame** (in execution order):

| # | Direction | Trigger | Target |
| - | --------- | ------- | ------ |
| 1 | Bank 0 → 1 | `dispatchRoomHandler` | `selectRoomHandler` (room-specific handler) |
| 2 | Bank 1 → 0 | `jmpSetupNewRoom` | `setupNewRoom` (pre-kernel color/position setup) |
| 3 | Bank 0 → 1 | `jmpDisplayKernel` | `drawScreen` (visible kernel + overscan) |
| 4 | Bank 1 → 0 | `jmpObjHitHandeler` | `checkForObjHit` (collision dispatch) |

Bank 1 also has a safety stub (`bank1Start`) at its reset vector entry — it immediately reads `BANK0STROBE` to switch back to Bank 0 if Bank 1 is entered on power-on.

#### Special States

**Title / Ark Room**: The Ark Room (`ID_ARK_ROOM`, `$0D`) serves double duty as the title screen and the endgame screen. On cold boot, `startGame` sets `currentRoomId = ID_ARK_ROOM` and fills inventory with copyright text sprites. The VBLANK Ark Room logic plays the Raiders March, runs the pedestal elevator animation (lowering Indy to his score height), and checks the fire button for restart.

**Death Sequence**: Setting `indyStatus` bit 7 triggers the death dissolve during overscan. Indy's sprite height shrinks by one line every 16 frames. Once only the hat remains (height < 3), the flag is rotated and the sprite disappears for 60 frames. At frame 120, Indy respawns at full height and `livesLeft` is decremented. If lives drop below zero, `indyStatus` is set to `INDY_GAMEOVER` — on the next frame, the VBLANK overflow check catches this and transitions to the Ark Room.

**Room Transitions**: Triggered by the boundary override system in `handleIndyMove`. When Indy crosses a room edge (checked via `checkRoomOverrideCondition` against per-room boundary tables), `currentRoomId` is changed and `initRoomState` reinitializes all per-room state — sprites, playfield pointers, object positions, and event flags. Special transitions include: Mesa Side fall into Valley of Poison (Y position check), M0 collision into Well of Souls, blown-open wall alignment into the Temple, and Ankh warp directly to Mesa Field.

### Display Kernels

The game uses **4 different scanline kernels** selected via `kernelJumpTableIndex` and `kernelJumpTable`:

| Index | Kernel | Rooms |
| ----- | ------ | ----- |
| 0 | `staticSpriteKernel` | Treasure Room, Marketplace, Entrance Room, Black Market, Map Room, Mesa Side |
| 1 | `scrollingPlayfieldKernel` | Temple Entrance, Spider Room, Shining Light, Mesa Field, Valley of Poison |
| 2 | `multiplexedSpriteKernel` (thiefKernel) | Thieves' Den, Well of Souls |
| 3 | `arkPedestalKernel` | Ark Room (title/ending) |

Each kernel handles TIA register writes differently to accommodate the visual needs of those rooms — the thief kernel manages multiple P0 objects across scanlines, while the playfield kernel handles scrolling dungeon walls.

* **`staticSpriteKernel`**: P0's data stream is dual-purpose — bit 7 encodes direct TIA register writes (color/HMOVE) instead of graphics. Simplest kernel.
* **`scrollingPlayfieldKernel`**: Full PF1/PF2 rendering from pointer tables, dynamic dungeon wall segments, conventional P0/P1 drawing, ball object for timepiece. Supports scrollable rooms.
* **`multiplexedSpriteKernel`**: P0 is repositioned and redrawn multiple times per frame via coarse timing loops — classic scanline multiplexing to display several enemies from one hardware sprite.
* **`arkPedestalKernel`**: Single-purpose kernel for the title/ending screen — draws the Ark sprite and Indy on a height-adjustable pedestal.

### P0 Graphics Stream Encoding

The `staticSpriteKernel` rooms (0–5) use a clever data encoding for Player 0 that allows a single byte stream to carry **both** pixel data and inline TIA register commands. This is handled by the `drawP0GraphicsStream` routine.

#### How It Works

Each byte in a `*playerGraphics` data table (e.g., `marketplacePlayerGraphics`, `entranceRoomPlayerGraphics`) is read once per scanline. The routine checks **bit 7** to determine the byte's meaning:

| Bit 7 | Meaning      | Action                                                       |
| ----- | ------------ | ------------------------------------------------------------ |
| **0** | Pixel data   | Written directly to `GRP0` (the Player 0 graphics register)  |
| **1** | Command byte | Decoded as a TIA register write (color or horizontal motion) |

#### Command Byte Decoding

When bit 7 is set, the byte encodes both a **target register** and a **payload value**:

```text
Byte layout:  1 R PPPPPP 0
              │ │ └─────┘
              │ │    └── Payload (6 bits → shifted into bits 7-2 of TIA register)
              │ └─────── Register select: 0 = COLUP0 (color), 1 = HMP0 (motion)
              └───────── Bit 7: always 1 (command flag)
```

The decoding steps:

1. **ASL** — Shift left, pushing bit 7 out (into carry) and the register-select bit into bit 1.
2. **AND #$02** — Isolate bit 1 → becomes the X index: `0` = `COLUP0`, `2` = `HMP0`.
3. **STA (pf1GfxPtrLo,X)** — Write the shifted payload to the selected TIA register via indirect indexed addressing. The `pf1GfxPtrLo` pointer is set up so that `X=0` targets `COLUP0` and `X=2` targets `HMP0`.

Two assembly constants simplify authoring these command bytes:

```asm
SET_PLAYER_0_COLOR = %10000000   ; bit 7 set, bit 0 clear → writes COLUP0
SET_PLAYER_0_HMOVE = %10000001   ; bit 7 set, bit 0 set   → writes HMP0
```

A color command is written as:

```asm
.byte SET_PLAYER_0_COLOR | (GREEN + 8) >> 1   ; Set P0 color to green (luminance 8)
```

An HMOVE command is written as:

```asm
.byte SET_PLAYER_0_HMOVE | HMOVE_L7 >> 1      ; Shift P0 left 7 pixels
```

The `>> 1` is necessary because ASL will shift the payload back left during decoding.

#### GRP0 Persistence

A critical detail: **GRP0 is not cleared between command scanlines**. When a command byte is processed, the TIA register is updated but GRP0 retains whatever pixel pattern was last written. This means the same sprite shape continues to be displayed across multiple scanlines while its color or position changes.

This is exploited heavily for multi-colored sprites. For example, the marketplace sellers use a single `$7E` (`.XXXXXX.`) pixel pattern that persists through rapid color changes — BLACK (hat) → grey (stripe) → pink (face) → BLACK (body) — creating the illusion of a multi-colored character from a single repeating shape.

#### HMOVE for Repositioning and Diagonals

HMOVE commands serve two purposes in the data streams:

1. **Repositioning between items**: Large moves (e.g., `HMOVE_L7`, `HMOVE_R8`) shift P0 to a new screen location for the next visual element. GRP0 is typically set to `$00` during these scanlines so nothing is visible during the move.

2. **Diagonal shapes**: Sustained small moves (e.g., `HMOVE_R1` every scanline) shift the sprite 1 pixel per line, creating angled shapes. The Entrance Room whip uses `HMOVE_R3` drift, and the Marketplace flute uses `HMOVE_R1` drift to produce their diagonal angles.

3. **Jagged edges**: Alternating `HMOVE_L1`/`HMOVE_R1` commands with a persistent GRP0 pattern create irregular, natural-looking silhouettes. The Entrance Room cave opening uses 15 consecutive HMOVE jitter commands to produce its rough stone wall edge.

#### Per-Room Data Tables

Each `staticSpriteKernel` room has its own `*playerGraphics` data table:

| Room | Data Table | Key Elements |
| ---- | ---------- | ------------ |
| Treasure Room | `treasureRoomPlayerGraphics` | Ankh, coins, hourglass, chai (cycling treasures) |
| Marketplace | `marketplacePlayerGraphics` | Two sellers, flute, three baskets, parachute pack |
| Entrance Room | `entranceRoomPlayerGraphics` | Cave entrance (jagged edge), boulder, whip |
| Black Market | `blackMarketPlayerGraphics` | Two sellers, bullets, basket, shovel |
| Map Room | `mapRoomPlayerGraphics` | Sun disc, hieroglyphic wall, model chamber, pedestal |
| Mesa Side | `mesaSidePlayerGraphics` | Parachute figure, tree (canopy/trunk), mesa ground |

The initial P0 color for each room is set from `roomP0ColorTable` during pre-kernel setup, but is typically overridden immediately by the first `SET_PLAYER_0_COLOR` command in the data stream.

### Room System

There are **14 rooms** defined as constants (IDs `$00`–`$0D`):

| ID | Constant | Room |
| -- | -------- | ---- |
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

Room transitions call `initRoomState` which loads per-room data from tables: `roomBGColorTable`, `roomPFColorTable`, `pfControlTable`, `objectPosXTable`, `roomObjPosYTable`, playfield graphics pointers, and sprite data.

Each room has a **handler** dispatched from `roomHandlerJmpTable` (Bank 1), which runs room-specific logic every frame.

### Inventory System

The player can carry up to **6 items** (`MAX_INVENTORY_ITEMS`). Each slot is a pair of zero-page pointers (`invSlotLo`/`invSlotHi` through `invSlotLo6`/`invSlotHi6`) that point directly to 8-byte sprite data in the `inventorySprites` table.

Item IDs are computed at assembly time as offsets from the sprite table:

```text
ID = (spriteLabel - inventorySprites) / HEIGHT_ITEM_SPRITES
```

Key items and their IDs include:

| Item | Constant |
| ---- | -------- |
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

Selection uses the left joystick. `selectedItemSlot` tracks the cursor position (byte offset 0,2,4,6,8,10 into the slot array), and `selectedInventoryId` holds the current item's ID. Items are added via `placeItemInInventory` and removed via `removeItem`.

**Item Tracking Bitmasks:**

The game tracks which items have been collected using two separate bitmasks:

* **`basketItemStatus`** — Tracks **spawnable items** found at fixed world locations. In the Marketplace, these are the three literal baskets that contain the Key, Grenades, and Revolver. In the Treasure Room, the term "basket" is a code abstraction — it simply means the item is in its original, non-picked-up state (P0 displays the cycling item, and touching it picks it up). These items can respawn when dropped.
* **`pickupItemStatus`** — Tracks **unique items** that exist as one-of-a-kind objects in the world: Whip, Shovel, Head of Ra, Timepiece, Hourglass, Ankh, and Chai. Once collected, their world placement changes.

The `itemIndexTable` determines which bitmask applies to each item: even indices use `basketItemStatus`, odd indices use `pickupItemStatus`. The helper routines `showItemAsTaken`, `setItemAsNotTaken`, and `isItemAlreadyTaken` handle the bit manipulation transparently.

### Scoring System

The score (`adventurePoints`) starts at `INIT_SCORE` (100) and is modified in `getFinalScore`. Lower is better — bonuses are subtracted and penalties are added.

**Bonuses (subtracted):**

| Variable | Description | Points |
| -------- | ----------- | ------ |
| `findingArkBonus` | Found the Ark | 10 |
| `usingParachuteBonus` | Used parachute | 3 |
| `ankhUsedBonus` | Used Ankh for Mesa skip | 9 |
| `yarFoundBonus` | Found Yar easter egg | 5 |
| `mapRoomBonus` | Used Head of Ra | 14 |
| `mesaLandingBonus` | Landed on mesa | 3 |
| `livesLeft` | Remaining lives | varies |

**Penalties (added):**

| Variable | Description | Points |
| -------- | ----------- | ------ |
| `grenadeOpeningPenalty` | Blasted wall | 2 |
| `escapePrisonPenalty` | Escaped dungeon via secret exit | 13 |
| `thiefShotPenalty` | Shot the thief | 4 |

The final value determines Indy's pedestal height in the Ark Room. Unlike what the legends say, you can not get enough points to "Touch" the Ark.

### Win Condition

Implemented in `playerHitInWellOfSouls`. All three conditions must be true:

1. `indyPosY >= $3F` — Indy is deep enough in the Well
2. `dirtPileGfxState == clearedDirtPile` — dirt fully cleared via shovel
3. `secretArkMesaID == activeMesaID` — correct mesa (discovered via Map Room)

When all three are met, `arkRoomStateFlag` is set positive, triggering the endgame sequence in `arkPedestalKernel` which shows the Ark above Indy's pedestal.

### Key Game Mechanics

#### Grappling Hook (Mesa Field)

Calculated in `calculateMesaGrapple` — converts the hook's pixel position to a grid ID:

```text
RegionY = ((HookY - 6) + ScrollOffset) / 16
RegionX = (HookX - 16) / 32
```

#### Map Room Reveal

In `mapRoomHandler`, when Indy holds the Head of Ra and the sun (driven by `timeOfDay`) is at the correct position, a beam reveals the Ark's mesa using data from `mapRoomArkLocX` / `mapRoomArkLocY`.

#### Time System

`timeOfDay` increments every ~63 frames (roughly once per second), driven in the VBLANK section. It controls the timepiece display, treasure room rotation, sun position, and Head of Ra timing.

#### Scrolling (Mesa Field)

Handled in `handleMesaScroll` — the camera offset `roomObjectVar` shifts all object positions when Indy nears screen edges, bounded by `MESA_MAP_MAX_HEIGHT` (`$50`).

#### Sound System

Two channels with effect timers (`soundChan0Effect`, `soundChan1Effect`). The Raiders March plays from `raidersMarchFreqTable` when triggered with `RAIDERS_MARCH` (`$9C`). The flute melody uses `snakeCharmFreqTable` with `SNAKE_CHARM_SONG` (`$84`).

#### Easter Egg (Yar)

Triggered in `checkForArkRoom` — finding Yar on the Flying Saucer Mesa (via `checkMarketYar`) sets `yarFoundBonus`. When `yarFoundBonus` is set and `arkRoomStateFlag` bit 7 is clear, Howard Scott Warshaw's initials (`devInitialsGfx0` / `devInitialsGfx1`) are loaded into the inventory display slots.

### Controls

* **Right joystick**: Movement + action button (use items/weapons)
* **Left joystick**: Inventory selection + drop button
* Input is read from `SWCHA` (`$0280`) and `INPT5` (fire buttons)

### Special Thanks

Thanks to Dennis Debro for sharing his reverse engineering attempt so that I could merge it with mine.

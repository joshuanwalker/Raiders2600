# Raiders of the Lost Ark (Atari 2600) - Reverse Engineered Source

**Original Game (1982) by Atari, Inc.**  
**Original Designer:** Howard Scott Warshaw  
**Disassembly & Analysis:** Dennis Debro & Halkun

---

## Overview

This repository contains the fully reverse-engineered and commented source code for the Atari 2600 classic, *Raiders of the Lost Ark*.

Unlike a raw disassembly, this project aims to provide a **semantic understanding** of the game logic. Variables, constants, and subroutines have been renamed and heavily commented to explain *how* the game works, from the procedural flute music to the complex collision logic in the Map Room.

## Project Structure

The project has been reorganized for a clean development workflow:

*   **`src/`**: Contains the main assembly source (`raiders.asm`) and header files (`tia_constants.h`).
*   **`bin/`**: Contains build tools (DASM) and emulator executable (Stella).
*   **`out/`**: Destination for compiled binaries (`.bin`), symbol files (`.sym`), and listing files (`.lst`).
*   **`make.bat`**: Windows batch script to compile the project.
*   **`run.bat`**: Windows batch script to launch the compiled game.

## Key Features & Analysis

This codebase documents several unique programming feats achieved by Howard Scott Warshaw on the 2600 hardware:

### 1. The Dual-Joystick Input System
*   **Logic:** The code uniquely reads both `INPT` and `SWCHA` ports simultaneously to interpret two Joystick controllers.
*   **Implementation:** See `playerInputState` in `src/raiders.asm` for how movement (Right Stick) and Inventory management (Left Stick) are decoupled.

### 2. Procedural Music Generation
*   **The Flute:** Instead of storing meaningful table data for the "Snake Charmer" tune, the game uses the master `frameCount` to mathematically generate pitch variations in real-time.
*   **The Check:** See `playFluteMelody` for the algorithm and `handleIndyVsObjHit` for how the flute grants immunity to snakes.

### 3. Complex Room Architectures
Each room runs its own specific kernel logic in Bank 1:
*   **The Map Room:** Contains complex math to calculate the "Sun Height" based on the `timeOfDay` variable. Using the Staff/Head of Ra triggers a geometric check to draw the beam of light.
*   **The Mesa Field:** Documented the "Parallax/Camera Scroll" logic. Previously confused with Indy "sinking," the code actually shifts the world offset (`p0OffsetPosY`) and all object Y-coordinates to simulate a vertically scrolling map.
*   **Entrance Room:** Logic for destructible environments (grenade vs. wall) and strictly bounded collision detection for picking up the Whip versus the Rock.

### 4. Inventory & State Management
*   **System:** A complex pointer-based system (`invSlotLo`/`Hi`) manages the 6 inventory slots.
*   **The Ark Logic:** The "Win Condition" is determined by comparing the `activeMesaID` (where the player dug) against the randomized `secretArkMesaID`.

## How to Build & Run

### Prerequisites
*   Windows OS
*   **DASM**: `dasm.exe` must be in the `bin/` folder.
*   **Stella**: `Stella.exe` and `SDL2.dll` must be in the `bin/` folder (optional, for running).

### Compiling
Run the build script from the root directory:

```cmd
make.bat
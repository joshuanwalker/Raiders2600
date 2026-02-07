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

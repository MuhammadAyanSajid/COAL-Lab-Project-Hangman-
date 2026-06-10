# CSC205L - Assembly Language Data Processing and Security Toolkit

## Project Overview
This project is a modular, menu-driven Assembly Language toolkit that combines **Bit-level Security Operations**, **String Processing**, and **Numeric Data Handling** through an interactive Hangman Game. 

Developed for the **UET Lahore Computer Organization and Assembly Language (CSC205L) Open Ended Lab**.

## Tools & Environment
* **Assembler**: MASM (Microsoft Macro Assembler)
* **IDE**: Microsoft Visual Studio (2019/2022/2026)
* **Library**: Irvine32 (`Irvine32.inc`)
* **Architecture**: x86 (32-bit)

## File Structure (Modular Design)
The project is strictly divided into 5 modules to demonstrate professional procedure-based architecture:
1. `globals.inc`: Shared header file containing `PROTO` definitions, global variables, and `Start_level` / `Reset_Str` MACROS.
2. `main.asm`: The entry point and main menu control.
3. `auth.asm`: Bit-level security utility (XOR/ROL/ROR) and password file handling.
4. `hangman.asm`: String processor (array traversal, character replacement, string reversal, bitwise case-conversion).
5. `results.asm`: Numeric analyzer (averages, high scores, file I/O, array-based history tracking).

## How to Build and Run
1. Create a new Visual Studio MASM/Irvine32 Project.
2. Add all `.asm` files to the **Source Files** folder.
3. Add `globals.inc` to the **Header Files** folder. *(Note: Do not place the .inc file in Source Files, or VS will attempt to compile it and throw an END directive error).*
4. Right-click any `.asm` file -> **Properties** -> Ensure **Item Type** is set to **Microsoft Macro Assembler**.
5. Press **Ctrl + Shift + B** to build the solution.
6. Press **Ctrl + F5** to run the program.

## First Boot Instructions
On the very first run, the system will automatically create `password.txt` and `highscore.dat`.
* **Default Password**: `123456`
Once logged in, you can change the password or play the game. The new password and high scores will persist across program restarts via binary File I/O.

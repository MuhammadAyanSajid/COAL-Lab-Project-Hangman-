# CSC205L - Assembly Language Data Processing & Security Toolkit
**Computer Organization and Assembly Language Lab (CSC205L)**  
**Department of Computer Science, UET Lahore (New Campus) - Fall 2024**

## 👥 Project Team
| Name | GitHub Profile |
| :--- | :--- |
| **Muhammad Ayan Sajid** | [@MuhammadAyanSajid](https://github.com/MuhammadAyanSajid) |
| **Muhammad Husnain** | [@nexHus](https://github.com/nexhus) |
| **Fiza Shahid Khan** | [@Fiza Shahid Khan](https://www.linkedin.com/in/fiza-shahid-khan-a657713b2/) |
| **Shareen Asim** | [@Shareen Asim](https://www.linkedin.com/in/shareen-asim-9987a33a8/) |
| **Abdul Hadi** |

**Submitted To:** Mr. Noman Munir

---

## Project Overview
This project is an advanced, fully modular Assembly Language toolkit that combines **Bit-level Security Operations**, **Dynamic String Processing**, and **Numeric Data Handling** through an interactive, infinitely replayable Hangman Game.

It strictly adheres to the UET Lahore Open Ended Lab (OEL) Rubric, demonstrating real-world applications of low-level memory management, aggressive file parsing, and system-level I/O.

## ✨ Core Features
* **Bitwise Security Module:** Secure login system using XOR masking and Bitwise Rotations (`ROL`/`ROR`). Passwords are fully encrypted in memory and stored securely in a local text file.
* **Dynamic File Parsing & RNG:** Automatically generates or reads a 500+ word dictionary (`words.txt`). Uses an aggressive alphabetic filter to wipe out ghost characters/delimiters, dynamically buffering up to 15,000 bytes. Uses the system clock to randomly select 10 unique words per game session.
* **Advanced String Processing:** Features on-the-fly lowercase to uppercase conversion (`AND AL, 11011111b`), dynamic array searching, and a String Reversal algorithm that prints the actual word backwards if the user fails.
* **Persistent File I/O:** 
  * `password.txt`: Stores encrypted login credentials.
  * `highscore.dat`: Binary file that saves the all-time high score as raw 32-bit registers.
  * `words.txt`: Dynamic dictionary database.
* **Numeric Analyzer & History:** Tracks game-by-game scores in a scaled-index `DWORD` array, calculates session averages using `MUL/DIV`, and features a strict 3-hint limit system.

## 🗂️ Modular Architecture
The project is split into 5 strictly modular files using `PROTO` and `EXTERNDEF` linking:
1. `globals.inc` - Shared header containing macros (`Start_level`), global variables, and procedure prototypes.
2. `main.asm` - Entry point, RNG seeding, boot-sequence file loading, and main menu routing.
3. `auth.asm` - Handles user authentication, bit-level encryption, and password file I/O.
4. `hangman.asm` - Core game engine, array traversal, memory nuking/resetting, and hint logic.
5. `results.asm` - Arithmetic calculations (averages/max), history array scaling, and `.dat` file streaming.

## 🚀 Environment & Setup
* **Assembler:** MASM (Microsoft Macro Assembler)
* **IDE:** Microsoft Visual Studio (2019/2022)
* **Library:** Irvine32 (`Irvine32.inc`)
* **Architecture:** x86 (32-bit)

### How to Compile:
1. Create a standard MASM/Irvine32 Project in Visual Studio.
2. Add `main.asm`, `auth.asm`, `hangman.asm`, and `results.asm` to the **Source Files** folder.
3. Add `globals.inc` to the **Header Files** folder. *(Warning: Do not place the .inc file in Source Files, or the compiler will attempt to build it directly and throw an error).*
4. Right-click each `.asm` file -> **Properties** -> set **Item Type** to **Microsoft Macro Assembler**.
5. Press **Ctrl + Shift + B** to build the solution.
6. Press **Ctrl + F5** to run.

## 🔐 First Boot Instructions
On the very first run, the system will automatically create `password.txt`, `highscore.dat`, and generate a default `words.txt` file if one is not found.

* **Default Login Password:** `123456`

Once authenticated, you can change the password, play a randomized 10-level game of Hangman, or view the session score history array. The new password and high scores will persist across system restarts.

---
*Built for educational purposes in x86 Assembly.*

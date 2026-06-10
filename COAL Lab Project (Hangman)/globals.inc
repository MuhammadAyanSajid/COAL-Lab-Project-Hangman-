INCLUDE C:/irvine/Irvine32.inc

; ==============================================================================
; 1. MACRO DEFINITION
; ==============================================================================
Start_level MACRO wordAddr, hiddenAddr, missCount
    push ecx
    push edx
    push esi
    push edi
    
    mov esi, wordAddr        
    mov edi, hiddenAddr      
    mov ecx, missCount       
    call PlayLevelRoutine    
    
    pop edi
    pop esi
    pop edx
    pop ecx
ENDM

; ==============================================================================
; 2. PROCEDURE PROTOTYPES
; ==============================================================================
AuthModule PROTO
ChangePasswordProc PROTO
PlayGameProc PROTO
ResultsProc PROTO
PlayLevelRoutine PROTO

; File Handling Prototypes
LoadPassword PROTO
LoadHighScore PROTO
SaveHighScore PROTO

; ---> NEW: History Prototype <---
PrintHistoryProc PROTO

; ==============================================================================
; 3. GLOBAL VARIABLES
; ==============================================================================
EXTERNDEF total_score:DWORD
EXTERNDEF highest_score:DWORD
EXTERNDEF no_of_rounds:DWORD
EXTERNDEF avg_score:DWORD
EXTERNDEF level_score:DWORD
INCLUDE globals.inc

.data
msg_menu      BYTE 0Ah,0Dh,"===== MAIN MENU =====",0Ah,0Dh
              BYTE "1. Change Password",0Ah,0Dh
              BYTE "2. Play Hangman Game",0Ah,0Dh
              BYTE "3. View Score History",0Ah,0Dh   ; <--- NEW OPTION
              BYTE "Any other key to EXIT",0Ah,0Dh
              BYTE "Select an option: ",0
msg_exit      BYTE "Exiting toolkit. Goodbye!",0

; --- Global Variables Memory Allocation ---
total_score   DWORD 0
highest_score DWORD 0
no_of_rounds  DWORD 0
avg_score     DWORD 0
level_score   DWORD 0

.code
main PROC
    ; 1. Boot Sequence: Load Data from Files
    call LoadPassword
    call LoadHighScore

    ; 2. Require Authentication First
    call AuthModule

MainMenu:
    mov edx, OFFSET msg_menu
    call WriteString
    call ReadDec             ; Read user option into EAX
    
    cmp eax, 1
    je OptChangePass
    cmp eax, 2
    je OptPlayGame
    cmp eax, 3               ; <--- NEW BRANCH FOR OPTION 3
    je OptViewHistory
    jmp OptExit              ; Else Quit

OptChangePass:
    call ChangePasswordProc
    jmp MainMenu

OptPlayGame:
    call PlayGameProc
    jmp MainMenu

OptViewHistory:
    call PrintHistoryProc    ; <--- CALL NEW PROCEDURE
    jmp MainMenu

OptExit:
    mov edx, OFFSET msg_exit
    call WriteString
    call Crlf
    exit
main ENDP
END main
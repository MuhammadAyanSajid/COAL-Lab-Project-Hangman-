INCLUDE globals.inc

; ========================================================
; MACRO: Resets hidden string memory using string primitives
; ========================================================
Reset_Str MACRO template, hidden
    mov esi, OFFSET template
    mov edi, OFFSET hidden
    mov ecx, SIZEOF template
    rep movsb                ; Copies bytes from ESI to EDI
ENDM

.data
; ========================================================
; HANGMAN 10 WORDS DATABASE 
; (Added 'tpl' templates to restore strings on replay)
; ========================================================
word1   BYTE "ASSEMBLY",0
hid1    BYTE "A__EMB_Y",0      
tpl1    BYTE "A__EMB_Y",0      ; Template for reset
miss1   DWORD 3

word2   BYTE "REGISTER",0
hid2    BYTE "R_GI_T_R",0      
tpl2    BYTE "R_GI_T_R",0
miss2   DWORD 3

word3   BYTE "COMPUTER",0
hid3    BYTE "C_MP__ER",0      
tpl3    BYTE "C_MP__ER",0
miss3   DWORD 3

word4   BYTE "HARDWARE",0
hid4    BYTE "H_R_WA_E",0      
tpl4    BYTE "H_R_WA_E",0
miss4   DWORD 3

word5   BYTE "SOFTWARE",0
hid5    BYTE "S_F_WA_E",0      
tpl5    BYTE "S_F_WA_E",0
miss5   DWORD 3

word6   BYTE "COMPILER",0
hid6    BYTE "C_M_IL_R",0      
tpl6    BYTE "C_M_IL_R",0
miss6   DWORD 3

word7   BYTE "DATABASE",0
hid7    BYTE "D_T_BA_E",0      
tpl7    BYTE "D_T_BA_E",0
miss7   DWORD 3

word8   BYTE "INTERNET",0
hid8    BYTE "I_T_RN_T",0      
tpl8    BYTE "I_T_RN_T",0
miss8   DWORD 3

word9   BYTE "SECURITY",0
hid9    BYTE "S_C_RI_Y",0      
tpl9    BYTE "S_C_RI_Y",0
miss9   DWORD 3

word10  BYTE "VARIABLE",0
hid10   BYTE "V_R_AB_E",0      
tpl10   BYTE "V_R_AB_E",0
miss10  DWORD 3

; --- UI Messages ---
msg_guessReq  BYTE "Enter a letter to guess (or '?' for Hint): ",0
msg_hintMsg   BYTE ">>> HINT USED! Revealing 1 letter (-1 Point).",0Ah,0Dh,0
msg_wordState BYTE "Current Word: ",0
msg_lvlWin    BYTE "Excellent! You cleared the level.",0
msg_lvlFail   BYTE "You Failed this level! No tries left.",0
msg_revWord   BYTE "The actual word reversed was: ",0 
msg_currScore BYTE "Level Score (Added): ",0
msg_limit     BYTE "Wrong guesses left: ",0

wrong_limit   DWORD 5
no_mistake    DWORD 1

.code
; ====================================================================
; PROCEDURE: ResetGameProc (Memory Management / Replayability)
; Uses cld and rep movsb to restore all hid arrays to their templates
; ====================================================================
ResetGameProc PROC
    pushad
    cld                      ; Clear Direction Flag (move forward in memory)
    
    Reset_Str tpl1, hid1
    Reset_Str tpl2, hid2
    Reset_Str tpl3, hid3
    Reset_Str tpl4, hid4
    Reset_Str tpl5, hid5
    Reset_Str tpl6, hid6
    Reset_Str tpl7, hid7
    Reset_Str tpl8, hid8
    Reset_Str tpl9, hid9
    Reset_Str tpl10, hid10
    
    popad
    ret
ResetGameProc ENDP

; ====================================================================
; PROCEDURE: PlayGameProc
; Loops through all 10 words using the MACRO
; ====================================================================
PlayGameProc PROC
    call ResetGameProc       ; <--- FIX: Resets all memory before playing!
    mov total_score, 0       
    
    Start_level OFFSET word1, OFFSET hid1, miss1
    mov eax, level_score
    add total_score, eax     
    
    Start_level OFFSET word2, OFFSET hid2, miss2
    mov eax, level_score
    add total_score, eax
    
    Start_level OFFSET word3, OFFSET hid3, miss3
    mov eax, level_score
    add total_score, eax

    Start_level OFFSET word4, OFFSET hid4, miss4
    mov eax, level_score
    add total_score, eax

    Start_level OFFSET word5, OFFSET hid5, miss5
    mov eax, level_score
    add total_score, eax

    Start_level OFFSET word6, OFFSET hid6, miss6
    mov eax, level_score
    add total_score, eax

    Start_level OFFSET word7, OFFSET hid7, miss7
    mov eax, level_score
    add total_score, eax

    Start_level OFFSET word8, OFFSET hid8, miss8
    mov eax, level_score
    add total_score, eax

    Start_level OFFSET word9, OFFSET hid9, miss9
    mov eax, level_score
    add total_score, eax

    Start_level OFFSET word10, OFFSET hid10, miss10
    mov eax, level_score
    add total_score, eax

    call ResultsProc
    ret
PlayGameProc ENDP

; ====================================================================
; PROCEDURE: PlayLevelRoutine
; Core Logic (Search, Hints, Score Management)
; ====================================================================
PlayLevelRoutine PROC
    mov wrong_limit, 5
    mov no_mistake, 1
    mov level_score, 0

GameLoop:
    call Crlf
    mov edx, OFFSET msg_wordState
    call WriteString
    mov edx, edi
    call WriteString         
    call Crlf

    ; Win Condition
    cmp ecx, 0
    je LevelWin
    
    ; Fail Condition
    cmp wrong_limit, 0
    je LevelFail

    mov edx, OFFSET msg_limit
    call WriteString
    mov eax, wrong_limit
    call WriteDec
    call Crlf

    mov edx, OFFSET msg_guessReq
    call WriteString
    call ReadChar
    call WriteChar           
    call Crlf

    ; ---> HINT CHECK LOGIC <---
    cmp al, '?'
    je TriggerHint

    ; Case Conversion (Lowercase to Uppercase)
    and al, 11011111b        

    mov ebx, 0               ; Index
    mov edx, 0               ; Found Flag (0=No, 1=Yes)

SearchLoop:
    mov ah, [esi+ebx]        ; Original character
    cmp ah, 0
    je EndSearch             
    
    cmp ah, al               ; Match?
    jne NextChar
    
    mov ah, [edi+ebx]        ; Hidden character
    cmp ah, '_'
    jne NextChar             ; Already guessed
    
    mov [edi+ebx], al        ; Reveal letter
    mov edx, 1               ; Set Found Flag
    add level_score, 3       
    dec ecx                  ; Missing count -= 1
    
NextChar:
    inc ebx
    jmp SearchLoop

EndSearch:
    cmp edx, 1               
    je GameLoop              ; Valid guess, skip penalty

    ; Wrong Guess Penalty
    sub level_score, 1       
    mov no_mistake, 0
    dec wrong_limit          
    jmp GameLoop

; ==============================
; HINT SYSTEM ROUTINE
; ==============================
TriggerHint:
    push ebx
    mov ebx, 0
HintSearch:
    mov ah, [edi+ebx]
    cmp ah, '_'
    je HintApply             ; Found the first missing blank
    inc ebx
    jmp HintSearch
HintApply:
    mov al, [esi+ebx]        ; Get the actual character
    mov [edi+ebx], al        ; Put it in the hidden word
    dec ecx                  ; Missing count -= 1
    
    mov no_mistake, 0        ; Lose the x3 multiplier
    sub level_score, 1       ; -1 Point Penalty for using a hint
    
    mov edx, OFFSET msg_hintMsg
    call WriteString
    
    pop ebx
    jmp GameLoop

; ==============================
; WIN / LOSS ROUTINES
; ==============================
LevelWin:
    mov edx, OFFSET msg_lvlWin
    call WriteString
    call Crlf
    
    cmp no_mistake, 1
    jne WinEnd
    mov eax, level_score
    mov ebx, 3
    mul ebx                  ; Perfect round! Score *= 3
    mov level_score, eax
WinEnd:
    mov edx, OFFSET msg_currScore
    call WriteString
    mov eax, level_score
    call WriteInt            ; Using WriteInt in case of negative hint penalty scores
    call Crlf
    ret

LevelFail:
    mov level_score, 0       
    mov edx, OFFSET msg_lvlFail
    call WriteString
    call Crlf
    
    mov edx, OFFSET msg_revWord
    call WriteString
    call ReverseStringPrint  
    call Crlf
    ret
PlayLevelRoutine ENDP

; ====================================================================
; PROCEDURE: ReverseStringPrint
; ====================================================================
ReverseStringPrint PROC
    pushad
    mov edi, esi
    call Str_length          
    mov ecx, eax             
    add edi, eax
    dec edi                  
RevLoop:
    mov al, [edi]
    call WriteChar
    dec edi
    loop RevLoop
    popad
    ret
ReverseStringPrint ENDP
END
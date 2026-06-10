INCLUDE globals.inc

.data
score_filename BYTE "highscore.dat",0    
msg_resTitle  BYTE 0Ah,0Dh,"--- GAME OVER: ROUND RESULTS ---",0
msg_newHigh   BYTE "*** CONGRATULATIONS! NEW HIGHEST SCORE! ***",0
msg_totScore  BYTE "Total Score for this round: ",0
msg_maxScore  BYTE "All-Time Highest Score: ",0
msg_avgScore  BYTE "Session Average Score: ",0
msg_rounds    BYTE "Session Rounds Played: ",0

; ---> NEW: History Data <---
score_history DWORD 100 DUP(0)           ; Array holding up to 100 past game scores
msg_histTitle BYTE 0Ah,0Dh,"--- SESSION SCORE HISTORY ---",0
msg_noHist    BYTE "No games have been played yet in this session.",0
msg_gameNum   BYTE "Game ",0
msg_colon     BYTE ": ",0

.code
; ====================================================================
; PROCEDURE: LoadHighScore
; ====================================================================
LoadHighScore PROC
    pushad
    mov edx, OFFSET score_filename
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    je NoScoreFile           
    
    mov ebx, eax             
    mov edx, OFFSET highest_score
    mov ecx, 4               
    call ReadFromFile
    mov eax, ebx
    call CloseFile
NoScoreFile:
    popad
    ret
LoadHighScore ENDP

; ====================================================================
; PROCEDURE: SaveHighScore
; ====================================================================
SaveHighScore PROC
    pushad
    mov edx, OFFSET score_filename
    call CreateOutputFile
    mov ebx, eax             
    mov edx, OFFSET highest_score
    mov ecx, 4               
    call WriteToFile
    mov eax, ebx
    call CloseFile
    popad
    ret
SaveHighScore ENDP

; ====================================================================
; PROCEDURE: ResultsProc
; ====================================================================
ResultsProc PROC
    call Crlf
    mov edx, OFFSET msg_resTitle
    call WriteString
    call Crlf

    mov edx, OFFSET msg_totScore
    call WriteString
    mov eax, total_score
    call WriteInt
    call Crlf

    ; ---> NEW: Save current score to the History Array <---
    mov eax, total_score
    mov ebx, no_of_rounds                ; Use rounds as the array index
    mov score_history[ebx*4], eax        ; *4 because DWORD is 4 bytes

    ; High Score Logic
    mov eax, total_score
    cmp eax, highest_score
    jle CalcAverage
    
    ; Update Memory and save to File
    mov highest_score, eax
    call SaveHighScore       
    
    mov edx, OFFSET msg_newHigh
    call WriteString
    call Crlf

CalcAverage:
    mov eax, avg_score
    mov ebx, no_of_rounds
    mul ebx                  
    add eax, total_score     
    
    mov ebx, no_of_rounds
    inc ebx                  
    xor edx, edx             
    div ebx                  
    
    mov avg_score, eax       
    inc no_of_rounds         ; Increment rounds AFTER using it as an array index

    ; Display Statistics
    mov edx, OFFSET msg_maxScore
    call WriteString
    mov eax, highest_score
    call WriteInt            
    call Crlf

    mov edx, OFFSET msg_avgScore
    call WriteString
    mov eax, avg_score
    call WriteInt
    call Crlf

    mov edx, OFFSET msg_rounds
    call WriteString
    mov eax, no_of_rounds
    call WriteDec
    call Crlf
    
    ret
ResultsProc ENDP

; ====================================================================
; PROCEDURE: PrintHistoryProc
; Loops through the score_history array and prints past results
; ====================================================================
PrintHistoryProc PROC
    pushad
    call Crlf
    mov edx, OFFSET msg_histTitle
    call WriteString
    call Crlf

    cmp no_of_rounds, 0                  ; If no rounds played, skip loop
    je NoHistoryFound

    mov ecx, no_of_rounds                ; Loop counter = number of games played
    mov esi, 0                           ; ESI will be our index (0, 1, 2...)

PrintLoop:
    ; Print "Game X: "
    mov edx, OFFSET msg_gameNum
    call WriteString
    mov eax, esi
    inc eax                              ; Display index+1 (so it starts at Game 1, not Game 0)
    call WriteDec
    mov edx, OFFSET msg_colon
    call WriteString

    ; Fetch score from array and print
    mov eax, score_history[esi*4]        ; Scale index by 4 (DWORD)
    call WriteInt
    call Crlf

    inc esi
    loop PrintLoop
    jmp FinishHistory

NoHistoryFound:
    mov edx, OFFSET msg_noHist
    call WriteString
    call Crlf

FinishHistory:
    popad
    ret
PrintHistoryProc ENDP

END
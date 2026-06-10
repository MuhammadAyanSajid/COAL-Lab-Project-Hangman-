INCLUDE globals.inc

.data
pass_filename BYTE "password.txt",0      ; File to store password
enc_key       BYTE 5Ah                   
; Default encrypted password "123456" 
enc_pass      BYTE 0D6h, 0D0h, 0D2h, 0DCh, 0DEh, 0D8h, 0 
dec_pass      BYTE 7 DUP(0)              
input_pass    BYTE 20 DUP(0)             

msg_auth      BYTE "--- AUTHENTICATION ---",0
msg_passReq   BYTE "Enter 6-char Password: ",0
msg_authFail  BYTE "Incorrect Password! Try again.",0
msg_authSucc  BYTE "Authentication Successful!",0
msg_newPass   BYTE "Enter new 6-char Password: ",0
msg_passSaved BYTE "Password valid. Encrypted and saved to file!",0
msg_passInv   BYTE "Invalid password! Must be exactly 6 characters.",0

.code
; ====================================================================
; PROCEDURE: LoadPassword (File I/O)
; ====================================================================
LoadPassword PROC
    pushad
    mov edx, OFFSET pass_filename
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    jne ReadExistingFile
    
    ; If file doesn't exist, create it and save the default enc_pass
    mov edx, OFFSET pass_filename
    call CreateOutputFile
    mov ebx, eax             ; Save File Handle
    mov edx, OFFSET enc_pass
    mov ecx, 6               ; 6 Bytes to write
    call WriteToFile
    mov eax, ebx
    call CloseFile
    jmp FinishLoad
    
ReadExistingFile:
    mov ebx, eax             ; Save File Handle
    mov edx, OFFSET enc_pass
    mov ecx, 6
    call ReadFromFile
    mov eax, ebx
    call CloseFile
FinishLoad:
    popad
    ret
LoadPassword ENDP

AuthModule PROC
AuthLoop:
    call Crlf
    mov edx, OFFSET msg_auth
    call WriteString
    call Crlf

    call DecryptPassword

    mov edx, OFFSET msg_passReq
    call WriteString
    mov edx, OFFSET input_pass
    mov ecx, 20
    call ReadString

    mov esi, OFFSET dec_pass
    mov edi, OFFSET input_pass
    mov ecx, 6
    cld                      
    repe cmpsb               
    je AuthSuccess           
    
    mov edx, OFFSET msg_authFail
    call WriteString
    call Crlf
    jmp AuthLoop

AuthSuccess:
    mov edx, OFFSET msg_authSucc
    call WriteString
    call Crlf
    ret
AuthModule ENDP

DecryptPassword PROC
    pushad
    mov ecx, 6
    mov esi, OFFSET enc_pass
    mov edi, OFFSET dec_pass
DecLoop:
    mov al, [esi]
    ror al, 1                
    xor al, enc_key          
    mov [edi], al
    inc esi
    inc edi
    loop DecLoop
    mov BYTE PTR [edi], 0
    popad
    ret
DecryptPassword ENDP

ChangePasswordProc PROC
    call Crlf
    mov edx, OFFSET msg_newPass
    call WriteString
    
    mov edx, OFFSET input_pass
    mov ecx, 20
    call ReadString
    
    cmp eax, 6
    jne InvalidPass
    
    ; 1. Encrypt Data in Memory
    mov ecx, 6
    mov esi, OFFSET input_pass
    mov edi, OFFSET enc_pass
EncLoop:
    mov al, [esi]
    xor al, enc_key          
    rol al, 1                
    mov [edi], al
    inc esi
    inc edi
    loop EncLoop
    
    ; 2. Overwrite 'password.txt' with new encrypted bytes
    mov edx, OFFSET pass_filename
    call CreateOutputFile
    mov ebx, eax
    mov edx, OFFSET enc_pass
    mov ecx, 6
    call WriteToFile
    mov eax, ebx
    call CloseFile

    mov edx, OFFSET msg_passSaved
    call WriteString
    call Crlf
    ret

InvalidPass:
    mov edx, OFFSET msg_passInv
    call WriteString
    call Crlf
    ret
ChangePasswordProc ENDP
END
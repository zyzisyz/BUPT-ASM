;data
DATA SEGMENT
    ;output data, init min is 99
    MIN db '9','9'
    
    ;output strings
    string0 DB 'Input some integers, devided with SPACE, show result with ENTER:','$'
    string1 DB 'Input Error!, please input again:','$'
    string2 DB 'The Minest number is:','$'
DATA ENDS


;stack
STACK SEGMENT STACK'STACK'
    DB 100H DUP(?)
STACK ENDS


;code
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
;display enter char
DisplayEnter proc near
    push ax
    push dx
    mov ah,2h
    mov dl,0dh
    int 21h
    mov ah,2h
    mov dl,0ah
    int 21h
    pop dx
    pop ax
    ret 
DisplayEnter endp

;input char to al
InputChar proc near
    mov ah,01h
    int 21h
    ret
InputChar endp

;judge if al in 0-9 
Test_Num proc near
    cmp al,'0'
	jb error    ;below
	cmp al,'9'
	ja error    ;above
	jmp exit
error:	
	mov al,0						
exit:
	ret
Test_Num endp

START:
    ;display string0
    mov ax,data
	mov ds,ax
	mov dx,offset string0
	mov ax,0900h
	int 21h
    call DisplayEnter

Input_loop:
    ;input high num
    call InputChar
    call Test_Num
    cmp al,00h
    jz Display_Error
    mov bh,al   ;put high num in b high
    ;input low num
    call InputChar
    call Test_Num
    cmp al,00h
    jz Display_Error
    mov bl,al   ;put low num in b low
    ;input space
    call InputChar
    cmp al,0dh
    jz Compare_Last
    cmp al,' '
    jz Compare
    jmp Display_Error

Display_Error:	
    call DisplayEnter
	mov dx,offset string1
	mov ax,0900h
	int 21h
    call DisplayEnter
	jmp Input_loop

Compare:
    cmp bx,word ptr MIN
    jb Change_NUM
    jmp Input_loop

Change_NUM:
    mov word ptr MIN,bx
	jmp Input_loop

Compare_Last:
    ;for last num
    cmp bx,word ptr MIN 
    jb Swap
    jmp Show_Result

Swap:
    mov word ptr min,bx
    jmp Show_Result

Show_Result:
    mov dx,offset string2
    ;display high
    mov ax,0900h
	int 21h
	mov dl,min+1
	mov ax,0200h
	int 21h

    ;diplay low
	mov dl,min
	int 21h
	mov ax,4c00h
	int 21h
CODE ENDS
    END START
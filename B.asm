;data
DATA SEGMENT
    ;nums
    NUMS DW -1,2,0,0,1,-9
    COUNT EQU $-NUMS
    
    ;output data
    POSITIVE_NUM DB ?
    ZERO_NUM DB ?
    NEGATIVE_NUM DB ?
    
    ;output strings
    string0 DB 'Nums is: -1,2,0,0,1,-9$'
    string1 DB 'Positive number:','$'
    string2 DB 'Zero number:','$'
    string3 DB 'Negative number:','$'
DATA ENDS


;stack
STACK SEGMENT STACK'STACK'
    DB 100H DUP(?)
STACK ENDS


;code
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:
    MOV AX,DATA
    MOV DS,AX
    MOV CX,COUNT
    SHR CX,1        ;dw=2db
    MOV DX,0
    MOV AH,0
    LEA BX,NUMS
COMPERE:
    CMP WORD PTR[BX],0
    JGE POSITIVE_CONT
    INC AH
    JMP NEXT
POSITIVE_CONT:
    JZ ZERO_CONT
    INC DL
    JMP NEXT
ZERO_CONT:
    INC DH
NEXT:
    INC BX
    INC BX
    LOOP COMPERE
    
    ;POSITIVE_NUM
    ADD DL,48
    MOV POSITIVE_NUM,DL
    
    ;ZERO_NUM
    ADD DH,48
    MOV ZERO_NUM,DH

    ;NEGATIVE_NUM
    ADD AH,48
    MOV NEGATIVE_NUM,AH
    
DISPLAY:
    sub dx,dx       ;dx to zero
    MOV AH,09H
    mov dx,offset string0
    int 21h
    
    ;display enter
    mov ah,02h
    mov dl,0dh
    int 21h
    mov ah,02h
    mov dl,0ah
    int 21h 

    sub dx,dx       ;dx to zero

    ;POSITIVE_NUM
    mov dx,offset string1
	mov ax,0900h
	int 21h

	mov dl,[POSITIVE_NUM]
	mov ax,0200h
	int 21h

    mov dl,0dh
    int 21h
    mov dl,0ah
    int 21h
	
	mov dx,offset string2
	mov ax,0900h
	int 21h
	
	mov dl,[ZERO_NUM]
	mov ax,0200h
	int 21h

    mov dl,0dh
    int 21h
    mov dl,0ah
    int 21h

    mov dx,offset string3
	mov ax,0900h
	int 21h
    
	mov ax,0200h
	mov dl,[NEGATIVE_NUM]
	int 21h
	
	mov ax,4c00h
	int 21h

CODE ENDS
    END START

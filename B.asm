;显示字符串的宏
PrintString MACRO STR							
	MOV	AH,	9
	MOV	DX,	SEG STR
	MOV	DS,	DX
	MOV	DX,	OFFSET STR
	INT	21H
ENDM

;数据段
DATA SEGMENT
    ;nums存放的是数据
    NUMS DW -8,2,0,0,4,-3,1,1,5
    COUNT EQU $-NUMS
    
    ;显示输出的数据
    Positive_Num DB ?   ;正数的个数
    Zero_Num DB ?       ;零的个数
    NEGATIVE_NUM DB ?   ;负数的个数
    
    EnterString DB 0DH,0AH,'$';回车
    
    ;输出的提示字符串
    Start_String DB 'Nums are: -8,2,0,0,4,-3,1,1,5','$'
    Positive_Result DB 'Positive number:','$'
    Zero_Result DB 'Zero number:','$'
    Negative_Result DB 'Negative number:','$'
DATA ENDS


;堆栈段
STACK SEGMENT STACK'STACK'
    DB 100H DUP(?)
STACK ENDS


;代码段
;DL存放正数的个数
;DH存放零的个数
;AH存放负数的个数
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:
    ;把data的基地址地址存到dx
    MOV AX,DATA
    MOV DS,AX
    ;把count存到cx里
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
    
    ;Positive_Num
    ADD DL,48
    MOV Positive_Num,DL
    
    ;Zero_Num
    ADD DH,48
    MOV Zero_Num,DH

    ;NEGATIVE_NUM
    ADD AH,48
    MOV NEGATIVE_NUM,AH
    
DISPLAY:
    sub dx,dx       ;dx to zero
    ;输出开始的提示字符串
    PrintString Start_String
    PrintString EnterString

    ;输出零的结果
    PrintString Zero_Result
    mov dl,[Zero_Num]
	mov ax,0200h
	int 21h
    PrintString EnterString

    ;输出正数的结果
    PrintString Positive_Result
    mov dl,[POSITIVE_NUM]
	mov ax,0200h
	int 21h
    PrintString EnterString

    ;输出负数的结果
    PrintString Negative_Result
    mov dl,[NEGATIVE_NUM]
	mov ax,0200h
	int 21h
    PrintString EnterString

    mov AH,4CH
	int	21H
CODE ENDS
    END START

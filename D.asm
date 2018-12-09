;显示字符串的宏
PrintString MACRO STR							
	MOV	AH,	9
	MOV	DX,	SEG STR
	MOV	DS,	DX
	MOV	DX,	OFFSET STR
	INT	21H
ENDM


;data seg
DATA SGEMENT
    Error_String DB 0DH,0AH,'Input Error! Please try again :',0DH,0AH,'$' ;错误提示字符串
    Result_String DB 0DH,0AH,'Rank    Number    Score',0DH,0AH,'$' ;输出结果
    Score db 100 DUP(?),'$' ;用于存放成绩
    Rank db 100 DUP(?),'$'  ;用于存放排名
    Cont dw 0;用于计数
DATA ENDS


;stack seg
STACK SEGMENT STACK'STACK'
    DB 100H DUP(?)
STACK ENDS


;code seg
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK

;输入用的process，把键盘输入的char存到al中
InputChar proc near
    mov ah,01h
    int 21h
    ret
InputChar endp

START:
    mov ax,data
    mov dx,ax
    mov si, OFFSET Score;SI为Score的偏移地址
    mov cx, 0031h;CX从1的ASCII码31H开始计数,表示学号
Input_NUM:
    ;写入成绩的十位数
    call InputChar
    cmp al,'0'
    jb Print_Error
    cmp al,'9'
    ja Print_Error
    MOV	BYTE PTR[SI],AL
    INC SI;指向下个字节

    ;写入成绩的个位数
    call InputChar
    cmp al,'0'
    jb Print_Error
    cmp al,'9'
    ja Print_Error
    INC SI;指向下一个字节

    call InputChar
    cmp al,' '
    jz Add_ID
    cmp al,'0dh'
    jz Put_Off
    jmp Print_Error
Print_Error:
    PrintString 
    mov SI,OFFSET Score	;SI重新指向Score的开头
	mov	CX,	0031H       ;学号从1开始
    jmp Input_NUM

Add_ID:;添加学号
    mov	BYTE PTR[SI],	CL	;将学生的学号写入在成绩之后
	mov	SI	;指向下一个字节
	inc cx
    jmp Input_NUM

Put_Off:;写入最后一个学号
    mov BYTE PTR[SI],CL
    jmp Sort_Loop

Sort_Loop:;排序,到这步骤，Score里存的格式为 分数+学号
    

Print_Result:
    PrintString Result_String
    PrintString Rank
    mov AH,4CH
	int	21H
CODE ENDS
    END START
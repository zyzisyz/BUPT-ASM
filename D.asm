;显示字符串的宏
PrintString MACRO STR							
	MOV	AH,	9
	MOV	DX,	SEG STR
	MOV	DS,	DX
	MOV	DX,	OFFSET STR
	INT	21H
ENDM


;data seg
DATA SEGMENT
    Start_String db 'Please input score:',0DH,0AH,'$';开始的提示代码
    Error_String DB 0DH,0AH,'Input Error! Please try again :',0DH,0AH,'$';错误提示字符串
    Line_String db '--------------------',0DH,0AH,'$'
    Commet_String db 'R:rank',0DH,0AH,'N:student_Number',0DH,0AH,'S:score',0DH,0AH,'$';符号解释
    Result_String db 0DH,0AH,'R N S',0DH,0AH,'$'
    Score db 100 DUP(?),'$' ;用于存放成绩
    Rank db 100 DUP(?),'$'  ;用于存放排名
    Count dw 0;用于计数
    test_string db 0DH,0AH,'ok',0DH,0AH,'$'
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

;用于冒泡排序的函数
Get_MAX proc
    push bx
	push cx
	push dx
    push si     ;保存寄存器运行proc前的值
    pushf
	MOV	BX,	SI							;BX记录最大值的下标
	MOV	DH,	[SI]
	MOV	DL,	[SI+1]

Compere_HIGH:	
	CMP	DH,	[SI]						;比较十位数
	JA	Put_Loop							;大于的话,跳转	
	JZ	Compere_LOW							;等于的话,跳转
	MOV	DH,	[SI]							;将大数给DX
	MOV	DL,	[SI+1]
	MOV	BX,	SI							; BX记录最大值的下标
	JMP	Put_Loop

Compere_LOW:
	CMP	DL,	[SI+1]						;比较个位数
	JAE	Put_Loop	
	MOV	DL,	[SI+1]						;将大数给DX
	MOV	BX,	SI

Put_Loop:	
	ADD	SI,	3H			;指向下一个成绩
	DEC	CX				;次数-1
	CMP	CX,	0030H
	JA	Compere_HIGH
	MOV	BYTE PTR [BX],	30H	    ;将Score中将找到的最大值置0
	MOV	BYTE PTR [BX+1],30H	    ;为下一轮寻找最大值做准备

	MOV	BYTE PTR[DI],AL			;写入排名
	MOV	BYTE PTR[DI+1],' '				

	MOV	BYTE PTR [DI+4],dh		;写入成绩
	MOV	BYTE PTR[DI+5],dl

	MOV	BYTE PTR[DI+6],0DH		;写回车
	MOV	BYTE PTR[DI+7],0AH

	MOV	DL,BYTE PTR[BX+2]					;写入学号
	MOV	BYTE PTR[DI+2],DL
	MOV	BYTE PTR[DI+3],' '

	;一条记录的格式为: 排名+空格+学号+空格+成绩+空格+换行
	ADD	DI,8	;指向下一个待写入排序的位置
    
    popf        ;恢复寄存器运行proc前的值
    POP	SI
	POP	DX
	POP	CX
	POP	BX
    ret
Get_MAX endp

START:
    PrintString Start_String
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
    inc SI;                 指向下一个字节

    call InputChar
    cmp al,' '
    jz Add_ID
    cmp al,0dh
    jz Put_Off
    jmp Print_Error
Print_Error:
    PrintString Error_String
    mov SI,OFFSET Score	    ;SI重新指向Score的开头
	mov	CX,'1'              ;学号从1开始
    jmp Input_NUM

Add_ID:                     ;添加学号
    mov	BYTE PTR[SI],cl     ;将学生的学号写入在成绩之后
	inc	si	                ;指向下一个字节
	inc cx
    jmp Input_NUM

Put_Off:
    mov BYTE PTR[SI],CL     ;写入最后一个学号
    mov di,OFFSET Rank      ;di指向RANK的地址
    mov	si,OFFSET Score		;si指向Score的地址
	mov	Count,CX            ;将cx学生人数传给count
    mov ax,'1'              ;将ax置为1
    jmp Sort_Loop

;--------------------------------------------------------------------
Sort_Loop:                  ;排序,到这步骤，Score里存的格式为 分数+学号
    ;di指向RANK的地址,指向Score的地址
    ;我选择的方法是冒泡排序
    ;因为比较复杂，我找到最大值以后将最大值存入di（rank）后，si归零
    call Get_MAX            ;调用子程序找最大值
    inc ax                  ;ax存放排序次数
    cmp ax,Count            ;检查排序次数是否到达需要的次数
    jbe Sort_Loop           ;没有，接着sort
    jmp Print_Result        ;跳转到输出

;输出结果
Print_Result:
    
    PrintString Result_String
    PrintString Rank;一条记录的格式为: 排名+空格+学号+空格+成绩+空格+换行
    
    mov AH,4CH
	int	21H
CODE ENDS
    END START
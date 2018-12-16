;显示字符串的宏
PrintString MACRO STR							
	MOV	AH,	9
	MOV	DX,	SEG STR
	MOV	DS,	DX
	MOV	DX,	OFFSET STR
	INT	21H
ENDM

DATA SEGMENT
    ;提示语句dividend除数,divisor被除数
    Input_Dividend32 DB 0DH,0AH,'Please enter the dividend(32): ',0DH,0AH,'$'
    Input_Divisor16 DB 0DH,0AH,'Please enter the divisor(16): ',0DH,0AH,'$'
    Error_string DB 0DH,0AH,'Input Wrong Number! Please try again...',0DH,0AH,'$'
    Consult_Result DB 0DH,0AH,'The consult is: ',0DH,0AH,'$'
    DivisorEqualsZero DB 0DH,0AH,'Divisor equals 0 ',0DH,0AH,'$'
    Reminder_Result DB 0DH,0AH,'The reminder is: ',0DH,0AH,'$'
       
    DIVIDEND DD ?;存储被除数
    DIVISOR  DW ?;存储除数
    FALG1 DB ?;被除数是否输入错误的标志
    FALG2 DB ?;除数是否输入错误的biaozhi 
DATA ENDS

STACK SEGMENT 'STACK'
    DB 100 DUP(?)
STACK ENDS

CODE SEGMENT;代码段
    ASSUME CS:CODE,DS:DATA,SS:STACK

Start PROC FAR
    PUSH DS
    MOV AX,0
    PUSH AX;隐式返回DOS

    MOV AX,DATA
    MOV DS,AX;DATA的首地址赋值给DS完成对DS的初始化
    INPUT:
    PrintString Input_Dividend32
    CALL INPUT1;调用被除数输入模块
    CMP FALG1,1;观察被除数输入是否出错，出错则报错，未出错则输入除数
    JNZ NEXT1
    PrintString Error_string
    JMP INPUT
    NEXT1:
    PrintString Input_Divisor16
    CALL INPUT2;调用除数输入模块
    CMP FALG2,1;观察除数输入是否出错，出错则报错，未出错则修改中断
    JNZ NEXT2
    PrintString Error_string
    JMP INPUT

    NEXT2:
    ;中断，进入中断
    STI
    XOR AX,AX
    MOV AL,00H
    MOV AH,35H
    INT 21H
    PUSH ES;段地址
    PUSH BX;偏移地址
    ;保存原来的0号中断服务子程序入口的段地址和偏移地址

    PUSH DS
    MOV AX,SEG TIDAI
    MOV DS,AX
    LEA DX,TIDAI
    MOV AL,00H
    MOV AH,25H
    INT 21H
    POP DS
    ;替换原来0号子程序入口的段地址和偏移地址为自己设置的子程序

    MOV CX,0;CX存储高十六的商，清零初始化
    LEA SI,DIVIDEND;被除数的偏移地址给SI
    MOV AX,WORD PTR[SI];AX存储32位被除数的低位
    MOV DX,WORD PTR[SI+2];SX存储32位被除数的高位
    LEA SI,DIVISOR; 除数的偏移地址给SI
    MOV BX,WORD PTR[SI];BX存储除数（16位）
    DIV BX;进行除法
    CMP BX,0;比较除数是否为0
    JZ EXIT;为0则结束程序
    CALL OUTPUT;不为零则进行输出
    ;恢复
    POP DX
    POP AX;将原来零号中断的段地址和偏移地址弹出堆栈至DX,AX中
    PUSH DS;保护DS
    MOV DS,AX
    MOV AL,00H
    MOV AH,25H
    INT 21H;恢复0号中断为本来的子程序
    POP DS 
    EXIT:
    MOV AX,4C00H;结束程序
    INT 21H
Start ENDP

TIDAI PROC FAR
    POP CX;将IP弹入CX，
    ADD CX,2;CX加2 这样在执行完中断后会执行主程序的下一条指令，不会造成中断指令重复执行
    PUSH CX;将修改后的IP弹回堆栈，等到程序结束弹给IP
    CMP BX,0;比较除数是否为0 为0则报错
    JNZ NEXT
    PrintString DivisorEqualsZero
    JMP FINISH;结束程序
    NEXT:;不为0 则高十六的商存入CX，低十六的商存入AX，余数存入DX
        PUSH AX;
        MOV AX,DX;
        MOV DX,0;
        DIV BX
        MOV CX,AX;
        POP AX
        DIV BX
    FINISH:RET
TIDAI ENDP

INPUT1 PROC NEAR
    XOR BX,BX
    SHL BX,1
    XOR BX,BX;标志CF清空 防止对接下来的移位造成干扰
    MOV CX,16;输入十六位被除数的高位，所以循环16次
    MOV FALG1,0;标志位置0，方便重复输入
    LOOP1:
        MOV AH,01H;字符输入调用01H号中断
        INT 21H
        CMP AL,'0';比较输入的是否为二进制数，不是则报错
        JB ERROR
        CMP AL,'1'
        JA ERROR
        SUB AL,30H;从ASCII码转为0或1
        ADD BL,AL;将输入的字符存入BL中
        CMP CX,1;比较是否输入最后一位，输入最后一位则不用进行移位，可以直接跳出循环
        JZ XX1
        SAL BX,1;BX向右移位，完成权值的赋值
    LOOP  LOOP1;循环

    XX1:
        LEA SI,DIVIDEND;将被除数的地址传递给SI
        MOV [SI+2],bx
        XOR BX,BX;BX初始化清零，避免对低十六的输入造成干扰
        MOV CX,16

    ;被除数低十六位的输入和高十六的输入思路一致，只是最后的存储位置在被除数的低字节部分
    LOOP2:
        MOV AH,01H
        INT 21H
        CMP AL,'0'
        JB ERROR
        CMP AL,'1'
        JA ERROR
        SUB AL,30H
        ADD BL,AL
        CMP CX,1
        JZ XX2
        SAL BX,1
    LOOP LOOP2
    XX2:
        MOV [SI],BX
        RET
    ERROR:
        MOV FALG1,1
        RET
INPUT1 ENDP

INPUT2 PROC NEAR
;除数低十六位的输入和高十六的输入思路一致，只是最后的存储位置在被除数的低字节部分

XOR BX,BX
SHL BX,1
XOR BX,BX
MOV FALG2,0
MOV CX,16
LOOP3:
    MOV AH,01H
    INT 21H
    CMP AL,'0'
    JB ERROR2
    CMP AL,'1'
    JA ERROR2
    SUB AL,30H
    ADD BL,AL
    CMP CX,1
    JZ XX3
    SAL BX,1
LOOP LOOP3

XX3:
LEA SI,DIVISOR
MOV [SI],BX
RET
ERROR2:
MOV FALG2,1
RET
INPUT2 ENDP

OUTPUT PROC NEAR
    PUSH CX
    PUSH DX
    PUSH AX;保护CX,DX,AX CX存储高字节的商，AX存储低字节的商 DX存储余数
    PrintString Consult_Result

    XOR BX,BX
    SHL BX,1
    XOR BX,BX;BX标志位清空 防止对后续的移位进行干扰
    ;每个商和余数都是十六位的 所以十六位循环
    MOV DX,16

    LOOP10:
        MOV BX,CX;高十六的商传递给BX
        RCL BX,1;BX左移一位将商的最高位的值传递给CF
        MOV BX,0;BX清零
        RCL BX,1;这样BX只剩下商的最高位
        ADD BX,30H;将商的的最高位加上30H转换为ASCII码便于输出
        PUSH DX;保护DX,因为调用02H号输出要用改变DL的值
        MOV AH,02H
        MOV DL,BL
        INT 21H;输出商的最高位
        XOR BX,BX;BX清空 完成初始化，便于对商的下一位进行操作
        POP DX
        DEC DX;完成一次循环 DX减一
    JNZ LOOP10

;思路与商的高位的十六位输出一致
    XOR BX,BX
    SHL BX,1
    XOR BX,BX
    MOV DX,16
    LOOP11:
        POP AX
        MOV BX,AX
        PUSH AX
        RCL BX,1
        MOV BX,0
        RCL BX,1
        ADD BX,30H
        PUSH DX
        MOV AH,02H
        MOV DL,BL
        INT 21H
        POP AX
        PUSH AX
        XOR BX,BX
        POP DX
        DEC DX
    JNZ LOOP11

    PrintString Reminder_Result
;思路与商的高位的十六位输出一致
    POP AX
    POP DX
    PUSH AX
    XOR BX,BX
    SHL BX,1
    XOR BX,BX
    MOV AX,16

    LOOP12:
    MOV BX,DX
    RCL BX,1
    MOV BX,0
    RCL BX,1
    ADD BX,30H
    PUSH AX
    MOV AH,02H
    PUSH DX
    MOV DL,BL
    INT 21H
    XOR BX,BX
    POP DX
    POP AX
    DEC AX
    JNZ LOOP12

    POP AX
    POP CX
    RET
OUTPUT ENDP

CODE ENDS
END Start

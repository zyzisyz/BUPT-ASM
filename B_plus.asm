;显示字符串的宏
PrintString MACRO STR							
	MOV	AH,	9
	MOV	DX,	SEG STR
	MOV	DS,	DX
	MOV	DX,	OFFSET STR
	INT	21H
ENDM

DATA SEGMENT
    NUMS DW -2，-1，0，0，0，-9，1，2，3，4，-7，-1，-2;待检测数字
    COUNT EQU $-NUMS

    Plus_Odd        DB  (?);存储大于0的奇数数字
    Plus_Even        DB  (?);存储大于0的偶数数字
    ZERO           DB (?);存储等于0的数字
    Minus_Odd       DB (?);存储小于0的奇数数字
    Minus_Even       DB (?);存储小于0的偶数数字
    
    EnterString DB 0DH,0AH,'$';回车

    ;用于输出提示的
    STRING0 DB 'Nums are: -2，-1，0，0，0，-9，1，2，3，4，-7，-1，-2','$'
    STRING1 DB 'The number of Plus Odd is: ','$';
    STRING2 DB 'The number of ZERO is: ','$';
    STRING3 DB 'The number of Minus Odd is: ','$';
    STRING4 DB 'The number of PLUS EVEN is: ','$';
    STRING5 DB 'The number of MINUS EVEN is: ','$';
DATA ENDS

STACK SEGMENT STACK'STACK'
    DB   100 DUP(?)
STACK ENDS

CODE SEGMENT;代码段
    ASSUME CS:CODE, DS:DATA, ES:DATA, SS:STACK
START:
    
    MOV AX,DATA
    MOV DS,AX
    MOV CX,COUNT;将数组长度传递给CX
    SHR CX,1;确定数字个数，由字转为Byte要除以2
    MOV DX,0;数据存储，提前清零以免出错，DH 存储大于零的奇数DL存储大于零的偶数
    MOV AX,0;数据存储，提前清零以免出错   AH 存储小于零的奇数 AL存储小于零的偶数
    LEA BX,NUMS;数组的首地址传递给BX，便于后续的比较

AGAIN:
    CMP  WORD PTR [BX],0;与0比较 
    JGE PLU;大于0跳转至PLU
    AND WORD PTR[BX],00001H;确定最后一位是否为1，为1为奇数，为0为偶数
    JZ VerifyH;与1相同是奇数，跳转至VerifyH
    INC AL;AL存储小于零的偶数 加1
    JMP NEXT
VerifyH:
    INC AH;存储小于零的奇数 加1
    JMP NEXT

PLU: 
    JZ ZER;等于0 跳转至ZER
    AND WORD PTR[BX],0001H;确定最后一位是否为1，为1为奇数，为0为偶数
    JZ VerifyW;与1相同是奇数，跳转至VerifyW
    INC DL;DL存储大于零的偶数 加1
    JMP NEXT
VerifyW:
    INC DH;存储大于零的奇数 加1      
    JMP NEXT

ZER:INC ZERO;存储0的个数 加一

NEXT: 
    INC BX
    INC BX;选择下一个字，因为数字存的是字
    LOOP AGAIN;循环

    ;将寄存器存储的数据转移至内存中
    MOV Plus_Even,DH
    MOV Plus_Odd,DL
    MOV Minus_Odd,AL
    MOV Minus_Even,AH

    ADD Plus_Even,30H
    ADD Plus_Odd,30H
    ADD Minus_Odd,30H
    ADD Minus_Even,30H
    ADD ZERO,30H
    ;转换为ASCII码 在屏幕显示

    ;显示区域
    PrintString STRING0
    PrintString EnterString

    PrintString STRING1
    MOV AH,02H
    MOV DL,Plus_Odd
    INT 21H
    PrintString EnterString
    
    PrintString STRING4
    MOV AH,02H
    MOV DL,Plus_Even
    INT 21H
    PrintString EnterString
    
    PrintString STRING3
    MOV AH,02H
    MOV DL,Minus_Odd
    INT 21H
    PrintString EnterString
    
    PrintString STRING5
    MOV AH,02H
    MOV DL,Minus_Even
    INT 21H
    PrintString EnterString

    PrintString STRING2
    MOV AH,02H
    MOV DL,ZERO
    INT 21H
    PrintString EnterString
    MOV AX,4C00H;程序结束返回DOS
    INT 21H
CODE ENDS
    END START

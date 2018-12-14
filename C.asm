;空格用于分隔数字，回车用于结束输入

;数据段
DATA SEGMENT
    ;输出的data，为了比较初始化设置为99
    MIN db '9','9'
    
    ;输出的提示自发出
    Input_Prompt DB 'Input some integers, devided with SPACE, show result with ENTER:','$'
    Error_Prompt DB 'Input Error!, please input again:','$'
    Result_String DB 'The Minest number is:','$'
DATA ENDS


;堆栈段
STACK SEGMENT STACK'STACK'
    DB 100H DUP(?)
STACK ENDS


;代码段
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
;显示回车的proc
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
;将键盘输入的char放到al
InputChar proc near
    mov ah,01h
    int 21h
    ret
InputChar endp

;输入的字符判断是否在0-9
Test_Num proc near
    cmp al,'0'
	jb Error    ;below
	cmp al,'9'
	ja Error    ;above
	jmp exit
Error:	
	mov al,0						
exit:
	ret
Test_Num endp

START:
    ;display Input_Prompt
    ;显示输入提示
    mov ax,data
	mov ds,ax
	mov dx,offset Input_Prompt
	mov ax,0900h
	int 21h
    call DisplayEnter

Input_loop:
    ;input high num
    ;输入十位数
    call InputChar
    call Test_Num
    cmp al,00h
    jz Display_Error
    mov bh,al   ;put high num in b high
    ;输入个位数
    call InputChar
    call Test_Num
    cmp al,00h
    jz Display_Error
    mov bl,al   ;put low num in b low
    ;放一个空格区别
    call InputChar
    cmp al,0dh
    jz Compare_Last
    cmp al,' '
    jz Compare
    jmp Display_Error

;如果输入错误，则显示错误提示，重新输入
Display_Error:	
    call DisplayEnter
	mov dx,offset Error_Prompt
	mov ax,0900h
	int 21h
    call DisplayEnter
	jmp Input_loop
;比较大小
Compare:
    cmp bx,word ptr MIN
    jb Change_NUM
    jmp Input_loop
;如果bx寄存器上的数字大于MIN
Change_NUM:
    mov word ptr MIN,bx
	jmp Input_loop

Compare_Last:
    ;for last num
    ;最后一个数字要单独比较
    cmp bx,word ptr MIN 
    jb Swap
    jmp Show_Result
;如果最后一个数字更小，则要交换
Swap:
    mov word ptr min,bx
    jmp Show_Result
;结果输出
Show_Result:
    mov dx,offset Result_String
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
;data
DATA SEGMENT
    ;nums
    NUMS DB -4,-3,-2,-1,0,1,2,3,4
    COUNT equ $-buff
    
    ;output data
    POSITIVE_NUM db ?
    ZERO_NUM db ?
    NEGATIVE_NUM db ?
    
    ;output strings
    string0 db 'nums: -4,-3,-2,-1,0,1,2,3,4'
    string1 db 'Positive number:','$'
    string2 db 'Zero number:','$'
    string3 db 'Negative number:','$'
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


   

CODE ENDS
    END START

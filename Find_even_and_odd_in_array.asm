;Bonus Work done
;Word wise implementation
;find max min

;=========MEMORY LOCATIONS======= 


;--------------------------------
;For Byte_wise operations
;--------------------------------

;Value_array Starts from = 0700:0107
;Even_array Starts from  = 0700:0117
;Odd_array Starts from   = 0700:0127 
;Tatal Even num are at   = 0700:0137
;Total Odd num are at    = 0700:0138
;Maximum value at        = 0700:013A       
;Minimum value at        = 0700:013B
 


 
;--------------------------------
;For Word_wise operations
;-------------------------------- 
 
 
;Value_array Starts from = 0700:013D
;Even_array Starts from  = 0700:015C
;Odd_array Starts from   = 0700:017B 
;Tatal No of Even are at = 0700:019A
;Total No of Odd are at  = 0700:019B
;Maximum value at        = 0700:019D       
;Minimum value at        = 0700:019F 
 
;------------------------------------
 

org 100h 



;Main procedure is at the end of the code
JMP MAIN
 
 
 
.DATA 
;======================================
;Data for byte_wise operations 
;====================================== 

spaceB0 db 'V'                  
Value_array db 15 DUP (0)
spaceB1 db  "E"
Even_array db 15 DUP (0)
spaceB2 db  "O"
Odd_array db 15 DUP (0)
spaceB3 db  "+"  
NoOfeven db 1 DUP (0)   
NoOfodd db 1 DUP (0) 
line_B db 1 DUP ('+')
Max_B db 1 DUP (0)
Min_B db 1 DUP (0)
line_B1 db 1 DUP ('-') 


;======================================
;Data for word_wise operations
;====================================== 

Value_arrayW DW 15 DUP (0)
spaceW1 db  "-"
Even_arrayW DW 15 DUP (0)
spaceW2 db  "-"
Odd_arrayW DW 15 DUP (0)
spaceW3 db  "-"
NoOfevenW db 1 DUP (0)   
NoOfoddW db 1 DUP (0)
line_W db 1 DUP ('*')
Max_W DW 1 DUP (0)
Min_W DW 1 DUP (0)
line_W1 db 1 DUP ('*')

;--------------------------------------
 
              

.CODE                   

;Start of bytewise procedure.             
BYTEWISE PROC    
    
;Enter value in array to find even and odd.
MOV Value_array[0],02h 
MOV Value_array[1],03h
MOV Value_array[2],04h
MOV Value_array[3],05h
MOV Value_array[4],06h 

;Please enter total no.of value in CX 
;(it will be used as loop counter). 
MOV CX, 05h

MOV DL, 02h 
MOV DH, 00h
MOV BX, 0h
MOV DI, 0h 

;Saves Load effective address in SI register.              
Lea SI,Value_array

;Saves first value of the array.
;in the max_B and min_B var.
MOV AL, [SI]
MOV Max_B, AL
MOV Min_B, AL 


; -----------------------Approach--------------------------
;\                                                         /
;\ 1. Divide the value by 2.                               /
;\ 2. Compare the remainder with 0.                        / 
;\ 3. If it is equal to zero, it will jump to              / 
;\    update even array and will save that value in        / 
;\    even array.                                          / 
;\ 4. If it is not equal to zero. It will jump and update  / 
;\    the odd array.                                       /
;\ 5. Parallelly It will check max and min and update them./  
; ---------------------------------------------------------

;Main loop to check if the value is even
;or odd. Also checks max and min values 
check_Byte:
    
    MOV AL, [SI]
    JMP Max_min
    
check_max_min: 

    MOV AH,0h
    IDIV DL
    CMP AH,DH
    JE Update_even_array ;Jump if equel 
    
JMP Update_odd_array

Update_odd_array:
    MOV AL, [SI]
    INC SI
    MOV Odd_array[DI], AL
    ADD NoOfodd, 1h
    INC DI
    LOOP check_Byte
JMP exit

Update_even_array:
    MOV AL, [SI]
    INC SI
    MOV Even_array[BX], AL
    ADD NoOfeven, 1h
    INC BX
    LOOP check_Byte
JMP exit
     
Max_min:
    MOV AH, Max_b
    CMP AH, AL
    ;Jump if below or equal
    JBE Update_max_b  
JMP Update_min_b

Update_max_b:
    MOV Max_b ,AL
    JMP check_max_min: 
    
Update_min_b:
    MOV Min_b ,AL
    JMP check_max_min:   
exit:     
ret 
;End of Bytewise procedure        
BYTEWISE ENDP   
 
;----------------------------
;----------------------------

;Start of wordwise procedure 
WORDWISE PROC

;Enter values and update index  
;accordingly to find even or odd values                 
MOV Value_arrayW[0], 2222h
MOV Value_arrayW[2], 3333h
MOV Value_arrayW[4], 4444h
MOV Value_arrayW[6], 5555h
MOV Value_arrayW[8], 6666h


;Please update CX accordingly to tatal num of values
MOV CX, 5h
MOV DI, 0h
MOV BX, 0h

;Will save load effective address in registers
LEA SI, Value_arrayW
LEA BX, Even_arrayW
LEA DI, Odd_arrayW
                  
;Will take word from memory and save it in AX                  
MOV AX, WORD PTR [SI]

;Save first value in max and min var  
MOV Max_W, AX 
MOV Min_W, AX 

;------------------------------Approach----------------------------------------
;\                                                                             \
;\ 1.Here I used rotation. When we do rotat right w/o carry,                   \
;\   It is equal to division by two. So, instead dividing the                  \
;\   value by 2 and comparing we simply rotat the bits right and update        \
;\   carry flag.                                                               \
;\ 2.If the carry flag is 0. It will jump to update even array and will save   \
;\   the value in even arrayW.                                                 \
;\ 3.If the carry flag is set. It will update the odd array.                   \
;------------------------------------------------------------------------------



;main loop
check_word:
    MOV AX, [SI]
    JMP Max_min_W ;jump and update max and min. 
Check_max_minW:
    ROR AX, 1h
    JA Update_even_arrayW ;Jump if carry is 0.
JMP Update_odd_arrayW     
    
    
Update_odd_arrayW:

    MOV AX, [SI]
    MOV WORD PTR [DI], AX
    ADD SI, 02h
    ADD DI, 02h
    INC NoOfoddW
    LOOP check_word
JMP exit1 
    
    
    
Update_even_arrayW:
    MOV AX, [SI]
    MOV WORD PTR [BX], AX
    ADD SI, 02h
    ADD BX, 02h
    INC NoOfevenW
    LOOP check_word 
JMP exit1

Max_min_W:
    MOV DX, Max_W
    CMP DX, AX
    JBE Update_max_W
JMP Update_min_W

Update_max_W:

    MOV Max_W , AX
    JMP Check_max_minW 

Update_min_W:
    
    MOV Min_W, AX
    JMP Update_min_W    

exit1:
ret


;===========================

WORDWISE ENDP


MAIN PROC
    ;Here we can call other procedures.
    ;comment the procedure if you do not want to run it. 
    CALL BYTEWISE  
    CALL WORDWISE 
    
ret

MAIN ENDP

;==============================================================    
     
END
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

 
 
 
 







                 
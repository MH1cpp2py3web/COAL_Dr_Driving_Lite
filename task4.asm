;task4
[org 0x100]

jmp start

num:      dw 12
mul_res:  dw 0       
div_res:  dw 0        
start:
    mov ax, [num]     
    shl ax, 1         
    mov [mul_res], ax  
    mov ax, [num]     
    shr ax, 1         
    mov [div_res], ax 
    mov ax, 0x4c00
    int 0x21
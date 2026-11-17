;task7
[org 0x100]

jmp start

num:    dw 0xD2B6  
count:  dw 0
bits:   dw 16                  
start:
    mov ax, [num]        
    mov cx, [bits]       
    mov bx, 0            
checkLoop:
    cmp cx, 0
    je  done

    shl ax, 1            
    jnc skip         
    inc bx              
skip:
    dec cx
    jmp checkLoop

done:
    mov [count], bx      
    mov ax, 0x4c00
    int 0x21
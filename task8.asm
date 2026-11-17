;task8
[org 0x100]

jmp start

num:    db 0xB5    
result: db 0

start:
    mov al, [num]    
    and al, 0x7F
    
    xor al, 0x04 
    test al, 0x01
    jz  clear

    mov byte [result], 1   
    jmp done

clear:
    mov byte [result], 0  
done:
    mov ax, 0x4c00
    int 0x21
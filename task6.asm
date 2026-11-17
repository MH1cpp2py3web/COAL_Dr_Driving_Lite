;task6
[org 0x100]

jmp start

num:    db 11010010b    
result: db 0
count: db 8            
start:
    mov al, [num]     
    mov bl, 0          
    mov cl, [count]  

reverse:
    cmp cl, 0
    je  done

    shl al, 1         
    rcl bl, 1          
    dec cl
    jmp reverse

done:
    mov [result], bl   
    mov ax, 0x4c00
    int 0x21
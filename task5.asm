;Task5
[org 0x100]

jmp start

num:    db 10110101b     
result: db 0

start:
    mov al, [num]      
    rol al, 4          
    mov [result], al   
    mov ax, 0x4c00
    int 0x21
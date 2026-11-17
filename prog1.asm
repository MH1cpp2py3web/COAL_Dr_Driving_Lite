;Question 1
[org 0x0100]

           jmp start
arr: db 2,5,8,11,14,17,20,23,26,29
start:
      mov bx, 0
      mov cx, 10
      mov ax, 0

L1:
    mov dl, [arr+bx]
    and dl, 1
    jnz L2

    add ax, 1

L2:
    add bx, 1
    loop L1
    mov ah, 0x4c
    int 0x21


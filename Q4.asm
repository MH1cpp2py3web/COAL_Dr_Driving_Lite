[org 0x0100]

jmp main

obs: dw 0x6552, 0x2C91, 0x7FA3
totalObs: db 3

weights: db 2, -3, -1, 10
         db 1,  4,  2,  0
         db -2, 5,  4, -5


normal:  dw 0, 0, 0
susp:    dw 0, 0, 0
attack:  dw 0, 0, 0
flags:   db 0, 0, 0

main:
    xor cx, cx             
    xor di, di             

process:
    mov ax, [obs + di]
    mov bp, ax
    and bp, 0x001F        
    shr ax, 5

    mov bx, ax
    and bx, 0x001F        
    shr ax, 5
    mov dx, ax

    and dx, 0x003F        
    sub dx, 0x0014             
    sub bx, 0x0008
    sub bp, 0x0010         

normal_calc:
    mov ax, dx
    shl ax, 1
    mov [normal + di], ax

    mov ax, bx
    shl ax, 1
    add ax, bx
    sub [normal + di], ax

    sub [normal + di], bp
    add word [normal + di], 10

susp_calc:
    mov [susp + di], dx

    mov ax, bx
    shl ax, 2
    add [susp + di], ax

    mov ax, bp
    shl ax, 1
    add [susp + di], ax

attack_calc:
    mov word [attack + di], 0

    mov ax, dx
    shl ax, 1
    sub [attack + di], ax

    mov ax, bx
    shl ax, 2
    add ax, bx
    add [attack + di], ax

    mov ax, bp
    shl ax, 2
    add [attack + di], ax

    sub word [attack + di], 5

compare:
    mov si, di
    shr si, 1

    mov ax, [normal + di]
    cmp ax, [susp + di]
    jge normal_high

susp_high:
    mov ax, [susp + di]
    cmp ax, [attack + di]
    jge susp_highest

    mov byte [flags + si], 3
    jmp advance

normal_high:
    mov ax, [normal + di]
    cmp ax, [attack + di]
    jge normal_highest

    mov byte [flags + si], 3
    jmp advance

normal_highest:
    mov byte [flags + si], 1
    jmp advance

susp_highest:
    mov byte [flags + si], 2

advance:
    add di, 2
    inc cx
    cmp cl, [totalObs]
    jb process

exit:
    mov ax, 0x4C00
    int 0x21
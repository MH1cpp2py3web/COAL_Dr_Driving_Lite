
[org 0x100]

jmp start

old15: dw 0, 0

buffer: times 4000 db 0

msg: db 'tsr installed. press c to save, v to restore.$'


savescreen:
    push ax
    push cx
    push si
    push di
    push ds
    push es

    mov ax, 0xb800
    mov ds, ax

    push cs
    pop es

    mov si, 0
    mov di, buffer
    mov cx, 4000

    cld
    rep movsb

    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    ret


restorescreen:
    push ax
    push cx
    push si
    push di
    push ds
    push es

    push cs
    pop ds

    mov ax, 0b800h
    mov es, ax

    mov si, buffer
    mov di, 0
    mov cx, 4000

    cld
    rep movsb

    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    ret

new15:

    cmp ah, 4fh
    jne chain_old

    cmp al, 2eh         
    je key_c

    cmp al, 2fh         
    je key_v

    jmp chain_old


key_c:

    push bp
    mov bp, sp

    call savescreen

    and word [ss:bp+6], 0xfffe

    pop bp
    iret


key_v:

    call restorescreen

    jmp far [cs:old15]


chain_old:

    jmp far [cs:old15]


start:

    push cs
    pop ds

    mov ax, 0x3515
    int 21h

    mov [old15], bx
    mov [old15+2], es

    mov dx, new15
    mov ax, 0x2515
    int 21h

    mov dx, msg
    mov ah, 09h
    int 21h

    mov dx, (resident_end+15)/16
    mov ax, 3100h
    int 21h


resident_end:

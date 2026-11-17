[org 0x100]

jmp start

flag db 0
x dw 0
y dw 0


start:

    push cs
    pop ds

    mov word [x], 0
    mov word [y], 0

    call printstar

l1:
    cmp byte [flag], 1
    jne l1

    call movestar
    call delay

    jmp l1


printstar:

    mov ah, 02h
    mov bh, 0
    mov dh, byte [y]
    mov dl, byte [x]
    int 10h
    mov ah, 09h
    mov al, '*'
    mov bh, 0
    mov bl, 0fh
    mov cx, 1
    int 10h
    ret


movestar:

    mov ah, 02h
    mov bh, 0
    mov dh, byte [y]
    mov dl, byte [x]
    int 10h

    mov ah, 09h
    mov al, ' '
    mov bh, 0
    mov bl, 07h
    mov cx, 1
    int 10h

    inc word [x]

    cmp word [x], 79
    jbe print_new

    mov word [x], 0

print_new:
    call printstar
    ret

delay:
    mov cx, 0xFFFF

d1:
    loop d1
    ret
kbdisr:

    push ax

    in al, 60h

    cmp al, 1fh
    je start_move

    cmp al, 19h
    je stop_move

    jmp exit_isr

start_move:
    mov byte [flag], 1
    jmp exit_isr

stop_move:
    mov byte [flag], 0

exit_isr:
    mov al, 20h
    out 20h, al
    pop ax
    iret
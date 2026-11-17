;Question2
[org 0x100]
           jmp start

array: db -3, 5, -10, 4, 6, -7, 1
size: db 7
max: db 0
start
  mov si,0
  mov al,[array+si]
  mov bl,al
  cmp ah,0
  jge positive
  not al
  add al,1

positive:
    cmp al, [max]
    jbe skip
    mov [max], bl
skip:
  add si,1
  cmp si,[size]
  jl start
mov ax,0x4c00
int 0x21


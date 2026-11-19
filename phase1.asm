
org 100h

jmp start

; VARIABLES

x dw 0
y dw 0
w dw 0
h dw 0
color db 0

road_y dw 85
road_left dw 0
road_right dw 0

lane_x dw 0
lane_y dw 0
lane_dx dw 0
lane_count dw 0

; STEERING VARIABLES
center_x dw 298
center_y dw 184
disk_radius dw 32
disk_color db 0
disk_row dw 0
disk_dy dw 0
disk_dy2 dw 0
disk_r2 dw 0
disk_half dw 0

; TEXT VARIABLES
speed_text db '078', 0
kmh_text db 'km/h', 0
fuel_text db 'FUEL', 0
time_text db 'TIME', 0
dist_text db 'DIST : 0472', 0
score_text db 'SCORE : 0070', 0

; MAIN

start:

    push cs
    pop ds

    ; VGA GRAPHICS MODE
    mov ax, 0013h
    int 10h

    ; VIDEO MEMORY
    mov ax, 0A000h
    mov es, ax

    cld

    ; SKY
    mov word [x], 0
    mov word [y], 0
    mov word [w], 320
    mov word [h], 85
    mov byte [color], 9
    call DrawRect

    ; GRASS
    mov word [x], 0
    mov word [y], 85
    mov word [w], 320
    mov word [h], 85
    mov byte [color], 2
    call DrawRect

    ; ROAD
    call DrawRoad

    ; LEFT DASHED LANE
    mov word [lane_x], 155
    mov word [lane_y], 92
    mov word [lane_dx], -1
    call DrawLane

    ; RIGHT DASHED LANE
    mov word [lane_x], 170
    mov word [lane_y], 92
    mov word [lane_dx], 1
    call DrawLane

    ; ENEMY CAR
    mov word [x], 173
    mov word [y], 91
    mov word [w], 18
    mov word [h], 10
    mov byte [color], 3
    call DrawRect

    mov word [x], 177
    mov word [y], 87
    mov word [w], 12
    mov word [h], 6
    mov byte [color], 3
    call DrawRect

    ; ENEMY WINDOW
    mov word [x], 178
    mov word [y], 88
    mov word [w], 10
    mov word [h], 4
    mov byte [color], 1
    call DrawRect

    ; PLAYER CAR
    mov word [x], 129
    mov word [y], 95
    mov word [w], 30
    mov word [h], 21
    mov byte [color], 1
    call DrawRect

    ; PLAYER UPPER BODY
    mov word [x], 135
    mov word [y], 91
    mov word [w], 19
    mov word [h], 7
    mov byte [color], 1
    call DrawRect

    ; WINDSHIELD
    mov word [x], 135
    mov word [y], 95
    mov word [w], 19
    mov word [h], 8
    mov byte [color], 9
    call DrawRect

    ; REAR LIGHTS
    mov word [x], 130
    mov word [y], 109
    mov word [w], 6
    mov word [h], 5
    mov byte [color], 4
    call DrawRect

    mov word [x], 153
    mov word [y], 109
    mov word [w], 6
    mov word [h], 5
    mov byte [color], 4
    call DrawRect

    ; ORANGE BONNET
    call DrawArc

    ; DASHBOARD
    mov word [x], 0
    mov word [y], 170
    mov word [w], 320
    mov word [h], 30
    mov byte [color], 0
    call DrawRect

    ; SPEEDOMETER BORDER
    mov word [x], 96
    mov word [y], 174
    mov word [w], 61
    mov word [h], 26
    mov byte [color], 7
    call DrawRect

    ; SPEEDOMETER INSIDE
    mov word [x], 98
    mov word [y], 176
    mov word [w], 57
    mov word [h], 22
    mov byte [color], 0
    call DrawRect

    ; FUEL BORDER
    mov word [x], 174
    mov word [y], 181
    mov word [w], 61
    mov word [h], 11
    mov byte [color], 15
    call DrawRect

    ; FUEL INSIDE
    mov word [x], 176
    mov word [y], 183
    mov word [w], 57
    mov word [h], 7
    mov byte [color], 0
    call DrawRect

    ; GREEN FUEL
    mov word [x], 177
    mov word [y], 184
    mov word [w], 26
    mov word [h], 5
    mov byte [color], 10
    call DrawRect

    ; TIME BAR BACKGROUND
    mov word [x], 9
    mov word [y], 18
    mov word [w], 5
    mov word [h], 120
    mov byte [color], 0
    call DrawRect

    ; RED TIME BAR
    mov word [x], 9
    mov word [y], 73
    mov word [w], 5
    mov word [h], 65
    mov byte [color], 12
    call DrawRect

    ; STEERING WHEEL
    call DrawWheel

    ; DRAW TEXT
    call DrawHUD

    ; WAIT FOR KEY
    mov ah, 00h
    int 16h

    ; RETURN TO TEXT MODE
    mov ax, 0003h
    int 10h

    ; EXIT
    mov ax, 4C00h
    int 21h


; DRAW RECTANGLE

DrawRect:

    push ax
    push bx
    push cx
    push dx
    push di

rect_loop:

    mov ax, [y]
    mov bx, 320
    mul bx

    add ax, [x]
    mov di, ax

    mov al, [color]
    mov cx, [w]
    rep stosb

    inc word [y]
    dec word [h]

    jnz rect_loop

    pop di
    pop dx
    pop cx
    pop bx
    pop ax

    ret


; DRAW ROAD

DrawRoad:

road_loop:

    ; LEFT EDGE
    mov ax, [road_y]
    sub ax, 85

    mov bx, 130
    mul bx

    mov bx, 85
    div bx

    mov bx, 130
    sub bx, ax
    mov [road_left], bx

    ; RIGHT EDGE
    mov ax, [road_y]
    sub ax, 85

    mov bx, 145
    mul bx

    mov bx, 85
    div bx

    add ax, 175
    mov [road_right], ax

    ; ROAD SURFACE
    mov ax, [road_left]
    mov [x], ax

    mov ax, [road_right]
    sub ax, [road_left]
    mov [w], ax

    mov ax, [road_y]
    mov [y], ax

    mov word [h], 1
    mov byte [color], 8

    call DrawRect

    ; LEFT WHITE EDGE
    mov ax, [road_left]
    mov [x], ax

    mov ax, [road_y]
    mov [y], ax

    mov word [w], 1
    mov word [h], 1
    mov byte [color], 15

    call DrawRect

    ; RIGHT WHITE EDGE
    mov ax, [road_right]
    mov [x], ax

    mov ax, [road_y]
    mov [y], ax

    mov word [w], 1
    mov word [h], 1
    mov byte [color], 15

    call DrawRect

    inc word [road_y]

    cmp word [road_y], 170
    jne road_loop

    ret


; DRAW DASHED LANES

DrawLane:

    mov word [lane_count], 4

dash_loop:

    mov cx, 5

pixel_loop:

    ; X POSITION
    mov ax, [lane_x]
    mov [x], ax

    ; Y POSITION
    mov ax, [lane_y]
    mov [y], ax

    ; RECTANGLE SIZE
    mov word [w], 7
    mov word [h], 1

    ; WHITE
    mov byte [color], 15

    call DrawRect

    ; DIAGONAL MOVEMENT
    mov ax, [lane_dx]
    add [lane_x], ax

    inc word [lane_y]

    loop pixel_loop

    ; GAP BETWEEN DASHES
    add word [lane_y], 9

    mov ax, [lane_dx]
    mov bx, 9
    imul bx
    add [lane_x], ax

    dec word [lane_count]
    jnz dash_loop

    ret


; DRAW CURVED BONNET

DrawArc:

    pusha

    mov cx, 0

arc_loop:

    ; DX = X - 160
    mov ax, cx
    sub ax, 160

    ; DX SQUARED
    imul ax

    mov bx, ax

    ; HEIGHT = (25600 - DX^2) / 1024
    mov ax, 25600
    sub ax, bx

    mov bx, 1024
    xor dx, dx
    div bx

    ; BASE Y = 165
    mov bx, 165
    sub bx, ax

    ; VIDEO MEMORY OFFSET
    mov ax, bx
    mov dx, 320
    mul dx

    add ax, cx
    mov di, ax

fill_loop:

    mov byte [es:di], 6

    add di, 320
    inc bx

    cmp bx, 165
    jle fill_loop

    inc cx
    cmp cx, 320
    jl arc_loop

    popa
    ret


; DRAW STEERING WHEEL

DrawWheel:

    ; OUTER BLACK RING
    mov word [center_x], 298
    mov word [center_y], 184
    mov word [disk_radius], 32
    mov byte [disk_color], 0
    call DrawDisk

    ; INNER DARK AREA
    mov word [disk_radius], 24
    mov byte [disk_color], 8
    call DrawDisk

    ; HORIZONTAL SPOKE
    mov word [x], 267
    mov word [y], 181
    mov word [w], 26
    mov word [h], 6
    mov byte [color], 0
    call DrawRect

    ; CENTRE HUB
    mov word [disk_radius], 12
    mov byte [disk_color], 7
    call DrawDisk

    ret


; DRAW FILLED CIRCLE

DrawDisk:

    pusha

    mov word [disk_row], 0

    ; RADIUS SQUARED
    mov ax, [disk_radius]
    mul ax
    mov [disk_r2], ax

disk_loop:

    ; DY = CURRENT ROW - RADIUS
    mov ax, [disk_row]
    sub ax, [disk_radius]
    mov [disk_dy], ax

    ; DY SQUARED
    imul ax
    mov [disk_dy2], ax

    ; FIND HALF WIDTH
    mov bx, [disk_radius]

disk_find:

    mov ax, bx
    mul bx

    add ax, [disk_dy2]

    cmp ax, [disk_r2]
    jbe disk_found

    dec bx
    jmp disk_find

disk_found:

    mov [disk_half], bx

    ; X = CENTER X - HALF WIDTH
    mov ax, [center_x]
    sub ax, bx
    mov [x], ax

    ; WIDTH = HALF WIDTH * 2 + 1
    shl bx, 1
    inc bx
    mov [w], bx

    ; Y = CENTER Y + DY
    mov ax, [center_y]
    add ax, [disk_dy]

    cmp ax, 0
    jl disk_next

    cmp ax, 200
    jge disk_next

    mov [y], ax

    ; CLIP RIGHT SIDE
    mov ax, [x]
    add ax, [w]

    cmp ax, 320
    jbe disk_draw

    mov ax, 320
    sub ax, [x]
    mov [w], ax

disk_draw:

    mov word [h], 1

    mov al, [disk_color]
    mov [color], al

    call DrawRect

disk_next:

    inc word [disk_row]

    mov ax, [disk_radius]
    shl ax, 1
    inc ax

    cmp [disk_row], ax
    jb disk_loop

    popa
    ret


; DRAW HUD TEXT

DrawHUD:

    ; DISTANCE - TOP CENTRE
    mov dh, 0
    mov dl, 14
    mov bl, 15
    mov si, dist_text
    call PrintText

    ; SCORE - TOP CENTRE
    mov dh, 1
    mov dl, 14
    mov bl, 14
    mov si, score_text
    call PrintText

    ; TIME - LEFT SIDE
    mov dh, 2
    mov dl, 0
    mov bl, 15
    mov si, time_text
    call PrintText

    ; SPEED - YELLOW
    mov dh, 22
    mov dl, 13
    mov bl, 14
    mov si, speed_text
    call PrintText

    ; KM/H - WHITE
    mov dh, 24
    mov dl, 14
    mov bl, 15
    mov si, kmh_text
    call PrintText

    ; FUEL LABEL
    mov dh, 21
    mov dl, 22
    mov bl, 15
    mov si, fuel_text
    call PrintText

    ret


; PRINT TEXT

PrintText:

    push ax
    push bx
    push dx
    push si

    ; SET CURSOR
    mov ah, 02h
    mov bh, 0
    int 10h

print_loop:

    lodsb

    cmp al, 0
    je print_done

    ; PRINT CHARACTER
    mov ah, 0Eh
    mov bh, 0
    int 10h

    jmp print_loop

print_done:

    pop si
    pop dx
    pop bx
    pop ax

    ret

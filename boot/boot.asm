;
; SimpleOS bootloader
;

; set origin
[org 0x7c00]

; clear screen
    call clear_screen

; Version
    mov bx, SOS_VERSION_STR
    call print_line

; Hello World
    mov bx, HELLO_WORLD_STR
    call print_line

; Hex print tests
    mov bx, 0x42FE
    call print_hex
    mov bx, NEW_LINE_STR
    call print_string

    mov bx, 0xABCD
    call print_hex
    mov bx, NEW_LINE_STR
    call print_string

    mov bx, 0x1234
    call print_hex
    mov bx, NEW_LINE_STR
    call print_string

    mov bx, $
    call print_hex
    mov bx, NEW_LINE_STR
    call print_string

    mov bx, SOS_VERSION_STR
    call print_hex
    mov bx, NEW_LINE_STR
    call print_string

; endless loop
    jmp $

clear_screen:
    pusha

    mov ah, 0x7            ; scroll down function
    mov al, 0              ; 0 = entire window
    mov cx, 0              ; 0,0 as upper left corner.
    mov dx, 0x184f         ; 24,79 as lower right corner.
    mov bh, 0x7            ; normal bg / fg color
    int 0x10               ; call bios

    mov ah, 0x2            ; set cursor position function
    mov bh, 0              ; page number
    mov dx, 0              ; dh = row, dl = column
    int 0x10               ; call bios

    popa
    ret

print_string:
    pusha
    mov ah, 0xe                ; write char
.loop_start:
    mov al, [bx]
    cmp al, 0
    je .loop_end
    int 0x10                   ; video service interrupt
    inc bx
    jmp .loop_start
.loop_end:
    popa
    ret

print_line:
    pusha
    call print_string
    mov bx, NEW_LINE_STR
    call print_string
    popa
    ret

; print hex
print_hex:
    pusha
    mov dx, bx
    mov bx, HEX_PREFIX_STR
    call print_string

    mov ah, 0xe                ; write char
    mov cl, 12
.loop_start:
    mov bx, dx
    shr bx, cl
    and bx, 0x000F
    mov al, bl
    cmp al, 0xA
    jge .char_part

    add al, 0x30                ; 0x30 ASCII = 0
    jmp .print_hexchar

.char_part:
    add al, 0x37                ; 0x41 ASCII = A, 0x41 - 10 = 0x37

.print_hexchar:
    int 10h

    sub cl, 4
    cmp cl, 0
    jl .loop_end
    jmp .loop_start
.loop_end:
    popa
    ret

section .data
section .text
NEW_LINE_STR:
    db 0x0a, 0x0d, 0
HEX_PREFIX_STR:
    db "0x", 0
HELLO_WORLD_STR:
    db "Hello World!", 0
SOS_VERSION_STR:
    db "SimpleOS Version 0.0.0", 0


; padding till 510 bytes with zero
times 510-($-$$) db 0

; bootloader magic number
dw 0xaa55

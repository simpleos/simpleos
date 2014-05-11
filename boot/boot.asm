;
; SimpleOS bootloader
;

; set origin
[org 0x7c00]

; clear screen
    call clear_screen

; Version
    mov bx, SOS_VERSION_STR
    call print_string

; Hello World
    mov bx, HELLO_WORLD_STR
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

; print string
print_string:
    pusha
    mov ah, 0xe                ; write char
print_string_start:
    mov al, [bx]
    cmp al, 0
    je print_string_start_end
    int 0x10                   ; video service interrupt
    inc bx
    jmp print_string_start
print_string_start_end:
    popa
    ret

HELLO_WORLD_STR:
    db "Hello World!", 0x0a, 0x0d, 0
SOS_VERSION_STR:
    db "SimpleOS Version 0.0.0", 0x0a, 0x0d, 0


; padding till 510 bytes with zero
times 510-($-$$) db 0

; bootloader magic number
dw 0xaa55

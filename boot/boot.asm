;
; SimpleOS bootloader
;

; set origin
[org 0x7c00]

; Hello World
    mov bx, str_hello_world
    mov ah, 0xe                ; write char

hello_world:
    mov al, [bx]
    cmp al, 0
    je end_hello_world
    int 0x10                   ; video service interrupt
    inc bx
    jmp hello_world
end_hello_world:

; endless loop
jmp $

str_hello_world:
    db "Hello World!", 0


; padding till 510 bytes with zero
times 510-($-$$) db 0

; bootloader magic number
dw 0xaa55

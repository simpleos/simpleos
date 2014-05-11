[bits 32]

; Config
VIDEO_MEMORY     equ 0xb8000
WHITE_ON_BLACK   equ 0x0f


print_string_32:
    pusha
    mov edx, VIDEO_MEMORY
    mov ah, WHITE_ON_BLACK
.loop_start:
    mov al, [ebx]

    cmp al, 0
    je .loop_end

    mov [edx], ax
    inc ebx
    add edx, 2
    jmp .loop_start
.loop_end:
    popa
    ret

[bits 16]

; read dh sectors from drive dl to es:bx
disk_read:
    pusha
    push dx

    mov ah, 0x2
    mov al, dh

    mov ch, 0x0            ; cylinder 0
    mov dh, 0x0            ; head 0
    mov cl, 0x1            ; sector 1 (starting with sector 1 as first sector)

    int 13h
    jc disk_error

    pop dx
    cmp dh, al
    jne disk_error

    popa
    ret

disk_error:
    mov bx, SOS_VERSION_STR
    call print_line
    jmp $

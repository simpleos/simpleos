[bits 16]

; Hello World
    mov bx, HELLO_WORLD_STR
    call print_line

; Hex print tests
    mov bx, 0x42FE
    call print_hex
    mov bx, NEW_LINE_STR
    call print_string

; Read from floppy disk
    mov bp, 0x8000
    mov sp, bp

    mov bx, 0x9000
    mov dh, 5        ; 5 sectors
    mov dl, 1        ; disk 1
    call disk_read

    mov bx, [0x9000]
    xchg bl, bh
    call print_hex
    mov bx, [0x9002]
    xchg bl, bh
    call print_hex

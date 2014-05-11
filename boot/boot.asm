;
; SimpleOS bootloader
;

; set origin and bits
[org 0x7c00]
[bits 16]

; store bootdrive
    mov [BOOTDRIVE], dl

; clear screen
    call clear_screen

; Version
    mov bx, SOS_VERSION_STR
    call print_line

; Tests
;%include "boot/tests.asm"

; switch to 32bit mode
    call switch_32bit

; endless loop
    jmp $

[bits 32]
BEGIN_32BIT:

; test 32bit direct mem write string
    mov ebx, TEST32_STR
    call print_string_32

; endless loop
    jmp $

%include "boot/16bit/screen.asm"
;%include "boot/16bit/disk.asm"
%include "boot/16bit/switch_32bit.asm"
%include "boot/32bit/screen.asm"
%include "boot/gdt.asm"


section .data
BOOTDRIVE:         db 0

section .text
DISK_ERROR_STR:    db "Disk read error!", 0
NEW_LINE_STR:      db 0x0a, 0x0d, 0
HEX_PREFIX_STR:    db "0x", 0

HELLO_WORLD_STR:   db "Hello World!", 0
SOS_VERSION_STR:   db "SimpleOS Version 0.0.0", 0
TEST32_STR:        db "32bit Memory Write String Test", 0


; padding till 510 bytes with zero
times 510-($-$$) db 0

; bootloader magic number
dw 0xaa55

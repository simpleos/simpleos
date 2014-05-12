;
; SimpleOS bootloader
;

; set origin and bits
[org 0x7c00]
[bits 16]
KERNEL_OFFSET equ 0x1000        ; This is the memory offset to which we will load our kernel

; store bootdrive
    mov [BOOTDRIVE], dl

; setup stack
    mov bp, 0x9000
    mov sp, bp

; clear screen
    call clear_screen

; Version
    mov bx, MSG_SOS_VERSION
    call print_line

; Load Kernel
    mov bx, MSG_LOAD_KERNEL
    call print_line
    call load_kernel

; debug
    mov bx, [KERNEL_OFFSET]
    call print_hex
    mov bx, [KERNEL_OFFSET + 8]
    call print_hex
    mov bx, [KERNEL_OFFSET + 16]
    call print_hex
    mov bx, [KERNEL_OFFSET + 24]
    call print_hex

; switch to 32bit mode
    call switch_32bit

; endless loop
    jmp $

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET        ; Setup parameters for our disk_load routine , so
    mov dh , 15                  ; that we load the first 15 sectors (excluding
    mov dl, [BOOTDRIVE]          ; the boot sector) from the boot disk (i.e. our
    call disk_read               ; kernel code) to address KERNEL_OFFSET
    ret


[bits 32]
BEGIN_32BIT:

; Welcome 32bit protected mode
    mov ebx, MSG_32BIT
    call print_string_32

; Start kernel
    call KERNEL_OFFSET

; endless loop
    jmp $

%include "boot/16bit/screen.asm"
%include "boot/16bit/disk.asm"
%include "boot/16bit/switch_32bit.asm"
%include "boot/32bit/screen.asm"
%include "boot/gdt.asm"


;section .data
BOOTDRIVE:         db 0

;section .text
DISK_ERROR_STR:    db "Disk read error!", 0
NEW_LINE_STR:      db 0x0a, 0x0d, 0
HEX_PREFIX_STR:    db "0x", 0

HELLO_WORLD_STR:   db "Hello World!", 0
MSG_SOS_VERSION:   db "SimpleOS Version 0.0.0", 0
MSG_32BIT:         db "Successfully landed in 32-bit Protected Mode.", 0
MSG_LOAD_KERNEL:   db "Loading kernel into memory...", 0


; padding till 510 bytes with zero
times 510-($-$$) db 0

; bootloader magic number
dw 0xaa55

; Ensures that we jump straight into the kernel’s entry function.
[bits 32]			; We’re in protected mode by now, so use 32-bit instructions.
[extern main]		; Declate that we will be referencing the external symbol ’main’,
					 ; so the linker can substitute the final address

; test
mov ah, 0x0F
mov al, 'E'
mov [0xb8000], eax

call main			; invoke main() in our C kernel
jmp $				; Hang forever when we return from the kernel
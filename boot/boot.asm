jmp $				; loop

times 510-($-$$) db 0		; 512 byte zero padding

dw 0xaa55			; magic number

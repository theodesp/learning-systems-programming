ORG 0x7c00
bits 16

start:
    ; Clear all segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    
    ; Jump to main code
    jmp main

; Main code goes here, but in this case there is nothing to do
main:
    ; Infinite loop
    cli
    hlt
    jmp $

; Bootloader signature
times 510-($-$$) db 0
dw 0xaa55
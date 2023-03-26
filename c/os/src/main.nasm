ORG 0x7c00
bits 16

%define ENDL 0x0D, 0x0A

start:
    ; Clear all segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    ; Setup stack
    mov ss, ax
    mov sp, 0x7c00
    
    ; Jump to main code
    jmp main


; Prints a string to the screen
; Params:
;    - ds:si points to string
puts:
    ; save registers we will modify
    pusha         ; save registers
    mov ah, 0x0e   ; teletype output function

.loop:
    lodsb ; loads next character in al
    or al, al ; verify if next char is null
    jz .done ; jump to done label is zero flag is set
    int 0x10      ; otherwise, print the character
    jmp .loop

.done:
    popa          ; restore registers
    ret

; Main code goes here, but in this case there is nothing to do
main:
    ; print message
    mov si, msg_hello
    call puts

    ; Infinite loop
    cli
    hlt
    jmp $

; String to print
msg_hello db 'Hello World!', ENDL, 0

; Bootloader signature
times 510-($-$$) db 0
dw 0xaa55
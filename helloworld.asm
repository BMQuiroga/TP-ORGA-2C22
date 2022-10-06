;%include "io.inc"

global main
extern puts
extern gets

section     .data
    ;texto db "Hola Mundo"
section .bss
    texto resb 100
section .text
    
main:
    mov rcx,texto
    sub rsp,32
    call gets
    add rsp,32
    
    mov rcx,texto
    sub rsp,32
    call puts
    add rsp,32
    ret




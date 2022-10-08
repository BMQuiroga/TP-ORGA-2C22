global  main
extern	puts
extern  gets
extern	printf

section     .data
    textCadena      db  "Ingrese la cadena numero %lli",10,0
        

section     .bss
    cadena1     resw 40
    cadena2     resw 40
    cadena3     resw 40
    cadena4     resw 40
    cadena5     resw 40
    cadena6     resw 40



section     .text
main:
    mov rbp, rsp; for correct debugging
    mov rdx,1
    mov rcx,cadena1
    call input
    mov rdx,2
    mov rcx,cadena2
    call input
    mov rdx,3
    mov rcx,cadena3
    call input
    mov rdx,4
    mov rcx,cadena4
    call input
    mov rdx,5
    mov rcx,cadena5
    call input
    mov rdx,6
    mov rcx,cadena6
    call input
    ret
 
input:
    ;rdx numero de ciclo
    ;rcx donde se deja la cadena
    mov rdi,rcx
    
    mov rcx,textCadena
    sub rsp,32
    call printf
    add rsp,32
    
    
    mov rcx,rdi
    
    
    sub rsp,32
    call gets
    add rsp,32
    
    mov rcx,rdi
    call validador
    cmp rax,1;Si validador devuelve 1, es valido
    jne input:
    ret
validador:
    

analyze:
    ret
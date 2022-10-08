global  main
extern	puts
extern  gets
extern	printf

section     .data
    textCadena      db  "Ingrese la cadena numero %lli",10,0
        

section     .bss
    cadena1     resw 20
    cadena2     resw 20
    cadena3     resw 20
    cadena4     resw 20
    cadena5     resw 20
    cadena6     resw 20



section     .text
main:
    mov rbp, rsp; for correct debugging
    mov rdx,1
    inicio:
    
    mov rcx,textCadena
    sub rsp,32
    call printf
    add rsp,32
    
    mov rcx,cadena1
    sub rsp,32
    call gets
    add rsp,32
    
    inc rdx
   
    cmp rdx,6
    jle inicio
    call analyze
    ret
input:
    ;rax numero de ciclo
    ;rcx donde se deja la cadena
    

analyze:
    ret
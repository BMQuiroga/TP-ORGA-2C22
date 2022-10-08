global  main
extern	puts
extern  gets
extern	printf

section     .data
    textCadena      db  "Ingrese la cadena numero %lli",10,0
        

section     .bss
    cadena1     resw 100
    cadena2     resw 100
    cadena3     resw 100
    cadena4     resw 100
    cadena5     resw 100
    cadena6     resw 100



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
    start:
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
    jne start
    ret
validador:
    mov r9,0;contador de elementos
    mov r8,0;contador de bytes movidos
    ;si me muevo mas de 60 bytes, deberia haber 20 elementos max
    jmp startValidador
    restart:
    inc r8
    inc r9
    cmp r9,20
    je endValidador
    startValidador:
    
    cmp rcx,32
    je restart
    inc rcx
    inc r8
    cmp rcx,32
    je restart
    inc rcx
    inc r8
    cmp rcx,32
    je restart
    
    mov r9,100 ;r9 se convierte en la cantidad de bytes para llegar al final de la cadena reservada
    sub r9,r8
    
    
    endValidador:;Hay 3 elementos seguidos que no son espacio
    dec r9
    cmp rcx,0;si ese elemento (y todos los que le siguen) son espacio, se termino la cadena
    jne errorValidador
    inc rcx
    cmp r9,0
    jg endValidador
    mov rax,1
    ret
    errorValidador:
    mov rax, 0
    ret

analyze:
    ret
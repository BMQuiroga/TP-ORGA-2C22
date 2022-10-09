global  main
extern	puts
extern  gets
extern	printf

section     .data
    textCadena      db  "Ingrese la cadena numero %lli",10,0
    cadena1 times 20 db " "
    cadena2 times 20 db " " 
    cadena3 times 20 db " " 
    cadena4 times 20 db " "
    cadena5 times 20 db " " 
    cadena6 times 20 db " " 

section     .bss
    ;cadena1     resw 100
    
    elementoAux1    resw 1
    elementoAux2    resw 1
    elementoAux3    resw 1
    tamanoArray     resw 1
    
   



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
    
    ret
    


analyze:
    ret
    
    
elementoDelArrayNumeroX:;falta probar
    ;rcx numero
    ;rdx cadena
    ;devuelve el elemento a ElementoAux1
    ;El primer elemento es 0
    cmp rcx,0
    jne siguienteElemento
    mov ElementoAux1,rdx
    ret
    siguienteElemento:
    sub rcx
    inc rdx
    inc rdx
    cmp rdx,0x32
    jne elementoDelArrayNumeroX;si despues de 2 despl estoy en otro char no espacio, aca empieza la sig palabra
    inc rdx
    jmp elementoDelArrayNumeroX;si no, hace falta 1 despl mas
    
arrayIncluyeElemento:
    ret
    
TamanoDeArray:;sin probar
    ;rcx array
    ;busca hasta encontrar 2 0x32 seguidos
    mov r8,0;contador espacios encontrados
    mov r9,0;contador espacios seguidos
    TamanoStart:
    cmp r9,2
    je endTamañoArray
    cmp rcx,0x32
    je EncontroEspacio
    NoEncontroEspacio:
    mov r9,0
    inc rcx
    jmp TamanoStart
    EncontroEspacio:
    inc r9
    inc r8
    inc rcx
    jmp TamanoStart
 
    endTamanoArray:
    sub r8
    mov tamanoArray,r8
    
    
    
    
    
    
    
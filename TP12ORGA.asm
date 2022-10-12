global  main
extern	puts
extern  gets
extern	printf

section     .data
    textCadena      db  "Ingrese la cadena numero %lli",10,0
    cadena  times 180 db " "

section     .bss
    ;cadena1     resw 100
    
    elementoAux1    resw 1
    elementoAux2    resw 1
    elementoAux3    resw 1
    tamanoArray     resw 1
    
   



section     .text
main:
    mov rbp, rsp; for correct debugging
    mov rsi,0
    inicio:   
    mov rdx,rsi
    imul rdx,60
    
    add rdx,cadena
    mov rcx, rdx
    
    mov rdx,rsi
    call input
    inc rsi
    cmp rsi,5
    jle inicio
      
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
    mov [elementoAux1],rdx
    ret
    siguienteElemento:
    dec rcx
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
    je endTamanoArray
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
    dec r8
    mov [tamanoArray],r8
    
ElementosSonIguales:;sin probar
    ;rcx y rdx direccs de memoria
    mov r15,[rcx]
    cmp r15,[rdx]
    je PrimerElementoIgual
    jmp NoSonIguales
    PrimerElementoIgual:
    inc rcx
    inc rdx
    mov r15,[rcx]
    cmp r15,[rdx]
    je SegundoElementoIgual
    jmp NoSonIguales
    SegundoElementoIgual:
    mov rax,1
    ret
    NoSonIguales:
    mov rax,0
    ret
    
    
    
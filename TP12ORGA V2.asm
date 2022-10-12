global  main
extern	puts
extern  gets
extern	printf

section     .data
    textCadena      db  "Ingrese la cadena numero %lli",10,0
    cadena  times 240 db 0x20
    placeholder db 0x20

section     .bss
    ;cadena1     resw 100
    
    elementoAux1    resw 1
    tamanoArray     resw 1
    
    
   



section     .text
main:
    mov rbp, rsp; for correct debugging
    mov rsi,0
    inicio:   
    mov rdx,rsi
    imul rdx,40
    
    add rdx,cadena
    mov rcx, rdx
    
    mov rdx,rsi
    call input
    inc rsi
    cmp rsi,5
    jle inicio
    
    call analyze
    
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
    ;ret
    ;modo debug
    mov rdx,2
    mov rcx,1
    
    ;call DeepCopy
    call elementoXDelArrayA
    
    
    mov rcx,elementoAux1
    
    sub rsp,32
    call printf
    add rsp,32
    
    mov rdx,1
    
    call TamanoDeArray
    
    mov rcx,rax
    
    sub rsp,32
    call printf
    add rsp,32
    
    
    
    
    
    
    
    
    
    
    ret
    
elementoXDelArrayA:;devuelve el elemento
    ;rdx numero del elemento
    ;rcx numero del array
    mov r8,cadena
    imul r9,rcx,40
    add r8,r9
    imul r9,rdx,2
    add r8,r9
    mov ax,[r8]
    mov word[elementoAux1],ax
    ret
    
TamanoDeArray:;sin probar
    ;rdx numero del array
    ;r10 contador de elementos
    ;r8 puntero
    ;al placeholder, elemento vacio
    mov rax,0
    mov rbx,0
    

    mov r10,0
    mov r8,cadena
    imul r9,rdx,40
    add r8,r9
    mov ax,[placeholder]
    ;mov 
    startTamanoDeArray:
    
    
        
    ;cmp [r8],ax;NUNCA ES =
    mov bx,[r8]
    cmp bx,ax
    
    
    
    je endTamanoDeArray; si encuentra un espacio, el resto de la cadena esta vacia
    
    add r8,2; paso al siguiente elemento
    inc r10; el array tiene 1 elemento mas
    
    cmp r10,20; si tiene 20, corto
    jl startTamanoDeArray
    endTamanoDeArray:
    mov rax,r10
    ret
    
ElementosSonIguales:;sin probar
    ;rcx y rdx direccs de memoria
    mov r15,[rcx]
    cmp r15,[rdx]
    jne NoSonIguales
    ;si llega aca, tienen el mismo primer elemento
    inc rcx
    inc rdx
    mov r15,[rcx]
    cmp r15,[rdx]
    jne NoSonIguales
    ; segundo elemento igual, son iguales
    mov rax,1
    ret
    NoSonIguales:
    mov rax,0
    ret
    
;DeepCopy:
    ;rdx numero del elemento
    ;rcx numero del array
    ;call elementoXDelArrayA
    ;mov r8,elementoAux1
    ;mov r9,elementoCargado1
    ;mov [r9],r8
    ;inc r8
    ;inc r9
    ;mov [r9],r8
    ;ret
    
    
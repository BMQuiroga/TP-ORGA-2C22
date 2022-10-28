global  main
extern	puts
extern  gets
extern	printf

section     .data
    textCadena      db  "Ingrese la cadena numero %lli: ",10,0
    textInput1      db  "Ingrese la primera cadena a analizar: ",0
    textInput2      db  "Ingrese la segunda cadena a analizar, para seguir ingrese el mismo numero que en la primera: ",0
    textSearch      db  "Ingrese un elemento a buscar, para salir ingrese el elemento '  ' (doble espacio, sin comillas): ",0
    textSize        db  "La cadena ingresada tiene %lli elementos",10,0
    textInclucion   db  "La cadena %lli incluye a la cadena %lli",10,10,0
    textIgualdad    db  "La cadenas %lli y %lli son iguales",10,10,0
    textSearch2     db  "El elemento [%c%c] se encuentra en la cadena %lli",10,10,10,0
    cadena  times 240 db 0;6*(20*2)
    placeholder db 0
    elementoquit    dw  "  "

section     .bss
    ;cadena1     resw 100
    
    elementoAux1    resw 1
    elementoAux2    resw 1
    elementoAux3    resw 1
    tamanoArray1    resq 1
    tamanoArray2    resq 1
    numeroArray1    resq 1
    numeroArray2    resq 1
    coincidencias   resq 1
    check           resb 1


    

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
    
    maininput2:
    
    call input2
    
    mov r8,[numeroArray1]
    mov r9,[numeroArray2]
    cmp r8,r9
    je maininput3
    
    call Analizar
    
    jmp maininput2
    
    maininput3:

    call input3
    
    mov r8w,[elementoAux2]
    cmp r8w,[elementoquit]
    je mainsalir
    
    call BuscarElemento
    
    jmp maininput3
    
    mainsalir:
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
    
debug:
    mov rdx,1
    
    call TamanoDeArray
    
    mov rdx,rax
    mov rcx,textSize
    
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
    mov [elementoAux1],ax
    ret
    
TamanoDeArray:;fu
    ;rdx numero del array
    ;r10 contador de elementos
    ;r8 puntero
    ;al placeholder, elemento vacio
 
    mov r10,0

    imul r8,rdx,40
    add r8,cadena
    
    
    startTamanoDeArray:

    ;cmp [r8],ax;NUNCA ES =
    ;mov bx,[r8]
    ;cmp bx,ax
    
    mov rcx,1
    mov rsi,placeholder
    mov rdi,r8
    repe cmpsb
    
    
    
    je endTamanoDeArray; si encuentra un espacio, el resto de la cadena esta vacia
    
    add r8,2; paso al siguiente elemento
    inc r10; el array tiene 1 elemento mas
    
    cmp r10,20; si tiene 20, corto
    jl startTamanoDeArray
    endTamanoDeArray:
    mov rax,r10
    ret

InstanciasDeIgualdadFull:
    ;rcx no se usa
    ;rbp numero de array 1 
    ;rdx numero de array 2, se lo pasa a rsi temporalmente para usar rdx de parametro a TamanoDeArray, y se lo devuelve dsp 
    ;r8 direccion de array 1
    ;r9 direccion de array 2
    ;r10 iterador 1
    ;r11 iterador 2
    ;r12 contador
    ;r13 puntero 1
    ;r14 puntero 2
    ;rsi,rdi,rcx se usan para el compsb
    mov rbp,[numeroArray1]
    mov rdx,rbp
    call TamanoDeArray
    mov [tamanoArray1],rax
    
    mov rsi,[numeroArray2]
    mov rdx,rsi
    call TamanoDeArray
    mov [tamanoArray2],rax

    mov rdx,[numeroArray2] ;numero array 2 queda en rdx

    imul r8,rbp,40
    add r8,cadena
    imul r9,rdx,40
    add r9,cadena

    mov r12,0
    mov r11,0
    mov r10,0

    mov r13,r8
    mov r14,r9
    Loop1:

    mov rcx,2
    mov rsi,r13
    mov rdi,r14
    repe cmpsb
    jne abajo
    inc r12
    abajo:

    add r13,2
    inc r10

    cmp r10,[tamanoArray1]
    jl Loop1

    add r14,2
    mov r13,r8
    inc r11
    mov r10,0

    cmp r11,[tamanoArray2]
    jl Loop1

    mov [coincidencias],r12
    ret

input2:
    
    mov rcx,textInput1
    sub rsp,32
    call printf
    add rsp,32
    
    mov rcx,numeroArray1
    sub rsp,32
    call gets
    add rsp,32

    mov rcx,textInput2
    sub rsp,32
    call printf
    add rsp,32
    
    mov rcx,numeroArray2
    sub rsp,32
    call gets
    add rsp,32
    ;perdon por lo que estas a punto de presenciar
    mov rax,[numeroArray2]
    add rax,-48
    mov [numeroArray2],rax
    mov rax,[numeroArray1]
    add rax,-48
    mov [numeroArray1],rax
    ;perdon por lo que acabas de presenciar
    ret

input3:
    mov rcx,textSearch
    sub rsp,32
    call printf
    add rsp,32
    
    mov rcx,elementoAux2
    sub rsp,32
    call gets
    add rsp,32

    ret

Analizar:
    call InstanciasDeIgualdadFull
    call PrimeroIncluyeSegundo
    call SegundoIncluyePrimero
    call igualdad
    call union
    ret

PrimeroIncluyeSegundo:
    mov rax,[tamanoArray1]
    mov rbx,[tamanoArray2]
    mov rcx,[coincidencias]
    cmp rax,rbx
    jle PrimeroNoIncluyeSegundo;1 tiene que ser mayor en tamaño
    cmp rcx,rbx
    jne PrimeroNoIncluyeSegundo;1 y 2 comparten todos los elementos de 2

    mov rcx,textInclucion 
    mov rdx,[numeroArray1]
    mov r8,[numeroArray2]
    sub rsp,32
    call printf
    add rsp,32
    PrimeroNoIncluyeSegundo:
    ret

SegundoIncluyePrimero:
    mov rax,[tamanoArray1]
    mov rbx,[tamanoArray2]
    mov rcx,[coincidencias]
    cmp rbx,rax
    jle SegundoNoIncluyePrimero;2 tiene que ser mayor en tamaño
    cmp rcx,rax
    jne SegundoNoIncluyePrimero;1 y 2 comparten todos los elementos de 1

    mov rcx,textInclucion 
    mov rdx,[numeroArray2]
    mov r8,[numeroArray1]
    sub rsp,32
    call printf
    add rsp,32
    SegundoNoIncluyePrimero:
    ret

igualdad:
    mov rax,[tamanoArray1]
    mov rbx,[tamanoArray2]
    mov rcx,[coincidencias]
    cmp rbx,rax
    jne noigualdad;misma cdad de elementos
    cmp rcx,rax
    jne noigualdad;cdad de elementos igual a las coincidencias

    mov rcx,textIgualdad 
    mov rdx,[numeroArray1]
    mov r8,[numeroArray2]
    sub rsp,32
    call printf
    add rsp,32

    noigualdad:
    ret

union:;WORK IN PROGRESS
    ret

InstanciasDeIgualdadFullb:
    mov qword[coincidencias],3
    mov qword[tamanoArray1],3
    mov qword[tamanoArray2],4
    ret

BuscarElemento:;falta probar
    mov r12,cadena
    mov r13,1;contador
    BuscarElementoLoop:
    
    mov rcx,2
    mov rdi,r12
    mov rsi,elementoAux2
    repe cmpsb
    jne BuscarElementoAbajo

    call printAparicionesElemento

    BuscarElementoAbajo:

    add r12,2
    inc r13


    cmp r13,121
    jne BuscarElementoLoop
    ret
    

printAparicionesElemento:;sin probar
    mov r14,r13
    mov r9,0

    cmp r14,20
    jle printElementoEnd
    inc r9
    cmp r14,40
    jle printElementoEnd
    inc r9
    cmp r14,60
    jle printElementoEnd
    inc r9
    cmp r14,80
    jle printElementoEnd
    inc r9
    cmp r14,100
    jle printElementoEnd
    inc r9
    
    printElementoEnd:

    mov rcx,textSearch2
    mov rdx,[elementoAux2]
    mov r8,elementoAux2
    inc r8
    mov r8,[r8]
    sub rsp,32
    call printf
    add rsp,32
    ret

printUnion:
    call printArray1
    call printArray2

printArray1:
    mov r10,[numeroArray1]
    mov r11,0
    mov r12,[tamanoArray1]
    printArray1Loop:
    
    ;elementoXDelArrayA:;devuelve el elemento
    ;rdx numero del elemento
    ;rcx numero del array

    mov rdx,r11
    mov rcx,r10

    call elementoXDelArrayA

    mov rcx,[elementoAux1]
    sub rsp,32
    call printf
    add rsp,32

    call printSpace

    inc r11
    cmp r11,r12
    jne printArray1Loop
    ret

printSpace:
    push rcx
    mov rcx,' '
    sub rsp,32
    call printf
    add rsp,32
    pop rcx
    ret

printArray2:
    mov r10,[numeroArray2]
    mov r11,0
    mov r12,[tamanoArray2]
    printArray2Loop:
    
    ;elementoXDelArrayA:;devuelve el elemento
    ;rdx numero del elemento
    ;rcx numero del array

    mov rdx,r11
    mov rcx,r10

    call elementoXDelArrayA

    mov rcx,[elementoAux1]

    call perteneceAlArray;FALTA HACER

    cmp byte[check],'S';COMO HACE EL RETURN,

    sub rsp,32
    call printf
    add rsp,32

    call printSpace

    inc r11
    cmp r11,r12
    jne printArray2Loop
    ret

perteneceAlArray:
    mov byte[check],'N'
    ;no puede modificar r10,r11,r12
    ;recibe la direccion en rcx
    mov r13,[tamanoArray1]
    ret
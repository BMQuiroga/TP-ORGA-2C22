global  main
extern	puts
extern  gets
extern	printf

section     .data
    textLineJump    db  "",10,0
    cadenaValida    db  " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";37
    textStart       db  "Las cadenas se inputean con todos los elementos sin separacion, en el caso de haber un elemento de 1 char, usar espacio como 2do char",10,0
    textCadena      db  "Ingrese la cadena numero %lli: ",10,0
    textInput1      db  "Ingrese la primera cadena a analizar: ",10,0
    textInput2      db  "Ingrese la segunda cadena a analizar, para salir ingrese el mismo numero que en la primera: ",10,0
    textSearch      db  "Ingrese un elemento a buscar, para salir ingrese el elemento '  ' (doble espacio, sin comillas): ",10,0
    textSize        db  "La cadena ingresada tiene %lli elementos",10,0
    textInclucion   db  "La cadena %lli incluye a la cadena %lli",10,0
    textIgualdad    db  "La cadenas %lli y %lli son iguales",10,0
    textSearch2     db  "El elemento [%c%c] se encuentra en la cadena %lli",10,0
    textUnion       db  "La union de las cadenas %lli y %lli es: ",10,0 
    textInvalido    db  "Alguna de las cadenas ingresadas es invalida, vuelvalo a intentar",10,0
    cadena          times 252 db  " ";6*(21*2) 
    placeholder     db " "
    elementoquit    dw "  "
    space           db  " ",0
    cadenaRelleno   times 252 db  " "

section     .bss
    ;cadena1     resw 100
    
    elementoAux1    resw 1;la func elementoXdelArrayA devuelve el resultado aca, tambien es usado por printArray2
    elementoAux2    resw 1;aca va el elemento de input
    ;elementoAux3    resw 1;usado por el printArray2
    tamanoArray1    resq 1
    tamanoArray2    resq 1
    numeroArray1    resq 1
    numeroArray2    resq 1
    coincidencias   resq 1
    check           resb 1
    check2          resb 1


    

section     .text
main:
    mov rbp, rsp; for correct debugging
    
    call startMsg

    mov rsi,0
    inicio:   
    mov rdx,rsi
    imul rdx,42
    
    add rdx,cadena
    mov rcx, rdx
    
    mov rdx,rsi
    call input
    inc rsi
    cmp rsi,5
    jle inicio
    
    call validador;
    cmp byte[check],'V';VALIDADOR DEJA EN AL UNA V de valido O UNA N
    je maininput2
    mov rcx,textInvalido
    sub rsp,32
    call printf
    add rsp,32
    call reescribir
    mov rsi,0
    jmp inicio

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
    imul r9,rcx,42
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

    imul r8,rdx,42
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

    imul r8,rbp,42
    add r8,cadena
    imul r9,rdx,42
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
    call printUnion
    ret

PrimeroIncluyeSegundo:
    mov rax,[tamanoArray1]
    mov rbx,[tamanoArray2]
    mov rcx,[coincidencias]
    cmp rax,rbx
    jle PrimeroNoIncluyeSegundo;1 tiene que ser mayor en tamaño
    cmp rcx,rbx
    jl PrimeroNoIncluyeSegundo;1 y 2 comparten todos los elementos de 2

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
    jl SegundoNoIncluyePrimero;1 y 2 comparten todos los elementos de 1

    mov rcx,textInclucion;305 Y 323 ERAN JNE, version 1.1 entrega
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


    cmp r13,127
    jne BuscarElementoLoop
    ret
    

printAparicionesElemento:;sin probar
    mov r14,r13
    mov r9,0

    cmp r14,21
    jl printElementoEnd
    inc r9
    cmp r14,42
    jl printElementoEnd
    inc r9
    cmp r14,63
    jl printElementoEnd
    inc r9
    cmp r14,84
    jl printElementoEnd
    inc r9
    cmp r14,106
    jl printElementoEnd
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
    mov rcx,textUnion
    mov rdx,[numeroArray1]
    mov r8, [numeroArray2]
    sub rsp,32
    call printf
    add rsp,32

 

    call printArray1
    call printArray2
    
    mov rcx,textLineJump
    sub rsp,32
    call printf
    add rsp,32
    ret

printArray1:
    mov rsi,0;contador y marcador de numero de elemento
    ;mov rdi,98
    
    printArray1Loop:
    
    ;elementoXDelArrayA:;devuelve el elemento
    ;rdx numero del elemento
    ;rcx numero del array

    mov rdx,rsi
    mov rcx,[numeroArray1]

    call elementoXDelArrayA
    
   
    
    ;mov rcx,0
    ;mov cx,[elementoAux1]
    mov rcx,elementoAux1
    sub rsp,32
    call printf
    add rsp,32
    
    inc rsi
    cmp rsi,[tamanoArray1]
    je printAray1Abajo;no tiene que imprimir un espacio en el ultimo elemento
    
    
    
    mov rcx,space
    sub rsp,32
    call printf
    add rsp,32
    
    printAray1Abajo:
    
    
    cmp rsi,[tamanoArray1]
    jne printArray1Loop
    ret


printArray2:
    mov r15,0;contador y marcador de numero de elemento
    printArray2Loop:
    
    ;elementoXDelArrayA:;devuelve el elemento
    ;rdx numero del elemento
    ;rcx numero del array

    mov rdx,r15
    mov rcx,[numeroArray2]

    call elementoXDelArrayA

    mov rcx,[elementoAux1]

    call perteneceAlArray

    cmp byte[check],'S';COMO HACE EL RETURN,
    je printArray2Repeat
    
    mov rcx,elementoAux1
    sub rsp,32
    call printf
    add rsp,32

    mov rcx,space
    sub rsp,32
    call printf
    add rsp,32
    
    printArray2Repeat:

    inc r15
    cmp r15,[tamanoArray2]
    jne printArray2Loop
    ret

perteneceAlArray:
    mov byte[check],'N'
    ;no puede modificar r15
    mov r13,[numeroArray1]
    imul r13,[numeroArray1],42
    add r13,cadena
    mov r14,0;contador
    perteneceAlArrayStart:
    mov rcx,2
    mov rsi,r13
    mov rdi,elementoAux1
    repe cmpsb
    je perteneceAlArraySi
    add r14,1
    add r13,2
    cmp r14,[tamanoArray1]
    je perteneceAlArrayNo
    jmp perteneceAlArrayStart

    perteneceAlArraySi:
    mov byte[check],'S'
    perteneceAlArrayNo:
    ret

validador:
    mov byte[check],'N'
    mov byte[check2],'S'

    call validarChars
    cmp byte[check2],'N'
    je validadorEnd

    call validarOverflow
    cmp byte[check2],'N'
    je validadorEnd

    ;2 validaciones: que cada cadena tenga solo chars validos y que no se hallan ingresado de mas
    mov byte[check],'V'
    validadorEnd:
    ret

validarChars:
    mov r15,0
    mov rax,0
    mov rcx,0
    mov r8,cadena
    validarCharsLoop:
    mov byte[check2],'V'
    mov al,[r8]
    call validarCharIndividual
    cmp byte[check2],'N'
    jne validarCharsAbajo
    inc r15;r15 es errores
    validarCharsAbajo:
    cmp r15,7
    je validarCharsEnd
    inc r8
    inc rcx
    cmp rcx,252
    jne validarCharsLoop
    validarCharsEnd:
    cmp r15,6
    ;que paso aca? originalmente la cantidad de errores permitidos era 0, pero los '0/000' (enter) no son validos, asi que la cantidad de chars
    ;validos tiene que ser 6, ahora, si una cadena es mas larga de lo esperado, la cadena siguiente sobreescribe el enter de la cadena anterior
    ;por lo que checkear que haya exactamente 6 chars invalidos checkea tanto chars validos como overflow
    ;(cada cadena tiene 20 espacios para elementos y un espacio para el enter)
    jne validarCharsEnd2
    mov byte[check2],'V'
    validarCharsEnd2:  
    ret

validarCharIndividual:
    mov rbx,0
    mov rdx,cadenaValida
    validarCharIndividualLoop:
    mov ah,[rdx]
    cmp al,ah
    je validarCharIndividualEnd
    inc rbx
    inc rdx
    cmp rbx,37
    jne validarCharIndividualLoop
    mov byte[check2],'N'
    validarCharIndividualEnd:
    ret

reescribir:;ponele
    mov rsi,cadenaRelleno
    mov rdi,cadena
    mov rcx,252
    rep movsb
    ret

validarOverflow:
    mov byte[check2],'S'
    mov rcx,cadena
    add rcx,43;251 para el 6
    mov rdi,placeholder
    mov rsi,rcx
    mov rcx,1
    repe cmpsb
    ;por lo aclarado anteriormente, falta checkear que la ultima cadena no tenga overflow, se hace reservando un byte de mas despues de los 42
    ;de c/cadena y checkear que sea un espacio
    je validarOverflowEnd
    mov byte[check2],'N'
    validarOverflowEnd:
    ret
    
startMsg:
    mov rcx,textStart
    sub rsp,32
    call printf
    add rsp,32
    ret

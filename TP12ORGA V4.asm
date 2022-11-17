global  main
extern	puts
extern  gets
extern	printf

section     .data
    textLineJump    db  "",10,0
    cadenaValida    db  " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";37
    textErrorB      db  "Elemento Invalido, vuelva a ingresar",10,0
    textErrorNum    db  "Alguna de las entradas es invalida, vuelva a ingresar",10,0
    textStart       db  "En el caso de haber un elemento de 1 char, usar espacio como 2do char",10,0
    textStart2      db  "Errores conocidos: cadena con elementos repetidos, elemento invalido con espacio de 4to char",10,0
    textStart4      db  "Para pasar a la siguiente cadena, ingresar el elemento doble espacio",10,0
    textInput1      db  "Ingrese la primera cadena a analizar: ",10,0
    textInput2      db  "Ingrese la segunda cadena a analizar, para salir ingrese el mismo numero que en la primera: ",10,0
    textSearch      db  "Ingrese un elemento a buscar, para salir ingrese el elemento doble espacio: ",10,0
    textSize        db  "La cadena ingresada tiene %lli elementos",10,0
    textInclucion   db  "La cadena %lli incluye a la cadena %lli",10,0
    textIgualdad    db  "La cadenas %lli y %lli son iguales",10,0
    textSearch2     db  "El elemento [%c%c] se encuentra en la cadena %lli",10,0
    textUnion       db  "La union de las cadenas %lli y %lli es: ",10,0 
    textInvalido    db  "Alguna de las cadenas ingresadas es invalida, vuelvalo a intentar",10,0
    textInputB      db  "Ingrese el elemento %lli de la cadena %lli: ",0 
    cadena          times 252 db  " ";6*(21*2)
    placeholder     db " "
    elementoquit    dw "  "
    space           db " ",0
    cadenaRelleno   times 252 db  " "

section     .bss
    ;cadena1     resw 100
    
    elementoAux1    resw 1;la func elementoXdelArrayA devuelve el resultado aca, tambien es usado por printArray2
    elementoAux2    resw 1;aca va el elemento de input
    elementoAux3    resd 1;usado por el input1B
    tamanoArray1    resq 1
    tamanoArray2    resq 1
    numeroArray1    resq 1
    numeroArray2    resq 1
    coincidencias   resq 1
    check           resb 1
    check2          resb 1
    endCadenacheck  resb 1


    

section     .text
main:
    mov rbp, rsp; for correct debugging
    
    call startMsg

    call input1B
        
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
    mov rbx,[numeroArray2]
    add rbx,-48
    mov [numeroArray2],rbx
    mov rax,[numeroArray1]
    add rax,-48
    mov [numeroArray1],rax
    ;perdon por lo que acabas de presenciar
    
    cmp rax,6
    jge input2error
    cmp rbx,6
    jge input2error
    cmp rax,0
    jl input2error
    cmp rbx,0
    jl input2error
    jmp input2end
    input2error:
    call ErrorNumMsg
    jmp input2

    input2end:
    ret

input3:
    mov rcx,textSearch
    sub rsp,32
    call printf
    add rsp,32

    input3loop:

    call resetInputB
    
    mov rcx,elementoAux3
    sub rsp,32
    call gets
    add rsp,32
    
    mov rcx,2
    mov rsi,elementoAux3
    mov rdi,elementoquit
    repe cmpsb
    je input3end
    
    call validadorB

    cmp byte[check],'N'
    jne input3end

    call ErrorMsg
    jmp input3loop

    input3end:

    mov rcx,2
    mov rsi,elementoAux3
    mov rdi,elementoAux2
    rep movsb
    
    
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
    ;V 1.2 PODRIA SER JL
    ;V 1.2 PUEDE NO FUNCIONAR CON ELEMENTOS REPETIDOS
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

 
    mov r14,[numeroArray1]
    mov r15,[tamanoArray1]
    call printArray1
    mov r14,[numeroArray2]
    mov r15,[tamanoArray2]
    call printArray1
    
    mov rcx,textLineJump
    sub rsp,32
    call printf
    add rsp,32
    ret

printArray1:
    ;r14 numero de array, r15 tamano de array


    mov rsi,0;contador y marcador de numero de elemento
    ;mov rdi,98
    
    printArray1Loop:
    
    ;elementoXDelArrayA:;devuelve el elemento
    ;rdx numero del elemento
    ;rcx numero del array

    mov rdx,rsi
    mov rcx,r14

    call elementoXDelArrayA
    
   
    
    ;mov rcx,0
    ;mov cx,[elementoAux1]
    mov rcx,elementoAux1
    sub rsp,32
    call printf
    add rsp,32
    
    inc rsi
    ;cmp rsi,[tamanoArray1]
    ;je printAray1Abajo;no tiene que imprimir un espacio en el ultimo elemento
    
    
    
    mov rcx,space
    sub rsp,32
    call printf
    add rsp,32
    
    ;printAray1Abajo:
    
    
    cmp rsi,r15
    jne printArray1Loop
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

startMsg:
    mov rcx,textStart
    sub rsp,32
    call printf
    add rsp,32
    mov rcx,textStart2
    sub rsp,32
    call printf
    add rsp,32
    mov rcx,textStart4
    sub rsp,32
    call printf
    add rsp,32
    ret


input1B:
    mov r12,0;cadena
    mov r13,0;elemento
    inicioinput1B:
    call inputB
    cmp byte[endCadenacheck],'E'
    je input1Bendcadena
    inc r13
    cmp r13,20
    jne inicioinput1B

    input1Bendcadena:
    mov r13,0
    inc r12
    cmp r12,6
    jne inicioinput1B
    ret

inputB:
    mov byte[endCadenacheck],'E'
    mov rcx,textInputB
    mov rdx,r13
    mov r8,r12
    sub rsp,32
    call printf
    add rsp,32
    
    call resetInputB
    
    mov rcx,elementoAux3
    sub rsp,32
    call gets
    add rsp,32

    mov rcx,2
    mov rsi,elementoAux3
    mov rdi,elementoquit
    repe cmpsb
    je inputBend
    mov byte[endCadenacheck],'N'

    call validadorB

    cmp byte[check],'N'
    jne inputBend
    
    call ErrorMsg

    jmp inputB
    inputBend:
    
    mov rsi,elementoAux3
    mov rcx,2
    imul rdi,r12,42
    imul r8,r13,2
    add rdi,r8
    add rdi,cadena
    rep movsb
    
    ret

validadorB:
    mov byte[check],'V'
    ;no tocar r12,r13
    mov rsi,elementoAux3;que no se vaya de tamaño
    add rsi,3
    mov rdi,placeholder
    mov rcx,1
    repe cmpsb
    jne validadorBerror

    mov rdx,cadenaValida;primer char valido
    add rdx,1;le sumo uno pq el primer char de la cadena valida es el espacio, y el 1er char no puede ser espacio
    mov al,[elementoAux3]
    call validarCharIndividualB
    cmp byte[check2],'N'
    je validadorBerror

    mov rdx,cadenaValida;segundo char valido o espacio
    mov r14,elementoAux3
    inc r14
    mov al,[r14]
    call validarCharIndividualB
    cmp byte[check2],'N'
    je validadorBerror
    
    jmp validadorBend
    validadorBerror:
    mov byte[check],'N'
    validadorBend:
    ret

validarCharIndividualB:
    mov byte[check2],'S'
    mov rbx,0
    ;mov rdx,cadenaValida
    validarCharIndividualLoopB:
    mov ah,[rdx]
    cmp al,ah
    je validarCharIndividualEndB
    inc rbx
    inc rdx
    cmp rbx,37
    jne validarCharIndividualLoopB
    mov byte[check2],'N'
    validarCharIndividualEndB:
    ret
    
resetInputB:
    mov rcx,4
    mov rdi,elementoAux3
    mov rsi,cadenaRelleno
    rep movsb
    ret

ErrorMsg:
    mov rcx,textErrorB
    sub rsp,32
    call printf
    add rsp,32
    ret
    
ErrorNumMsg:
    mov rcx,textErrorNum
    sub rsp,32
    call printf
    add rsp,32
    ret
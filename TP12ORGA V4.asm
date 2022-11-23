global  main
extern	puts
extern  gets
extern	printf
;V4.1.2 23/11/2022 Bruno Quroga 107788 
section     .data
    textLineJump    db  "",10,0
    cadenaValida    db  " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";37
    textMainMenu    db  "-----Menu principal-----",10,"0- Ingresar la cadena 0",10,"1- Ingresar la cadena 1",10,"2- Ingresar la cadena 2",10,"3- Ingresar la cadena 3",10,"4- Ingresar la cadena 4",10,"5- Ingresar la cadena 5",10,"6- Evaluar la existencia de un elemento",10,"7- Evaluar relaciones de Igualdad e Inclusion entre cadenas",10,"8- Union de cadenas",10,"9- Salir",10,0
    textContinue    db  "Desea continuar? (S/N): ",0
    textErrorB      db  "Elemento Invalido, vuelva a ingresar",10,0
    textErrorNum    db  "Alguna de las entradas es invalida, vuelva a ingresar",10,0
    textErrorMenu   db  "Entrada Invalida, vuelva a ingresar",10,0
    textStart       db  "En el caso de haber un elemento de 1 char, usar espacio como 2do char",10,0
    textInput1      db  "Ingrese la primera cadena: ",0
    textInput2      db  "Ingrese la segunda cadena: ",0
    textSearch      db  "Ingrese un elemento a buscar: ",0
    textSize        db  "La cadena ingresada tiene %lli elementos",10,0;DIOS SABE HACE CUANTO ESTA ESTO ACA
    textInclucion   db  "La cadena %lli incluye a la cadena %lli",10,0
    textIgualdad    db  "La cadenas %lli y %lli son iguales",10,0
    textNoRelacion  db  "No hay relaciones de igualdad o inclusion entre las cadenas %lli y %lli",10,0
    textNoAparicion db  "El elemento [%c%c] no aparece en ninguna cadena",10,0
    textSearch2     db  "El elemento [%c%c] se encuentra en la cadena %lli",10,0
    textUnion       db  "La union de las cadenas %lli y %lli es: ",10,0 
    textInputB      db  "Ingrese el elemento %lli de la cadena %lli: ",0 
    cadena          times 252 db  " ";6*(21*2)
    placeholder     db " "
    space           db " ",0
    cadenaRelleno   times 252 db  " "
    cadenaRelleno2  times 21 dq -1

section     .bss
    ;cadena1     resw 100
    
    elementoAux1    resw 1;la func elementoXdelArrayA devuelve el resultado aca, tambien es usado por printArray
    exp1            resq 1;sin esto printf me agarra el elementoaux2 y 3 si estan escritos
    elementoAux2    resw 1;aca va el elemento de input
    elementoAux3    resd 1;usado por el input1C
    tamanoArray1    resq 1
    tamanoArray2    resq 1
    numeroArray1    resq 1
    numeroArray2    resq 1
    coincidencias   resq 1
    check           resb 1
    check2          resb 1
    inputmainmenu   resq 1
    inputSN         resb 1
    quit            resb 1
    checkinput      resb 1
    arrayMagico     resq 21
    tamanoArrayMagico   resq 1

section     .text
main:
    mov rbp, rsp; for correct debugging
    mov byte[quit],'N'
    call Menu
    ;call PrintCoincidenciasDebug
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
    ;no se usan: rax, rbx, r15
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
    call CalcularTamanos
    call ResetArrayMagico

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
    IDIFLoop1:

    mov rcx,2
    mov rsi,r13
    mov rdi,r14
    repe cmpsb

    jne IDIFabajo
    
    mov rbx,r10
    call PALAM
    cmp byte[check],'Y'
    je IDIFabajo

    call AddArrayMagico
    inc r12
    jmp IDIFendcadena

    IDIFabajo:

    add r13,2
    inc r10

    cmp r10,[tamanoArray1]
    jl IDIFLoop1
    
    IDIFendcadena:
    
    add r14,2
    mov r13,r8
    inc r11
    mov r10,0

    cmp r11,[tamanoArray2]
    jl IDIFLoop1

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
    
    ;mov rcx,2
    ;mov rsi,elementoAux3
    ;mov rdi,elementoquit
    ;repe cmpsb
    ;je input3endREMOVIDOS YA QUE EL ELEMENTOQUIT NO SE USA PARA SALIR Y ES INVALIDO
    
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

    mov rsi,0

    call PrimeroIncluyeSegundo
    call SegundoIncluyePrimero
    call igualdad

    cmp rsi,0
    jne AnalizarAbajo

    mov rcx,textNoRelacion
    mov rdx,[numeroArray1]
    mov r8,[numeroArray2]
    sub rsp,32
    call printf
    add rsp,32

    AnalizarAbajo:
    call printUnion
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

    inc rsi

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

    mov rcx,textInclucion;305 Y 323 ERAN JNE, version 1.1 entrega
    mov rdx,[numeroArray2]
    mov r8,[numeroArray1]
    sub rsp,32
    call printf
    add rsp,32

    inc rsi

    SegundoNoIncluyePrimero:
    ret

igualdad:
    mov rax,[tamanoArray1]
    mov rbx,[tamanoArray2]
    mov rcx,[coincidencias]
    cmp rbx,rax
    jne noigualdad;misma cdad de elementos
    cmp rcx,rax
    jnge noigualdad;
    ;deberia ser jne, pero por como InstanciasDeIgualdadFull primero compara elementos y despues checkea tamaño
    ;dos cadenas vacias tienen 1 coincidencia, asi que se hace este arreglo
    ;no afecta nada mas, ya que es la unica forma que 2 cadenas tengan mas coincidencias que elementos
    mov rcx,textIgualdad 
    mov rdx,[numeroArray1]
    mov r8,[numeroArray2]
    sub rsp,32
    call printf
    add rsp,32

    inc rsi

    noigualdad:
    ret


BuscarElemento:
    mov r15,0
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

    cmp r15,0
    jne BuscarElementoEnd

    mov rcx,textNoAparicion
    mov rdx,[elementoAux2]
    mov r8,elementoAux2
    inc r8
    mov r8,[r8]
    sub rsp,32
    call printf
    add rsp,32

    BuscarElementoEnd:

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

    inc r15

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
    cmp r15,0
    je printArray1End

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
    
    printArray1End:
    
    ret

startMsg:
    mov rcx,textStart
    sub rsp,32
    call printf
    add rsp,32
    ret



input1C:;borrar input1B
    call ResetCadena
    mov r12,rbx;cadena
    mov r13,0;elemento
    inicioinput1C:
    call inputC
    call InputContinue
    cmp byte[inputSN],'N'
    je input1Cend
    inc r13
    cmp r13,20
    jne inicioinput1C

    input1Cend:
    ret



inputC:;borrar inputb
    cmp byte[inputSN],'S'
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

    call validadorB

    cmp byte[check],'N'
    jne inputCend
    
    call ErrorMsg
    jmp inputC

    inputCend:
    
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


ValidarInputSN:
    mov byte[checkinput],'V'
    cmp byte[inputSN],'S'
    je ValidarInputSNEnd
    cmp byte[inputSN],'N'
    je ValidarInputSNEnd
    mov byte[checkinput],'N'

    ValidarInputSNEnd:
    ret

ValidarInputMainMenu:
    mov byte[checkinput],'N'
    mov rbx,[inputmainmenu]
    add rbx,-48
    mov [inputmainmenu],rbx
    cmp rbx,0
    jl ValidarInputMainMenuEnd
    cmp rbx,9
    jg ValidarInputMainMenuEnd
    mov byte[checkinput],'V'
    ValidarInputMainMenuEnd:
    ret

Menu:
    mov rcx,textMainMenu
    sub rsp,32
    call printf
    add rsp,32

    MenuLoop:

    mov rcx,inputmainmenu
    sub rsp,32
    call gets
    add rsp,32

    call ValidarInputMainMenu

    cmp byte[checkinput],'N'
    je MenuError

    call DireccionadorMenu
    cmp byte[quit],'Y'
    je MenuEnd
    jmp Menu

    MenuError:
    call errorMenuMsg
    jmp MenuLoop

    MenuEnd:
    ret

errorMenuMsg:
    mov rcx,textErrorMenu
    sub rsp,32
    call printf
    add rsp,32
    ret

DireccionadorMenu: 
    cmp rbx,6
    jl DMEscribirCadena
    je DMPertenenciaElemento
    cmp rbx,7
    je DMIgualdadInclusion
    cmp rbx,8
    je DMUnion
    jmp DMQuit

    DMEscribirCadena:
    call EscribirCadena
    jmp DMEnd
    DMPertenenciaElemento:
    call PertenenciaElemento
    jmp DMEnd
    DMIgualdadInclusion:
    call IgualdadInclusion
    jmp DMEnd
    DMUnion:
    call Union
    ret
    DMQuit:
    mov byte[quit],'Y'
    DMEnd:
    ret

PertenenciaElemento:
    call input3
    call BuscarElemento
    ret

IgualdadInclusion:
    call input2
    call Analizar2
    ret

Union:
    call input2
    call CalcularTamanos
    call printUnion
    ret

EscribirCadena:
    ;rbx tiene el numero del input que coincide con el numero de la cadena a escribir 200IQ
    call startMsg
    call input1C
    ret

InputContinue:
    mov rcx,textContinue
    sub rsp,32
    call printf
    add rsp,32

    InputContinueLoop:

    mov rcx,inputSN
    sub rsp,32
    call gets
    add rsp,32

    call ValidarInputSN

    cmp byte[checkinput],'N'
    jne InputContinueEnd

    call errorMenuMsg
    jmp InputContinueLoop

    InputContinueEnd:
    ret

Analizar2:
    call InstanciasDeIgualdadFull

    mov rsi,0

    call PrimeroIncluyeSegundo
    call SegundoIncluyePrimero
    call igualdad

    cmp rsi,0
    jne AnalizarAbajo2

    mov rcx,textNoRelacion
    mov rdx,[numeroArray1]
    mov r8,[numeroArray2]
    sub rsp,32
    call printf
    add rsp,32
    AnalizarAbajo2:
    ret

ResetCadena:
    ;rbx numero de cadena
    mov rcx,42
    imul rdi,rbx,42
    push rbx
    add rdi,cadena
    mov rsi,cadenaRelleno
    rep movsb
    pop rbx
    ret


CalcularTamanos:
    mov rbp,[numeroArray1]
    mov rdx,rbp
    call TamanoDeArray
    mov [tamanoArray1],rax
    
    mov rsi,[numeroArray2]
    mov rdx,rsi
    call TamanoDeArray
    mov [tamanoArray2],rax
    ret


PALAM:;Pertenece al array magico
    ;se pueden usar rax, rbx, r15
    ;el numero entra en rbx
    mov byte[check],'N'
    mov rax,arrayMagico
    mov r15,-1
    PALAMLoop:
    cmp rbx,[rax]
    je PALAMerror
    cmp r15,[rax]
    je PALAMend
    add rax,8
    jmp PALAMLoop
    PALAMerror:
    mov byte[check],'Y'
    PALAMend:
    ret

ResetArrayMagico:
    mov qword[tamanoArrayMagico],0
    mov rcx,168
    mov rsi,cadenaRelleno2
    mov rdi,arrayMagico
    rep movsb
    ret

AddArrayMagico:
    ;se pueden usar rax, rbx, r15
    ;el numero entra en rbx
    mov r15,[tamanoArrayMagico]    
    imul rax,r15,8
    add rax,arrayMagico
    mov [rax],rbx
    inc r15
    mov qword[tamanoArrayMagico],r15
    ret

PrintCoincidenciasDebug:
    mov rcx,textSize
    mov rdx,[coincidencias]
    sub rsp,32
    call printf
    add rsp,32
    ret

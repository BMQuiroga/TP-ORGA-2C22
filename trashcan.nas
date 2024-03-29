;trashcan

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

ElementosSonIguales2:;sin probar
    ;rcx y rdx direccs de memoria
    mov rax,0
    mov rsi,rcx
    mov rdi,rdx
    mov rcx,2
    repe cmpsb
    jne ElementosSonIgualesEnd
    mov rax,1
    ElementosSonIgualesEnd:
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
    
InstanciasDeIgualdad:; sin probar
    ;Cantidad de elementos del array A que aparecen en el Array B
    ;rcx y rdx numeros
    mov r15,0; r15 contador
    imul rcx,40
    add rcx,cadena
    mov r14,rcx



    InstanciasDeIgualdadLoop:

    mov rcx,r14
    call ElementoPerteneceAlArray
    
    add r15,rax
    add r14,2

    cmp r10,
    ret


ElementoPerteneceAlArray:;sin probar
    ;rcx direccion del elemento
    ;rdx numero del array
    ;r12 queda el loop
    ;r13 queda el numero de array
    mov r11,rcx ;queda en r11 la direcc del elemento
    imul rdx,40
    add rdx,cadena
    mov r13,rdx

    call TamanoDeArray

    mov rdx,r12
    
    mov rcx,rax
    dec rcx; itero i-1 veces

    mov rax,0
    ElementoPerteneceAlArrayLoop:

    mov r12,rcx
    mov rcx,r11; saco de r11 la direcc del elemento
    
    call ElementosSonIguales2

    cmp rax,1
    je ElementoPerteneceAlArrayEncontrado

    mov rcx,r12
    
    add rdx,2
    loop ElementoPerteneceAlArrayLoop
    ElementoPerteneceAlArrayEnd:
    mov rdx,r13
    ret

validarOverflow:
    mov byte[check2],'S'
    mov rcx,cadena
    mov r9,0
    validarOverflowLoop:
    add rcx,41
    mov r8,[rcx]
    cmp r8,[placeholder]
    jne validarOverflowError
    inc r9
    add rcx,2
    cmp r9,6
    ;(cada cadena tiene 20 espacios para elementos y un espacio para el enter)
    jne validarOverflowLoop
    jmp validarOverflowEnd
    validarOverflowError:
    ;mov byte[check2],'N'
    validarOverflowEnd:
    ret

input1A:
    mov rsi,0
    inicio:   
    mov rdx,rsi
    imul rdx,42
    
    add rdx,cadena
    mov rcx, rdx
    
    mov rdx,rsi
    call inputA
    inc rsi
    cmp rsi,5
    jle inicio
    ret


validarRepeticion:
    mov byte[check2],'S'
    mov r12,0
    validarRepeticionLoop:
    call validarRepeticionCadena
    inc r12
    cmp r12,6
    jne validarRepeticionLoop
    ret

validarRepeticionCadena:
    mov r13,cadena
    imul r13,r12,42
    call validarRepeticionElemento




validarRepeticionElemento:
    ret


validarOverflowMultiple:
    ;explicar como se me escapa ese ultimo byte
    mov r12,41
    mov r13,0
    validarOverflowMultipleLoop:
    call validarOverflow
    add r12,42
    inc r13
    cmp byte[check2],'N'
    je validarOverflowMultipleError
    cmp r13,6;Cantidad de cadenas
    jne validarOverflowMultipleLoop
    validarOverflowMultipleError:
    ret

validador:
    mov byte[check],'N'
    mov byte[check2],'S'

    call validarChars
    cmp byte[check2],'N'
    je validadorEnd

    call validarOverflowMultiple
    cmp byte[check2],'N'
    je validadorEnd

    ;call validarRepeticion
    ;cmp byte[check2],'N'
    ;je validadorEnd

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
    add rcx,r12;251 para el 6
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

main:
    mov rbp, rsp; for correct debugging
    
    call startMsg

    call input1B
    
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

    textCadena      db  "Ingrese la cadena numero %lli: ",10,0

inputA:
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

inputB:
    mov byte[endCadenacheck],'E'
    mov rcx,textInputB
    mov rdx,r13;ELEMENTO
    mov r8,r12;CADENA
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

textSearch      db  "Ingrese un elemento a buscar, para salir ingrese el elemento doble espacio: ",10,0
textStart4      db  "Para pasar a la siguiente cadena, ingresar el elemento doble espacio",10,0
elementoquit    dw "  "



InstanciasDeIgualdadFullb:
    mov qword[coincidencias],3
    mov qword[tamanoArray1],3
    mov qword[tamanoArray2],4
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

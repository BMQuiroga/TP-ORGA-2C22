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
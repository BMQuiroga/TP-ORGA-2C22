global  main
extern	puts
extern  gets
extern	printf

section     .data
    textCadena      db  "Ingrese la cadena numero %lli",10,0
        

section     .bss
    cadena1     resw 20
    cadena2     resw 20
    cadena3     resw 20
    cadena4     resw 20
    cadena5     resw 20
    cadena6     resw 20



section     .text
main:
    mov rbp, rsp; for correct debugging
    mov rdx,1
    inicio:
    mov rcx,textCadena
    sub rsp,32
    call printf
    add rsp,32
    
    mov rcx,cadena1
    call InputText
    inc rdx
   
    cmp rdx,6
    jle inicio
    ret
    
InputText:
    ;parametro 1 rcx: donde guardar el input       
    ;parametro 2 rdx: numero del array
    
    sub rsp,32
    call gets
    add rsp,32
    
    ret
    
analyze: 
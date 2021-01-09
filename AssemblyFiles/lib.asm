global _start 

section .data
message: db "Hello, World!", 0

section .text 

; Função que pega um código de saída e encerra o processo atual
exit:
    ; O código de saída deve estar no acumulador
    mov rdi, rax       ; passa o código de saída no acumulador para o descritor de saída (RDI)
    mov rax, 60        ; número da syscall de saída de uma chamada de sistema 
    syscall 
;***

; Função que aceita um ponteiro para a string e devolve seu tamanho
string_length:
    ; Incialização da função 
    ; O ponteiro deve ter sido previamente alocado no registrador RDI
    push r13            ; salva o valor de r13 na stack
    xor r13,r13         ; zera o valor em r13 para iniciar a contagem
.loop:
    cmp byte[r13 + rdi], 0 ; confirma se não chegou no finalizador nulo
                           ; byte [] explicita que estamos com um ponteiro que aponta para um dado de tamanho de 1 byte 
    je .end                ; caso chegou no caractere nulo, finaliza a contagem (je  = jz => jump se a flag de zero for setada)
    inc r13                ; se não, incrementa o registrador para contar o próximo caractere
    jmp .loop              
.end:
    mov rax, r13           ; passa o tamanho da string pro acumulador
    pop r13                ; resgata o valor inicial de r13
    call exit              ; chama a função de saída -> retorna o tamanho da string 
;***

; Função que aceita um ponteiro de string com terminação nula e exibe-a em stdout
print_string:
    push r13
    push r15
    xor r13,r13
    mov rax, 1
    mov rdi, 1
.loop:
    cmp byte[r13 + r15], 0  
    je .end
    inc r13
    jmp .loop
.end:
    mov rsi, r15
    mov rdx, r13
    pop r15
    pop r13
    syscall
    xor rax, rax
    call exit 
;***

; Função que aceita um caractere diretamente como seu primeiro argumento e exibe-o em stdout
print_char:


;**
;* MAIN
;**
_start:
    mov r15, message 
    call print_string


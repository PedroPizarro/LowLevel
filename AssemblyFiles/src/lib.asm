global _start 

; dados para testes
section .data 
message: db "hello, world", 10, 0

section .text 

; Função que pega um código de saída e encerra o processo atual
exit:
    ; O código de saída deve estar no acumulador
    mov rdi, rax       ; passa o código de saída no acumulador para o descritor de saída (RDI)
    mov rax, 60        ; número da syscall "exit"  
    syscall 
;***

; Função que aceita um ponteiro para a string e devolve seu tamanho
string_length:
    ; O ponteiro previamente alocado em "rdi"
    xor rax, rax
.loop:
    cmp byte[rdi + rax], 0 ; confirma se não chegou no finalizador nulo
                           ; "byte" explicita o ponteiro de um dado de 1 byte.  
    je .end                ; caso chegou no caractere nulo, finaliza a contagem (je  = jz => jump se a flag de zero for setada)
    inc rax                ; se não, incrementa o registrador para contar o próximo caractere
    jmp .loop              
.end:
    ret                    ; retorna com RAX armazenando o tamanho da string
;***

; Função que aceita um ponteiro de string com terminação nula e exibe-a em stdout
print_string: 
    ; O ponteiro previamente alocado em "rdi"
    push rdi               ; salva o endereço da mensagem na pilha
    call string_length
    pop rsi                ; pega o endereço salvo por "rdi" na pilha
    mov rdx, rax           ; o número de bytes que deve ser escrito (tamanho da string)
    mov rax, 1             ; número da syscall "write"
    mov rdi, 1             ; descritor de stdout (terminal)
    syscall
    ret 
;***

; Função que aceita um caractere diretamente como argumento e exibe-o em stdout
print_char:
    push rdi               ; poe o código do caracter na pilha
    mov rsi, rsp           ; passa o endereço do código do caracter para rsi
    call print_string
    pop rdi                ; retorna o código do caracter para rdi (boa prática!) 
    ret
;***

; Exibe o caractere "\n"
print_newline:
    mov rdi, 0xA
    jmp print_char         ; sem chamar com "call" -> não guarda na pilha o endereço da próxima instrução
                           ; menos chance de dar stack overflow 

; Exibe número inteiro de 8 bytes sem sinal, em formato decimal.
print_uint:


;
; MAIN
;
_start:
    mov rax, 0
    call exit 
    


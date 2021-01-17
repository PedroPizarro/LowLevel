global _start 

; dados para testes
;section .data 
;message: db "hello, world", 10, 0
;number: dq 1

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
    pop rsi                ; pega o endereço salvo por "rdi" na pilha e salva em "rsi"
    mov rdx, rax           ; o número de bytes que deve ser escrito (tamanho da string)
    mov rax, 1             ; número da syscall "write"
    mov rdi, 1             ; descritor de stdout (terminal)
    syscall
    ret 
;***

; Função que aceita um caractere diretamente como argumento e exibe-o em stdout
print_char:
    push rdi               ; poe o código do caracter na pilha
    mov rdi, rsp           ; passa o endereço do código do caracter para rdi
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
    mov rax, rdi           ; pega o valor uint de "rdi"
    mov rdi, rsp           ; salva o stack pointer em "rdi"
    push 0                 ; zera 8 células da stack (garante o caracter nulo para sinalizar o fim do número) 
    sub rsp, 16            ; "rsp" ignora 16 células -> stack alignment convention antes de chamadas de funções
                           ; servem para o armazenamento de uint
    ; poderia pular somente 14 bytes que daria certo também
    dec rdi                ; decrementa 1 de rdi -> contém o endereço da pimeira célula do "push 0"
    mov r8, 10             ; salva 10 no registrador para as divisões 

 .loop:
    xor rdx, rdx           ; zera "rdx"
    div r8                 ; quociente da divisão-> "rax"; resto da divisão -> "rdx"
                           ; como o resto sempre é < 10 -> somente o LSByte de "rdx" é usado ("dl")
    or  dl, 0x30           ; passa o resto da divisão para ASCII                
    dec rdi                ; mexendo com a stack: o comando "PUSH" primeiro decrementa o "rsp" e depois carrega, ou seja, 
                           ; deve-se seguir essa convenção também
    mov [rdi], dl          ;
    test rax, rax          ; verifica se é zero -> chegou no MSB?
    jnz .loop              ; enquanto não chegou, loop
   
    call print_string
    
    add rsp, 24            ; retorna "rsp" para o endereço de retorno da chamada de "print_uint"
    ; esse valor depende do quanto que foi pulado:
    ; push 0 -> 8 bytes pulados
    ; sub rsp, 16 -> 16
    ; 8+16 = 24 bytes pulados
    ret    

; Exibe número inteiro de 8 bytes com sinal
print_int:
    test rdi, rdi          ; verifica se é um inteiro com sinal
    ; test além de verificar se o número é igual,
    ; também seta a flag de sinal SF, caso for um inteiro 
    jns print_uint         ; caso SF=0, significa que é um inteiro sem sinal
    push rdi               ; salva o número na pilha 
    mov rdi, '-'           ; move o caracter de menos para o registrador
    call print_char        ; printa o caracter de menos
    pop rdi                ; pega o inteiro da pilha
    neg rdi                ; transforma o inteiro em uint
    jmp print_uint 

;
; MAIN
;
_start:
    mov rax, 0
    call exit 
    


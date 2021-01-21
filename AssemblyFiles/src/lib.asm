global _start 
; Basics about registers conventions:

; Callee-save:
; rbx, rbp, rsp, r12-r15
; Therefore they must be saved by the function called and restored after; all whitin the function
; -> use 'push' command to save

; Caller-saved: 
; all the other registers
; Therefore they must be saved before the function call and restored after the function call; all outside the function
; -> use 'push' command to save before the function call

; So: if you don't save the caller-saved registers before a function call, your info can be lost after that function is executed

section .data                          ; data for test
message:     db "hello, world", 10, 0
word_buffer: times 20 db 0xca          ; 'times' directive repeats the command 'n' times. 'times n command' 

section .text 
; Takes one exit code and finish the current process
exit:
    ; rax: exit code
    mov rdi, rax           ; pass the exit code to 'rdi'
    mov rax, 60            ; syscall "exit" number loaded to 'rax'  
    syscall 
;***

; Função que aceita um ponteiro para a string e devolve seu tamanho
string_length:
    ; rdi: address pointer
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
    ; rdi: address pointer
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

; Lê um caractere de stdin e o devolve em "rax"
read_char:  
    push 0                 ; apesar de somenter ler 1 byte, zera 8 bytes da stack
    ; para poder se assegurar que não vai 'popar' lixo para "rax"
    xor rax, rax           ; número da syscall "read"
    xor rdi, rdi           ; descritor de "stdin" = 0
    mov rsi, rsp           ; pega o endereço do "stack pointer" para armazenar o caracter
    mov rdx, 1             ; somente um byte vai ser lido (um caractere)
    syscall                ; essa syscall por padrão retorna em "rax" o valor de bytes lidos
    ; nesse caso, sempre 1, e como não nos interessa isso, sobrecreve-se "rax" com o valor lido, em 113.
    pop rax                ; pega o caractere lido na "stack"
    ret 

; 
read_word:          
    ; rdi: buffer address
    ; rsi: buffer size
    push r14               ; saves the callee-saved registers that will be used
    push r15                             
    xor r14, r14           ; reset the char count
    mov r15, rsi           ;
    dec r15                 
    ; r14: counts the chars that have been saved in buffer
    ; r15: buffer size minus one ( size(word + NULL char) <= size(buffer) )

    .A:
    push rdi               ; saves caller-saved register thar will be used later  
    call read_char
    pop rdi
    ; the 'cmp' commands verifies the blank spaces
    ; ignores all the blank spaces control chars that comes before the word
    ; as 'read_char' returns the char in 'rax' -> the char will be in 'al'
    cmp al, ' '            ; SPACE char (32)
    je .A 
    cmp al, 10             ; NEW LINE char 
    je .A
    cmp al, 13             ; CARRIAGE RETURN char 
    ; Sometimes used together with other control char to identify the end of a paragraph or line 
    je .A 
    cmp al, 9              ; HORIZONTAL TAB char
    je .A

    test al, al            ; verifies the NULL char
    jz .C

    .B:
    mov byte [rdi + r14], al ; saves the word char in buffer
    inc r14                  ; increments the char count

    push rdi
    call read_char
    pop rdi
    ; if there is a blank space after the first char, the word reading is interrupt 
    ; and the NULL char is inserted at the end of the word
    cmp al, ' '
    je .C
    cmp al, 10
    je .C
    cmp al, 13
    je .C 
    cmp al, 9
    je .C
    test al, al
    jz .C
    cmp r14, r15
    ; if 'rsi' is set equal to before the function call
    ; the function will not be able to verify if the char count => buffer memory
    je .D                  ; verifies if the word size is equal or greater than the buffer space
    ; if size(word) >= size(buffer) -> returns 0. 

    jmp .B

    .C:
    ; alocate the NULL char to the end of the word and returns the buffer address
    mov byte [rdi + r14], 0 
    mov rax, rdi 
   
    mov rdx, r14 
    pop r15
    pop r14
    ret

    .D:
    ; returns 0
    xor rax, rax
    pop r15
    pop r14
    ret

;
; MAIN
;
_start:
    mov rax, 0
    call exit 
    


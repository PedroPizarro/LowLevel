; Faz uma chamda de sistema "write" com os argumentos especificados nas linhas 10 até 13
;***
global _start

section .data
message: db 'hello, world', 10

section .text 
_start:
    mov     rax, 1      ; o n da chamada de sistema "write" armazenado (RAX: é um "acumulador")
    mov     rdi, 1      ; onde escrever; descritor, nesse caso stdout (RDI: é o índice de destino em comandos de maninupalçao de string)
    mov     rsi, message; onde começa a string (RSI: índice de orgiem em comandos de manupulação de strings)
    mov     rdx, 14     ; quantos bytes devem ser escritos (RDX: armazena dados durante oprerações de entrada;saída)  
    syscall             ; chamada de sistema

    mov     rax, 60     ; o n da chamada de sistema "exit"
    xor     rdi, rdi    ; 1 XOR 1 => 0. Ou seja, standard input
    syscall             ; Usa-se XOR por ser gastar menos bytes: XOR usa um byte de memória e MOV usa nove.
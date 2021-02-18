section .data                                                           
codes:                              
    db      '0123456789ABCDEF'             ;caracteres em hexadecimal armazenados

section .text                       
global _start                       
_start:                         
    ; number 1122... in hexadecimal format
    mov rax, 0x1122334455667788            ;valor que desejamos imprimir em hexadecimal
    
    mov rdi, 1                             ;descritor de stdout 
    mov rdx, 1                             ;tamanho da string que vai ser escrita (1 byte)
    mov rcx, 64                            ;registrador usado para loops 
	; Each 4 bits should be output as one hexadecimal digit
	; Use shift and bitwise AND to isolate them
	; the result is the offset in 'codes' array  
    ; Portanto estamos isolando cada valor desejado em hex, dessa forma, o valor
    ; é somado ao endereço de "codes" para se obter o número em hex que se deseja impŕimir
.loop:                            
    push rax                               ;guardamos o valor do acumulador 
    sub rcx, 4                             ;subtrai de 64, 4 => 60
	; cl is a register, smallest part of rcx
	; rax -- eax -- ax -- ah + al
	; rcx -- ecx -- cx -- ch + cl
    sar rax, cl                            ;na primeira iteração é rotacionado 60 bits, e por assim vai.       
    and rax, 0xf 
    ;Exemplo: Primeiro caso com rotação de 60 bits
    ;111111111111111(1) -> primeiro 1 fica no nibble menos significativo
    ;Isso ^ AND 0xF => 0000000000000001, que somado ao endereço de codes, resulta no hexadecimal 1.                
    
    lea rsi, [codes + rax]     ;assim, em rsi tme-se o endereço do byte que vai ser escrito
    mov rax, 1                 ;número da syscall que vai ser realizada "write"

    ; syscall leaves rcx and r11 changed
    push rcx                     
    syscall                     
    pop rcx                     
    
    pop rax                     ;resgata o valor  original que deseja-se imprimir 
	; test can be used for the fastest 'is it a zero?' check
	; see docs for 'test' command
    test rcx, rcx               ;faz um AND entre os operandos, caso forem iguais, a flag de zero é ativada
    jnz .loop                   ;enquanto não for igual (flag zero desativada), loop
    
    mov     rax, 60            ; invoke 'exit' system call
    xor     rdi, rdi           ; código de saída 0 (zera por XOR para consumir menos memória)
    syscall
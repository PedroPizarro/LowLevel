section .data


section .text
global _start

factorial:
	cmp rdi, 1
	jz .end
	imul rdi
	dec rdi
	jmp factorial
	.end:
	ret

parse_uint:
	; Arguments:
	; rdi: string address
	; Returns:
	; rax = number identified by the parse
	; rdx = char count 
	mov r8, 10
	xor rax, rax
	xor rcx, rcx
	.loop:
	movzx r9, byte [rdi + rcx]
	; move with zero-extend
	; move the byte pointed by 'rdi+rcx' to the a 64 bit 'r9' register, zero extending it
	; ex: if the byte lodaded is 0xEE the sign bit is 1, because MSB is one: *1*110 1110
	; however, when moved to r9, the register will hold: 0x00000000000000EE
	cmp r9b, '0'
	jb .end                ; jump if the uint number is bellow the other one (Carry Flag = 1) | (r9b < 0) 
	cmp r9b, '9'
	ja .end                ; jump if the uint number is above the other one (CF = 0 and Zero Flag = 0) | (r9b > 0)
	mul r8                 ; RDX:RAX <- RAX*r8 (will be stored in the register pair depending on the operand size)
	and r9b, 0x0f          ; leaves only the LSB of R9 
	add rax, r9            ;
	inc rcx                ; increments the rcx to indicates that one char have been read
	jmp .loop
	.end:
	mov rdx, rcx
	ret

print_uint:
	; Arguments:
	; rdi: uint number
	; Returns: none
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

print_string:
	; Returns: none
	push rdi               ; salva o endereço da mensagem na pilha
	call string_length
	pop rsi                ; pega o endereço salvo por "rdi" na pilha e salva em "rsi"
	mov rdx, rax           ; o número de bytes que deve ser escrito (tamanho da string)
	mov rax, 1             ; número da syscall "write"
	mov rdi, 1             ; descritor de stdout (terminal)
	syscall
	ret

string_length:
	; Arguments:
	; rdi: string pointer
	; Returns:
	; rax = string size
	xor rax, rax
	.loop:
	cmp byte[rdi + rax], 0 ; confirma se não chegou no finalizador nulo
	; "byte" explicita o ponteiro de um dado de 1 byte.  
	je .end                ; caso chegou no caractere nulo, finaliza a contagem (je  = jz => jump se a flag de zero for setada)
	inc rax                ; se não, incrementa o registrador para contar o próximo caractere
	jmp .loop
	.end:
	ret

print_newline:
	mov rdi, 0xA
	jmp print_char

print_char:
	push rdi
	mov rdi, rsp
	call print_string
	pop rdi
	ret

_start:
; integer input from stdin: read syscall
push 0
xor rax, rax
xor rdi, rdi
mov rsi, rsp    ;where the int will be saved 
mov rdx, 10     ;maximum uint possible
syscall		;return in rax the number of bytes successfully read

; there is the need to parse the ASCII char bytes in stack to one uint value
mov rdi, rsi
call parse_uint

mov rdi, rax
mov rax, 1
call factorial

mov rdi, rax
call print_uint

call print_newline

;exit
mov rax, 60
xor rdi, rdi
syscall


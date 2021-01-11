global _start

section .data

test_string: db "abcdef", 0

section .text

strlen:                       
push r13                ;
xor r13, r13            ;
.loop:                        
cmp byte [rdi+r13], 0     
je .end                   
inc r13                   
jmp .loop
.end:
mov rax, r13
pop r13                 ;
ret                       

_start:
mov rdi, test_string
call strlen
mov rdi, rax

mov rax, 60
syscall 
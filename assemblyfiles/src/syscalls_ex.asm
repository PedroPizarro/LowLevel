%define OPN_RONLY 0
%define PROT_READ 0x1
%define MAP_PRIVATE 0x2

section .data
fname: db 'file.txt', 0

section .text
global _start

print_string:
	push rdi	  ; saving string pointer
	call string_length; calculating the string size
	pop rsi		  ; poping the str ptr to write syscall ptr flag
	mov rdx, rax	  ; string length to rdx 
	mov rax, 1	  ; write descriptor 
	mov rdi, 1	  ; stdout 
	syscall
	ret

string_length:
	xor rax, rax
.loop:
	cmp byte [rdi+rax], 0
	je .end 
	inc rax
	jmp .loop
.end:
	ret

print_char:
	push rdi
	mov rdi, rsp
	call print_string
	pop rdi
	ret	

print_uint:
	mov rax, rdi
	mov rdi, rsp
	push 0
	sub rsp, 16

	dec rdi
	mov r8, 10

	.loop:
	xor rdx, rdx
	div r8

	or  dl, 0x30
	dec rdi
	
	mov [rdi], dl
	test rax, rax
	jnz .loop

	call print_string
	add rsp, 24
	ret

_start:
; open syscal
mov rax, 2 		 
mov rdi, fname		; pointer to file location
mov rsi, OPN_RONLY	; flags about file permission
mov rdx, 0 		; we are not creating a file, so no system permissions required
syscall			; rax holds opened file descriptor 

; mmap syscall		; for maping the file into virtual memory 
mov r8, rax             ; file descriptor
mov rax, 9		
mov rdi, 0		; the OS will choose the address
mov rsi, 4096		; page size 
mov r10, MAP_PRIVATE	; pages will not be shared between processes 
mov rdx, PROT_READ
mov r9, 0               ; 0 offset
syscall			; rax points to mapped location

mov rdi, rax
call print_string
mov rdi, rax
call print_uint
mov rdi, 10 
call print_char

xor rdi, rdi
mov rax, 60
syscall 
; stat syscall 

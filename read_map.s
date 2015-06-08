;;
;; read_map.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; Login   <bonnet_v@epitech.net>
;; 
;; Started on  Tue Feb 25 19:24:38 2014 Bonnet Vivien
;; Last Update Mon Mar  3 16:36:26 2014 Bonnet Vivien
;;

;;; DEBUG
%include "libc/stdio.inc"
section	.rodata
string:	db	"%ld, %p, %ld",0x0A,0

%include "libc/fcntl.inc"
%include "libc/stdlib.inc"
%include "libc/unistd.inc"
%include "globals.inc"
%include "params.inc"
%include "parse.inc"

%define	BUFFER_SIZE	0x3000

section	.rodata

alloc_error:	db	"Malloc fail",0x0A
read_error:	db	"Read fail",0x0A
open_error:	db	"Cannot open your map file",0x0A


section	.text

global	read_map
read_map:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x10

	;; Open file
	mov	rdi,[rdi]
	mov	rsi,O_RDONLY
	call	open

	;; Check open error
	mov	rdi,open_error
	mov	rsi,27
	cmp	rax,-1
	je	error
	mov	[rbp-0x10],rax


	;; Alloc read buffer
	mov	rdi,BUFFER_SIZE
	call	malloc
	mov	[rbp-0x8],rax

	;; Check malloc return value
	cmp	rax,0
	mov	rax,0
	jne	alloc2
	mov	rdi,alloc_error
	mov	rsi,12
	jmp	error


	;; Alloc map
alloc2:	mov	rdi,(MAP_WIDTH * MAP_HEIGHT)
	call	malloc
	mov	[g_map],rax

	;; Check malloc return value
	cmp	rax,NULL
	mov	rax,0
	jne	read_call
	mov	rdi,alloc_error
	mov	rsi,12
	jmp	error



read_call:
	;; Read file in buffer
	mov	rax,0
	mov	rdi,[rbp-0x10]
	mov	rsi,[rbp-0x8]
	mov	rdx,BUFFER_SIZE
	syscall


	;; Check read return value
	cmp	rax,0
	jnle	parse_call
	mov	rdi,read_error
	mov	rsi,10
	jmp	error

parse_call:

	;; Insert '\0' at the end of buffer
	mov	rdi,[rbp-0x8]
	add	rdi,rax
	mov	[rdi],BYTE 0

	;; Call parse function (parse.s)
	mov	rdi,[rbp-0x8]
	call	parse

	;; Close and free
	mov	rdi,[rbp-0x10]
	call	close
	mov	rdi,[rbp-0x8]
	call	free
	mov	rax,0

	jmp	return

error:
	;; Write error
	mov	rdx,rsi
	mov	rsi,rdi
	mov	rdi,2
	mov	rax,1
	syscall

	;; return 1
	mov	rax,1

	;; Epilogue
return:	mov	rsp,rbp
	pop	rbp
	ret

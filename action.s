;;
;; action.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; 
;; Started on  Sat Mar  1 18:44:50 2014 Bonnet Vivien
;; Last Update Mon Mar  3 16:11:34 2014 Bonnet Vivien
;;

%include	"libc/stdlib.inc"
%include	"list.inc"
%include	"globals.inc"


section	.text

global	create_action
create_action:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x30

	;; Save args
	mov	[rbp-0x10],rdi	; Save function arg
	mov	[rbp-0x8],rsi	; Save param arg
	mov	[rbp-0x18],rdx	; Save time arg
	mov	[rbp-0x20],rcx	; Save param2 arg
	mov	[rbp-0x28],r8	; Save return arg
	mov	[rbp-0x30],r9	; Save param3 arg

	;; Alloc action
	mov	rdi,SIZEOF_ACTION
	call	malloc
	cmp	rax,NULL
	je	error

	;; Setter action
	mov	rdi,QWORD [rbp-0x10]
	mov	[rax],rdi	; Moove function ptr
	mov	rdi,QWORD [rbp-0x8]
	mov	[rax+0x8],rdi	; Moove function param
	mov	rdi,QWORD [rbp-0x18]
	mov	[rax+0x10],rdi	; Moove time to wait
	mov	rdi,QWORD [rbp-0x20]
	mov	[rax+0x18],rdi	; Moove function param2
	mov	rdi,QWORD [rbp-0x28]
	mov	[rax+0x20],rdi	; Moove return
	mov	rdi,QWORD [rbp-0x30]
	mov	[rax+0x28],rdi	; Moove function param3

	;; Add in action list
	mov	rdi,[g_action_list]
	mov	rsi,rax
	call	add_in_list
	mov	[g_action_list],rax

	;; Return 0
	mov	rax,0
	jmp	return

error:	mov	rax,1
	
	;; Epilogue
return:	add	rsp,0x30
	pop	rbp
	ret

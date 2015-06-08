;;
;; list.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; Login   <bonnet_v@epitech.net>
;; 
;; Started on  Sat Mar  1 18:59:52 2014 Bonnet Vivien
;; Last Update Mon Mar  3 19:19:18 2014 Bonnet Vivien
;;

%include	"libc/stdlib.inc"
%include	"globals.inc"

;;; DEBUG
%include	"libc/stdio.inc"
section	.rodata
str:	db	"YOLO %p, %p",0x0A,0


section	.text

global	add_in_list
add_in_list:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x10

	;; Save args
	mov	[rbp-0x8],rdi	; Save list
	mov	[rbp-0x10],rsi	; Save data

	;; Alloc elem
	mov	rdi,SIZEOF_LIST
	call	malloc
	cmp	rax,NULL
	je	error

	;; Stock everything in elem
	mov	rdi,[rbp-0x10]	; Get data
	mov	rsi,[rbp-0x8]	; Get list
	mov	[rax],rdi	; Stock data
	mov	[rax+0x8],rsi	; next = NULl
	jmp	return

error:	mov	rax,NULL
	
	;; Epilogue
return:	add	rsp,0x10
	pop	rbp
	ret



global	delete_elem
delete_elem:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x20

	;; Save args
	mov	[rbp-0x8],rdi	; Save list
	mov	[rbp-0x18],rdi	; Save list again
	mov	[rbp-0x10],rsi	; Save elem
	mov	[rbp-0x20],rdx	; Save delete function

	;; if elem and list are different, search elem
	cmp	rdi,rsi
	jne	search

	;; Free first elem
	mov	rdi,[rdi]
	cmp	rdx,NULL
	je	nodel
	call	rdx		; Use delete function
nodel:	mov	rdi,[rbp-0x8]
	mov	rsi,[rdi+0x8]
	mov	[rbp-0x8],rsi
	mov	rdi,[rbp-0x10]
	call	free
	mov	rax,[rbp-0x8]
	jmp	end

search:	mov	rdi,[rbp-0x8]
	mov	rsi,[rdi+0x8]
	mov	[rbp-0x8],rsi

while:	cmp	rsi,[rbp-0x10]
	jne	search

	;; Change prev ptr next
	mov	rdx,[rsi+0x8]
	mov	[rdi+0x8],rdx

	;; Free elem
	mov	rdi,[rbp-0x10]
	mov	rdi,[rdi]
	mov	rdx,[rbp-0x20]
	call	rdx		; Use delete function
	mov	rdi,[rbp-0x10]
	call	free

	;; Return list
	mov	rax,[rbp-0x18]

	;; Epilogue
end:	add	rsp,0x20
	pop	rbp
	ret



global	destroy_list
destroy_list:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x8

	;; Free loop
	jmp	while2
	mov	[rbp-0x8],rdi
do2:	mov	rdi,[rbp-0x8]
	mov	rsi,[rdi+0x8]
	mov	[rbp-0x8],rsi
	call	free
while2:	cmp	QWORD [rbp-0x8],NULL
	jne	do2

	;; Epilogue
	add	rsp,0x8
	pop	rbp
	ret

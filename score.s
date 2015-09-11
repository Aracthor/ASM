;;
;; score.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; 
;; Started on  Mon Mar  3 17:59:07 2014 Bonnet Vivien
;; Last Update Fri Sep 11 20:19:33 2015 Aracthor
;;

%include	"CSFML/Graphics.inc"
%include	"CSFML/Overlay.inc"
%include	"libc/stdio.inc"
%include	"libc/stdlib.inc"
%include	"globals.inc"
%include	"list.inc"
%include	"params.inc"


section	.rodata
str:	db	"%ld",0


section	.bss
buffer:	resb	7


section	.text

global	add_score
add_score:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x30

	;; Save args
	mov	[rbp-0x18],rdi	; Save score
	mov	[rbp-0x20],rsi	; Save x
	mov	[rbp-0x28],rdx	; Save y

	;; Add to total score
	add	[g_score],rdi

	;; Alloc
	mov	rdi,SIZEOF_TEXT
	call	malloc
	cmp	rax,NULL
	je	error

	;; Set timer
	mov	[rbp-0x8],rax
	mov	QWORD [rax + 0x8],TEXT_TIMER


	;; Create sfText
	call	sfText_create
	cmp	rax,NULL
	je	error
	mov	[rbp-0x10],rax

	;; Set font
	mov	rdi,rax
	mov	rsi,[g_font]
	mov	rdx,NULL
	call	sfText_setFont

	;; Set message
	mov	rdi,buffer
	mov	rsi,str
	mov	rdx,[rbp-0x18]
	call	sprintf
	mov	rdi,[rbp-0x10]
	mov	rsi,buffer
	call	sfText_setString

	;; Set character features
	mov	rdi,[rbp-0x10]
	mov	rsi,CHAR_SIZE
	call	sfText_setCharacterSize
	mov	rdi,[rbp-0x10]
	mov	rsi,CHAR_COLOR
	call	sfText_setColor

	;; Set position
	mov	rdi,[rbp-0x10]
	mov	rsi,[rbp-0x20]
	mov	rdx,[rbp-0x28]
	call	text_set_position

	;; Add in list
	mov	rdi,[rbp-0x8]
	mov	rsi,[rbp-0x10]
	mov	[rdi],rsi
	mov	rsi,rdi
	mov	rdi,[g_text_list]
	call	add_in_list
	mov	[g_text_list],rax

	;; Return 0
	mov	rax,[rbp-0x10]
	jmp	return

	;; Epilogue
error:	mov	rax,NULL
return:	add	rsp,0x30
	pop	rbp
	ret

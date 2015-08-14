;;
;; image.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; 
;; Started on  Sat Mar  1 10:19:42 2014 Bonnet Vivien
;; Last Update Sat Mar  1 12:01:47 2014 Bonnet Vivien
;;

%include	"CSFML/Graphics.inc"

;;; DEBUG
%include	"libc/stdio.inc"
section	.rodata
str:	db	"0x%X,0x%X",0x0A,0


section	.text

global	create_opposite_image
create_opposite_image:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x20

	mov	[rbp-0x20],rdi	; Save Image
	call	sfImage_getSize


	;; DEBUG
	mov	rdi,rax
	mov	rsi,rsi		; USELESS
	call	sfImage_create
	mov	[rbp-0x18],rax

	mov	rax,[rbp-0x18]
	;; Epilogue
	add	rsp,0x20
	pop	rbp
	ret

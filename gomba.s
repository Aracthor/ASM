;;
;; gomba.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; 
;; Started on  Mon Mar  3 08:58:28 2014 Bonnet Vivien
;; Last Update Fri Sep 11 20:18:53 2015 Aracthor
;;

%include	"CSFML/Graphics.inc"
%include	"CSFML/Overlay.inc"
%include	"libc/stdlib.inc"
%include	"globals.inc"
%include	"list.inc"
%include	"params.inc"


section	.text

global	create_gomba
create_gomba:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x20

	;; Save args
	mov	[rbp-0x10],rdi	; Save x
	mov	[rbp-0x18],rsi	; Save y

	;; Alloc action
	mov	rdi,SIZEOF_GOMBA
	call	malloc
	cmp	rax,NULL
	je	error
	mov	[rbp-0x8],rax

	;; Create sprite
	call	sfSprite_create
	mov	rdi,[rbp-0x8]
	mov	[rdi + GOMBA_SPRITE_POS],rax
	mov	rdi,rax
	mov	rsi,[rbp-0x10]
	mov	rdx,[rbp-0x18]
	call	sprite_moove

	;; Set data
	mov	rdi,[rbp-0x8]
	mov	rax,[g_gomba_textures + GOMBA_MOTION1_POS]
	mov	[rdi + GOMBA_TEXTURE1_POS],rax	; Set texture 1
	mov	rax,[g_gomba_textures + GOMBA_MOTION2_POS]
	mov	[rdi + GOMBA_TEXTURE2_POS],rax	; Set texture 2
	mov	rax,[g_gomba_textures + GOMBA_TEXTURE_DYING_POS]
	mov	[rdi + GOMBA_DYING_POS],rax	; Set texture dying
	mov	QWORD [rdi + GOMBA_MOOVEMENT_X_POS],-GOMBA_SPEED	; Set x moovement
	mov	QWORD [rdi + GOMBA_MOOVEMENT_Y_POS],0			; Set y moovement
	mov	QWORD [rdi + GOMBA_COUNTER_POS],0			; Set counter

	;; Set sprite features
	mov	rax,[rbp-0x8]
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	mov	rsi,[rax + GOMBA_TEXTURE1_POS]
	mov	rdx,NULL
	call	sfSprite_setTexture
	mov	rax,[rbp-0x8]
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	mov	rsi,2
	mov	rdx,2
	call	sprite_set_scale
	mov	rax,[rbp-0x8]
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	mov	rsi,0
	mov	rdx,16
	call	sprite_set_origin


	;; Add in ennemy list
	mov	rsi,[rbp-0x8]
	mov	rdi,[g_entity_list]
	call	add_in_list
	mov	[g_entity_list],rax

	;; Return 0
	mov	rax,0
	jmp	return

error:	mov	rax,1

	;; Epilogue
return:	add	rsp,0x20
	pop	rbp
	ret

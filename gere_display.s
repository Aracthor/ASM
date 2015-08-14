;;
;; gere_display.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; 
;; Started on  Tue Feb 25 12:30:37 2014 Bonnet Vivien
;; Last Update Mon Mar  3 18:49:06 2014 Bonnet Vivien
;;

%include	"CSFML/Graphics.inc"
%include	"CSFML/OpenGL.inc"
%include	"CSFML/Overlay.inc"
%include	"CSFML/Window.inc"
%include	"globals.inc"
%include	"params.inc"

;;; DEBUG
%include	"libc/stdio.inc"
section	.rodata
str:	db	"YOLO %p",0x0A,0


section	.text

global	gere_display
gere_display:
	;;  prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x10

	;; Clear
	mov	rdi,[g_window]
	mov	rsi,BACKGROUND_COLOR
	call	sfRenderWindow_clear

	;; Disable color mode
	mov	rdi,GL_COLOR_ARRAY
	call	glDisable

	;; Draw background
	mov	rdi,[g_window]
	mov	rsi,[g_vertex_array]
	mov	rdx,[g_map_image]
	call	draw_vertex_array

	;; Draw player
	mov	rdi,[g_window]
	mov	rsi,[g_player_sprite]
	mov	rdx,NULL
	call	sfRenderWindow_drawSprite

	;; Draw ennemies
	mov	rdi,[g_entity_list]
	jmp	whilee

doe:	mov	[rbp-0x8],rdi
	mov	rdi,[rdi]
	mov	rsi,[rdi + GOMBA_SPRITE_POS]
	mov	rdi,[g_window]
	mov	rdx,NULL
	
	call	sfRenderWindow_drawSprite
	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi+0x8]
whilee:	cmp	rdi,NULL
	jne	doe

	;; Draw scores
	mov	rdi,[g_text_list]
	jmp	whilet

dot:	mov	[rbp-0x8],rdi
	mov	rdi,[rdi]
	mov	rsi,[rdi]
	mov	rdi,[g_window]
	mov	rdx,NULL
	call	sfRenderWindow_drawText

	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi+0x8]
whilet:	cmp	rdi,NULL
	jne	dot

	;; Update camera
	mov	rdi,[g_window]
	mov	rsi,[g_camera]
	call	sfRenderWindow_setView

	;; Display
	mov	rdi,[g_window]
	call	sfRenderWindow_display

	;; Return 0
return:	mov	rax,0
	add	rsp,0x10
	pop	rbp
	ret

;;
;; init.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; 
;; Started on  Tue Feb 25 12:12:15 2014 Bonnet Vivien
;; Last Update Tue Mar  4 09:00:43 2014 Bonnet Vivien
;;

%include	"CSFML/Audio.inc"
%include	"CSFML/Graphics.inc"
%include	"CSFML/OpenGL.inc"
%include	"CSFML/Overlay.inc"
%include	"CSFML/Window.inc"
%include	"globals.inc"
%include	"images.inc"
%include	"params.inc"

;;; DEBUG
%include	"libc/stdio.inc"
section	.rodata
str:	db	"YOLO",0x0A,0

section	.rodata

window_name:	db	WINDOW_NAME,0
music_path:	db	"musics/overworld.wav",0
font_path:	db	"font/arial.ttf",0
map_image_path:	db	"textures/blocks.png",0

player_texture_motionless_path:	db	"textures/player/motionless.png",0
player_texture_motion1_path:	db	"textures/player/motion1.png",0
player_texture_motion2_path:	db	"textures/player/motion2.png",0
player_texture_motion3_path:	db	"textures/player/motion3.png",0
player_texture_flying_path:	db	"textures/player/flying.png",0
player_texture_dying_path:	db	"textures/player/dying.png",0

gomba_texture_motion1_path:	db	"textures/gomba/motion1.png",0
gomba_texture_motion2_path:	db	"textures/gomba/motion2.png",0
gomba_texture_dying_path:	db	"textures/gomba/dying.png",0

die_sound_path:		db	"sounds/die.wav",0
jump_sound_path:	db	"sounds/jump.wav",0
rebound_sound_path:	db	"sounds/rebound.wav",0
victory_sound_path:	db	"sounds/victory.wav",0

font_error:	db	"Font loading fail.",0x0A
window_error:	db	"Window creation fail.",0x0A
music_error:	db	"Music loading fail.",0x0A
sound_error:	db	"Sound loading fail.",0x0A
texture_error:	db	"Texture loading fail.",0x0A
sprite_error:	db	"Sprite creation fail.",0x0A
view_error:	db	"View creation fail.",0x0A


section .text

;;; Write font error
font_problem:
	mov	rax,1
	mov	rdi,2
	mov	rsi,font_error
	mov	rdx,19
	syscall
	jmp	error

;;; Write window error
window_problem:
	mov	rax,1
	mov	rdi,2
	mov	rsi,window_error
	mov	rdx,22
	syscall
	jmp	error

;;; Write music error
music_problem:
	mov	rax,1
	mov	rdi,2
	mov	rsi,music_error
	mov	rdx,20
	syscall
	jmp	error

;;; Write sound error
sound_problem:
	mov	rax,1
	mov	rdi,2
	mov	rsi,sound_error
	mov	rdx,20
	syscall
	jmp	error

;;; Write texture error
texture_problem:
	mov	rax,1
	mov	rdi,2
	mov	rsi,texture_error
	mov	rdx,22
	syscall
	jmp	error

;;; Write sprite error
sprite_problem:
	mov	rax,1
	mov	rdi,2
	mov	rsi,sprite_error
	mov	rdx,22
	syscall
	jmp	error

;;; Write view error
view_problem:
	mov	rax,1
	mov	rdi,2
	mov	rsi,view_error
	mov	rdx,20
	syscall
	jmp	error

global	init
init:
	;;  prologue
	push	rbp
	mov	rbp,rsp


	;; Font loading
	mov	rdi,font_path
	mov	rsi,NULL
	call	sfFont_createFromFile
	mov	[g_font],rax
	cmp	rax,NULL	; Jump to font_problem if NULL returned.
	je	font_problem

	;; Map texture loading
	mov	rdi,map_image_path
	mov	rsi,NULL
	call	sfTexture_createFromFile
	mov	[g_map_image],rax
	cmp	rax,NULL	; Jump to texture_problem if NULL returned.
	je	texture_problem

	;; Player motionless texture loading
	mov	rdi,player_texture_motionless_path
	mov	rsi,NULL
	call	sfTexture_createFromFile
	mov	[g_player_textures + MOTIONLESS_POS],rax
	cmp	rax,NULL	; Jump to texture_problem if NULL returned.
	je	texture_problem

	;; Player motion1 texture loading
	mov	rdi,player_texture_motion1_path
	mov	rsi,NULL
	call	sfTexture_createFromFile
	mov	[g_player_textures + MOTION1_POS],rax
	cmp	rax,NULL	; Jump to texture_problem if NULL returned.
	je	texture_problem

	;; Player motion2 texture loading
	mov	rdi,player_texture_motion2_path
	mov	rsi,NULL
	call	sfTexture_createFromFile
	mov	[g_player_textures + MOTION2_POS],rax
	cmp	rax,NULL	; Jump to texture_problem if NULL returned.
	je	texture_problem

	;; Player motion3 texture loading
	mov	rdi,player_texture_motion3_path
	mov	rsi,NULL
	call	sfTexture_createFromFile
	mov	[g_player_textures + MOTION3_POS],rax
	cmp	rax,NULL	; Jump to texture_problem if NULL returned.
	je	texture_problem

	;; Player flying texture loading
	mov	rdi,player_texture_flying_path
	mov	rsi,NULL
	call	sfTexture_createFromFile
	mov	[g_player_textures + FLYING_POS],rax
	cmp	rax,NULL	; Jump to texture_problem if NULL returned.
	je	texture_problem

	;; Player dying texture loading
	mov	rdi,player_texture_dying_path
	mov	rsi,NULL
	call	sfTexture_createFromFile
	mov	[g_player_textures + DYING_POS],rax
	cmp	rax,NULL	; Jump to texture_problem if NULL returned.
	je	texture_problem


	;; Player sprite
	call	sfSprite_create
	mov	[g_player_sprite],rax
	cmp	rax,NULL	; Jump to sprite_problem if NULL returned.
	je	sprite_problem

	;; Sprite features
	mov	rdi,[g_player_sprite]
	mov	rsi,[g_player_textures + MOTIONLESS_POS]
	call	sfSprite_setTexture
	mov	rdi,[g_player_sprite]
	mov	rsi,2
	mov	rdx,2
	call	sprite_set_scale
	mov	rdi,[g_player_sprite]
	mov	rsi,PLAYER_BEGIN_POS_X
	mov	rdx,PLAYER_BEGIN_POS_Y
	call	sprite_set_pos
	mov	rdi,[g_player_sprite]
	mov	rsi,0
	mov	rdx,16
	call	sprite_set_origin

	;; Player features
	mov	BYTE [g_player_status],PLAYER_GROUNDED
	mov	BYTE [g_player_walk_counter],0
	mov	QWORD [g_player_jump_counter],1
	mov	WORD [g_player_moove_x],0
	mov	WORD [g_player_moove_y],0


	;; Gomba motion1 texture loading
	mov	rdi,gomba_texture_motion1_path
	mov	rsi,NULL
	call	sfTexture_createFromFile
	mov	[g_gomba_textures + GOMBA_MOTION1_POS],rax
	cmp	rax,NULL	; Jump to texture_problem if NULL returned.
	je	texture_problem

	;; Gomba motion2 texture loading
	mov	rdi,gomba_texture_motion2_path
	mov	rsi,NULL
	call	sfTexture_createFromFile
	mov	[g_gomba_textures + GOMBA_MOTION2_POS],rax
	cmp	rax,NULL	; Jump to texture_problem if NULL returned.
	je	texture_problem

	;; Gomba dying texture loading
	mov	rdi,gomba_texture_dying_path
	mov	rsi,NULL
	call	sfTexture_createFromFile
	mov	[g_gomba_textures + GOMBA_TEXTURE_DYING_POS],rax
	cmp	rax,NULL	; Jump to texture_problem if NULL returned.
	je	texture_problem


	;; View creation
	call	sfView_create
	mov	[g_camera],rax

	;; Jump to view_problem if NULL returned.
	cmp	rax,NULL
	je	view_problem

	;; View data
	mov	WORD [g_camera_pos],0


	;; Window creation
	mov	rdi,WINDOW_HEIGHT * 0x100000000 ; VideoMode.height
	add	rdi,WINDOW_WIDTH		; VideoMode.width
	mov	rsi,WINDOW_BPP			; VideoMode.bpp
	mov	rdx,window_name			; Title
	mov	rcx,0b00000111			; Style (sfTitlebar | sfResize | sfClose)
	mov	r8,NULL				; Settings
	call	sfRenderWindow_create
	mov	[g_window],rax

	;; Jump to window_problem if NULL returned.
	cmp	rax,NULL
	je	window_problem

	;; Framerate limit setter
	mov	rdi,rax
	mov	rsi,WINDOW_FRAMERATE
	call	sfRenderWindow_setFramerateLimit

	;; Assign view
	mov	rdi,[g_window]
	mov	rsi,[g_camera]
	call	sfRenderWindow_setView


	;; Music loading
	mov	rdi,music_path
	call	sfMusic_createFromFile
	mov	[g_music],rax

	;; Jump to music_problem if NULL returned.
	cmp	rax,NULL
	je	music_problem

	;; Music play in loop
	mov	rdi,[g_music]
	mov	rsi,1
	call	sfMusic_setLoop
	mov	rdi,[g_music]
	call	sfMusic_play


	;; Die sound loading
	mov	rdi,die_sound_path
	call	sfSoundBuffer_createFromFile
	cmp	rax,NULL
	je	sound_problem
	mov	[g_sounds + SOUND_DIE_POS],rax

	;; Jump sound loading
	mov	rdi,jump_sound_path
	call	sfSoundBuffer_createFromFile
	cmp	rax,NULL
	je	sound_problem
	mov	[g_sounds + SOUND_JUMP_POS],rax

	;; Rebound sound loading
	mov	rdi,rebound_sound_path
	call	sfSoundBuffer_createFromFile
	cmp	rax,NULL
	je	sound_problem
	mov	[g_sounds + SOUND_REBOUND_POS],rax

	;; Victory sound loading
	mov	rdi,victory_sound_path
	call	sfSoundBuffer_createFromFile
	cmp	rax,NULL
	je	sound_problem
	mov	[g_sounds + SOUND_VICTORY_POS],rax


	;; Sound to play creation
	call	sfSound_create
	cmp	rax,NULL
	je	sound_problem
	mov	[g_actual_sound],rax


	;; OpenGL init
	mov	rdi,GL_TEXTURE_2D
	call	glEnable


	;; Init lists
	mov	QWORD [g_action_list],NULL
	mov	QWORD [g_entity_list],NULL
	mov	QWORD [g_text_list],NULL


	;; Init score
	mov	QWORD [g_score],0


	;; Return 1 if failed, 0 if ok.
cool:	mov	rax,0
	jmp	return
error:	mov	rax,1
	
	;; epilogue
return:	pop	rbp
	ret

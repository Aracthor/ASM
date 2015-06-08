;;
;; player.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; Login   <bonnet_v@epitech.net>
;; 
;; Started on  Thu Feb 27 17:58:59 2014 Bonnet Vivien
;; Last Update Mon Mar  3 17:29:02 2014 Bonnet Vivien
;;

%include	"CSFML/Audio.inc"
%include	"CSFML/Graphics.inc"
%include	"action.inc"
%include	"game.inc"
%include	"globals.inc"
%include	"params.inc"

;;; DEBUG
%include	"libc/stdio.inc"
section	.rodata
str:	db	"YOLO",0x0A,0


section	.rodata

end_message:	db	"NOOB !",0x0A,0


section	.text

;;; JUMP !
global	player_jump
player_jump:
	;; Prologue
	push	rbp
	mov	rbp,rsp

	;; Check if player is on ground
	mov	al,BYTE [g_player_status]
	and	al,PLAYER_FLYING
	cmp	al,0
	jne	nojump

	;; Now player is flying
	mov	QWORD [g_player_moove_y],rdi

	;; If player isn't dead, change his sprite
	mov	al,BYTE [g_player_status]
	and	al,PLAYER_DYING
	cmp	al,0
	jne	end
	mov	rdi,[g_player_sprite]
	mov	rsi,[g_player_textures + FLYING_POS]
	call	sfSprite_setTexture

	;; Play jump sound
sound:	mov	rdi,[g_actual_sound]
	mov	rsi,[g_sounds + SOUND_JUMP_POS]
	call	sfSound_setBuffer
	mov	rdi,[g_actual_sound]
	call	sfSound_play
	
end:	xor	BYTE [g_player_status],PLAYER_FLYING
	
	;; Epilogue
nojump:	pop	rbp
	ret



set_texture:
	mov	rsi,rdi
	mov	rdi,[g_player_sprite]
	mov	rdx,0
	call	sfSprite_setTexture
	jmp	try_to_change

;;; WALK !
global	player_change_sprite
player_change_sprite:
	;; Prologue
	push	rbp
	mov	rbp,rsp

	cmp	BYTE [g_player_walk_counter],-1
	mov	rdi,[g_player_textures + MOTION1_POS]
	je	set_texture

try_to_change:
	inc	BYTE [g_player_walk_counter]
	cmp	BYTE [g_player_walk_counter],(WALK_FREQUENCY)
	jne	nochange

	;; Change texture to next
	mov	BYTE [g_player_walk_counter],0
	mov	rdi,[g_player_sprite]
	call	sfSprite_getTexture
	cmp	rax,[g_player_textures + MOTION1_POS]
	mov	rdi,[g_player_textures + MOTION2_POS]
	je	set_texture
	cmp	rax,[g_player_textures + MOTION2_POS]
	mov	rdi,[g_player_textures + MOTION3_POS]
	je	set_texture
	cmp	rax,[g_player_textures + MOTION3_POS]
	mov	rdi,[g_player_textures + MOTION1_POS]
	je	set_texture
	jmp	nochange
	
	;; Epilogue
nochange:
	pop	rbp
	ret

;;; STOP !
global	player_stop
player_stop:
	;; Prologue
	push	rbp
	mov	rbp,rsp

	;; Stop moove
	mov	QWORD [g_player_moove_x],0

	;; If player is not mobile...
	mov	al,BYTE [g_player_status]
	and	al,PLAYER_FLYING
	cmp	al,0
	jne	stop_stop

	;; Reset sprite texture.
	mov	rdi,[g_player_sprite]
	mov	rsi,[g_player_textures + MOTIONLESS_POS]
	mov	rdx,0
	call	sfSprite_setTexture
	mov	BYTE [g_player_walk_counter],-1

stop_stop:
	;; Prologue
	pop	rbp
	ret


;;; DIE !
global	player_die
player_die:
	;; Prologue
	push	rbp
	mov	rbp,rsp

	mov	al,BYTE [g_player_status]
	and	al,PLAYER_DYING
	cmp	al,0
	jne	already_dead

	;; Now he is dying
	mov	BYTE [g_player_status],PLAYER_DYING
	mov	rdi,[g_player_sprite]
	mov	rsi,[g_player_textures + DYING_POS]
	mov	rdx,NULL
	call	sfSprite_setTexture

	;; Stop horizontal moovement
	mov	QWORD [g_player_moove_x],0

	;; Create jump action
	mov	rdi,player_jump
	mov	rsi,-JUMP_POWER
	mov	rdx,DIE_JUMP_WAIT
	mov	r8,NULL
	mov	r9,NULL
	call	create_action

	;; Create end action
	mov	rdi,game_end
	mov	rsi,end_message
	mov	rdx,DIE_CLOSE_WAIT
	mov	r8,NULL
	mov	r9,NULL
	call	create_action

	;; Stop music
	mov	rdi,[g_music]
	call	sfMusic_stop

	;; Play dying sound
	mov	rdi,[g_actual_sound]
	mov	rsi,[g_sounds + SOUND_DIE_POS]
	call	sfSound_setBuffer
	mov	rdi,[g_actual_sound]
	call	sfSound_play

already_dead:
	;; Epilogue
	pop	rbp
	ret

;;
;; gere_data.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; Login   <bonnet_v@epitech.net>
;; 
;; Started on  Tue Feb 25 12:30:37 2014 Bonnet Vivien
;; Last Update Tue Mar  4 09:23:49 2014 Bonnet Vivien
;;

%include	"CSFML/Audio.inc"
%include	"CSFML/Graphics.inc"
%include	"CSFML/Overlay.inc"
%include	"libc/stdlib.inc"
%include	"action.inc"
%include	"entity.inc"
%include	"game.inc"
%include	"globals.inc"
%include	"list.inc"
%include	"params.inc"
%include	"player.inc"
%include	"score.inc"

;;; DEBUG
%include	"libc/stdio.inc"
section	.rodata
str:	db	"YOLO 0x%X, 0x%X",0x0A,0


section	.rodata

victory_message:	db	"Okay, not noob...",0x0A,0


section	.text

player_is_flying:
	add	QWORD [g_player_moove_y],GRAVITY
	jmp	player_moove

global	gere_data
gere_data:
	;;  prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x20

	;; Player moovement
	mov	rax,[g_player_status]
	and	rax,PLAYER_FLYING
	cmp	rax,0
	jne	player_is_flying

	;; If player is dead, do nothing
	mov	al,BYTE [g_player_status]
	and	al,PLAYER_DYING
	cmp	al,0
	jne	gere_actions

	;; Try to see if entity have a ground under itself
	mov	rdi,[g_player_sprite]
	mov	rsi,0
	mov	rdx,1
	call	sprite_moove
	mov	rdi,[g_player_sprite]
	call	entity_is_in_wall
	cmp	rax,0
	jne	demove

	;; Now player is falling
	xor	BYTE [g_player_status],PLAYER_FLYING
	mov	QWORD [g_player_moove_y],0
	mov	rdi,[g_player_sprite]
	mov	rsi,[g_player_textures + FLYING_POS]
	call	sfSprite_setTexture

demove:
	mov	rdi,[g_player_sprite]
	mov	rsi,0
	mov	rdx,-1
	call	sprite_moove

player_moove:
	;; Moove x
	mov	rdi,[g_player_sprite]
	mov	rsi,[g_player_moove_x]
	mov	rdx,0
	call	entity_moove

	;; Moove y
	mov	rdi,[g_player_sprite]
	mov	rsi,0
	mov	rdx,[g_player_moove_y]
	call	entity_moove

	;; If is grounded, change sprite
	mov	rax,[g_player_status]
	and	rax,PLAYER_FLYING
	cmp	rax,0
	jne	end_moove
	cmp	QWORD [g_player_moove_x],0
	je	end_moove
	call	player_change_sprite

end_moove:
	;; Moove camera if player is in border
	mov	rdi,[g_player_sprite]
	call	sprite_getpos_x
	sub	ax,[g_camera_pos]
	cmp	rax,((WINDOW_WIDTH / 2) + LIMIT_CAMERA)
	jg	right
	cmp	rax,((WINDOW_WIDTH / 2) - LIMIT_CAMERA)
	jnl	checks
	cmp	WORD [g_camera_pos],0
	jle	checks

	;; Moove camera to left
	sub	WORD [g_camera_pos],PLAYER_SPEED
	mov	rdi,[g_camera]
	mov	rsi,-PLAYER_SPEED
	mov	rdx,0
	call	view_move
	jmp	checks

	;; Moove camera to right
right:	cmp	WORD [g_camera_pos],((MAP_WIDTH * CASE_SIZE) - WINDOW_WIDTH)
	jnl	checks
	add	WORD [g_camera_pos],PLAYER_SPEED
	mov	rdi,[g_camera]
	mov	rsi,PLAYER_SPEED
	mov	rdx,0
	call	view_move

	;; Die if player is too low
checks:	mov	rdi,[g_player_sprite]
	call	sprite_getpos_y
	cmp	rax,DIE_POS_Y
	jl	gere_actions
	call	player_die

;;; Gere action list
gere_actions:
	mov	rdi,[g_action_list]
	mov	[rbp-0x8],rdi
	jmp	whilea

doa:	mov	rdi,[rbp-0x8]
	mov	rax,[rdi]
	dec	QWORD [rax+0x10]
	cmp	QWORD [rax+0x10],0
	jg	nexta

	;; call function if timer is out
	mov	rdi,[rax+0x8]
	mov	rsi,[rax+0x18]
	mov	rdx,[rax+0x28]
	mov	rcx,NULL
	call	[rax]		; Call
	mov	rsi,[rbp-0x8]
	mov	rsi,[rsi]	; Set return value
	cmp	QWORD [rsi+0x20],NULL
	je	next

	
	mov	rsi,[rsi+0x20]
	mov	[rsi],rax

next:	mov	rsi,[rbp-0x8]
	mov	rdi,[rsi+0x8]
	mov	[rbp-0x8],rdi

	;; Del elem
	mov	rdi,[g_action_list]
	mov	rdx,free
	call	delete_elem
	mov	[g_action_list],rax
	jmp	whilea

nexta:	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi+0x8]
	mov	[rbp-0x8],rdi

whilea:	cmp	QWORD [rbp-0x8],NULL
	jne	doa


;;; Gere text list
gere_texts:
	mov	rdi,[g_text_list]
	mov	[rbp-0x8],rdi
	jmp	whilet

dot:	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi]
	mov	rdi,[rdi]
	mov	rsi,0
	mov	rdx,-1
	call	text_moove

	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi]
	dec	QWORD [rdi + 0x8]
	cmp	QWORD [rdi + 0x8],0
	jne	nextt

	;; Del elem
	mov	rdi,[g_text_list]
	mov	rsi,[rbp-0x8]
	mov	rdx,free
	call	delete_elem
	mov	[g_text_list],rax
	mov	rdi,[g_text_list]
	mov	[rbp-0x8],rdi
	jmp	whilet
	

nextt:	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi+0x8]
	mov	[rbp-0x8],rdi

whilet:	cmp	QWORD [rbp-0x8],NULL
	jne	dot


;;; Gere ennemy list
gere_ennemies:
	;; If player is dead, don't give a shit to ennemies
	mov	al,[g_player_status]
	and	al,PLAYER_DYING
	cmp	al,0
	jne	end

	;; Init list
	mov	rdi,[g_entity_list]
	mov	[rbp-0x8],rdi
	jmp	whilee

doe:
	;; Check if mob isn't dead
	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi]
	mov	rdi,[rdi + GOMBA_SPRITE_POS]
	call	sfSprite_getTexture
	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi]
	mov	rdi,[rdi + GOMBA_DYING_POS]
	cmp	rax,rdi
	je	nexte

	;; Moove sprite in Y
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	mov	rsi,0
	mov	rdx,[rax + GOMBA_MOOVEMENT_Y_POS]
	call	entity_moove

	;; Moove sprite in X
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	mov	rsi,[rax + GOMBA_MOOVEMENT_X_POS]
	mov	rdx,0
	call	entity_moove

	;; If moovement horizontal failed, inverse moovement
	cmp	rax,0
	je	gere_ground
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	mov	rsi,0
	sub	rsi,[rax + GOMBA_MOOVEMENT_X_POS]
	mov	[rax + GOMBA_MOOVEMENT_X_POS],rsi
	jmp	gere_animation

gere_ground:
	;; Try to see if entity as a ground under itself

	;; For left...
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	mov	rsi,CASE_SIZE
	mov	rdx,1
	call	sprite_moove
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	call	entity_is_in_wall
	cmp	rax,0
	jne	demove_entity
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	mov	rsi,0
	sub	rsi,[rax + GOMBA_MOOVEMENT_X_POS]
	mov	[rax + GOMBA_MOOVEMENT_X_POS],rsi

demove_entity:
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	mov	rsi,-CASE_SIZE
	mov	rdx,-1
	call	sprite_moove
	
	;; ... And for right.
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	mov	rsi,-CASE_SIZE
	mov	rdx,1
	call	sprite_moove
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	call	entity_is_in_wall
	cmp	rax,0
	jne	demove_entity2
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	mov	rsi,0
	sub	rsi,[rax + GOMBA_MOOVEMENT_X_POS]
	mov	[rax + GOMBA_MOOVEMENT_X_POS],rsi

demove_entity2:
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	mov	rsi,CASE_SIZE
	mov	rdx,-1
	call	sprite_moove

gere_animation:
	;; Gere animation
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	inc	QWORD [rax + GOMBA_COUNTER_POS]
	cmp	QWORD [rax + GOMBA_COUNTER_POS],GOMBA_WALK_FREQUENCY
	jne	gere_collisions

	;; Set new texture
	mov	QWORD [rax + GOMBA_COUNTER_POS],0
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	call	sfSprite_getTexture
	mov	rsi,[rbp-0x8]
	mov	rsi,[rsi]
	cmp	rax,[rsi + GOMBA_TEXTURE1_POS]
	jne	second_texture
	mov	rdi,[rsi + GOMBA_SPRITE_POS]
	mov	rsi,[rsi + GOMBA_TEXTURE2_POS]
	mov	rdx,NULL
	call	sfSprite_setTexture
	jmp	gere_collisions
second_texture:
	mov	rdi,[rsi + GOMBA_SPRITE_POS]
	mov	rsi,[rsi + GOMBA_TEXTURE1_POS]
	mov	rdx,NULL
	call	sfSprite_setTexture

;;; Gere collisions between player and ennemies
gere_collisions:
	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi]
	mov	rdi,[rdi + GOMBA_SPRITE_POS]
	call	entity_contact_player
	cmp	rax,0
	je	nexte

	;; Collision ! Ennmy die if player is up, else... Game over.
	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi]
	mov	rdi,[rdi + GOMBA_SPRITE_POS]
	call	sprite_getpos_y
	mov	[rbp-0x10],rax
	mov	rdi,[g_player_sprite]
	call	sprite_getpos_y
	sub	[rbp-0x10],rax
	cmp	QWORD [rbp-0x10],0
	jg	bound
	call	player_die
	jmp	nexte

;;; An ennemy is dead !
bound:	mov	QWORD [g_player_moove_y],-REBOUND_POWER

	;; Create score
	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi]
	mov	rdi,[rdi + GOMBA_SPRITE_POS]
	call	sprite_getpos_x
	mov	[rbp-0x10],rax
	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi]
	mov	rdi,[rdi + GOMBA_SPRITE_POS]
	call	sprite_getpos_y
	mov	[rbp-0x18],rax
	mov	rdi,100
	mov	rax,[g_player_jump_counter]
	mul	rdi
	mov	rdi,rax
	mov	rsi,[rbp-0x10]
	mov	rdx,[rbp-0x18]
	sub	rdx,(CASE_SIZE / 2)
	call	add_score

	;; Mult jump counter
	mov	rax,[g_player_jump_counter]
	mov	rdi,2
	mul	rdi
	mov	[g_player_jump_counter],rax

	;; Stop ennemy moovement
	mov	rax,[rbp-0x8]
	mov	rax,[rax]
	mov	QWORD [rax + GOMBA_MOOVEMENT_X_POS],0
	mov	QWORD [rax + GOMBA_MOOVEMENT_Y_POS],0

	;; Change texture to dying
	mov	rdi,[rax + GOMBA_SPRITE_POS]
	mov	rsi,[rax + GOMBA_DYING_POS]
	mov	rdx,NULL
	call	sfSprite_setTexture

	;; Suppr sprite in 1/2 second.
	mov	rdi,delete_elem
	mov	rsi,[g_entity_list]
	mov	rdx,30
	mov	rcx,[rbp-0x8]
	mov	r8,g_entity_list
	mov	r9,sfSprite_destroy
	call	create_action

	;; Play rebound sound
	mov	rdi,[g_actual_sound]
	mov	rsi,[g_sounds + SOUND_REBOUND_POS]
	call	sfSound_setBuffer
	mov	rdi,[g_actual_sound]
	call	sfSound_play


	;; Next
nexte:	mov	rdi,[rbp-0x8]
	mov	rdi,[rdi+0x8]
	mov	[rbp-0x8],rdi

whilee:	cmp	rdi,NULL
	jne	doe

	;; If player is located at the end, END !
	;; Check x
	mov	rdi,[g_player_sprite]
	call	sprite_getpos_x
	sub	eax,(CASE_SIZE / 2)
	mov	ebx,CASE_SIZE
	div	ebx
	cmp	eax,END_X
	jne	end

	;; Check y
	mov	rdi,[g_player_sprite]
	call	sprite_getpos_y
	mov	ebx,CASE_SIZE
	div	ebx
	cmp	eax,END_Y
	jne	end

	;; Victory !
	or	BYTE [g_player_status],PLAYER_VICTORY

	;; Stop music
	mov	rdi,[g_music]
	call	sfMusic_stop

	;; Play victory sound
	mov	rdi,[g_actual_sound]
	mov	rsi,[g_sounds + SOUND_VICTORY_POS]
	call	sfSound_setBuffer
	mov	rdi,[g_actual_sound]
	call	sfSound_play

	;; Game end in 6 seconds
	mov	rdi,game_end
	mov	rsi,victory_message
	mov	rdx,VICTORY_CLOSE_WAIT
	mov	r8,NULL
	mov	r9,NULL
	call	create_action

	;; Add Victory score
	mov	rdi,VICTORY_SCORE
	mov	rsi,END_X
	mov	rax,CASE_SIZE
	mul	rsi
	mov	rsi,rax
	mov	rdx,END_Y
	mov	rax,CASE_SIZE
	mul	rdx
	mov	rdx,rax
	call	add_score

	;; Stop player moovement
	mov	QWORD [g_player_moove_x],0


	;; Epilogue
end:	mov	rax,0		; Return 0
	add	rsp,0x20
	pop	rbp
	ret

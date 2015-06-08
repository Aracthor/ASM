;;
;; gere_events.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; Login   <bonnet_v@epitech.net>
;; 
;; Started on  Tue Feb 25 12:30:37 2014 Bonnet Vivien
;; Last Update Sun Mar  2 14:26:41 2014 Bonnet Vivien
;;

%include	"CSFML/Audio.inc"
%include	"CSFML/Overlay.inc"
%include	"CSFML/Window.inc"
%include	"globals.inc"
%include	"params.inc"
%include	"player.inc"


section	.text

;;; Gere close events (Alt+F4 or click on cross)
close_event:
	mov	rdi,[g_window]
	call	sfRenderWindow_close
	jmp	get_event

up_sound:
	mov	rdi,[g_music]
	call	music_get_volume
	cmp	rax,100
	jg	get_event
	inc	rax
	inc	rax
	mov	rsi,rax
	mov	rdi,[g_music]
	call	music_set_volume
	jmp	get_event

down_sound:
	mov	rdi,[g_music]
	call	music_get_volume
	cmp	rax,0
	jle	get_event
	dec	rax
	mov	rsi,rax
	mov	rdi,[g_music]
	call	music_set_volume
	jmp	get_event

pause_sound:
	mov	rdi,[g_music]
	call	sfMusic_getStatus
	cmp	rax,sfPaused
	je	unlock_sound
	mov	rdi,[g_music]
	call	sfMusic_pause
	jmp	get_event

unlock_sound:
	mov	rdi,[g_music]
	call	sfMusic_play
	jmp	get_event

do_player_jump:
	mov	rdi,-JUMP_POWER
	call	player_jump
	jmp	get_event

moove_right:
	mov	rdi,[g_player_sprite]
	mov	rsi,2
	mov	rdx,2
	call	sprite_set_scale
	mov	rdi,[g_player_sprite]
	mov	rsi,0
	mov	rdx,16
	call	sprite_set_origin
	mov	QWORD [g_player_moove_x],PLAYER_SPEED

	;; Reset texture if player was motionless
	cmp	QWORD [g_player_moove_x],0
	jne	get_event
	mov	BYTE [g_player_walk_counter],-1
	jmp	get_event

moove_left:
	mov	rdi,[g_player_sprite]
	mov	rsi,-2
	mov	rdx,2
	call	sprite_set_scale
	mov	rdi,[g_player_sprite]
	mov	rsi,16
	mov	rdx,16
	call	sprite_set_origin
	mov	QWORD [g_player_moove_x],-PLAYER_SPEED
	
	;; Reset texture if player was motionless
	cmp	QWORD [g_player_moove_x],0
	jne	get_event
	mov	BYTE [g_player_walk_counter],-1
	jmp	get_event


;;; Gere Keyboard pression
key_pressed:
	mov	ebx,DWORD [rbp-0x1C] ; get key code
	cmp	ebx,sfKeyEscape
	je	close_event
	cmp	ebx,sfKeyAdd
	je	up_sound
	cmp	ebx,sfKeySubtract
	je	down_sound
	cmp	ebx,sfKeyM
	je	pause_sound
	cmp	ebx,sfKeySpace
	je	do_player_jump
	cmp	ebx,sfKeyRight
	je	moove_right
	cmp	ebx,sfKeyLeft
	je	moove_left
	jmp	get_event


unmoove_right:
	cmp	QWORD [g_player_moove_x],PLAYER_SPEED
	jne	get_event
	call	player_stop
	jmp	get_event

unmoove_left:
	cmp	QWORD [g_player_moove_x],-PLAYER_SPEED
	jne	get_event
	call	player_stop
	jmp	get_event
	

;;; Gere keyboard release
key_release:
	mov	ebx,DWORD [rbp-0x1C] ; get key code
	cmp	ebx,sfKeyRight
	je	unmoove_right
	cmp	ebx,sfKeyLeft
	je	unmoove_left
	jmp	get_event


global	gere_events
gere_events:
	;;  prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x20

	;; If player is dead, do nothing
	mov	rax,[g_player_status]
	and	rax,PLAYER_DYING
	cmp	rax,0
	jne	return

	jmp	get_event

event_loop:
	;; Get event type
	mov	ebx,DWORD [rbp-0x20]

	;; Close event
	cmp	ebx,sfEvtClosed
	je	close_event
	cmp	ebx,sfEvtKeyPressed
	je	key_pressed
	cmp	ebx,sfEvtKeyReleased
	je	key_release

;;; Get next event in window event queue
get_event:
	mov	rdi,[g_window]
	mov	rsi,rbp
	sub	rsi,0x20
	call	sfRenderWindow_pollEvent
	cmp	rax,0
	jne	event_loop

	;; epilogue
return:	add	rsp,0x20
	pop	rbp

	;; Return 0
	mov	rax,0
	ret

;;
;; entity.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; 
;; Started on  Thu Feb 27 18:27:42 2014 Bonnet Vivien
;; Last Update Tue Mar  4 09:17:17 2014 Bonnet Vivien
;;

%include	"CSFML/Graphics.inc"
%include	"CSFML/Overlay.inc"
%include	"globals.inc"
%include	"params.inc"

;;; DEBUG
%include	"libc/stdio.inc"
section	.rodata
str:	db	"YOLO %d, %d : %d, %d",0x0A,0


section	.text

global	entity_is_in_wall
entity_is_in_wall:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x20
	mov	[rbp-0x18],rdi	; Save sprite


	;; Get map x
	mov	rdi,[rbp-0x18]
	call	sprite_getpos_x
	mov	ebx,0x20
	div	ebx
	inc	rax
	mov	[rbp-0x10],rax

	;; Test if x is in limits
	cmp	rax,0
	jle	no
	cmp	rax,MAP_WIDTH
	jge	no

	;; Get map y
	mov	rdi,[rbp-0x18]
	call	sprite_getpos_y
	dec	eax
	mov	ebx,0x20
	div	ebx

	;; Test if y is in limits
	cmp	rax,0
	jle	no
	cmp	rax,MAP_HEIGHT
	jge	no

	;; Get map y (suit)
	mov	ebx,eax
	mov	eax,MAP_WIDTH
	mul	ebx
	mov	[rbp-0x8],rax

	;; Check g_map case
	mov	rax,0
	mov	esi,[g_map]
	add	esi,[rbp-0x10]
	add	esi,[rbp-0x8]
	cmp	[esi],BYTE 0
	jne	no

	;; Check g_map case 2
	sub	esi,MAP_WIDTH
	cmp	[esi], BYTE 0
	jne	no

	;; Check g_map case 3
	inc	esi
	cmp	[esi], BYTE 0
	jne	no

	;; Check g_map case 4
	add	esi,MAP_WIDTH
	cmp	[esi], BYTE 0
	jne	no

	jmp	end
no:	mov	rax,1

	;; Epilogue
end:	add	rsp,0x20
	pop	rbp
	ret


global	entity_moove
entity_moove:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x30

	mov	[rbp-0x28],rdi	; Save sprite
	mov	[rbp-0x20],rsi	; Save x
	mov	[rbp-0x18],rdx	; Save y

	;; Try yo moove
	call	sprite_moove

	;; If entity is player and player is dead, don't give a shit to walls
	mov	rdi,[rbp-0x28]
	cmp	rdi,[g_player_sprite]
	jne	coll
	mov	al,[g_player_status]
	and	al,PLAYER_DYING
	cmp	al,0
	jne	moove_end

coll:	mov	rdi,[rbp-0x28]
	call	entity_is_in_wall
	cmp	rax,0
	je	moove_end

	;; Opposite moove
	mov	rdi,[rbp-0x28]
	mov	rbx,[rbp-0x20]
	mov	rsi,0
	sub	rsi,rbx
	mov	rbx,[rbp-0x18]
	mov	rdx,0
	sub	rdx,rbx
	call	sprite_moove

	;; assign moovement
	cmp	QWORD [rbp-0x20],0
	je	equalx
	jnl	left
	mov	QWORD [rbp-0x10],-1
	jmp	moovey
left:	mov	QWORD [rbp-0x10],1
	jmp	moovey
equalx:	mov	QWORD [rbp-0x10],0
moovey:	cmp	QWORD [rbp-0x18],0
	je	equaly
	jnle	fall
	mov	QWORD [rbp-0x8],-1
	jmp	loop
fall:	mov	QWORD [rbp-0x8],1
	jmp	loop
equaly:	mov	QWORD [rbp-0x8],0

	;; Moove
loop:	mov	rdi,[rbp-0x28]
	call	entity_is_in_wall
	cmp	rax,0
	jne	after_while
do:	mov	rdi,[rbp-0x28]
	mov	rsi,[rbp-0x10]
	mov	rdx,[rbp-0x8]
	call	sprite_moove
while:	mov	rdi,[rbp-0x28]
	call	entity_is_in_wall
	cmp	rax,0
	je	do

	;; Cancel last step
	mov	rdi,[rbp-0x28]
	mov	rbx,[rbp-0x10]
	mov	rsi,0
	sub	rsi,rbx
	mov	rbx,[rbp-0x8]
	mov	rdx,0
	sub	rdx,rbx
	call	sprite_moove

after_while:
	;; If sprite is player and moovement was vertical, set motionless texture
	mov	rdi,[rbp-0x28]
	cmp	rdi,[g_player_sprite] ; Sprite is mob ?
	jne	moove_with_problem
	cmp	QWORD [rbp-0x18],0 ; Vertical moovement ?
	je	moove_with_problem
	xor	BYTE [g_player_status],PLAYER_FLYING
	mov	QWORD [g_player_moove_y],0
	mov	rdi,[g_player_sprite]
	mov	rsi,[g_player_textures + MOTIONLESS_POS]
	mov	rdx,NULL
	call	sfSprite_setTexture
	mov	BYTE [g_player_walk_counter],-1

	;; If player touch ground, jump counter reset to 1
	cmp	QWORD [rbp-0x18],0
	jl	moove_with_problem
	mov	QWORD [g_player_jump_counter],1

moove_with_problem:
	mov	rax,1		; Return 1
	jmp	return
	
moove_end:
	;; Epilogue
	mov	rax,0		; Return 0
return:	add	rsp,0x30
	pop	rbp
	ret



global	entity_contact_player
entity_contact_player:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x20

	;; Get sprite position
	mov	[rbp-0x8],rdi
	call	sprite_getpos_y
	mov	[rbp-0x10],rax
	mov	rdi,[rbp-0x8]
	call	sprite_getpos_x
	mov	[rbp-0x8],rax

	;; Get player position
	mov	rdi,[g_player_sprite]
	call	sprite_getpos_y
	mov	[rbp-0x20],rax
	mov	rdi,[g_player_sprite]
	call	sprite_getpos_x
	mov	[rbp-0x18],rax

	;; Compare x
	sub	QWORD [rbp-0x8],CASE_SIZE
	mov	rax,[rbp-0x18]
	cmp	QWORD [rbp-0x8],rax
	jg	no_collision
	add	QWORD [rbp-0x8],(2 * CASE_SIZE)
	mov	rax,[rbp-0x18]
	cmp	QWORD [rbp-0x8],rax
	jl	no_collision

	;; Compare y
	sub	QWORD [rbp-0x10],CASE_SIZE
	mov	rax,[rbp-0x20]
	cmp	QWORD [rbp-0x10],rax
	jg	no_collision
	add	QWORD [rbp-0x10],(2 * CASE_SIZE)
	mov	rax,[rbp-0x20]
	cmp	QWORD [rbp-0x10],rax
	jl	no_collision

	mov	rax,1
	jmp	collision

	;; Epilogue
no_collision:
	mov	rax,0
collision:
	add	rsp,0x20
	pop	rbp
	ret

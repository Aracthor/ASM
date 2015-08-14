;;
;; destroy.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; 
;; Started on  Tue Feb 25 12:12:12 2014 Bonnet Vivien
;; Last Update Mon Mar  3 17:57:10 2014 Bonnet Vivien
;;

%include	"CSFML/Audio.inc"
%include	"CSFML/Graphics.inc"
%include	"CSFML/Window.inc"
%include	"libc/stdlib.inc"
%include	"globals.inc"
%include	"list.inc"

section	.text

global	destroy
destroy:
	;;  prologue
	push	rbp
	mov	rbp,rsp

	;; Music destruction
	mov	rdi,[g_music]
	call	sfMusic_destroy

	;; Textures destruction
	mov	rdi,[g_map_image]
	call	sfTexture_destroy
	mov	rdi,[g_player_textures + MOTIONLESS_POS]
	call	sfTexture_destroy
	mov	rdi,[g_player_textures + MOTION1_POS]
	call	sfTexture_destroy
	mov	rdi,[g_player_textures + MOTION2_POS]
	call	sfTexture_destroy
	mov	rdi,[g_player_textures + MOTION3_POS]
	call	sfTexture_destroy
	mov	rdi,[g_player_textures + FLYING_POS]
	call	sfTexture_destroy
	mov	rdi,[g_player_textures + DYING_POS]
	call	sfTexture_destroy
	mov	rdi,[g_gomba_textures + GOMBA_MOTION1_POS]
	call	sfTexture_destroy
	mov	rdi,[g_gomba_textures + GOMBA_MOTION2_POS]
	call	sfTexture_destroy
	mov	rdi,[g_gomba_textures + GOMBA_TEXTURE_DYING_POS]
	call	sfTexture_destroy

	;; SoundBuffers destruction
	mov	rdi,[g_sounds + SOUND_DIE_POS]
	call	sfSoundBuffer_destroy
	mov	rdi,[g_sounds + SOUND_JUMP_POS]
	call	sfSoundBuffer_destroy
	mov	rdi,[g_sounds + SOUND_REBOUND_POS]
	call	sfSoundBuffer_destroy
	mov	rdi,[g_sounds + SOUND_VICTORY_POS]
	call	sfSoundBuffer_destroy

	;; Sound destruction
	mov	rdi,[g_actual_sound]
	call	sfSound_destroy

	;; Vertex array destruction
	mov	rdi,[g_vertex_array]
	call	sfVertexArray_destroy

	;; View destruction
	mov	rdi,[g_camera]
	call	sfView_destroy

	;; Sprite destruction
	mov	rdi,[g_player_sprite]
	call	sfSprite_destroy

	;; Window destruction
	mov	rdi,[g_window]
	call	sfRenderWindow_destroy

	;; List frees
	mov	rdi,[g_action_list]
	call	destroy_list
	mov	rdi,[g_entity_list]
	call	destroy_list
	mov	rdi,[g_text_list]
	call	destroy_list

	;; Frees
	mov	rdi,[g_map]
	call	free

	;; epilogue
	pop	rbp
	ret

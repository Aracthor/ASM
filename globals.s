;;
;; globals.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; Login   <bonnet_v@epitech.net>
;; 
;; Started on  Tue Feb 25 12:12:29 2014 Bonnet Vivien
;; Last Update Tue Mar  4 09:00:34 2014 Bonnet Vivien
;;

section	.bss

;;; sfView *
global		g_camera
g_camera:	resq	1

;;; short
global		g_camera_pos
g_camera_pos:	resw	1

;;; sfRenderWindow *
global		g_window
g_window:	resq	1

;;; sfMusic *
global		g_music
g_music:	resq	1

;;; sfTexture *
global		g_map_image
g_map_image:	resq	1

;;; byte *
global		g_map
g_map:		resq	1

;;; sfVertexArray *
global		g_vertex_array
g_vertex_array:	resq	1

;;; sfSoundBuffer **
global		g_sounds
g_sounds:	resq	4

;;; sfSound *
global		g_actual_sound
g_actual_sound:	resq	1

;;; sfTexture **
global		g_gomba_textures
g_gomba_textures:	resq	3


;;; Player
;;; sfSprite *
global		g_player_sprite
g_player_sprite:	resq	1

;;; sfTexture **
global		g_player_textures
g_player_textures:	resq	6

;;; char
global		g_player_status
global		g_player_walk_counter
global		g_player_jump_counter
g_player_status:		resb	1
g_player_walk_counter:		resb	1
g_player_jump_counter:		resq	1

;;; longs
global		g_player_moove_x
global		g_player_moove_y
g_player_moove_x:		resq	1
g_player_moove_y:		resq	1


;;; Lists
global		g_action_list
global		g_entity_list
global		g_text_list
g_action_list:	resq	1
g_entity_list:	resq	1
g_text_list:	resq	1


;;; unsigned long
global		g_score
g_score:	resq	1

;;; sfFont *
global		g_font
g_font:		resq	1

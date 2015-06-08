%ifndef GLOBALS_INC_
 %define GLOBALS_INC_

section	.bss

 %define NULL	(00)

 %define PLAYER_GROUNDED	(0x00)
 %define PLAYER_FLYING		(0x01)
 %define PLAYER_DYING		(0x02)
 %define PLAYER_VICTORY		(0x03)
 %define PLAYER_MOOVE_RIGHT	(0b00000100)
 %define PLAYER_MOOVE_LEFT	(0b00001000)

 %define SOUND_DIE_POS		(0x00)
 %define SOUND_JUMP_POS		(0x08)
 %define SOUND_REBOUND_POS	(0x10)
 %define SOUND_VICTORY_POS	(0x18)

extern	g_camera
extern	g_camera_pos

extern	g_window
extern	g_music
extern	g_map_image

extern	g_map
extern	g_vertex_array

extern	g_sounds
extern	g_actual_sound

;;; Player
 %define MOTIONLESS_POS	(0x00)
 %define MOTION1_POS	(0x08)
 %define MOTION2_POS	(0x10)
 %define MOTION3_POS	(0x18)
 %define FLYING_POS	(0x20)
 %define DYING_POS	(0x28)

extern	g_player_textures
extern	g_player_sprite
extern	g_player_status
extern	g_player_walk_counter
extern	g_player_jump_counter
extern	g_player_moove_x
extern	g_player_moove_y

;;; Lists
 %define SIZEOF_LIST	(0x10)
 %define SIZEOF_ACTION	(0x30)
 %define SIZEOF_TEXT	(0x10)
extern	g_action_list
extern	g_entity_list
extern	g_text_list


;;; Gombas
extern	g_gomba_textures

 %define GOMBA_MOTION1_POS		(0x00)
 %define GOMBA_MOTION2_POS		(0x08)
 %define GOMBA_TEXTURE_DYING_POS	(0x10)

 %define GOMBA_SPRITE_POS	(0x00)
 %define GOMBA_TEXTURE1_POS	(0x08)
 %define GOMBA_TEXTURE2_POS	(0x10)
 %define GOMBA_DYING_POS	(0x18)
 %define GOMBA_MOOVEMENT_X_POS	(0x20)
 %define GOMBA_MOOVEMENT_Y_POS	(0x28)
 %define GOMBA_COUNTER_POS	(0x30)
 %define SIZEOF_GOMBA		(0x38)


;;; Score
extern	 g_score
extern	 g_font

 %define TEXT_TIMER		(50)

%endif ; GLOBALS_INC_

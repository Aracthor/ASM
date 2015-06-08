%ifndef PARAMS_INC_
 %define PARAMS_INC_

 %define WINDOW_WIDTH		1000
 %define WINDOW_HEIGHT		1000
 %define WINDOW_BPP		16
 %define WINDOW_FRAMERATE	60
 %define WINDOW_NAME		"Awesome Super Mario"

 %define MAP_WIDTH		211
 %define MAP_HEIGHT		0x20
 %define CASE_SIZE		0x20
 %define LIMIT_CAMERA		200

 %define BACKGROUND_COLOR	0xFB945D

 %define PLAYER_BEGIN_POS_X	(0x50)
 %define PLAYER_BEGIN_POS_Y	(0x200)
 %define DIE_POS_Y		(WINDOW_HEIGHT * 3 / 4)

 %define WALK_FREQUENCY		(6)
 %define DIE_JUMP_WAIT		(30)
 %define DIE_CLOSE_WAIT		(160)
 %define VICTORY_CLOSE_WAIT	(360)

 %define GRAVITY	(1)
 %define JUMP_POWER	(20)
 %define REBOUND_POWER	(JUMP_POWER / 2)
 %define PLAYER_SPEED	(4)

 %define GOMBA_SPEED			(2)
 %define GOMBA_WALK_FREQUENCY		(6)

 %define CHAR_SIZE			(10)
 %define CHAR_COLOR			(0xFFFFFF)
 %define SCORE_TIMER			(60)
 %define VICTORY_SCORE			(4000)

 %define END_X	(196)
 %define END_Y	(15)

%endif ; PARAMS_INC_

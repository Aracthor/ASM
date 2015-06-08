%ifndef MUSIC_INC_
 %define MUSIC_INC_

 %include	"CSFML/Audio/SoundStatus.inc"

extern	 sfMusic_createFromFile

extern	 sfMusic_play
extern	 sfMusic_setLoop
extern	 sfMusic_getStatus
extern	 sfMusic_setVolume
extern	 sfMusic_getVolume
extern	 sfMusic_pause
extern	 sfMusic_stop

extern	 sfMusic_destroy

%endif ; MUSIC_INC_
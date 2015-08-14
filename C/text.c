/*
** text.c for ASM in /home/bonnet_v/programs/projects/asm/ASM
** 
** Made by Bonnet Vivien
** 
** Started on  Mon Mar  3 18:32:19 2014 Bonnet Vivien
** Last Update Mon Mar  3 18:38:31 2014 Bonnet Vivien
*/

/*
** I am sorry to have a C part, but for float type,
** I really don't have choice.
*/

#include <SFML/Graphics/Text.h>

void		text_set_position(sfText *text, long x, long y)
{
  sfVector2f	vector;

  vector.x = x;
  vector.y = y;
  sfText_setPosition(text, vector);
}

void		text_moove(sfText *text, long x, long y)
{
  sfVector2f	vector;

  vector.x = x;
  vector.y = y;
  sfText_move(text, vector);
}

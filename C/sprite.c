/*
** sprites.c for ASM in /home/bonnet_v/programs/projects/asm/ASM
** 
** Made by Bonnet Vivien
** Login   <bonnet_v@epitech.net>
** 
** Started on  Thu Feb 27 11:28:02 2014 Bonnet Vivien
** Last Update Mon Mar  3 18:32:23 2014 Bonnet Vivien
*/

/*
** I am sorry to have a C part, but for float type,
** I really don't have choice.
*/

#include <SFML/Graphics/Sprite.h>

long	sprite_getpos_x(const sfSprite *sprite)
{
  sfVector2f	vertex;

  vertex = sfSprite_getPosition(sprite);

  return ((long)(vertex.x));
}

long	sprite_getpos_y(const sfSprite *sprite)
{
  sfVector2f	vertex;

  vertex = sfSprite_getPosition(sprite);

  return ((long)(vertex.y));
}

void		sprite_set_scale(sfSprite *sprite, long x, long y)
{
  sfVector2f	vector;

  vector.x = x;
  vector.y = y;
  sfSprite_setScale(sprite, vector);
}

void		sprite_set_origin(sfSprite *sprite, long x, long y)
{
  sfVector2f	vector;

  vector.x = x;
  vector.y = y;
  sfSprite_setOrigin(sprite, vector);
}

void		sprite_set_pos(sfSprite *sprite, long x, long y)
{
  sfVector2f	vector;

  vector.x = x;
  vector.y = y;
  sfSprite_setPosition(sprite, vector);
}

void		sprite_moove(sfSprite *sprite, long x, long y)
{
  sfVector2f	vector;

  vector.x = x;
  vector.y = y;
  sfSprite_move(sprite, vector);
}

/*
** view.c for ASM in /home/bonnet_v/programs/projects/asm/ASM
** 
** Made by Bonnet Vivien
** Login   <bonnet_v@epitech.net>
** 
** Started on  Sat Mar  1 17:09:44 2014 Bonnet Vivien
** Last Update Sat Mar  1 17:13:55 2014 Bonnet Vivien
*/

/*
** I am sorry to have a C part, but for float type,
** I really don't have choice.
*/

#include <SFML/Graphics/View.h>

void	view_move(sfView *view, long x, long y)
{
  sfVector2f	vertex;

  vertex.x = x;
  vertex.y = y;

  sfView_move(view, vertex);
}


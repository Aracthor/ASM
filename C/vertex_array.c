/*
** vertex_array.c for ASM in /home/bonnet_v/programs/projects/asm/ASM
** 
** Made by Bonnet Vivien
** Login   <bonnet_v@epitech.net>
** 
** Started on  Thu Feb 27 10:45:03 2014 Bonnet Vivien
** Last Update Thu Feb 27 10:46:38 2014 Bonnet Vivien
*/

/*
** I am sorry to have a C part, but for float type,
** I really don't have choice.
*/

#include <strings.h>

#include <SFML/Graphics.h>

void	draw_vertex_array(sfRenderWindow *window,
			  sfVertexArray *vertex_array,
			  sfTexture *image)
{
  sfRenderStates	states;

  bzero(&states, sizeof(states));
  states.transform = sfTransform_fromMatrix(1, 0, 0,
					    0, 1, 0,
					    0, 0, 1);
  states.texture = image;
  sfRenderWindow_drawVertexArray(window, vertex_array, &states);
}

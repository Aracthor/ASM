/*
** vertex.c for ASM in /home/bonnet_v/programs/projects/asm/ASM
** 
** Made by Bonnet Vivien
** Login   <bonnet_v@epitech.net>
** 
** Started on  Wed Feb 26 16:44:48 2014 Bonnet Vivien
** Last Update Sat Mar  1 15:20:41 2014 Bonnet Vivien
*/

/*
** I am sorry to have a C part, but for float type,
** I really don't have choice.
*/

#include <SFML/Graphics/Vertex.h>
#include <SFML/Graphics/VertexArray.h>

void	create_vertex(sfVertexArray *vertex_array,
		      long x, long y, sfColor color,
		      long tex_x, long tex_y)
{
  sfVertex	vertex;

  vertex.position.x = (float)x;
  vertex.position.y = (float)y;
  vertex.color = color;
  vertex.texCoords.x = (float)tex_x;
  vertex.texCoords.y = (float)tex_y;
  sfVertexArray_append(vertex_array, vertex);
}

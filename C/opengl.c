/*
** opengl.c for ASM in /home/bonnet_v/programs/projects/asm/ASM
** 
** Made by Bonnet Vivien
** Login   <bonnet_v@epitech.net>
** 
** Started on  Sat Mar  1 15:20:34 2014 Bonnet Vivien
** Last Update Sat Mar  1 15:21:29 2014 Bonnet Vivien
*/

/*
** I am sorry to have a C part, but for float type,
** I really don't have choice.
*/

#include "GL/gl.h"

void	gl_translate(long x, long y, long z)
{
  glTranslated(x, y, z);
}

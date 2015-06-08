/*
** Music.c for ASM in /home/bonnet_v/programs/projects/asm/ASM
** 
** Made by Bonnet Vivien
** Login   <bonnet_v@epitech.net>
** 
** Started on  Thu Feb 27 13:47:11 2014 Bonnet Vivien
** Last Update Thu Feb 27 14:01:24 2014 Bonnet Vivien
*/

#include <SFML/Audio/Music.h>

long	music_get_volume(sfMusic *music)
{
  return ((long)sfMusic_getVolume(music));
}

void	music_set_volume(sfMusic *music, long volume)
{
  sfMusic_setVolume(music, (float)volume);
}

##
## Makefile for ASM in /home/bonnet_v/programs/projects/asm/ASM
## 
## Made by Bonnet Vivien
## Login   <bonnet_v@epitech.net>
## 
## Started on  Tue Feb 25 08:01:48 2014 Bonnet Vivien
## Last Update Fri Nov 28 08:47:26 2014 
##

CC=	gcc

AS=	nasm

LD=	ld

LIBS=	-lsfml-window		\
	-lsfml-audio		\
	-lsfml-graphics		\
	-lcsfml-audio		\
	-lcsfml-graphics	\
	-lcsfml-window		\
	-lGL			\
	-lc


ASFLAGS=-f ELF64

CFLAGS=	-Wall -Werror -Wextra -O2

LDFLAGS=$(LIBS)


NAME=	ASM

ASRCS=	action.s	\
	destroy.s	\
	entity.s	\
	game.s		\
	gere_data.s	\
	gere_display.s	\
	gere_events.s	\
	globals.s	\
	gomba.s		\
	image.s		\
	init.s		\
	list.s		\
	main.s		\
	parse.s		\
	player.s	\
	read_map.s	\
	score.s

AOBJS=	$(ASRCS:.s=.o)

CDIR=	C

CSRCS=	$(CDIR)/music.c		\
	$(CDIR)/opengl.c	\
	$(CDIR)/sprite.c	\
	$(CDIR)/text.c		\
	$(CDIR)/view.c		\
	$(CDIR)/vertex.c	\
	$(CDIR)/vertex_array.c

COBJS=	$(CSRCS:.c=.o)

OBJS=	$(AOBJS) $(COBJS)



$(NAME):	$(OBJS)
		$(CC) -o $(NAME) $(OBJS) $(LDFLAGS)

all:		$(NAME)

clean:
		$(RM) $(OBJS)

fclean:		clean
		$(RM) $(NAME)

re:		fclean all

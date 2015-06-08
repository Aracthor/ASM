;;
;; game.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; Login   <bonnet_v@epitech.net>
;; 
;; Started on  Sun Mar  2 17:07:13 2014 Bonnet Vivien
;; Last Update Sun Mar  2 17:16:09 2014 Bonnet Vivien
;;

%include	"CSFML/Window.inc"
%include	"libc/stdio.inc"
%include	"globals.inc"


section	.data

global	game_end
game_end:
	;; Prologue
	push	rbp
	mov	rbp,rsp

	;; Print message
	call	printf

	;; Close window
	mov	rdi,[g_window]
	call	sfRenderWindow_close

	;; Epilogue
	pop	rbp
	ret

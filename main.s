;;
;; main.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; 
;; Started on  Tue Feb 25 12:12:21 2014 Bonnet Vivien
;; Last Update Fri Sep 11 20:18:45 2015 Aracthor
;;

%include	"CSFML/Window.inc"
%include	"libc/stdio.inc"
%include	"globals.inc"
%include	"map.inc"
%include	"phases.inc"


section	.rodata

arg_error:	db	"Enter a map, BIATCH !",0x0A
map_error:	db	"Map isn't valid...",0x0A
score:		db	"Final score : %ld",0x0A,0


section	.text

;;; MAIN
global	main
main:
	;;  prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x10

	;; Save argc, argv
	mov	[rbp-0x8],rdi
	mov	[rbp-0x10],rsi

	;; init
	call	init
	cmp	rax,0
	jne	exit

	;; Get arg
	cmp	QWORD [rbp-0x8],2
	mov	rdi,arg_error
	mov	rsi,22
	jne	error

	;; Read map
	mov	rdi,[rbp-0x10]
	add	rdi,0x8
	call	read_map

	;; Check error return
	mov	rdi,map_error
	mov	rsi,22
	cmp	rax,0
	jne	error

	mov	[rbp-0x1],BYTE 0
	jmp	test


;;; Game loop
game_loop:
	;; Gere events
	call	gere_events
	add	[rbp - 0x1],al

	;; Gere data
	call	gere_data
	add	[rbp - 0x1],al

	;; Gere display
	call	gere_display
	add	[rbp - 0x1],al

	;; Check for error
test:	cmp	[rbp - 0x1],BYTE 0
	jne	error

	;; Stop if window is closed
	mov	rdi,[g_window]
	call	sfRenderWindow_isOpen
	cmp	rax,1
	je	game_loop


	;; destroy
	call	destroy

	;; Print final score
	mov	rdi,score
	mov	rsi,[g_score]
	call	printf

	mov	rax,0
	jmp	exit


error:	mov	rax,1
	mov	rdx,rsi
	mov	rsi,rdi
	mov	rdi,2
	syscall
	mov	rax,1

	;; epilogue
exit:	add	rsp,0x10
	pop	rbp
	ret

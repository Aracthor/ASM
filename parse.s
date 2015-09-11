;;
;; parse.s for ASM in /home/bonnet_v/programs/projects/asm/ASM
;; 
;; Made by Bonnet Vivien
;; 
;; Started on  Wed Feb 26 12:33:02 2014 Bonnet Vivien
;; Last Update Fri Sep 11 20:19:21 2015 Aracthor
;;

%include	"CSFML/Graphics.inc"
%include	"CSFML/Overlay.inc"
%include	"globals.inc"
%include	"gomba.inc"
%include	"params.inc"


section	.text

;;; Add four vertex to list
insert_vertex:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x20

	;; Arg save
	mov	[rbp-0x18],rdi	; x
	mov	[rbp-0x10],rsi	; y
	mov	[rbp-0x8],dl	; texPos

	;; up, left
	mov	rdi,[g_vertex_array] ; vertex_array
	mov	rcx,[rbp-0x18]	; x
	mov	rax,32
	mul	rcx
	mov	rsi,rax
	mov	rcx,[rbp-0x10]	; y
	mov	rax,32
	mul	rcx
	mov	[rbp-0x20],rax	; save y
	mov	cl,[rbp-0x8]	; texCoord.x
	mov	rax,16
	mul	rcx
	mov	r8,rax
	mov	r9,0		; texCoord.y
	mov	rdx,[rbp-0x20]	; Get y
	call	create_vertex

	;; up, right
	mov	rdi,[g_vertex_array] ; vertex_array
	mov	rcx,[rbp-0x18]	; x
	inc	rcx
	mov	rax,32
	mul	rcx
	mov	rsi,rax
	mov	rcx,[rbp-0x10]	; y
	mov	rax,32
	mul	rcx
	mov	[rbp-0x20],rax	; save y
	mov	cl,[rbp-0x8]	; texCoord.x
	mov	rax,16
	mul	rcx
	mov	r8,rax
	add	r8,16
	mov	r9,0		; texCoord.y
	mov	rdx,[rbp-0x20]	; Get y
	call	create_vertex

	;; down, right
	mov	rdi,[g_vertex_array] ; vertex_array
	mov	rcx,[rbp-0x18]	; x
	inc	rcx
	mov	rax,32
	mul	rcx
	mov	rsi,rax
	mov	rcx,[rbp-0x10]	; y
	inc	rcx
	mov	rax,32
	mul	rcx
	mov	[rbp-0x20],rax	; save y
	mov	cl,[rbp-0x8]	; texCoord.x
	mov	rax,16
	mul	rcx
	mov	r8,rax
	add	r8,16
	mov	r9,16		; texCoord.y
	mov	rdx,[rbp-0x20]	; Get y
	call	create_vertex

	;; down, left
	mov	rdi,[g_vertex_array] ; vertex_array
	mov	rcx,[rbp-0x18]	; x
	mov	rax,32
	mul	rcx
	mov	rsi,rax
	mov	rcx,[rbp-0x10]	; y
	inc	rcx
	mov	rax,32
	mul	rcx
	mov	[rbp-0x20],rax	; save y
	mov	cl,[rbp-0x8]	; texCoord.x
	mov	rax,16
	mul	rcx
	mov	r8,rax
	mov	r9,16		; texCoord.y
	mov	rdx,[rbp-0x20]	; Get y
	call	create_vertex

	;; Epilogue
	add	rsp,0x20
	pop	rbp
	ret


global	parse
parse:
	;; Prologue
	push	rbp
	mov	rbp,rsp
	sub	rsp,0x20

	mov	rsi,rdi
	mov	rdi,[g_map]		; init ptr
	jmp	cond

do:
	;; It is a newline
	cmp	[rsi],BYTE 0x0A
	je	new_line

	;; It is a letter
	mov	al,[rsi]
	sub	al,'A'
	mov	[rdi],al
	inc	rdi

new_line:
	inc	rsi
cond:	cmp	[rsi],BYTE 0
	jne	do

	;; Create vertex array
	call	sfVertexArray_create
	mov	[g_vertex_array],rax
	mov	r8,[g_map]
	mov	[rbp-0x18],r8

	;; Set quad type
	mov	rdi,[g_vertex_array]
	mov	rsi,sfQuads
	call	sfVertexArray_setPrimitiveType

	mov	QWORD [rbp-0x8],0  ; y = 0
	jmp	whiley

	;; BIG LOOP
doy:	mov	QWORD [rbp-0x10],0 ; x = 0
	jmp	whilex

dox:	inc	QWORD [rbp-0x18]

	;; Add square to map
	mov	rdi,[rbp-0x10]
	mov	rsi,[rbp-0x8]
	mov	rdx,[rbp-0x18]
	mov	dl,BYTE [rdx]
	dec	dl
	cmp	dl,0xFF
	je	dont_add
	jl	add_gomba
	call	insert_vertex
	jmp	dont_add

add_gomba:
	;; Get x absolute position
	mov	rdi,[rbp-0x10]
	mov	rax,32
	mul	rdi
	mov	rdi,rax
	
	;; Get y absolute position
	mov	rsi,[rbp-0x8]
	inc	rsi
	mov	rax,32
	mul	rsi
	mov	rsi,rax

	;; Create ennemy
	call	create_gomba

	;; Reset map byte to 0
	mov	rdi,[rbp-0x18]
	mov	BYTE [rdi],0

dont_add:
	inc	QWORD [rbp-0x10]
whilex:	cmp	QWORD [rbp-0x10],MAP_WIDTH
	jne	dox

	inc	QWORD [rbp-0x8]
whiley:	cmp	QWORD [rbp-0x8],MAP_HEIGHT
	jne	doy

	;; Epilogue
	add	rsp,0x20
	pop	rbp
	ret

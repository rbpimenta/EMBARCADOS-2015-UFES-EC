; Trabalho Sistemas Embarcados 2015/2015/2
; Nome Aluno: Rodrigo Bittencourt Pimenta

segment code
..start:
    mov 	ax,data
    mov 	ds,ax
    mov 	ax,stack
    mov 	ss,ax
    mov 	sp,stacktop

; salvar modo corrente de video(vendo como está o modo de video da maquina)
    mov 	ah,0Fh
    int		10h
    mov		[modo_anterior],al
	
; alterar modo de video para gráfico 640x480 16 cores
   	mov		al,12h
	mov		ah,0
   	int		10h
	
;desenhar interface Gráfica
	; linha do limite inferior
	mov		byte[cor],branco_intenso	
	mov		ax, 0	; x1
	push	ax
	mov 	ax, 0	; y1
	push 	ax
	mov		ax, 639	; x2
	push 	ax
	mov 	ax, 0	; y2
	push 	ax
	call 	line
	
	; linha do limite superior
	mov		byte[cor],branco_intenso	
	mov		ax, 0	; x1
	push	ax
	mov 	ax, 479	; y1
	push 	ax
	mov		ax, 639	; x2
	push 	ax
	mov 	ax, 479	; y2
	push 	ax
	call 	line
	
	; linha do limite direita
	mov		byte[cor],branco_intenso	
	mov		ax, 639	; x1
	push	ax
	mov 	ax, 0	; y1
	push 	ax
	mov		ax, 639	; x2
	push 	ax
	mov 	ax, 479	; y2
	push 	ax
	call 	line

	; linha do limite esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, 0	; x1
	push	ax
	mov 	ax, 0	; y1
	push 	ax
	mov		ax, 0	; x2
	push 	ax
	mov 	ax, 479	; y2
	push 	ax
	call 	line	

	; linha esquerda menu
	mov		byte[cor],branco_intenso	
	mov		ax, 512	; x1
	push	ax
	mov 	ax, 0	; y1
	push 	ax
	mov		ax, 512	; x2
	push 	ax
	mov 	ax, 479	; y2
	push 	ax
	call 	line

	; linha superior opcao Sair
	mov		byte[cor],branco_intenso	
	mov		ax, 512	; x1
	push	ax
	mov 	ax, 80	; y1
	push 	ax
	mov		ax, 639	; x2
	push 	ax
	mov 	ax, 80	; y2
	push 	ax
	call 	line

	; linha superior opcao Qw
	mov		byte[cor],branco_intenso	
	mov		ax, 512	; x1
	push	ax
	mov 	ax, 160	; y1
	push 	ax
	mov		ax, 639	; x2
	push 	ax
	mov 	ax, 160	; y2
	push 	ax
	call 	line

	; linha superior opcao P
	mov		byte[cor],branco_intenso	
	mov		ax, 512	; x1
	push	ax
	mov 	ax, 240	; y1
	push 	ax
	mov		ax, 639	; x2
	push 	ax
	mov 	ax, 240	; y2
	push 	ax
	call 	line

	; linha superior opcao Qv
	mov		byte[cor],branco_intenso	
	mov		ax, 512	; x1
	push	ax
	mov 	ax, 320	; y1
	push 	ax
	mov		ax, 639	; x2
	push 	ax
	mov 	ax, 320	; y2
	push 	ax
	call 	line
	
	; linha superior opcao seta
	mov		byte[cor],branco_intenso	
	mov		ax, 512		; x1
	push	ax
	mov 	ax, 400		; y1
	push 	ax
	mov		ax, 639		; x2
	push 	ax
	mov 	ax, 400		; y2
	push 	ax
	call 	line
	
	; Desenhar linhas intermediarias do menu
	call desenharLinhasIntermediarias
	
	; Desenhar seta
	call desenharSetaMenu
	
	; Desenhar botão up
	call desenharBotoesUp
	
	; Desenhar botão down
	call desenharBotoesDown
	
	
; Sai do programa após qualquer tecla	
	mov    	ah,08h
	int     21h
	mov  	ah,0   			; set video mode
	mov  	al,[modo_anterior]   	; modo anterior
	int  	10h
	mov     ax,4c00h
	int     21h

;_____________________________________________________________________
;   função desenharBotoesUp
desenharBotoesUp:
	ret

;_____________________________________________________________________
;   função desenharBotaoUpQv
desenharBotaoUpQv:
	ret
;_____________________________________________________________________
;   função desenharBotaoUpP
desenharBotaoUpP:
	ret
;_____________________________________________________________________
;   função desenharBotaoUpQw
desenharBotaoUpQw:
	ret
	
;_____________________________________________________________________
;   função desenharBotoesDown
desenharBotoesDown:
	ret

;_____________________________________________________________________
;   função desenharBotaoUpQv
desenharBotaoUpQv:
	ret
;_____________________________________________________________________
;   função desenharBotaoUpP
desenharBotaoUpP:
	ret
;_____________________________________________________________________
;   função desenharBotaoUpQw
desenharBotaoUpQw:
	ret
	
;_____________________________________________________________________
;   função desenharSetaMenu
desenharSetaMenu:
	; Desenhar parte da direita da seta
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 20)		; x1
	push	ax
	mov 	ax, (320 + 30)		; y1
	push 	ax
	mov		ax, (512 + 20)		; x2
	push 	ax
	mov 	ax, (320 + 30 + 20)		; y2
	push 	ax
	call 	line
		
	; Desenhar reta inferior do corpo da seta
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 20)		; x1
	push	ax
	mov 	ax, (320 + 30)		; y1
	push 	ax
	mov		ax, (512 + 20) + 50		; x2
	push 	ax
	mov 	ax, (320 + 30)		; y2
	push 	ax
	call 	line		

	; Desenhar reta superior do corpo da seta
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 20)		; x1
	push	ax
	mov 	ax, (320 + 30 + 20)		; y1
	push 	ax
	mov		ax, (512 + 20) + 50		; x2
	push 	ax
	mov 	ax, (320 + 30 + 20)		; y2
	push 	ax
	call 	line
	
	; Desenhar reta vertical superior
	mov		byte[cor],branco_intenso	
	mov		ax, ((512 + 20) + 50)		; x1
	push	ax
	mov 	ax, (320 + 30 + 20)			; y1
	push 	ax
	mov		ax, ((512 + 20) + 50)		; x2
	push 	ax
	mov 	ax, (320 + 30 + 20) + 10	; y2
	push 	ax
	call 	line

	; Desenhar reta diagonal superior
	mov		byte[cor],branco_intenso	
	mov		ax, ((512 + 20) + 50)		; x1
	push	ax
	mov 	ax, (320 + 30 + 20)	+ 10	; y1
	push 	ax
	mov		ax, ((512 + 20) + 50) + 30	; x2
	push 	ax
	mov 	ax, (320 + 30) + 10			; y2
	push 	ax
	call 	line
	
	; Desenhar reta vertical inferior
	mov		byte[cor],branco_intenso	
	mov		ax, ((512 + 20) + 50)	; x1
	push	ax
	mov 	ax, (320 + 30)			; y1
	push 	ax
	mov		ax, ((512 + 20) + 50)	; x2
	push 	ax
	mov 	ax, (320 + 30) - 10 	; y2
	push 	ax
	call 	line

	; Desenhar reta diagonal inferior
	mov		byte[cor],branco_intenso	
	mov		ax, ((512 + 20) + 50)		; x1
	push	ax
	mov 	ax, (320 + 30) - 10			; y1
	push 	ax
	mov		ax, ((512 + 20) + 50) + 30	; x2
	push 	ax
	mov 	ax, (320 + 30) + 10			; y2
	push 	ax
	call 	line
	
	ret
	
;_____________________________________________________________________
;   função desenharLinhasIntermediarias
desenharLinhasIntermediarias:
	; linha intermediaria opcao Qw
	mov		byte[cor],branco_intenso	
	mov		ax, 512		; x1
	push	ax
	mov 	ax, 120		; y1
	push 	ax
	mov		ax, (512 + 50) 	; x2
	push 	ax
	mov 	ax, 120		; y2
	push 	ax
	call 	line
	
	; linha intermediaria opcao P
	mov		byte[cor],branco_intenso	
	mov		ax, 512		; x1
	push	ax
	mov 	ax, (120 + 80)		; y1
	push 	ax
	mov		ax, (512 + 50)		; x2
	push 	ax
	mov 	ax, (120 + 80)		; y2
	push 	ax
	call 	line
	
	; linha intermediaria opcao Qv
	mov		byte[cor],branco_intenso	
	mov		ax, 512		; x1
	push	ax
	mov 	ax, (120 + 80 + 80)		; y1
	push 	ax
	mov		ax, (512 + 50) 	; x2
	push 	ax
	mov 	ax, (120 + 80 + 80)		; y2
	push 	ax
	call 	line
	
	; linha vertical intermediaria
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 50)		; x1
	push	ax
	mov 	ax, 320		; y1
	push 	ax
	mov		ax, (512 + 50)		; x2
	push 	ax
	mov 	ax, 80		; y2
	push 	ax
	call 	line
	ret
	
;_____________________________________________________________________
;   função line
;
; push x1; push y1; push x2; push y2; call line;  (x<639, y<479)
line:
	push	bp
	mov		bp,sp
	pushf                        ;coloca os flags na pilha
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di
	mov		ax,[bp+10]   ; resgata os valores das coordenadas
	mov		bx,[bp+8]    ; resgata os valores das coordenadas
	mov		cx,[bp+6]    ; resgata os valores das coordenadas
	mov		dx,[bp+4]    ; resgata os valores das coordenadas
	cmp		ax,cx
	je		line2
	jb		line1
	xchg	ax,cx
	xchg	bx,dx
	jmp		line1
	
line2:		; deltax=0
	cmp		bx,dx  ;subtrai dx de bx
	jb		line3
	xchg	bx,dx        ;troca os valores de bx e dx entre eles

line3:	; dx > bx
	push	ax
	push	bx
	call 	plot_xy
	cmp		bx,dx
	jne		line31
	jmp		fim_line

line31:
	inc		bx
	jmp		line3

;deltax <>0
line1:
; comparar módulos de deltax e deltay sabendo que cx>ax
	; cx > ax
	push	cx
	sub		cx,ax
	mov		[deltax],cx
	pop		cx
	push	dx
	sub		dx,bx
	ja		line32
	neg		dx
	
line32:		
	mov		[deltay],dx
	pop		dx
	push	ax
	mov		ax,[deltax]
	cmp		ax,[deltay]
	pop		ax
	jb		line5
	; cx > ax e deltax>deltay
	push	cx
	sub		cx,ax
	mov		[deltax],cx
	pop		cx
	push	dx
	sub		dx,bx
	mov		[deltay],dx
	pop		dx
	mov		si,ax
	
line4:
	push	ax
	push	dx
	push	si
	sub		si,ax	;(x-x1)
	mov		ax,[deltay]
	imul	si
	mov		si,[deltax]		;arredondar
	shr		si,1
; se numerador (DX)>0 soma se <0 subtrai
	cmp		dx,0
	jl		ar1
	add		ax,si
	adc		dx,0
	jmp		arc1
	
ar1:
	sub		ax,si
	sbb		dx,0
	
arc1:
	idiv	word [deltax]
	add		ax,bx
	pop		si
	push	si
	push	ax
	call	plot_xy
	pop		dx
	pop		ax
	cmp		si,cx
	je		fim_line
	inc		si
	jmp		line4

line5:
	cmp		bx,dx
	jb 		line7
	xchg	ax,cx
	xchg	bx,dx
	
line7:
	push	cx
	sub		cx,ax
	mov		[deltax],cx
	pop		cx
	push	dx
	sub		dx,bx
	mov		[deltay],dx
	pop		dx
	mov		si,bx
	
line6:
	push	dx
	push	si
	push	ax
	sub		si,bx	;(y-y1)
	mov		ax,[deltax]
	imul	si
	mov		si,[deltay]		;arredondar
	shr		si,1
; se numerador (DX)>0 soma se <0 subtrai
	cmp		dx,0
	jl		ar2
	add		ax,si
	adc		dx,0
	jmp		arc2
	
ar2:
	sub		ax,si
	sbb		dx,0

arc2:
	idiv	word [deltay]
	mov		di,ax
	pop		ax
	add		di,ax
	pop		si
	push	di
	push	si
	call	plot_xy
	pop		dx
	cmp		si,dx
	je		fim_line
	inc		si
	jmp		line6

fim_line:
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	popf
	pop		bp
	ret		8

;_____________________________________________________________________________
;
;   função plot_xy
;
; push x; push y; call plot_xy;  (x<639, y<479)
; cor definida na variavel cor
plot_xy:
		push		bp
		mov		bp,sp
		pushf
		push 		ax
		push 		bx
		push		cx
		push		dx
		push		si
		push		di
	    mov     	ah,0ch
	    mov     	al,[cor]
	    mov     	bh,0
	    mov     	dx,479
		sub		dx,[bp+4]
	    mov     	cx,[bp+6]
	    int     	10h
		pop		di
		pop		si
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		popf
		pop		bp
		ret		4
		
;*******************************************************************
segment data

cor		db		branco_intenso

;	I R G B COR
;	0 0 0 0 preto
;	0 0 0 1 azul
;	0 0 1 0 verde
;	0 0 1 1 cyan
;	0 1 0 0 vermelho
;	0 1 0 1 magenta
;	0 1 1 0 marrom
;	0 1 1 1 branco
;	1 0 0 0 cinza
;	1 0 0 1 azul claro
;	1 0 1 0 verde claro
;	1 0 1 1 cyan claro
;	1 1 0 0 rosa
;	1 1 0 1 magenta claro
;	1 1 1 0 amarelo
;	1 1 1 1 branco intenso

preto		equ		0
azul		equ		1
verde		equ		2
cyan		equ		3
vermelho	equ		4
magenta		equ		5
marrom		equ		6
branco		equ		7
cinza		equ		8
azul_claro	equ		9
verde_claro	equ		10
cyan_claro	equ		11
rosa		equ		12
magenta_claro	equ		13
amarelo		equ		14
branco_intenso	equ		15

modo_anterior	db		0
linha   	dw  		0
coluna  	dw  		0
deltax		dw		0
deltay		dw		0	
mens    	db  		'Funcao Grafica'

xInicio	dw 	1
xFinal	dw	479
yInicio	dw	1
yFinal	dw	639
;*************************************************************************
segment stack stack
    		resb 		512
stacktop:
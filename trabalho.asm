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
	; call desenharSetaMenu
	
	; Desenhar botão up
	call desenharBotoesUp
	
	; Desenhar botão down
	call desenharBotoesDown
	
	; escrever mensagens na tela
	call escreverMensagens

	; detectar cliques do mouse
	call mouse
	
	;call saida
	
; Sai do programa após qualquer tecla
saida:
	;mov    	ah,08h
	;int     21h
	mov  	ah,0   			; set video mode
	mov  	al,[modo_anterior]   	; modo anterior
	int  	10h
	mov     ax,4c00h
	int     21h
	
;_____________________________________________________________________
;   função mouse
; 	Detecta quando houver interrupção do mouse
mouse:
	; show mouse cursor
	mov ax, 1h
	int 33h
	
	; return position and buttons status
	; input: mov ax, 3h
	;
	; output: 	bx -> button status (0->left, 1->right, 2->middle, 3-15->cleared)
	; 			cx -> pixel column position
	;			dx -> pixel row position
	;_____________________________________________________________________
	; input: 	mov ax, 5h
	;		 	mov bx, (0 -> left, 1 -> right)
	;
	; output: 	bx ->count of button press
	; 			cx -> horizontal position of last press
	;			dx -> vertical position of last press
	mov ax, 5h
	mov bx, 0
	int 33h
	mov word[mouseClick], bx
	mov word[mousePosX], cx
	mov word[mousePosY], dx
	; Verifica se o mouse foi clicado	
	call checkMouseClick
	
	loop mouse
	
;_____________________________________________________________________
;   função checkMouseClick
;	Check if the mouse was clicked
checkMouseClick:
	cmp		word[mouseClick], 1h
	je		checkMouseX		; Se botão direito for clicado checa posicao
	jne		mouse

;_____________________________________________________________________
;   função checkMouseX
;	Check the position of mouseX
checkMouseX:
	mov		ax, 512
	cmp		word[mousePosX], ax
	jge		checkMouseY		; if greater or equal 512
	call	mouse	

;_____________________________________________________________________
;   função checkMouseY
;	Check the position of mouseY
checkMouseY:
	mov		ax, 400
	cmp		word[mousePosY], ax
	jge		selecionarSair

	mov		ax, 320
	cmp		word[mousePosY], ax
	jge		selecionarQw
	
	mov		ax, 240
	cmp		word[mousePosY], ax
	jge		selecionarP

	mov		ax, 160
	cmp		word[mousePosY], ax
	jge		selecionarQv
	
	mov		ax, 80
	cmp		word[mousePosY], ax
	jge		selecionarSeta
	
	mov		ax, 0
	cmp		word[mousePosY], ax
	jge		selecionarAbrir
	
	call 	mouse

;_____________________________________________________________________
;   função selecionarSair	
selecionarSeta:
	call 	escreverMensagens
	call	desenharSetaMenuSelecionado
	call	mouse
	
;_____________________________________________________________________
;   função selecionarSair
selecionarSair:
	call 	escreverMensagens
	call	escreverMsgSairSelecionado
	call	saida	

;_____________________________________________________________________
;   função selecionarQw
selecionarQw:
	call 	escreverMensagens
	call	escreverMsgQwSelecionado
	call	mouse
	
;_____________________________________________________________________
;   função selecionarP
selecionarP:
	call 	escreverMensagens
	call	escreverMsgPSelecionado
	call	mouse
	
;_____________________________________________________________________
;   função selecionarAbrir
selecionarAbrir:
	call 	escreverMensagens
	call	escreverMsgAbrirSelecionado
	
	; Realizar algoritmo para abrir arquivo
	
	call	mouse
	
;_____________________________________________________________________
;   função selecionarQv
selecionarQv:
	call 	escreverMensagens
	call	escreverMsgQvSelecionado
	call	mouse

;_____________________________________________________________________
;   função escreverMensagens
escreverMensagens:
	call	escreverMsgAbrir
	call 	escreverMsgP
	call 	escreverMsgQw
	call 	escreverMsgQv
	call	escreverMsgSair
	call	desenharSetaMenu
	ret

;_____________________________________________________________________
;   função escreverMsgSair
escreverMsgSair:
    mov     cx,4			;número de caracteres
    mov     bx,0
    mov     dh,27			;linha 0-29
    mov     dl,70			;coluna 0-79
	mov		byte[cor], branco_intenso

loopMsgSair:
	call	cursor
    mov     al,[bx+msgSair]
	call	caracter
    inc     bx				;proximo caracter
	inc		dl				;avanca a coluna
	;inc		byte [cor]		;mudar a cor para a seguinte
    loop    loopMsgSair
	ret

;_____________________________________________________________________
;   função escreverMsgSairSelecionado
escreverMsgSairSelecionado:
    mov     cx,4			;número de caracteres
    mov     bx,0
    mov     dh,27			;linha 0-29
    mov     dl,70			;coluna 0-79
	mov		byte[cor], verde
	call	loopMsgSair
	ret	

;_____________________________________________________________________
;   função escreverMsgQv
escreverMsgQv:
    mov     cx,2			;número de caracteres
    mov     bx,0
    mov     dh,12			;linha 0-29
    mov     dl,74			;coluna 0-79
	mov		byte[cor], branco_intenso

loopMsgQv:
	call	cursor
    mov     al,[bx+msgQv]
	call	caracter
    inc     bx				;proximo caracter
	inc		dl				;avanca a coluna
	;inc		byte [cor]		;mudar a cor para a seguinte
    loop    loopMsgQv
	ret

;_____________________________________________________________________
;   função escreverMsgQvSelecionado
escreverMsgQvSelecionado:
    mov     cx,2			;número de caracteres
    mov     bx,0
    mov     dh,12			;linha 0-29
    mov     dl,74			;coluna 0-79
	mov		byte[cor], verde
	call	loopMsgQv
	ret
	
;_____________________________________________________________________
;   função escreverMsgP
escreverMsgP:
    mov     cx,1			;número de caracteres
    mov     bx,0
    mov     dh,17			;linha 0-29
    mov     dl,74			;coluna 0-79
	mov		byte[cor],branco_intenso

loopMsgP:
	call	cursor
    mov     al,[bx+msgP]
	call	caracter
    inc     bx				;proximo caracter
	inc		dl				;avanca a coluna
	;inc		byte [cor]		;mudar a cor para a seguinte
    loop    loopMsgP
	ret

;_____________________________________________________________________
;   função escreverMsgPSelecionado
escreverMsgPSelecionado:
    mov     cx,1			;número de caracteres
    mov     bx,0
    mov     dh,17			;linha 0-29
    mov     dl,74			;coluna 0-79
	mov		byte[cor],verde
	call 	loopMsgP
	ret	
;_____________________________________________________________________
;   função escreverMsgQw
escreverMsgQw:
    mov     cx,2			;número de caracteres
    mov     bx,0
    mov     dh,22			;linha 0-29
    mov     dl,74 			;coluna 0-79
	mov		byte[cor],branco_intenso

loopMsgQw:
	call	cursor
    mov     al,[bx+msgQw]
	call	caracter
    inc     bx				;proximo caracter
	inc		dl				;avanca a coluna
	;inc		byte [cor]		;mudar a cor para a seguinte
    loop    loopMsgQw
	ret

;_____________________________________________________________________
;   função escreverMsgQwSelecionado
escreverMsgQwSelecionado:
    mov     cx,2			;número de caracteres
    mov     bx,0
    mov     dh,22			;linha 0-29
    mov     dl,74 			;coluna 0-79
	mov		byte[cor],verde
	call 	loopMsgQw
	ret	
;_____________________________________________________________________
;   função escreverMsgAbrir
escreverMsgAbrir:
    mov     cx,5			;número de caracteres
    mov     bx,0
    mov     dh,2			;linha 0-29
    mov     dl,70			;coluna 0-79
	mov		byte[cor],branco_intenso

loopMsgAbrir:
	call	cursor
    mov     al,[bx+msgAbrir]
	call	caracter
    inc     bx				;proximo caracter
	inc		dl				;avanca a coluna
	;inc		byte [cor]		;mudar a cor para a seguinte
    loop    loopMsgAbrir
	ret
	
;_____________________________________________________________________
;   função escreverMsgAbrirSelecionado
escreverMsgAbrirSelecionado:
    mov     cx,5			;número de caracteres
    mov     bx,0
    mov     dh,2			;linha 0-29
    mov     dl,70			;coluna 0-79
	mov		byte[cor],verde
	call 	loopMsgAbrir
	ret	
;_____________________________________________________________________
;   função cursor
; 	dh = linha (0-29) e  dl=coluna  (0-79)
cursor:
	pushf
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di
	push	bp
	mov     ah,2
	mov     bh,0
	int     10h
	pop		bp
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	popf
	ret
;_____________________________________________________________________
;   função caracter 
;	escrito na posição do cursor
; 	al= caracter a ser escrito
; 	cor definida na variavel cor
caracter:
	pushf
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di
	push	bp
    mov     ah,9
    mov     bh,0
    mov     cx,1
   	mov     bl,[cor]
    int     10h
	pop		bp
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	popf
	ret
	
;_____________________________________________________________________
;   função desenharBotoesUp
desenharBotoesUp:
	call desenharBotaoUpQv
	call desenharBotaoUpP
	call desenharBotaoUpQw
	ret

;_____________________________________________________________________
;   função desenharBotaoUpQv
desenharBotaoUpQv:
	; Desenhar reta base
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 15)		; x1
	push	ax
	mov 	ax, 130	+ 80 + 80	; y1
	push 	ax
	mov		ax, ((512 + 15) + 20)		; x2
	push 	ax
	mov 	ax, 130	+ 80 + 80	; y2
	push 	ax
	call 	line
	
	; Desenhar diagonal esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 15)		; x1
	push	ax
	mov 	ax, 130	+ 80 + 80	; y1
	push 	ax
	mov		ax, ((512 + 15) + 10)		; x2
	push 	ax
	mov 	ax, 150 + 80 + 80	; y2
	push 	ax
	call 	line
	
	; Desenhar diagonal esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, ((512 + 15) + 20)		; x1
	push	ax
	mov 	ax, 130	+ 80 + 80	; y1
	push 	ax
	mov		ax, ((512 + 15) + 10)		; x2
	push 	ax
	mov 	ax, 150 + 80 + 80		; y2
	push 	ax
	call 	line
	
	ret
	ret
;_____________________________________________________________________
;   função desenharBotaoUpP
desenharBotaoUpP:
	; Desenhar reta base
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 15)		; x1
	push	ax
	mov 	ax, 130	+ 80	; y1
	push 	ax
	mov		ax, ((512 + 15) + 20)		; x2
	push 	ax
	mov 	ax, 130	+ 80	; y2
	push 	ax
	call 	line
	
	; Desenhar diagonal esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 15)		; x1
	push	ax
	mov 	ax, 130	+ 80	; y1
	push 	ax
	mov		ax, ((512 + 15) + 10)		; x2
	push 	ax
	mov 	ax, 150 + 80	; y2
	push 	ax
	call 	line
	
	; Desenhar diagonal esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, ((512 + 15) + 20)		; x1
	push	ax
	mov 	ax, 130	+ 80	; y1
	push 	ax
	mov		ax, ((512 + 15) + 10)		; x2
	push 	ax
	mov 	ax, 150 + 80		; y2
	push 	ax
	call 	line
	
	ret
;_____________________________________________________________________
;   função desenharBotaoUpQw
desenharBotaoUpQw:
	; Desenhar reta base
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 15)		; x1
	push	ax
	mov 	ax, 130		; y1
	push 	ax
	mov		ax, ((512 + 15) + 20)		; x2
	push 	ax
	mov 	ax, 130		; y2
	push 	ax
	call 	line
	
	; Desenhar diagonal esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 15)		; x1
	push	ax
	mov 	ax, 130		; y1
	push 	ax
	mov		ax, ((512 + 15) + 10)		; x2
	push 	ax
	mov 	ax, 150		; y2
	push 	ax
	call 	line
	
	; Desenhar diagonal esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, ((512 + 15) + 20)		; x1
	push	ax
	mov 	ax, 130		; y1
	push 	ax
	mov		ax, ((512 + 15) + 10)		; x2
	push 	ax
	mov 	ax, 150		; y2
	push 	ax
	call 	line
	
	ret
	
;_____________________________________________________________________
;   função desenharBotoesDown
desenharBotoesDown:
	call desenharBotaoDownQv
	call desenharBotaoDownP
	call desenharBotaoDownQw
	ret

;_____________________________________________________________________
;   função desenharBotaoDownQv
desenharBotaoDownQv:
	; Desenhar reta base
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 15)		; x1
	push	ax
	mov 	ax, 110	+ 80 + 80	; y1
	push 	ax
	mov		ax, ((512 + 15) + 20)		; x2
	push 	ax
	mov 	ax, 110	+ 80 + 80	; y2
	push 	ax
	call 	line
	
	; Desenhar diagonal esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 15)		; x1
	push	ax
	mov 	ax, 110	+ 80 + 80	; y1
	push 	ax
	mov		ax, ((512 + 15) + 10)		; x2
	push 	ax
	mov 	ax, 90 + 80 + 80	; y2
	push 	ax
	call 	line
	
	; Desenhar diagonal esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, ((512 + 15) + 20)		; x1
	push	ax
	mov 	ax, 110	+ 80 + 80	; y1
	push 	ax
	mov		ax, ((512 + 15) + 10)		; x2
	push 	ax
	mov 	ax, 90 + 80 + 80		; y2
	push 	ax
	call 	line
	
	ret
;_____________________________________________________________________
;   função desenharBotaoDownP
desenharBotaoDownP:
	; Desenhar reta base
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 15)		; x1
	push	ax
	mov 	ax, 110	+ 80	; y1
	push 	ax
	mov		ax, ((512 + 15) + 20)		; x2
	push 	ax
	mov 	ax, 110	+ 80	; y2
	push 	ax
	call 	line
	
	; Desenhar diagonal esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 15)		; x1
	push	ax
	mov 	ax, 110	+ 80	; y1
	push 	ax
	mov		ax, ((512 + 15) + 10)		; x2
	push 	ax
	mov 	ax, 90 + 80	; y2
	push 	ax
	call 	line
	
	; Desenhar diagonal esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, ((512 + 15) + 20)		; x1
	push	ax
	mov 	ax, 110	+ 80	; y1
	push 	ax
	mov		ax, ((512 + 15) + 10)		; x2
	push 	ax
	mov 	ax, 90 + 80		; y2
	push 	ax
	call 	line
	
	ret
;_____________________________________________________________________
;   função desenharBotaoDownQw
desenharBotaoDownQw:
	; Desenhar reta base
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 15)		; x1
	push	ax
	mov 	ax, 110		; y1
	push 	ax
	mov		ax, ((512 + 15) + 20)		; x2
	push 	ax
	mov 	ax, 110		; y2
	push 	ax
	call 	line
	
	; Desenhar diagonal esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, (512 + 15)		; x1
	push	ax
	mov 	ax, 110		; y1
	push 	ax
	mov		ax, ((512 + 15) + 10)		; x2
	push 	ax
	mov 	ax, 90		; y2
	push 	ax
	call 	line
	
	; Desenhar diagonal esquerda
	mov		byte[cor],branco_intenso	
	mov		ax, ((512 + 15) + 20)		; x1
	push	ax
	mov 	ax, 110		; y1
	push 	ax
	mov		ax, ((512 + 15) + 10)		; x2
	push 	ax
	mov 	ax, 90		; y2
	push 	ax
	call 	line
	
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
;   função desenharSetaMenuSelecionado
desenharSetaMenuSelecionado:
	; Desenhar parte da direita da seta
	mov		byte[cor],verde	
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
	mov		byte[cor],verde	
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
	mov		byte[cor],verde	
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
	mov		byte[cor],verde	
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
	mov		byte[cor],verde	
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
	mov		byte[cor],verde	
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
	mov		byte[cor],verde	
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

cor				db		branco_intenso

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

preto			equ		0
azul			equ		1
verde			equ		2
cyan			equ		3
vermelho		equ		4
magenta			equ		5
marrom			equ		6
branco			equ		7
cinza			equ		8
azul_claro		equ		9
verde_claro		equ		10
cyan_claro		equ		11
rosa			equ		12
magenta_claro	equ		13
amarelo			equ		14
branco_intenso	equ		15

corSelecionado	db	verde

modo_anterior	db		0
linha   		dw 		0
coluna  		dw  	0
deltax			dw		0
deltay			dw		0	
mens    		db  	'Funcao Grafica'

; Mensagens do programa
msgAbrir 		db 'Abrir'
msgQv	 		db 'Qv'
msgP 			db 'P'
msgQw 			db 'Qw'
msgSair 		db 'Sair'

; Cliques do mouse
mouseClick 		dw 0h
mousePosX 		dw 0h
mousePosY 		dw 0h

; Variáveis do sistema
valueQv			dw 1
valueP			dw 40
valueQw			dw 1
limiteSuperior 	dw 500
limiteInferior 	dw 500
valueIncremento dw 10
valueDecremento dw 10

; Arquivos
filename db "D:\Rodrigo\UFES\Embarcados\Programas\Codigo\sinal.txt", 0

; KeyPressed
kbdbuf			db 128

xInicio			dw 	1
xFinal			dw	479
yInicio			dw	1
yFinal			dw	639
;*************************************************************************
segment stack stack
    		resb 		512
stacktop:

; Referências de páginas
; https://courses.engr.illinois.edu/ece390/books/labmanual/io-devices-mouse.html
; http://pastebin.com/WWe7Sk9d#
; http://www.tutorialspoint.com/assembly_programming/assembly_registers.htm
; http://www.cs.virginia.edu/~evans/cs216/guides/x86.html
; http://regismain.wikidot.com/assembler
; http://www.cin.ufpe.br/~arfs/Assembly/apostilas/Tutorial%20Assembly%20-%20Gavin/ASM5.HTM
;
; Leitura de arquivo
; http://www.cin.ufpe.br/~arfs/Assembly/apostilas/Tutorial%20Assembly%20-%20Gavin/ASM6.HTM
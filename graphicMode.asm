; Damian Strojek s184407
.386
rozkazy SEGMENT use16
		ASSUME CS:rozkazy

	clear_screen PROC
		push ax
		push bx
		push cx

		mov ax, 0B800h ;adres pamięci ekranu
		mov es, ax
		mov bx, 0
		ptl2:
			mov byte PTR es:[bx], 0
			mov byte PTR es:[bx+1], 00000000b
			add bx, 2
			cmp bx, 4000
			jb ptl2

		pop cx
		pop bx
		pop ax
		ret
	clear_screen ENDP

	obsluga_zegara PROC
		cmp cs:czas, 18		; 18 = 1000ms
		jb koniec_zegar

		mov cs:czas, 0
		cmp cs:kolor, 0
		je CZERWONY1
		cmp cs:kolor, 1
		je ZIELONY1
		cmp cs:kolor, 2
		je NIEBIESKI1

	CZERWONY1:
		inc cs:kolor
		call maluj
		jmp koniec_zegar
	ZIELONY1:
		inc cs:kolor
		call maluj
		jmp koniec_zegar
	NIEBIESKI1:
		mov cs:kolor, 0
		call maluj
		jmp koniec_zegar

	koniec_zegar:
		add cs:czas, 1

		jmp dword PTR cs:wektor8
	licznik dw 0	; Domyslnie idziemy od gory
	kolor db 0		; 0 - czerwien, 1-zielony, 2-niebieski
	wektor8 dd ?
	klawisz db 2	;	0 - lewo, 1- prawo, 2-gora, 3-dol
	czas dw 0
	ilosc_pomalowanych dw 0
	obsluga_zegara ENDP

	maluj PROC
		push ax
		push bx
		push cx

		mov ax, 0B800h
		mov es, ax
		mov bx, cs:licznik
	ptl:
		mov byte PTR es:[bx], '*'
		cmp cs:kolor, 0
		je CZERWONY
		cmp cs:kolor, 1
		je ZIELONY
		cmp cs:kolor, 2
		je NIEBIESKI
	CZERWONY:
		mov byte PTR es:[bx+1], 01100111B
		jmp dalsza_czesc
	ZIELONY:
		mov byte PTR es:[bx+1], 00110111B
		jmp dalsza_czesc
	NIEBIESKI:
		mov byte PTR es:[bx+1], 01010111B
		jmp dalsza_czesc

	dalsza_czesc:
		mov al, cs:klawisz
		cmp al, 0
		je LEWO
		cmp al, 1
		je PRAWO
		cmp al, 2
		je GORA
		cmp al, 3
		je DOL
		jmp DALEJ_RYSUJ
	LEWO:
		add bx, 2
		mov dx, 0
		mov ax, bx
		mov cx, 160
		div cx		; dzielenie przez 160, jezeli reszta to 80 to skaczemy do kolejnej linii
		cmp dx, 80
		jne DALEJ_RYSUJ
		add bx, 80
		JMP DALEJ_RYSUJ
	PRAWO:
		add bx, 2
		mov dx, 0
		mov ax, bx
		mov cx, 160
		div cx
		cmp dx, 0	; jezeli reszta to 0 to skaczemy do kolejnej linii
		jne DALEJ_RYSUJ
		add bx, 80
		jmp DALEJ_RYSUJ
	GORA:
		add bx, 2
		cmp bx, 2000
		jmp DALEJ_RYSUJ
	DOL:
		add bx, 2
		cmp bx, 4000
		jmp DALEJ_RYSUJ
	DALEJ_RYSUJ:
		inc cs:ilosc_pomalowanych
		cmp cs:ilosc_pomalowanych, 1000		; 1000 pikseli to wszystkie piksele, ktore powinnismy narysowac
		jb ptl

	koniec:
		mov cs:ilosc_pomalowanych, 0			; przygotowanie do kolejnego rysowania
		pop cx
		pop bx
		pop ax
		ret
	maluj ENDP

zacznij:
	mov al, 0
	mov ah, 5
	int 10
	mov ax, 0
	mov ds,ax
	mov eax,ds:[32]
	mov cs:wektor8, eax

	mov ax, SEG obsluga_zegara
	mov bx, OFFSET obsluga_zegara

	cli
	mov ds:[32], bx
	mov ds:[34], ax
	sti

	call clear_screen
	call maluj

aktywne_oczekiwanie:
	mov ah,1
	int 16H
	jz aktywne_oczekiwanie
	mov ah, 0
	int 16H
	in al, 60h
	; Ustawienie zmiennej klawisz
	cmp al, 75
	je USTAW_LEWO
	cmp al, 72
	je USTAW_GORA
	cmp al, 80
	je USTAW_DOL
	cmp al, 77
	je USTAW_PRAWO
	jmp DALEJ

USTAW_LEWO:
	mov cs:klawisz, byte ptr 0
	mov cs:licznik, byte ptr 0
	call clear_screen
	call maluj
	jmp DALEJ
USTAW_PRAWO:
	mov cs:klawisz, byte ptr 1
	mov cs:licznik, byte ptr 80
	call clear_screen
	call maluj
	jmp DALEJ
USTAW_GORA:
	mov cs:klawisz, byte ptr 2
	mov cs:licznik, byte ptr 0
	call clear_screen
	call maluj
	jmp DALEJ
USTAW_DOL:
	mov cs:klawisz, byte ptr 3
	mov cs:licznik, byte ptr 2000
	call clear_screen
	call maluj
	jmp DALEJ

DALEJ:
	cmp ah, 1	; ESC
	jne aktywne_oczekiwanie

	mov eax, cs:wektor8
	cli
	mov ds:[32], eax
	sti
	mov al, 0
	mov ah, 4CH
	int 21H
rozkazy ENDS

nasz_stos SEGMENT stack
	db 128 dup (?)
nasz_stos ENDS

END zacznij

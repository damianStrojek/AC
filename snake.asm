.386
rozkazy SEGMENT use16
		ASSUME CS:rozkazy
	; procedura obslugi przerwania zegarowego
	obsluga_zegara PROC
		push ax
		push bx
		push cx
		push dx
		push es
		mov ax, 0B800h ;adres pamieci ekranu
		mov es, ax
		; licznik to adres biezacy w pamieci ekranu
		mov bx, cs:licznik
		mov al, cs:kreska
		mov byte PTR es:[bx], al
		mov al, cs:kolor
		mov byte PTR es:[bx+1], al

		; tutaj bedzie zmiana adresu biezacego w pamieci ekranu
		; lewo 75, gora 72, dol 80, prawo 77
		cmp cs:kierunek, word ptr 72
		je gora
		cmp cs:kierunek, word ptr 75
		je lewo
		cmp cs:kierunek, word ptr 77
		je prawo
		cmp cs:kierunek, word ptr 80
		je dol
		jmp wysw_dalej

	gora:
		cmp bx, 161
		jb wysw_dalej
		sub bx, 160
		mov cs:kreska, byte ptr '^'
		jmp wysw_dalej
	dol:
		cmp bx, 3840
		ja wysw_dalej
		add bx, 160
		mov cs:kreska, byte ptr 'v'
		jmp wysw_dalej
	lewo:
		mov cs:kreska, byte ptr '<'
		sub bx, 2
		xor dx, dx
		mov ax, bx
		mov cx, 160
		div cx
		cmp dx, 158
		jne wysw_dalej
		add bx, 2
		jmp wysw_dalej
	prawo:
		mov cs:kreska, byte ptr '>'
		add bx, 2
		xor dx, dx
		mov ax, bx
		mov cx, 160
		div cx
		cmp dx, 0
		jne wysw_dalej
		sub bx, 2

	wysw_dalej:
		inc cs:kolor
		mov cs:licznik, bx

		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		jmp dword PTR cs:wektor8
	licznik		dw 0
	wektor8		dd ?
	wektor9		dd ?
	kierunek	dw 77
	kreska		db '>'
	kolor		db 1
	obsluga_zegara ENDP

	obsluga_klawiatury PROC
		push ax

		xor ax, ax
		in al, 60h
		cmp al, byte ptr 72
		je wpisz
		cmp al, byte ptr 75
		je wpisz
		cmp al, byte ptr 77
		je wpisz
		cmp al, byte ptr 80
		je wpisz
		jmp koniec
	wpisz:
		mov cs:kierunek, ax
	koniec:
		pop ax
		jmp dword ptr cs:wektor9
	obsluga_klawiatury ENDP

; program glowny
zacznij:
	mov al, 0
	mov ah, 5
	int 10

	mov ax, 0
	mov ds, ax
	mov eax, ds:[32]
	mov cs:wektor8, eax
	mov ax, SEG obsluga_zegara		; czesc segmentowa adresu
	mov bx, OFFSET obsluga_zegara	; offset adresu
	cli
	mov ds:[32], bx ; OFFSET
	mov ds:[34], ax ; cz. segmentowa
	sti

	mov ax, 0
	mov ds, ax
	mov eax, ds:[36]
	mov cs:wektor9, eax
	mov ax, SEG obsluga_klawiatury
	mov bx, OFFSET obsluga_klawiatury
	cli
	mov ds:[36], bx
	mov ds:[38], ax
	sti

aktywne_oczekiwanie:
	mov ah, 1
	int 16H
	jz aktywne_oczekiwanie

	mov ah, 0
	int 16H
	cmp ah, 1		; ESC
	jne aktywne_oczekiwanie

	mov eax, cs:wektor8
	mov edx, cs:wektor9
	cli
	mov ds:[32], eax
	mov ds:[36], edx
	sti

	mov al, 0
	mov ah, 4CH
	int 21H
rozkazy ENDS

nasz_stos SEGMENT stack
	db 128 dup (?)
nasz_stos ENDS
END zacznij

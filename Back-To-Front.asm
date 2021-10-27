.686
.model flat

extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
tytul			dw 'Z','a','d','-','2', 0
magazyn_input	dw '1','2','3','4',' ','5','6','7','8',' ','9','A','B','C'
magazyn_output	dw 15 dup (?)

.code
_main proc
	mov ecx, 14			; licznik glownej petli, ilosc znakow w inpucie
	mov edi, 0			; indeks tekstu output
	mov esi, 0			; ilosc elementow w wyrazie
	mov edx, 0			; wyzerowanie edx dla naszego inputu

	; idziemy od ostatniego wyrazu do przodu i wrzucamy na stos
	glownaPetla:	mov dx, magazyn_input[2*ecx-2]		
	cmp dx, 32			; 32 to spacja w DEC
	je zeStosu
	jne naStos
	; wrzucamy na stos dana literke 
	naStos:	push dx
	inc esi
	cmp ecx, 1
	je zeStosu
	jne petla
	; zdejmujemy ze stosu cale slowo
	zeStosu:	pop bx
	mov magazyn_output[2*edi], bx
	inc edi
	dec esi
	jz dodajSpacje
	jnz zeStosu
	; dodajemy spacje miedzy slowami 
	dodajSpacje:	mov magazyn_output[2*edi], 32
	inc edi
	jmp petla
	; zapetlamy wszystko (ecx-=1 jmp glownaPetla)
	petla:	loop glownaPetla

	; dodanie 0 na koniec stringa
	mov magazyn_output[2*edi-1], 0

	; wyswietlanie sie outputu
	push 0
	push OFFSET tytul
	push OFFSET magazyn_output
	push 0
	call _MessageBoxW@16
	; zakonczenie programu
	push 0
	call _ExitProcess@4
_main endp
end

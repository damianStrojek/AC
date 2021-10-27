.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
tekst_output		db 10,'Mozesz powtorzyc ostatnie slowo za pomoca \d',10
koniec_tekstu		db ?
magazyn_input		db 80 dup (?)
magazyn_ostatnie	db 80 dup (?)
magazyn_output		db 80 dup (?)

.code
_main proc
	; wiadomosc powitalna
	mov ecx, (OFFSET koniec_tekstu) - (OFFSET tekst_output)
	push ecx
	push OFFSET tekst_output
	push 1
	call __write
	add esp, 12
	; wczytanie inputu
	push 80
	push OFFSET magazyn_input
	push 0
	call __read
	add esp, 12
	
	; glowny program
	mov ecx, eax				; ecx to glowny licznik petli, read wpisuje do eax ilosc znakow
	mov esi, 0					; indeks magazyn input
	mov edi, 0					; indeks magazyn output
	mov ebx, 0					; indeks ostatniego slowa

	; sprawdzanie literki po literce
	glownaPetla:	mov dl, magazyn_input[esi]
	inc esi
	cmp dl, ' '
	je sprawdzNastepne
	jne wpiszDoOutputu

	; jezeli to nie jest nic specjalnego to leci do outputu i do magazynu
	wpiszDoOutputu: mov magazyn_output[edi], dl
	inc edi
	mov magazyn_ostatnie[ebx], dl
	inc ebx
	loop glownaPetla
	jmp koniec

	; sprawdzamy kolejne slowo, jezeli jest \d to wtedy powtarzamy jezeli nie to zaczynamy od nowa
	sprawdzNastepne: mov dl, magazyn_input[esi]
	mov magazyn_output[edi], ' '		; dodanie spacji do outputu
	inc edi
	inc esi
	cmp dl, '\'
	jne cofnij1
	mov dl, magazyn_input[esi]
	inc esi
	cmp dl, 'd'
	jne cofnij2
	mov eax, 0			; indeks przygotowany do powtorzenia slowa
	jmp powtorzOstatnie

	; jezeli natrafilismy na \d to musimy w outpucie to wypisac
	powtorzOstatnie: mov dl, magazyn_ostatnie[eax]
	inc eax
	mov magazyn_output[edi], dl
	inc edi
	cmp eax, ebx
	jne powtorzOstatnie
	loop glownaPetla

	; jezeli to nie jest slash to musimy sie cofnac do glownej petli i 
	; zaczac sprawdzac od poczatku nowego slowa
	cofnij1: mov ebx, 0
	mov magazyn_ostatnie[ebx], dl
	inc ebx
	mov magazyn_output[edi], dl
	inc edi
	loop glownaPetla

	; jezeli jest slash, ale nie ma po nim d to cofamy sie do poczatku 
	; slowa i wpisujemy je odpowiednio do dwoch magazynow
	cofnij2: sub esi, 2
	mov ebx, 0
	dec ecx
	jmp glownaPetla

	koniec: push edi						; ilosc znakow outputu
	push OFFSET magazyn_output
	push 1
	call __write
	add esp, 12
	; koniec programu
	push 0
	call _ExitProcess@4	
_main endp
end

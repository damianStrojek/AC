.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
tekst_output		db	10,'Prosze napisac swoje imie i nazwisko :',10
koniec_tekstu		db	?

magazyn_input		db	80 dup (?)
magazyn_imie		db	80 dup (?)
magazyn_nazwisko	db	80 dup (?)
magazyn_output		db	80 dup (?)
liczba_znakow		dd	?

.code
_main proc
	; liczba znakow tekstu
	mov ecx, (OFFSET koniec_tekstu) - (OFFSET tekst_output)
	; tekst output
	push ecx
	push OFFSET tekst_output
	push 1
	call __write
	add esp, 12

	; tekst input
	push 80
	push OFFSET magazyn_input
	push 0
	call __read
	add esp, 12

	mov liczba_znakow, eax		; funkcja read wpisuje do eax liczbe wprowadzonych znakow
	mov ecx, eax				; ecx bedzie licznikiem calego inputu
	mov esi, 0					; esi jest indeksem inputu
	mov eax, 0					; eax jest indeksem imienia		damian = 6
	mov ebx, 0					; ebx jest indeksem nazwiska	strojek = 7
	mov edi, 0					; edi jest indeksem outputu

	ptl:	mov dl, magazyn_input[esi]
	inc esi
	cmp dl, ' '
	je nazwisko
	mov magazyn_imie[eax], dl
	inc eax
	loop ptl

	nazwisko:	mov dl, magazyn_input[esi]
	inc esi
	mov magazyn_nazwisko[ebx], dl
	inc ebx
	loop nazwisko

	mov ecx, ebx
	sub ecx, 2	; spacja oraz enter z inputu
	mov ebx, 0
	dodajNazwisko:	mov dl, magazyn_nazwisko[ebx]
	inc ebx
	mov magazyn_output[edi], dl
	inc edi
	loop dodajNazwisko

	mov magazyn_output[edi], ' '
	inc edi

	mov ecx, eax
	mov eax, 0
	dodajImie:	mov dl, magazyn_imie[eax]
	inc eax
	mov magazyn_output[edi], dl
	inc edi
	loop dodajImie
	
	; wyswietlanie tekstu
	push liczba_znakow
	push OFFSET magazyn_output
	push 1
	call __write
	add esp, 12

	; zakonczenie programu
	push 0
	call _ExitProcess@4
_main endp
END

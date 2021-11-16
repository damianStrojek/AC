.686
.model flat
public _main
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

.data
dekoder db '0123456789ABCDEF'
znaki db 12 dup (?)
dziesiec dd 10

.code
wczytaj_do_EAX_hex PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp
	
	; rezerwacja 12 bajtow na stosie
	; tymczasowe przechowanie cyfr szesnastkowych
	sub esp, 12				; rezerwacja
	mov esi, esp			; adres zarezerwowanego obszaru
	
	push dword PTR 10		; max ilosc znakow wczytywanych
	push esi				; adres obszaru pamieci
	push dword PTR 0		; numer urzadzenia (0 dla klawiatury)
	call __read
	
	add esp, 12				; usuniecie parametrow ze stosu
	mov eax, 0				; dotychczas uzyskany wynik
	
	pocz_konw:
	mov dl, [esi]			; pobranie kolejnego bajtu
	inc esi					; indeks
	cmp dl, 10				; sprawdzenie Entera
	je gotowe	
	; sprawdzenie czy wprowadzony znak jest cyfra 0-9
	cmp dl, '0'
	jb pocz_konw			; inny znak ignorowany
	cmp dl, '9'
	ja sprawdzaj_dalej
	sub dl, '0'				; zamiana ASCII na wartosc cyfry
	
	dopisz:
	shl eax, 4				; przesuniecie logiczne w lewo o 4 bity
	or al, dl				; dopisanie utworzonego kodu 4-bitowego
							; na 4 ostatnie bity rejestru EAX
	jmp pocz_konw
	
	; sprawdzenie czy wprowadzony znak jest cyfra A-F
	sprawdzaj_dalej:
	cmp dl, 'A'
	jb pocz_konw
	cmp dl, 'F'
	ja sprawdzaj_dalej2
	sub dl, 'A' - 10
	jmp dopisz
	
	; sprawdzenie czy wprowadzony znak jest cyfra a-f
	sprawdzaj_dalej2:
	cmp dl, 'a'
	jb pocz_konw
	cmp dl, 'f'
	ja pocz_konw
	sub dl, 'a' - 10
	jmp dopisz
	
	gotowe:
	add esp, 12
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX_hex ENDP

wyswietl_EAX PROC
	pusha

	mov esi, 10		                ; indeks w tablicy 'znaki'
    mov ebx, 10		                ; dzielnik równy 10
    
    ; konwersja na kod ASCII
    konwersja:
    mov edx, 0		                ; zerowanie starszej czesci dzielnej
    div ebx		                    ; dzielenie przez 10, reszta w EDX
                                    ; iloraz w EAX
    add dl, 30h		                ; zamiana reszty z dzielenia na kod ASCII
    mov znaki[esi], dl	            ; zapisanie cyfry w kodzie ASCII
    dec esi		                    ; zmniejszenie indeks
    cmp eax, 0		                ; sprawdzenie czy iloraz = 0
    jne konwersja
    
    ; wypelnienie pozostalych bajtow spacjami
    wypeln:
    or esi, esi
    jz wyswietl		                ; gdy indeks = 0
    mov byte PTR znaki[esi], 20h	; kod spacji
    dec esi
    jmp wypeln
    
    wyswietl:
    mov byte PTR znaki[0], 0Ah		; kod nowego wiersza
    mov byte PTR znaki[11], 0Ah
    push dword PTR 12
    push dword PTR OFFSET znaki
    push dword PTR 1
    call __write
    add esp, 12

	popa
	ret
wyswietl_EAX ENDP

_main PROC
    call wczytaj_do_EAX_hex
    call wyswietl_EAX

	push 0
	call _ExitProcess@4
_main ENDP
END

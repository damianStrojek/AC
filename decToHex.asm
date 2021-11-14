.686
.model flat
public _main
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

.data
dekoder db '0123456789ABCDEF'
obszar db 12 dup (?)
dziesiec dd 10

.code
wczytaj_do_EAX PROC
    push ebx
    push esi
    push edi
    push ebp
    
    push dword PTR 12                   ; max ilosc znakow wczytywanej liczby
    push dword PTR OFFSET obszar	    ; adres obszaru pamięci
    push dword PTR 0		            ; numer urządzenia (0 dla klawiatury)
    call __read 			            ; odczytywanie znaków z klawiatury
    add esp, 12 			            ; usunięcie parametrów ze stosu

    ; biezaca wartość przekształcanej liczby przechowywana jest
    ; w rejestrze EAX; przyjmujemy 0 jako wartość początkową
    xor eax, eax
    mov ebx, OFFSET obszar 		        ; adres obszaru ze znakami

    pobieraj_znaki:
    mov cl, [ebx] 		                ; pobranie kolejnej cyfry w kodzie ASCII
    inc ebx 			                ; zwiększenie indeksu
    cmp cl, 10			                ; sprawdzenie czy naciśnięto Enter
    je byl_enter 		                ; skok, gdy naciśnięto Enter
    sub cl, 30H 		                ; zamiana kodu ASCII na wartość cyfry
    movzx ecx, cl		                ; przechowanie wartości cyfry w ECX
    ; mnożenie wcześniej obliczonej wartości razy 10
    mul dword PTR dziesiec
    add eax, ecx 		                ; dodanie ostatnio odczytanej cyfry
    jmp pobieraj_znaki 		            ; skok na początek pętli
    
    byl_enter:			                ; wartość binarna w EAX

    pop ebp
    pop edi
    pop esi
    pop ebx
    ret
wczytaj_do_EAX ENDP

wyswietl_EAX_hex PROC
    pusha			; przechowanie rejestrow
    sub esp, 12			; rezerwacja 12 bajtow na stosie
    mov edi, esp		; adres zarezerwowanego obszaru
    
    ; przygotowanie konwersji
    mov ecx, 8			; liczba obiegow petli konwersji
    mov esi, 1			; indeks poczatkowy uzywany przy zapisie cyfr
    
    ; petla konwersji
    ptl3hex:
    ; przesuniecie cykliczne (obrot) rejestru EAX
    ; o 4 bity w lewo
    ; w pierwszym obiegu petli bity nr 31-28
    ; zostana przesuniete na pozycje 3-0
    rol eax, 4
    mov ebx, eax			; kopiowanie EAX do EBX
    and ebx, 0000000Fh			; zerowanie bitow 31-4
    mov dl, dekoder[ebx]		; pobranie cyfry z tablicy
    cmp dl, '0'
    je spacja
    mov dh, 'e'                   ; znacznik zakonczenia najmniej waznych zer
    jne dalej

    ; przeslanie cyfry do obszaru roboczego
    dalej:
    mov [edi][esi], dl
    inc esi
    loop ptl3hex
    jmp koniec

    spacja:
    cmp dh, 'e'
    je dalej
    mov dl, ' '
    mov [edi][esi], dl
    inc esi
    loop ptl3hex

    koniec:

     ; wpisanie znaku nowego wiersza przed i po cyfrach
    mov byte PTR [edi][0], 10
    mov byte PTR [edi][9], 10

    ; wyswietlanie przygotowanych cyfr
    push 10				; 8 cyfr + 2 znaki nowego wiersza
    push edi
    push 1
    call __write
    
    ; usuniecie ze stosu 24 bajtow
    ; 12 bajtow zapisanych przez 3 rozkazy push
    ; oraz 12 zarezerwowanych
    add esp, 24
    popa
    ret
wyswietl_EAX_hex ENDP

_main PROC
    call wczytaj_do_EAX
    call wyswietl_EAX_hex

	push 0
	call _ExitProcess@4
_main ENDP
END

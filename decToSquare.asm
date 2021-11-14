.686
.model flat
public _main
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

.data
znaki db 12 dup (?)
obszar db 12 dup (?)		            ; deklaracja do przechowywania wprowadzonych cyfr
dziesiec dd 10                          ; mnożnik



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
    call wczytaj_do_EAX
    mul eax
    call wyswietl_EAX

	push 0
	call _ExitProcess@4
_main ENDP
END

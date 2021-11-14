.686
.model flat
public _main
extern __write : PROC
extern _ExitProcess@4 : PROC

.data
znaki db 12 dup (?)		            ; deklaracja do przechowywania tworzonych cyfr

.code
ciag_liczb PROC
    pusha                           ; odlozenie na stos rejestrow
    xor eax, eax                    ; wyzerowanie rejestru EAX

    mov ecx, 0                      ; licznik petli
    mov eax, 1                      ; pierwszy element do wyswietlenia

    petla:
    call wyswietl_EAX               ; wyswietla liczbe z EAX
    inc ecx
    add eax, ecx
    cmp ecx, 50
    jne petla

    popa
    ret
ciag_liczb ENDP

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
    call ciag_liczb

	push 0
	call _ExitProcess@4
_main ENDP
END

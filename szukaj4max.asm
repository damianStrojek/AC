comment |
#include <stdio.h>

int szukaj4_max(int a, int b, int c, int d);

int main() {
	int v, x, y, z, wynik;
	printf("\nProsze podac cztery liczby calkowite ze znakiem: ");
	scanf_s("%d %d %d %d", &v, &x, &y, &z, 32);

	wynik = szukaj4_max(v, x, y, z);

	printf("\nSposrod podanych liczb %d ,%d, %d, %d, liczba %d jest najwieksza", v, x, y, z, wynik);

	return 0;
}
|

.686
.model flat

public _szukaj4_max

.code
_szukaj4_max PROC
	push ebp
	mov ebp, esp

	; v >= x
	mov eax, [ebp+8]
	cmp eax, [ebp+12]
	jge v_wieksza
	; x >= y
	mov eax, [ebp+12]
	cmp eax, [ebp+16]
	jge x_wieksza
	; y >= z
	mov eax, [ebp+16]
	cmp eax, [ebp+20]
	jge zakoncz
	jmp wpisz_z

wpisz_z:
	mov eax, [ebp+20]

zakoncz:
	pop ebp
	ret

v_wieksza:
	cmp eax, [ebp+16]
	jge sprawdz_z
	mov eax, [ebp+16]
	cmp eax, [ebp+20]
	jge zakoncz
	jmp wpisz_z

x_wieksza:
	cmp eax, [ebp+20]
	jge zakoncz
	jmp wpisz_z

sprawdz_z:
	cmp eax, [ebp+20]
	jge zakoncz
	jmp wpisz_z

_szukaj4_max ENDP
END

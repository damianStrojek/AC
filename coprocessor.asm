#include <stdio.h>

float objetosc_stozka(unsigned int big_r, unsigned int small_r, float h);

int main() {

	float wynik = objetosc_stozka(7, 3, 4.2f);
	printf("\\nWynik = %f", wynik);

	return 0;
}

.686
.XMM
.model flat

public _objetosc_stozka

.data
three dd 3.0

.code
_objetosc_stozka PROC
	push ebp
	mov ebp, esp
	finit

	fild dword ptr [ebp+8]
	fild dword ptr [ebp+8]
	fmul							; R^2

	fild dword ptr [ebp+12]
	fild dword ptr [ebp+8]
	fmul
	fadd							; R^2 + Rr

	fild dword ptr [ebp+12]
	fild dword ptr [ebp+12]
	fmul
	fadd							; R^2 + Rr + r^2

	fld dword ptr [ebp+16]
	fmul
	fldpi
	fmul
	fld dword ptr three
	fdiv

	pop ebp
	ret
_objetosc_stozka ENDP
END

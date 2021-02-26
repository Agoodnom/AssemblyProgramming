COMMENT @
	Programmer Name : Nam Ju Hyeong
	Student ID : 20171630
	Function : eax = 45 * x1 + 16 * x2 + 28 * x3
	Input : x1,x2,x3
	Ouput : eax
@


INCLUDE Irvine32.inc
.data
INCLUDE CSE3030_PHW02.inc
.code
main PROC
	mov ebx, x1; ebx = (2^0)*x1
	mov eax, ebx; eax = (2^0)*x1
	add ebx, ebx; ebx = (2^1)*x1
	add ebx, ebx; ebx = (2^2)*x1
	add eax, ebx; eax = (2^0+2^2)*x1
	add ebx, ebx; ebx = (2^3)*x1
	add eax, ebx; eax = (2^0+2^2+2^3)*x1
	add ebx, ebx; ebx = (2^4)*x1
	add ebx, ebx; ebx = (2^5)*x1
	add eax, ebx; eax = (2^0+2^2+2^3+2^5)*x1 = (45)*x1

	mov ebx, x2; ebx = (2^0)*x2
	add ebx, ebx; ebx = (2^1)*x2
	add ebx, ebx; ebx = (2^2)*x2
	add ebx, ebx; ebx = (2^3)*x2
	add ebx, ebx; ebx = (2^4)*x2
	add eax, ebx; eax = (45)*x1 + (2^4)*x2 = (45)*x1 + (16)*x2

	mov ebx, x3; ebx = (2^0)*x3
	add ebx, ebx; ebx = (2^1)*x3
	add ebx, ebx; ebx = (2^2)*x3
	add eax, ebx; eax = (45)*x1 + (16)*x2 + (2^2)*x3
	add ebx, ebx; ebx = (2^3)*x3
	add eax, ebx; eax = (45)*x1 + (16)*x2 + (2^2+2^3)*x3
	add ebx, ebx; ebx = (2^4)*x3
	add eax, ebx; eax = (45)*x1 + (16)*x2 + (2^2+2^3+2^4)*x3 = (45)*x1 + (16)*x2 + (28)*x3

	call WriteInt

	exit
main ENDP
END main
INCLUDE Irvine32.inc
.data
	prompt1 BYTE "Enter number(<ent> to exit) :",0
	prompt2 BYTE "Bye!",0
.code
fibo_recursion proc
;computes fib(eax-1) -->eax:do not call with eax==0
	cmp eax,1		;n<=1
	jbe last		
	dec eax			;=n-1
	push eax		;save n-1
	call fibo_recursion		;computing fib(n-1)to eax
	xchg eax,0[esp]	;swap fib(n-1)for saved n-1
	dec eax			; =n-2
	call fibo_recursion		;computing fib(n-2) to eax
	pop ecx			;=fib(n-1)
	add eax,ecx		;=fib(n-1)+fib(n-2)
last:
	ret
fibo_recursion endp

fibonacci proc
	push ebx
	push edx

	mov ecx,eax
	dec ecx
	cmp ecx,0
	jle Last
	mov ebx,0
	mov edx,1
L1:
	mov eax,ebx
	add eax,edx

	mov ebx,edx
	mov edx,eax
loop L1
Last:
	pop edx
	pop ebx
	ret
fibonacci endp


main PROC
	L1:
		mov edx,OFFSET prompt1
		call WriteString
		call Crlf
		call ReadInt

		cmp eax, 0
		je Last					;첫 문자가 0이면 Last로 이동(종료 조건)

		call fibonacci
		call WriteDec
		call Crlf
	jmp L1
	Last:
		mov edx, OFFSET prompt2
		call WriteString				;prompt2 출력
	exit
main ENDP
END main
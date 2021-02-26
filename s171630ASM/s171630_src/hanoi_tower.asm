INCLUDE Irvine32.inc
.data
	prompt1 BYTE "Enter number(<ent> to exit) :",0
	prompt2 BYTE "Bye!",0
.code

hanoi PROC
	push eax
	push ebx
	push ecx
	push edx

	cmp eax,1
	ja recurse

;move 1 from source to dest
	push eax
	mov al,bl		;source
	call WriteChar
	mov al,' '	
	call WriteChar
	mov al,cl		;dest
	call WriteChar
	mov al,' '	
		call WriteChar
	inc edi
	mov eax,edi
	call WriteDec
	call Crlf
	pop eax
	jmp Last

	recurse:
	;move n-1 from source to temp
		dec eax		;n-1
		xchg cl,dl	;swap dest and temp
		call hanoi
		xchg cl,dl	;swap back dest and temp
	
	;move 1 from source to dest
		push eax
		mov al,bl		;source
		call WriteChar
		mov al,' '	
		call WriteChar
		mov al,cl		;dest
		call WriteChar
		mov al,' '	
		call WriteChar
		inc edi
		mov eax,edi
		call WriteDec
		call Crlf
		pop eax

	;move n-1 from temp to dest
		xchg bl,dl
		call hanoi

	Last:
		pop edx
		pop ecx
		pop ebx
		pop eax
	ret
hanoi ENDP


main PROC
	L1:
		mov edx,OFFSET prompt1
		call WriteString
		call Crlf
		call ReadInt

		cmp eax, 0
		je Last					;첫 문자가 0이면 Last로 이동(종료 조건)

		mov bl, 'A'			;from A
		mov cl, 'C'			;to C
		mov dl, 'B'			;temp B
		
		mov edi,0
		call hanoi
	jmp L1
	Last:
		mov edx, OFFSET prompt2
		call WriteString				;prompt2 출력
	exit
main ENDP
END main
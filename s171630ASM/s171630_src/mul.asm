INCLUDE Irvine32.inc
.data
	BUF_SIZE EQU 255
	inBuffer BYTE BUF_SIZE DUP(?)
	intArray SDWORD BUF_SIZE/2 DUP(?)
	intArrayN DWORD 0
	temp DWORD 10 DUP(0)
	prompt1 BYTE "Enter number(<ent> to exit) :",0
	prompt2 BYTE "Bye!",0
.code

Int_Extraction PROC
	; Extract integers from a string
	; Call args: EDX = offset of string
	;			ESI = offset of intArray(SDWORD)
	; Return arg: EDI = intArrayN

	push eax							;save register
	push ecx

	mov edi, 0							;edi: 얻은 숫자의 개수

	FindNum:							;FindNum: ' '가 아닌 문자를 찾는 반복문
		mov al,BYTE PTR [edx]				
		cmp al,' '							
		jne L2							;' '가 아니면 L2로 이동
		inc edx
	jmp FindNum

	L2:
		cmp al,0
		je Int_Extraction_End			;문자열에 마지막에 도착하면 Int_Extraction_End로 이동

		mov ecx, 10
		call ParseInteger32				;문자열의 숫자를 정수형으로 바꿔주는 함수
		mov [esi], eax					;[esi]에 문자열에서 얻은 숫자를 저장
		inc edi							
		add esi,4

	FindSpace:							;FindSpace: ' '가 나올때까지 찾는 반복문
		mov al,BYTE PTR [edx]
		cmp al,' '
		je FindNum						;' '이면 FindNum으로 이동
		cmp al,0
		je Int_Extraction_End			;문자열에 마지막에 도착하면 Int_Extraction_End로 이동
		inc edx
	jmp FindSpace

	Int_Extraction_End:

	pop ecx								;restore registers
	pop eax

		ret
Int_Extraction ENDP

main PROC
	L1:
		mov esi, OFFSET intArray
		mov edx,OFFSET prompt1
		call WriteString
		call Crlf
		mov edx, OFFSET inBuffer
		mov ecx, BUF_SIZE
		call ReadString					;문자열 입력

		mov al,BYTE PTR [edx]
		cmp al, 0
		je Last							;첫 문자가 0이면 Last로 이동(종료 조건)

		call Int_Extraction
		mov intArrayN, edi
		mov ecx,intArrayN
		mov esi,0
		mov eax,1
		mulloop:
			mov ebx,intArray[esi]
			mul ebx
			add esi,4
		loop mulloop
		call WriteDec
		call Crlf
		compute:
			mov edx,0
			mov ecx,10
			div ecx
			inc temp[edx*4]
		cmp eax,0
		jnz compute

		mov ecx,10
		mov edx,0
		mov bl,'0'
		print:
			push eax
			mov al,bl
			call WriteChar
			inc bl
			mov al,':'
			call WriteChar
			mov al,' '
			call WriteChar
			pop eax
			mov eax,temp[edx]
			call WriteDec
			add edx,4
			cmp edx, 40
			jz print_end
			mov al,','
			call WriteChar
			mov al,' '
			call WriteChar
			print_end:
		loop print
		call Crlf
		
		mov ecx,10
		mov edx,0
		init_temp:
			mov temp[edx],0
			add edx,4
		loop init_temp

	jmp L1
	Last:
		mov edx, OFFSET prompt2
		call WriteString				;prompt2 출력
	exit
main ENDP
END main
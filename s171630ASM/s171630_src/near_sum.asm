INCLUDE Irvine32.inc
.data
	BUF_SIZE EQU 255
	inBuffer BYTE BUF_SIZE DUP(?)
	intArray SDWORD BUF_SIZE/2 DUP(?)
	intArrayN DWORD 0
	k DWORD 0
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
		je Last	
		call Int_Extraction
		cmp edi,1
		jnz L1
		mov eax, intArray[0]
		mov k,eax

		mov edx, OFFSET inBuffer
		mov ecx, BUF_SIZE
		call ReadString					;문자열 입력

		mov al,BYTE PTR [edx]
		cmp al, 0
		je Last							;첫 문자가 0이면 Last로 이동(종료 조건)

		call Int_Extraction
		mov intArrayN, edi
		cmp edi,0
		jle L1						

;solve start
		mov ecx, intArrayN				;outloop을 intArrayN만큼 반복
		dec ecx			
		mov esi,1000					;esi:최솟값 , 비교를 위해 큰 값을 넣어준다.
		mov edx,0
	outloop:							;각집의 각 집들 간의 거리의 합들 중 최소값을 esi에 저장하는 loop
		mov ebx, intArray[edx]
		mov ebp,0						;k에가까운 값
		push ecx
		push edx
		add edx, 4
		distance_sum:
			mov eax, ebx				
			add eax, intArray[edx]		;두 점의 합
			sub eax,k
			test eax, 80000000h
			jz next
			neg eax						;뺀값이 -면 +로 바꿔준다 즉,절댓값을 해주는것과 동일
			next:
			cmp esi,eax
			jle pass
			mov esi,eax
			cmp esi,0
			jz next_step
			pass:
			add edx,4
		loop distance_sum
		pop edx
		pop ecx
		add edx,4
	loop outloop
;----------------------------------------------------------
		next_step:
		mov ecx, intArrayN				;outloop을 intArrayN만큼 반복
		dec ecx
		mov edx,0
	outloop2:							;각집의 각 집들 간의 거리의 합들 중 최소값을 esi에 저장하는 loop
		mov ebx, intArray[edx]
		mov ebp,0						;k에가까운 값
		push ecx
		push edx
		add edx, 4
		distance_sum2:
			mov eax, ebx				
			add eax, intArray[edx]		;두 점의 합
			sub eax,k
			test eax, 80000000h
			jz next2
			neg eax						;뺀값이 -면 +로 바꿔준다 즉,절댓값을 해주는것과 동일
			next2:
			cmp esi,eax
			jnz pass2
			mov al,'('
			call WriteChar
			mov eax,ebx
			call WriteDec
			mov al,','
			call WriteChar
			mov eax,intArray[edx]
			call WriteDec
			mov al,')'
			call WriteChar
			mov al,' '
			call WriteChar
			pass2:
			add edx,4
		loop distance_sum2
		pop edx
		pop ecx
		add edx,4
	loop outloop2
	call Crlf

;solve end




	jmp L1
	Last:
		mov edx, OFFSET prompt2
		call WriteString				;prompt2 출력
	exit
main ENDP
END main
INCLUDE Irvine32.inc
.data
	BUF_SIZE EQU 248
	inBuffer BYTE BUF_SIZE DUP(?)
	intArray SDWORD BUF_SIZE/2 DUP(?)
	intArrayN DWORD 0
	prompt1 BYTE "Enter Ruby Sizes :",0
	prompt2 BYTE "Bye!",0
	prompt3 BYTE "Max Profit = ",0

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

insertion_sort PROC
	; Sort array
	; Call args: ESI = offset of intArray(SDWORD)
	;			EDI = intArrayN(정수의 개수)
	cmp edi, 1				
	jle sort_exit						;정수의 개수가 1이하면 종료

	push eax							;save register
	push ebx
	push ecx
	push edx
	push ebp

	mov ecx, edi						;copy array size
	mov ebp, 4

	for_loop:
		;edx = temp, ebp = i, ebx = j
		mov edx, [esi+ebp]				;temp = array[i]
		mov ebx, ebp
		sub ebx, 4						;j = i-1
	while_loop:
		cmp edx,[esi+ebx]
		jge exit_while_loop				;temp < array[j]

		;array[j+1] = array[j]
		mov eax, [esi+ebx]
		mov [esi+ebx+4], eax
		sub ebx, 4						;j = j-1
		cmp ebx, 0						
		jge while_loop					;j>= 0
	exit_while_loop:
		;array[j+1] = temp
		mov [esi+ebx+4], edx
		add ebp, 4						;i = i+1
		dec ecx
		cmp ecx,1
		jne for_loop					;if ecx==1, end

	pop ebp								;restore registers
	pop edx
	pop ecx
	pop ebx
	pop eax
	sort_exit:
	ret
insertion_sort ENDP

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
		cmp edi,0
		jle L1						

;solve start
		mov esi, OFFSET intArray
		mov edi, intArrayN
		call insertion_sort
		mov ecx,intArrayN
		mov edi,0
		mov esi,0
		mov ebx,intArrayN
	mulloop:
			mov eax,intArray[esi]
			mul ebx
			add esi,4
			dec ebx

			cmp edi, eax
			jg pass 
			mov edi, eax
			pass:
		loop mulloop

		mov edx,OFFSET prompt3
		call WriteString
		mov eax, edi
		call WriteDec
		call Crlf
		call Crlf


;solve end




	jmp L1
	Last:
		mov edx, OFFSET prompt2
		call WriteString				;prompt2 출력
	exit
main ENDP
END main
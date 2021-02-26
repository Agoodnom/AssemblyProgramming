INCLUDE Irvine32.inc
.data
	BUF_SIZE EQU 255
	inBuffer BYTE BUF_SIZE DUP(?)
	intArray1 SDWORD BUF_SIZE/2 DUP(?)
	intArray1N DWORD 0
	intArray2 SDWORD BUF_SIZE/2 DUP(?)
	intArray2N DWORD 0
	cap DWORD 0
	intArray3N

	prompt1 BYTE "Enter Capacity : ",0
	prompt3 BYTE "Enter Weights : ",0
	prompt4 BYTE "Enter Profits(the same # of weights) : ",0
	prompt5 BYTE "Max Profit = : ",0
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

picnic PROC
	push ebp
	mov esp,ebp
	sub esp, 4

	push ebx
	push edi
	push esi

	mov 
	mov eax,[ebp+4]
	mov ecx,[ebp+8]
	mov edx,[ebp+12]
	mov esi,[ebp+16]
	mov ebx,[ebp+20]

	mov edx, [ebp-4]

	mov edi,0
	for_loop:
		mov eax, [ebp+4]
		mov eax, [ebp+8]
		mov eax, [ebp+12]

		cmp edi,esi
		jae end_for_loop

		cmp 


picnic ENDP



main PROC
	L1:
		mov edx,OFFSET prompt1
		call WriteString

		mov edx, OFFSET inBuffer
		mov ecx, BUF_SIZE
		call ReadString					;문자열 입력

		mov al,BYTE PTR [edx]
		cmp al, 0
		je Last							;첫 문자가 0이면 Last로 이동(종료 조건)

		mov esi, OFFSET intArray1
		call Int_Extraction
		mov eax, intArray1[0]
		mov cap, eax
		cmp edi,0
		jle L1
		
		mov edx,OFFSET prompt3
		call WriteString
		call Crlf

		mov edx, OFFSET inBuffer
		mov ecx, BUF_SIZE
		call ReadString					;문자열 입력

		mov al,BYTE PTR [edx]
		cmp al, 0
		je Last							;첫 문자가 0이면 Last로 이동(종료 조건)

		mov esi, OFFSET intArray1
		call Int_Extraction
		mov intArray1N, edi
		cmp edi,0
		jle L1	

		mov edx,OFFSET prompt4
		call WriteString
		call Crlf

		mov edx, OFFSET inBuffer
		mov ecx, BUF_SIZE
		call ReadString					;문자열 입력

		mov al,BYTE PTR [edx]
		cmp al, 0
		je Last							;첫 문자가 0이면 Last로 이동(종료 조건)

		mov esi, OFFSET intArray2
		call Int_Extraction
		mov intArray2N, edi
		cmp edi,0
		jle L1	

;solve start
		





;solve end




	jmp L1
	Last:
		mov edx, OFFSET prompt2
		call WriteString				;prompt2 출력
	exit
main ENDP
END main
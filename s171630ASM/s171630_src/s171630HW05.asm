COMMENT @
	Programmer Name : Nam Ju Hyeong
	Student ID : 20171630
	Function : List sum
	Input :	number list
	Ouput : sum
@

INCLUDE Irvine32.inc

.data
BUF_SIZE EQU 250
inBuffer BYTE BUF_SIZE DUP(?)
intArray SDWORD BUF_SIZE/2 DUP(?)
intArrayN DWORD 0
prompt1 BYTE "Enter number(<ent> to exit) :",0
prompt2 BYTE "Bye!",0
.code
Int_Extraction PROC
	; Extract integers from a string
	; Call args: EDX = offset of string
	;			ESI = offset of intArray(SWORD)
	; Return arg: EDI = intArrayN

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
		ret
Int_Extraction ENDP

main PROC
	; Receives: EAX, EBX, ECX, EDX, ESI
	; Returns: EAX = SUM
	; Requires: nothing

	L1:
		mov esi, OFFSET intArray
		mov edx, OFFSET prompt1				
		call WriteString				;prompt1 출력
		call Crlf						;개행
		mov edx, OFFSET inBuffer
		mov ecx, BUF_SIZE
		call ReadString					;문자열 입력

		mov al,BYTE PTR [edx]
		cmp al, 0
		je Last							;첫 문자가 0이면 Last로 이동(종료 조건)

	call Int_Extraction					;정수추출을 위한 함수 호출

		mov intArrayN, edi				;Int_Extraction 에서 얻은 정수의 수를 저장
		mov ecx, intArrayN				;sum을 intArrayN만큼 반복
		cmp ecx,0
		je L1							;intArrayN이 0이면 L1으로 이동
		mov ebx, 0
		mov eax, 0
	sum:								;sum: 합계를 구하는 반복문
		add eax, intArray[ebx]
		add ebx, 4
	loop sum

		test eax,80000000h
		jnz negative					;eax가 음수이면 negative로 이동

		call WriteDec					;eax가 양수일때 출력
		call Crlf						;개행
	jmp L1

	negative:
		call WriteInt					;eax가 음수일때 출력
		call Crlf						;개행
	jmp L1

	Last:
		mov edx, OFFSET prompt2
		call WriteString				;prompt2 출력
	exit
main ENDP
END main
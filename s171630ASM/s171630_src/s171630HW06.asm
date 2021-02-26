COMMENT @
	Programmer Name : Nam Ju Hyeong
	Student ID : 20171630
	Function : gildong's store
	Input :	number list
	Ouput : 가게와 각 집들 간의 거리의 합
	How to solve a problem :
		1. string을 입력받고 정수를 추출한다.
		2. 특정 정수와 다른 정수와의 차의 절댓값(거리)의 합들 중 최솟값을 구한다.
		3. 최솟값을 출력한다.
@

INCLUDE Irvine32.inc

.data
BUF_SIZE EQU 255
inBuffer BYTE BUF_SIZE DUP(?)
intArray SDWORD BUF_SIZE/2 DUP(?)
intArrayN DWORD 0
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

		call Int_Extraction				;정수추출을 위한 함수 호출

		mov intArrayN, edi				;Int_Extraction 에서 얻은 정수의 수를 저장
		mov ecx, intArrayN				;outloop을 intArrayN만큼 반복
		cmp ecx,0
		je L1							;intArrayN이 0이면 L1으로 이동
		mov esi,10000					;esi:최솟값 , 비교를 위해 큰 값을 넣어준다.
		mov edx,0
	outloop:							;각집의 각 집들 간의 거리의 합들 중 최소값을 esi에 저장하는 loop
		mov ebx, intArray[edx]
		mov ebp,0						;거리의 합
		push ecx
		push edx
		mov ecx, intArrayN				;distance_sum을 intArrayN만큼 반복
		mov edx, 0
		distance_sum:
			mov eax, ebx				
			sub eax, intArray[edx]		;각 잡과의 거리
			test eax, 80000000h
			jz next
			neg eax						;뺀값이 -면 +로 바꿔준다 즉,절댓값을 해주는것과 동일
			next:
			add ebp, eax				;ebp에 각 집과의 거리들을 더해준다.
			add edx,4
		loop distance_sum
		pop edx
		pop ecx
		cmp esi, ebp
		jle pass						;if esi<=ebp, pass
		mov esi, ebp					;ebp가 현재 esi보다 작으면 esi를 ebp로 갱신
		pass:
		add edx,4
	loop outloop

		mov eax, esi					
		call WriteDec					;출력
		call Crlf						;개행
	jmp L1



	Last:
		mov edx, OFFSET prompt2
		call WriteString				;prompt2 출력
	exit
main ENDP
END main
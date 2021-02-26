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

	mov edi, 0							;edi: ���� ������ ����

	FindNum:							;FindNum: ' '�� �ƴ� ���ڸ� ã�� �ݺ���
		mov al,BYTE PTR [edx]				
		cmp al,' '							
		jne L2							;' '�� �ƴϸ� L2�� �̵�
		inc edx
	jmp FindNum

	L2:
		cmp al,0
		je Int_Extraction_End			;���ڿ��� �������� �����ϸ� Int_Extraction_End�� �̵�

		mov ecx, 10
		call ParseInteger32				;���ڿ��� ���ڸ� ���������� �ٲ��ִ� �Լ�
		mov [esi], eax					;[esi]�� ���ڿ����� ���� ���ڸ� ����
		inc edi							
		add esi,4

	FindSpace:							;FindSpace: ' '�� ���ö����� ã�� �ݺ���
		mov al,BYTE PTR [edx]
		cmp al,' '
		je FindNum						;' '�̸� FindNum���� �̵�
		cmp al,0
		je Int_Extraction_End			;���ڿ��� �������� �����ϸ� Int_Extraction_End�� �̵�
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
	;			EDI = intArrayN(������ ����)
	cmp edi, 1				
	jle sort_exit						;������ ������ 1���ϸ� ����

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
		call ReadString					;���ڿ� �Է�

		mov al,BYTE PTR [edx]
		cmp al, 0
		je Last							;ù ���ڰ� 0�̸� Last�� �̵�(���� ����)

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
		call WriteString				;prompt2 ���
	exit
main ENDP
END main
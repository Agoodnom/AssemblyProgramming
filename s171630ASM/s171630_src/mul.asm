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
		call WriteString				;prompt2 ���
	exit
main ENDP
END main
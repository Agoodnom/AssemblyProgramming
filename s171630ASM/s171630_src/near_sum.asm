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
		je Last	
		call Int_Extraction
		cmp edi,1
		jnz L1
		mov eax, intArray[0]
		mov k,eax

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
		mov ecx, intArrayN				;outloop�� intArrayN��ŭ �ݺ�
		dec ecx			
		mov esi,1000					;esi:�ּڰ� , �񱳸� ���� ū ���� �־��ش�.
		mov edx,0
	outloop:							;������ �� ���� ���� �Ÿ��� �յ� �� �ּҰ��� esi�� �����ϴ� loop
		mov ebx, intArray[edx]
		mov ebp,0						;k������� ��
		push ecx
		push edx
		add edx, 4
		distance_sum:
			mov eax, ebx				
			add eax, intArray[edx]		;�� ���� ��
			sub eax,k
			test eax, 80000000h
			jz next
			neg eax						;������ -�� +�� �ٲ��ش� ��,������ ���ִ°Ͱ� ����
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
		mov ecx, intArrayN				;outloop�� intArrayN��ŭ �ݺ�
		dec ecx
		mov edx,0
	outloop2:							;������ �� ���� ���� �Ÿ��� �յ� �� �ּҰ��� esi�� �����ϴ� loop
		mov ebx, intArray[edx]
		mov ebp,0						;k������� ��
		push ecx
		push edx
		add edx, 4
		distance_sum2:
			mov eax, ebx				
			add eax, intArray[edx]		;�� ���� ��
			sub eax,k
			test eax, 80000000h
			jz next2
			neg eax						;������ -�� +�� �ٲ��ش� ��,������ ���ִ°Ͱ� ����
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
		call WriteString				;prompt2 ���
	exit
main ENDP
END main
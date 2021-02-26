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
		ret
Int_Extraction ENDP

main PROC
	; Receives: EAX, EBX, ECX, EDX, ESI
	; Returns: EAX = SUM
	; Requires: nothing

	L1:
		mov esi, OFFSET intArray
		mov edx, OFFSET prompt1				
		call WriteString				;prompt1 ���
		call Crlf						;����
		mov edx, OFFSET inBuffer
		mov ecx, BUF_SIZE
		call ReadString					;���ڿ� �Է�

		mov al,BYTE PTR [edx]
		cmp al, 0
		je Last							;ù ���ڰ� 0�̸� Last�� �̵�(���� ����)

	call Int_Extraction					;���������� ���� �Լ� ȣ��

		mov intArrayN, edi				;Int_Extraction ���� ���� ������ ���� ����
		mov ecx, intArrayN				;sum�� intArrayN��ŭ �ݺ�
		cmp ecx,0
		je L1							;intArrayN�� 0�̸� L1���� �̵�
		mov ebx, 0
		mov eax, 0
	sum:								;sum: �հ踦 ���ϴ� �ݺ���
		add eax, intArray[ebx]
		add ebx, 4
	loop sum

		test eax,80000000h
		jnz negative					;eax�� �����̸� negative�� �̵�

		call WriteDec					;eax�� ����϶� ���
		call Crlf						;����
	jmp L1

	negative:
		call WriteInt					;eax�� �����϶� ���
		call Crlf						;����
	jmp L1

	Last:
		mov edx, OFFSET prompt2
		call WriteString				;prompt2 ���
	exit
main ENDP
END main
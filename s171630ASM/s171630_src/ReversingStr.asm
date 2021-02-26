INCLUDE Irvine32.inc
.data
	BUF_SIZE EQU 255
	inBuffer BYTE BUF_SIZE DUP(?)
	prompt1 BYTE "Enter number(<ent> to exit) :",0
	prompt2 BYTE "Bye!",0
.code

main PROC
	L1:
		mov edx,OFFSET prompt1
		call WriteString
		call Crlf

		mov edx, OFFSET inBuffer
		mov ecx, BUF_SIZE
		call ReadString					;���ڿ� �Է�

		mov al,BYTE PTR [edx]
		cmp al, 0
		je Last							;ù ���ڰ� 0�̸� Last�� �̵�(���� ����)				

;solve start
		mov ebx,-1
	find_num:							;������ ���� ã�Ƽ� ebx�� ����
		add ebx,1
		mov al,inBuffer[ebx]
		cmp al,0
		jnz find_num

	mov ecx,ebx
	mov esi,0

	loop1:
		mov al, inBuffer[esi]

		push eax
		inc esi
		loop loop1

		mov ecx, ebx
		mov esi,0

	loop2:
		pop eax
		mov inBuffer[esi],al
		inc esi
		loop loop2

		mov edx, OFFSET inBuffer
		call WriteString
		call Crlf


;solve end




	jmp L1
	Last:
		mov edx, OFFSET prompt2
		call WriteString				;prompt2 ���
	exit
main ENDP
END main
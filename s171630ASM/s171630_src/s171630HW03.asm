COMMENT @
	Programmer Name : Nam Ju Hyeong
	Student ID : 20171630
	Function : Caesar cipher(de-cipher)
	Input :	Num_Str, Cipher_Str
	Ouput : deCipher_Str
@


INCLUDE Irvine32.inc
.data
filename byte "0s171630_out.txt",0
filehandle handle ?
BUFSIZE = 5000
deCipher_Str BYTE BUFSIZE DUP(?)
bytesWritten DWORD ?
L	BYTE "QRSTUVWXYZABCDEFGHIJKLMNOP",0		
;k=10�� �����̹Ƿ� ���ڿ��� �̸� 10��ŭ �̵��ѻ��¿��� �����ϸ� ��ȣȭ�������� -10��ŭ ã�ư� �ʿ䰡 ����.
;���ǹ��� ���� �ʾƵ� ��밡��
INCLUDE CSE3030_PHW03.inc

.code
main PROC
	mov esi, 0
	mov edx, 0
	mov ecx, Num_Str						;ecx = Num_Str
	L1:
		push ecx							;����loop�� ���� ecx�� push
		mov ecx, 10							;ecx = 10
		L2:									
			mov AL, Cipher_Str[esi]			;AL = Cipher_Str[esi]
			sub AL, 'A'						;AL = Cipher_Str[esi] - 'A'
			movzx eax, AL					
			mov BL, L[eax]					;BL = L[Cipher_Str[esi] - 'A']  EX)Cipher_Str[esi] == 'A'�̸� L[0]�̰� L[0]�� �̹� A����-10��ŭ�̵��� ���ĺ��� Q�̴�.
			mov deCipher_Str[edx], BL				;deCipher_Str[edx] = BL
			inc esi
			inc edx
		loop L2								;10��ŭ �ݺ�
		inc esi
		inc edx
		mov BL, 0ah							;BL = LF
		mov deCipher_Str[edx], BL					;deCipher_Str[edx] = BL
		inc edx
		mov BL, 0dh							;BL = CR
		mov deCipher_Str[edx], BL					;deCipher_Str[edx] = BL
		pop ecx								;������ push�ص� ecx�� pop�Ͽ� ���
	loop L1									;Num_Str��ŭ �ݺ�

	; file open
	mov  edx, OFFSET filename
	call CreateOutputFile
	mov  filehandle, EAX

	; write
	mov ebx,0
	add ebx, Num_Str	;ebx = n
	add ebx, ebx		;ebx = 2n
	add ebx, ebx		;ebx = 4n
	mov esi, ebx		;esi = 4n
	add ebx, ebx		;ebx = 8n
	add esi, ebx		;esi = 4n + 8n = 12n
	mov  eax,fileHandle
	mov  edx,OFFSET deCipher_Str
	mov  ecx,esi		;12n��ŭ ���
	call WriteToFile
	mov  bytesWritten,eax

	; file close
	mov  eax,fileHandle
	call CloseFile

	exit
main ENDP
END main
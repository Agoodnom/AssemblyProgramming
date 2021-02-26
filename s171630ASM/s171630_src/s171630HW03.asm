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
;k=10이 고정이므로 문자열을 미리 10만큼 이동한상태에서 시작하면 복호화과정에서 -10만큼 찾아갈 필요가 없다.
;조건문을 쓰지 않아도 사용가능
INCLUDE CSE3030_PHW03.inc

.code
main PROC
	mov esi, 0
	mov edx, 0
	mov ecx, Num_Str						;ecx = Num_Str
	L1:
		push ecx							;이중loop를 위해 ecx를 push
		mov ecx, 10							;ecx = 10
		L2:									
			mov AL, Cipher_Str[esi]			;AL = Cipher_Str[esi]
			sub AL, 'A'						;AL = Cipher_Str[esi] - 'A'
			movzx eax, AL					
			mov BL, L[eax]					;BL = L[Cipher_Str[esi] - 'A']  EX)Cipher_Str[esi] == 'A'이면 L[0]이고 L[0]은 이미 A에서-10만큼이동한 알파벳인 Q이다.
			mov deCipher_Str[edx], BL				;deCipher_Str[edx] = BL
			inc esi
			inc edx
		loop L2								;10만큼 반복
		inc esi
		inc edx
		mov BL, 0ah							;BL = LF
		mov deCipher_Str[edx], BL					;deCipher_Str[edx] = BL
		inc edx
		mov BL, 0dh							;BL = CR
		mov deCipher_Str[edx], BL					;deCipher_Str[edx] = BL
		pop ecx								;위에서 push해둔 ecx를 pop하여 사용
	loop L1									;Num_Str만큼 반복

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
	mov  ecx,esi		;12n만큼 출력
	call WriteToFile
	mov  bytesWritten,eax

	; file close
	mov  eax,fileHandle
	call CloseFile

	exit
main ENDP
END main
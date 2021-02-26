INCLUDE Irvine32.inc
.data
	BUF_SIZE EQU 255
	inBuffer BYTE BUF_SIZE DUP(?)
	prompt1 BYTE "Enter a string : ",0
	prompt2 BYTE "Bye!",0
.code

print_buffer_from_to PROC
    ; Input:
    ;   esi = starting index
    ;   edi = end index

    xor     eax,    eax
    Print_Front_Spaces_Loop:
        cmp     eax,    esi
        jge     Print_Characters_Loop
		push eax
        mov     al,     ' '
        call    WriteChar
		pop eax
        inc     eax
        jmp     Print_Front_Spaces_Loop
    Print_Characters_Loop:
        cmp     eax,    edi
        jg      Print_Characters_End
		push eax
        mov     al, inbuffer[eax]
        call    WriteChar
		pop eax
        inc     eax
        jmp     Print_Characters_Loop
    Print_Characters_End:
        call Crlf
        ret
print_buffer_from_to ENDP

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

		mov ebx,-1
	find_num:							;문자의 개수 찾아서 ebx에 저장
		add ebx,1
		mov al,inBuffer[ebx]
		cmp al,0
		jnz find_num

		cmp ebx, 2
		jle except

		mov esi,0
		mov edi,ebx
		dec edi

    String_Decrement_Loop:
        push    esi
        push    edi
        call    print_buffer_from_to
        pop     edi
        pop     esi

        dec     edi
        inc     esi
        cmp     esi,    edi
        jg      String_Decrement_End
        jmp     String_Decrement_Loop
    String_Decrement_End:
	
	add edi,2
	sub esi,2
	jmp	String_Increment_Loop
	String_Increment_Loop:
		push esi
        push edi
        call print_buffer_from_to
        pop edi
        pop esi
        inc     edi
        dec     esi
        cmp     esi,    0
        jnge    String_Increment_End
        jmp     String_Increment_Loop
    String_Increment_End:
	call Crlf
	jmp L1

	except:
		mov edx,OFFSET inBuffer
		call WriteString
		call Crlf
		call Crlf

	jmp L1
	Last:
		mov edx, OFFSET prompt2
		call WriteString				;prompt2 출력
	exit
main ENDP
END main
INCLUDE Irvine32.inc
.data
	BUF_SIZE EQU 255
	inBuffer BYTE BUF_SIZE DUP(?)
	prompt1 BYTE "Enter number(<ent> to exit) :",0
	prompt2 BYTE "Bye!",0
.code

diamond_idx PROC
    ; starting/ending index for printing diamond
    ; Input:
    ;   eax = diamond size
    ; Output:
    ;   esi = starting index
    ;   edi = end index

    push    eax
    push    ecx
    push    edx

    ; ending index = floor(n/2)
    mov     ecx,    2
    push    eax
    xor     edx,    edx
    div     ecx
    mov     edi,    eax

    ; starting index = floor((n-1)/2)
    pop     eax
    dec     eax
    xor     edx,    edx
    div     ecx
    mov     esi,    eax

    pop     edx
    pop     ecx
    pop     eax

    ret
diamond_idx ENDP

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
		call Crlf
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


		mov eax,ebx
		mov ecx,eax
		call diamond_idx
		push ecx
	Diamond_Increment_Loop:
		push esi
        push edi
        call print_buffer_from_to
        pop edi
        pop esi
		pop ecx
        cmp ecx,2
        jbe Diamond_Decrement_End       ; if string length <= 2
        push ecx

        inc     edi
        dec     esi
        cmp     esi,    0
        jnge    Diamond_Increment_End
        jmp     Diamond_Increment_Loop
    Diamond_Increment_End:
        mov     esi,    0
        pop     edi
        inc     esi
        sub     edi,    2
        
        jmp     Diamond_Decrement_Loop
    Diamond_Decrement_Loop:
        push    esi
        push    edi
        call    print_buffer_from_to
        pop     edi
        pop     esi

        dec     edi
        inc     esi
        cmp     esi,    edi
        jg      Diamond_Decrement_End
        jmp     Diamond_Decrement_Loop
    Diamond_Decrement_End:


	jmp L1
	Last:
		mov edx, OFFSET prompt2
		call WriteString				;prompt2 출력
	exit
main ENDP
END main
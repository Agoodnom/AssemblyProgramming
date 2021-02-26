COMMENT @
	Programmer Name : Nam Ju Hyeong
	Student ID : 20171630
	Function : A hiking trail
	Input :	TN, CASE, HEIGHT
	Ouput : Altitude difference of uphill(MAX gap)
@


INCLUDE Irvine32.inc
.data
INCLUDE CSE3030_PHW04.inc

.code
main PROC
;Receives: EAX, EBX, ECX, EDX, ESI, EDI, EDP
;Returns: EAX = Max gap
;Requires: nothing
	mov esi, -4								
	mov ecx, TN								;test case
	L1:
		push ecx
		add esi, 4
		mov ecx, CASE[esi]					;list size
		dec ecx								
		mov eax, 0
		add esi, 4
		mov ebx, CASE[esi]					;ebx:min, ebx = CASE[esi]
		L2:
			add esi, 4
			mov edi, CASE[esi]				;ebi:current height
			cmp edi, CASE[esi-4]			;compare current height,before height
			jle L3							;if (edi <= CASE[esi-4]) jump L3
			mov edx, CASE[esi]				;edx:max, edx = current height
			mov ebp, edx					
			sub ebp, ebx					;ebp:new gap , ebp = max-min
			cmp eax, ebp					;compare current gap,new gap
			jge L4							;if(eax >= ebp) jump L4
			mov eax, ebp						
			jmp L4
			L3:
				mov ebx, CASE[esi]			;ebx = current height
				mov edx, -1
			L4:
		loop L2
		call WriteDec						;Output
		call Crlf							;Crlf
		pop ecx
	loop L1

	exit
main ENDP
END main
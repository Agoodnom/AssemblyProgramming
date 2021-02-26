;;; key = 10
.data
Num_Str    DWORD 3   ; 아래cipher 문자열들의 개수(채점시 문자열의 개수는 다름)
Cipher_Str	BYTE "SVSUOKCCOW", 0   ; 정확히10 개의 문자로 구성된cipher text이다
			BYTE "RYGKBOIYEE", 0   ; 이러한 문자열이Num_Str 개 만큼 반복
			BYTE "AAADDCCCFT", 0   ; 이러한 문자열이Num_Str 개 만큼 반복

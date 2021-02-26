ExitProcess proto
DumpRegs proto
.data

.code 
main proc
mov rax, 0FFFF0000FFFF0000h
mov rbx,2
mul rbx



call ExitProcess 
main endp 
end 
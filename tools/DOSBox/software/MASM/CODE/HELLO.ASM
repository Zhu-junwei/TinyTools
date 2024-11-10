assume cs:code, ds:data
data segment
	szmsg db 'Hello world!$'
data ends

code segment
start:	MOV AX,data
		MOV DS,AX
		LEA DX, szmsg
		MOV AH,9
		INT 21H
		
		MOV AX,4c00h
		INT 21h
code ends
end	start
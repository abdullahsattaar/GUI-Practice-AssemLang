[org 0x0100]
jmp start
endmessage: db 'To run again press Y, to exist press  N'

clrscr: 
	 push es
	 push ax
	 push cx
	 push di
	 mov ax, 0xb800
	 mov es, ax 
	 xor di, di 
	 mov ax, 0x0720 
	 mov cx, 2000 
	 cld 
	 rep stosw
	 pop di 
	 pop cx
	 pop ax
	 pop es
	 ret 
	
delay:
	push cx
	mov cx, 30 ; change the values  to increase delay time
	delay_loop1:
	push cx
	mov cx, 0xFFFF
	delay_loop2:
	loop delay_loop2
	pop cx
	loop delay_loop1
	pop cx
	ret
	 
Display:
 
 call clrscr
 mov ax,0xb800
 mov es,ax	
 push si
 push di
 mov si,0
 mov di,4000
 mov cx,13 
 Loop1:
	mov word [es:si],0x072A
	mov word [es:di],0x072A
	add si,166
	sub di,166
	call delay
	loop Loop1
 
 pop di
 pop si  
 ret


Endfunction:

 call clrscr
 mov ah, 0x13    			; service 13 - print string
 mov al, 1 						; subservice 01 – update cursor
 mov bh, 0 						; output on page 0
 mov bl, 7 						; normal attrib
 mov dx, 0x0A03 				; row 10 column 3
 mov cx, 39 					; length of string
 push cs
 pop es 						; segment of string
 mov bp, endmessage				; offset of string
 int 0x10 	                    ; call BIOS video service
 
 
 Again:
 mov ax,0
 mov ah,0
 int 0x16
 cmp al,0x59
 je start
 cmp al,0x79 
 je start
 cmp al,0x4E
 je Terminate
 cmp al,0x6E
 je Terminate 
 jmp Again



start:
 call Display
 call Endfunction

Terminate:
mov ax, 0x4c00
int 0x21
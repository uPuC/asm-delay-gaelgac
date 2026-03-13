;------------- definiciones e includes ------------------------------
;.INCLUDE "m1280def.inc" ; Incluir definiciones de Registros para 1280
.INCLUDE "m2560def.inc" ; Incluir definiciones de Registros para 2560

.equ INIT_VALUE = 0 ; Valor inicial R24

;------------- inicializar ------------------------------------------
ldi R24,INIT_VALUE
;------------- implementar ------------------------------------------
;call delay103uS
;call delay1mS
;call delay1S
;nop
;call myRand ; Retorna valor en R25
;------------- ciclo principal --------------------------------------
arriba: inc R24
	cpi R24,10
	breq abajo
	out PORTA,R24
	rjmp arriba

abajo: dec R24
	cpi R24,0
	breq arriba
	out PORTA,R24
	rjmp abajo



delay20uS:			; Llamada: 5
    ldi  R16, 103   ; 1   
loop_20us:
    dec  R16        ; n
    brne loop_20us  ; 2n - 1
	nop 			; 1
    ret             ; 5

	; 5 + 1 + n + 2n - 1 + 1 + 5
	; 3n + 8

	; Como n = 104: 
	; Complejidad: 3(103)+ 11 = 320 ciclos

	; Duracion por ciclo: 1/16MHz = 62.5 ns

	; Duracion de subrutina: (320)(62.5ns) = 20 us




delay4ms:				; Llamada: 5
    ldi  r18, 18		; 1
loop_ext_4ms:			; ciclo m
    ldi  r17, 32		; m
loop_int1_4ms:			; ciclo n
    ldi  r16, 36		; mn
loop_int2_4ms:			; ciclo o
    dec  r16			; mno
    brne loop_int2_4ms	; mn(2o - 1)
    dec  r17			; mn
    brne loop_int1_4ms	; m(2n-1)
    dec  r18			; m
    brne loop_ext_4ms	; 2m - 1
    ret					; 5


; Ciclos necesarios: 4ms / (1/16MHz) = 64000

; Desglose

; = 5 + 1 + m + mn + mno + 2mno - mn + mn + 2mn - m + m + 2m - 1 + 5
; = 3mno + 3mn + 3m + 10


; Si m = 18, n = 32 y o = 36

; Ciclos: 640000



delay1S:					; Llamada: 5
    ldi  r18, 144			; 1
loop_ext_1S:				; ciclo m
    ldi  r17, 188			; m
loop_int1_1S:				; ciclo n
    ldi  r16, 196			; mn
loop_int2_1S:				; ciclo o
    dec  r16				; mno
    brne loop_int2_1S		; mn(2o - 1)
    dec  r17				; mn
    brne loop_int1_1S		; m(2n-1)
    dec  r18				; m
    brne loop_ext_1S		; 2m-1
    nop						; 1
    nop						; 1
    nop						; 1
    nop						; 1
    nop						; 1
    nop						; 1
    ret						; 5





; Ciclos necesarios: 1 / (1/16MHz) = 16000000


; Desglose

; = 5 + 1 + m + mn + mno + 2mno - mn + mn + 2mn - m + m + 2m - 1 + 6 + 5
; = 3mno + 3mn + 3m + 16

; Si m = 144, n = 188, o = 196
; Ciclos: 16000000







; Subrutina random, use LSFR

; ldi R20, 0xCE          ; seed: cualquier valor menos 0




myRand:
    lsr  R20
    brcc endRand       ; si carry=0
    
    ; Bit es 1
    ; Mascara para x^8 + x^6 + x^5 + x^4 + 1 
	; --- 10001110 --- 0x8E

    ldi  R17,0x8E
    eor  R20,R17	; XOR de semilla y mascara

endRand:
    mov  R25,R20
    ret
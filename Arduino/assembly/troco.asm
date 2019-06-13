.INCLUDE "m328Pdef.inc"
.org 0x0000 
jmp SETUP
.org 0x0016
rjmp Interruption


BCDsetup:
	;ldi r16,34 ; Number to enter bcd conversion
    ;dec r26
	ld r16,X
    ldi r17,100 ; Maior ordem do numero
	ldi r18,0 ; Saida BCD pra cada dezena, unidade
	ldi r19,0b00000100; Second bit set means its subtracting from 10
    SubLoop:
        sub r16,r17
        cpi r16,0
        brge Contmaismais; jump if r16 >= 0. Therefore, sub again
        ChangeR17:
        add r16,r17
        sbrs r19,2
        jmp Finish;Essa parte de baixo apenas se tiver centena
        ldi r19,0b00000010
        ldi r17,10
        mov r22,r18
        ldi r18,0
        jmp SubLoop
    Contmaismais:
        inc r18
        jmp SubLoop
    Finish:
        mov r21,r18
        mov r20,r16
        ret
;End of BCD--------------------------

;7Seg------------------------------
DisplayOut:
    cpi r19,9 ; Antes dessa fun��o, fa�a r19 receber o regis necess�rio
    brsh Load9
    cpi r19,8
    brsh Load8
    cpi r19,7
    brsh Load7
    cpi r19,6
    brsh Load6
    cpi r19,5
    brsh Load5
    cpi r19,4
    brsh Load4
    cpi r19,3
    brsh Load3
    cpi r19,2
    brsh Load2
    cpi r19,1
    brsh Load1
    Load0:
    ldi r19,0b00111111
    ret
    Load1:
    ldi r19,0b00000110
    ret
    Load2:
    ldi r19,0b01011011
    ret
    Load3:
    ldi r19,0b01001111
    ret
    Load4:
    ldi r19,0b01100110
    ret
    Load5:
    ldi r19,0b01101101
    ret
    Load6:
    ldi r19,0b01111101
    ret
    Load7:
    ldi r19,0b00000111
    ret
    Load8:
    ldi r19,0b01111111
    ret
    Load9:
    ldi r19,0b01101111
    ret
;7Seg-----------------------------

ShiftRight:
    lsr r19
    lsr r19
    lsr r19
    lsr r19
    lsr r19
    lsr r19
ret
delay:
	sbrs r22,0 ; Skip if bit 0 in r22 is set
	jmp delay
	ldi r22,0
	ret

;calctroco -----------------
caltroco:
    ldi r20,124; Valor
       
    clr r27 ; Clear X high byte
    ldi r26,$4000 ; Set X low byte to $60

    clr r18
    
    ldi r19,1
    PUSH r19
    ldi r19,5
    PUSH r19
    ldi r19,10
    PUSH r19
    ldi r19,25
    PUSH r19
    ldi r19,50
    PUSH r19
    ldi r19,100
    PUSH r19

    LOOP1:
        POP r19
        clr r18
    LOOP:
        CP r20,r19
        brlt menor
        SBC r20,r19
        inc r18
        JMP LOOP
    menor:
        ;st X+,r18
        ;ldi r18,45 ; Set X low byte to $60
        st X+,r18
        ldi r16,1
        CPSE r19,r16
        rjmp LOOP1
        ret
;calctroco -----------------

setup:
	ldi r20,0b11111100
	out DDRD,r20
	ldi r20,0b00010111
	out DDRB,r20
	ldi r20,0
	out PORTB,r20
	sei ; Enable global interruption
	ldi r20,0b00000010
	sts TIMSK1,r20; Enable timer match A interrupt
	ldi r20,0b00000000 ;  OCR0A does nothing  and set mode normal
	sts TCCR1A, r20
	ldi r20, 0b00001101 ; Set clk select to clkIO/1024
	sts TCCR1B,r20
    call caltroco
    ldi r26,$4000

enlaitecer:
	;Contagem do timer
	ldi r20,0b00000000
	ldi r21,0b01111111
	sts OCR1AH,r20
	sts OCR1AL,r21
   
    ;clr r27 ; Clear X high byte
    ;ldi r26,$4000 ; Set X low byte to $60
    ;ldi r23,27
    ;st X,r23
	call BCDsetup;r20 e r21 est�o ocupados

	;Display 2 - Dezenas
	sbi PORTB,2
	cbi PORTB,0
	mov r19,r21
	call DisplayOut ; Aqui sai o numero em formato do display
	mov r18,r19
	lsl r18
	lsl r18
	out PORTD,r18

	;Apenas pro bit g do display
	call ShiftRight
	ldi r17,1; mascara pra pegar o bit 0 apenas
	and r19,r17
	in r16,PORTB
	or r16,r19
	out PORTB,r16
	call delay
	cbi PORTB,2

	;Display 1 - Unidades
	sbi PORTB,1
	cbi PORTB,0
	mov r19,r20
	call DisplayOut ; Aqui sai o numero em formato do display
	mov r18,r19
	lsl r18
	lsl r18
	out PORTD,r18

	;Apenas pro bit g do display
	call ShiftRight
	ldi r17,1; mascara pra pegar o bit 0 apenas
	and r19,r17
	in r16,PORTB
	or r16,r19
	out PORTB,r16
	call delay
	cbi PORTB,1

    in r16,PINB
    ldi r17,0b00010000
    
    SBRS r16,5
    ;sbi PORTB,4
    call delaysama
    
    ;nop
    ;SBRS r16,3
    ;cbi PORTB,4
    

	jmp enlaitecer


Interruption:
	ldi r22,0b00000001 ; Seta o bit 0 pra sair do delay
	reti

delaysama:
inc r26
 clr r20
 clr r21
 ldi R22,1

 delayloop:
  dec r20
  brne delayloop
  dec r21
  brne delayloop
  dec R22
  brne delayloop
  ret
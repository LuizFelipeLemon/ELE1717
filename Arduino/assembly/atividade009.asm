.include "m328pdef.inc"
.org 0x0000 jmp main
.org 0x002A jmp ADCOMPLETE

main:
    ldi r16, 0b01100101   ; Voltage Reference: AVcc with external capacitor at AREF pin
    sts ADMUX, r16        ; Enable ADC Left Adjust Result
                          ; Analog Channel: ADC5

    ldi r16, 0b11001101   ; Enable ADC
    sts ADCSRA, r16       ; ADC Prescaling Factor: 32

    ldi r16, 0b10000000
    sts SREG, r16

    sbi DDRD, 6
    sbi DDRD, 5
    sbi DDRD, 4
    sbi DDRD, 3
    sbi DDRD, 2

waitar:
    rjmp waitar


ADCOMPLETE:
    
    lds r18,ADCL
    lds r19,ADCH
    ; ldi r21, 0b00011100 
    ;out PORTD,r19
    cpi r19,50; 11001101
    brsh setbit1
    cbi PORTD,2
    jmp waitar
setbit1:
    sbi PORTD,2
    cpi r19,100; 11001101
    brsh setbit2
    cbi PORTD,3
    jmp waitar 
setbit2:
    sbi PORTD,3
    cpi r19,150
    brsh setbit3
    cbi PORTD,4
    jmp waitar
setbit3:
    sbi PORTD,4
    cpi r19,200
    brsh setbit4
    cbi PORTD,5
    jmp waitar
setbit4:
    sbi PORTD,5
    jmp waitar
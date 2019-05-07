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

    


wait:
    rjmp wait


ADCOMPLETE:
    lds r18, ADCL  ; Must read ADCL first, and ADCH after that
    lds r19, ADCH

    cpi r18,0b01100100
    BRCS 2
    sbi PORTD, 2
    RJMP 1
    cbi PORTD, 2

    reti
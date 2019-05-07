.include "m328Pdef.inc"
.org 0x0000 
jmp SPI_MasterInit
.org 0x002A 
jmp adcfinished

adcfinished:
    ; Start transmission of data (r16)
    ;lds r16, ADCH
    ldi r16, 0b10101010
    out SPDR,r16
    rjmp Wait_Transmit

Wait_Transmit:
    ; Wait for transmission complete
    in r16, SPSR
    sbrs r16, SPIF
    rjmp Wait_Transmit
    
    rcall delay
    ldi r16,0b11111111
    out PORTD,r16
    jmp adcfinished
    reti


SPI_MasterInit:
    ; Set MOSI and SCK output, all others input
    ldi r17,(1<<DDB3)|(1<<DDB5)
    out DDRB,r17
    ; Enable SPI, Master, set clock rate fck/16
    ldi r17,(1<<SPE)|(1<<MSTR)|(1<<SPR0)
    out SPCR,r17
    


main:
    ldi r16, 0b01100000   ; Voltage Reference: AVcc with external capacitor at AREF pin
    sts ADMUX, r16        ; Enable ADC Left Adjust Result
                          ; Analog Channel: ADC5

    ldi r16, 0b11001111   ; Enable ADC
    sts ADCSRA, r16       ; ADC Prescaling Factor: 32

    ldi r16, 0b10000000
    out SREG, r16

    sbi DDRD, 7
    sbi DDRD, 6
    sbi DDRD, 5
    ldi r16,0b00000000
    out PORTD,r16

    

wait:
    
    rjmp wait

delay:
 clr r20
 clr r21

 delayloop:
  dec r20
  brne delayloop
  dec r21
  brne delayloop
  ret
    


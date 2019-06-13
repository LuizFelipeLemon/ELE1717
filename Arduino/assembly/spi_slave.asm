.include "m328Pdef.inc"
.org 0x0000 
jmp SPI_SlaveInit
;.org 0x0022 jmp spi_transfer_complete
SPI_SlaveInit:
    ; Set MISO output to pin 13 
    ldi r17,(1<<DDB4)    
    out DDRB,r17
    ; Enable SPI
    ldi r17,0b01000001
    out SPCR,r17
    
    sbi DDRD, 7
    sbi DDRD, 6
    sbi DDRD, 5

    ldi r16, 0b00000000
    out PORTD, r16

    ;ret

main:

    ; Wait for reception complete
    
    in r16, SPSR
    sbrs r16, SPIF
    rjmp main
    ldi r16, 0b11111111
    out PORTD, r16
    ; Read received data and return
    in r16, SPDR
    out PORTD, r16
    rjmp main


delay:
 clr r20
 clr r21
 ldi R22,100

 delayloop:
  dec r20
  brne delayloop
  dec r21
  brne delayloop
  dec R22
  brne delayloop
  ret
    


    
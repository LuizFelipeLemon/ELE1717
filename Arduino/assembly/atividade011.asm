.INCLUDE "m328Pdef.inc"
.org 0x0000 
jmp setup
.org 0x002A 
jmp func

setup: 
  ldi R16,0x03
  out DDRC,R16
  ldi R16,0xFC
  out DDRD,R16

func:
  in R17,PINC
  cpi R17,0x01
  breq rec
  in R17,PINC
  cpi R17,0x02
  breq saw
  in R17,PINC
  cpi R17,0x03
  breq tri
  rjmp func

rec:
  ldi R20,0xFC
  out PORTD,R20
  rcall delay
  clr R20
  out PORTD,R20
  rcall delay
  rjmp func

saw:
  sbi PORTD,2
  rcall delay
  sbi PORTD,3
  rcall delay
  sbi PORTD,4
  rcall delay
  sbi PORTD,5
  rcall delay
  sbi PORTD,6
  rcall delay
  sbi PORTD,7
  rcall delay
  clr R17
  out PORTD,R17
  rcall delay
  rjmp func

tri:
  sbi PORTD,2
  rcall delay
  sbi PORTD,3
  rcall delay
  sbi PORTD,4
  rcall delay
  sbi PORTD,5
  rcall delay
  sbi PORTD,6
  rcall delay
  sbi PORTD,7
  rcall delay
  cbi PORTD,7
  rcall delay
  cbi PORTD,6
  rcall delay
  cbi PORTD,5
  rcall delay
  cbi PORTD,4
  rcall delay
  cbi PORTD,3
  rcall delay
  cbi PORTD,2
  rcall delay
  rjmp func
  
delay:

  clr R21
  clr R22
  ldi R23,30
  
   
loop:
  dec R21
  brne loop
  dec R22
  brne loop
  dec R23
  brne loop
  ret 
#include   "avr/io.h"
.org 0x0000 
rjmp main 

delaa:
  clr r17 
  clr r18
  ldi r19, 100 
  
delay_loop:
  dec r18 
  brne delay_loop 
  dec r17 
  brne delay_loop 
  dec r19 
  brne delay_loop 
  ret 
  
main:

  sbi (DDRB-0x20), 5

a:
  sbi (PORTB-0x20), 5 
  rcall a
  sbi (PORTB-0x20), 5
  rcall delaa 
  rjmp a 

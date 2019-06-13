#include <avr/io.h>
#include <util/delay.h>  //_delay_ms(iDelay);          // Call Delay function
#include <math.h>

int main(void){

  
   
   
   DDRD = 0xFF;                  // Set PORTD as Output
   DDRB = 0xFF;

   // Set ADCSRA Register in ATMega168
   ADCSRA = (1<<ADEN) | (1<<ADPS2) | (1<<ADPS1);
   // Set ADMUX Register in ATMega168
   ADMUX = (1<<REFS0);	
   for(;;) {                     // Loop Forever
     // Start conversion by setting ADSC in ADCSRA Register
     ADCSRA |= (1<<ADSC);
     // wait until conversion complete ADSC=0 -> Complete
     while (ADCSRA & (1<<ADSC));
     PORTD ^= (1 << 7);
     
   }
   return 0;	                    // Standard Return Code
}
// EOF: ADC.c
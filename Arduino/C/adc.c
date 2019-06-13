#include <avr/io.h>
#include <util/delay.h>  //_delay_ms(iDelay);          // Call Delay function
#include <math.h>

int main(void){

   float n;
   unsigned int adcOut,cosseno;
   
   DDRD = 0xFF;                  // Set PORTD as Output
   DDRB = 0xFF;

   // Set ADCSRA Register in ATMega168
   ADCSRA = (1<<ADEN) | (1<<ADPS2) | (1<<ADPS1);
   // Set ADMUX Register in ATMega168
   ADMUX = (1<<REFS0);	
   n = 0;
   for(;;) {                     // Loop Forever
     // Start conversion by setting ADSC in ADCSRA Register
     ADCSRA |= (1<<ADSC);
     // wait until conversion complete ADSC=0 -> Complete
     while (ADCSRA & (1<<ADSC));
     // Get ADC the Result
     //adcOut = ADCW;
     adcOut = (ADCW>>3);
     cosseno = (adcOut*cos(n))+127;
     unsigned int final = cosseno;//(int)adcOut;
     
     PORTD = (final & 0b0000000000111111)<<2; // SHIFT RIGHT Two bits to start from port 2
     PORTB = ((final   & 0b0000000011000000)>>6);  
     n=n+0.01;     
     //_delay_ms(500);
     if(n == 255)
      n=0;
     
   }
   return 0;	                    // Standard Return Code
}
// EOF: ADC.c
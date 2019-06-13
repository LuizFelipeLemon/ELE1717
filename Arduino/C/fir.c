  #include <avr/io.h>
  #include <util/delay.h>  //_delay_ms(iDelay);          // Call Delay function
  #include <math.h>
  #define len 9

  double convolve( double Signal[len],
               double Kernel[len]);

  int main(void){
 
    
    DDRD = 0xFF;                  // Set PORTD as Output
    DDRB = 0xFF;

    // Set ADCSRA Register in ATMega168
    ADCSRA = (1<<ADEN) | (1<<ADPS2) | (1<<ADPS1);
    // Set ADMUX Register in ATMega168
    ADMUX = (1<<REFS0) | (1<<ADLAR);	

    

    double buff[len];// = {, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0};
    double filter[len] = {
      6995.591515934211,
      -52714.48987291492,
      176926.9913695199,
      -345166.54422546347,
      427917.98761763115,
      -345166.54422546347,
      176926.9913695199,
      -52714.48987291492,
      6995.591515934211
      };
    double result;

    while(1) {                     // Loop Forever
      // Start conversion by setting ADSC in ADCSRA Register
      ADCSRA |= (1<<ADSC);
      // wait until conversion complete ADSC=0 -> Complete
      while (ADCSRA & (1<<ADSC));
      //adcOut = (ADCW>>3);
      
      for(uint8_t i = len-1;i>=1;i--){
        buff[i] = buff[i-1];
      }

      buff[0] = ADCH;
         
      
      result = convolve(filter,buff);
      
      PORTD = ((int)result)<<2; // SHIFT RIGHT Two bits to start from port 2
      PORTB = ((int)result)>>6;
      //PORTD ^= (1 << 7);
         
      _delay_ms(1);
    }
    return 0;	                    // Standard Return Code
  }

  double convolve(double Signal[len], double Kernel[len]){

    uint8_t k;
    double Result = 0;

    for (k = 0; k < len; k++){

      Result += (Signal[k] * Kernel[len-k]);
      
    }
    return Result;
  }
  // EOF: ADC.c
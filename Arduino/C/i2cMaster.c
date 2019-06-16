#include <avr/io.h>
#define F_CPU 16000000
#include <util/delay.h>
#include "i2c.h"

#ifndef cbi
#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif

#ifndef sbi
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif

#define TWI_FREQ 100000L

int main(void) {
  DDRD = 0xFF;
  DDRC = 0;
  // activate internal pullups for twi.
  PORTC = (1 << PC4) | (1 << PC5);
  cbi(TWSR, TWPS0);
  cbi(TWSR, TWPS1);
  TWBR = ((F_CPU / TWI_FREQ) - 16) / 2;
  // TWCR = _BV(TWEN) | _BV(TWIE) | _BV(TWEA);
  while (1) {
    TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);  // Send START CONDITION
        
    while (!(TWCR & (1 << TWINT))) {
      PORTD ^= (1 << 3);
    }
    _delay_ms(1000);
  }

  return 0;
}
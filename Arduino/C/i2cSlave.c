#include <avr/io.h>
#define F_CPU 16000000
#include <util/delay.h>
#include "i2cSlave.h"

int main(void) {
  DDRD = 0xFF;
  PORTD = 0x00;
  DDRB = 0x00;
  PORTB = 0x00;
  
  TWAR = 0b00000010;

  while (1) {
    TWCR = 0b11000100;
    if ((TWSR & 0xF8) == 0x60) {
      while (1) {
        TWCR = 0b11000100;
        while (!(TWCR & (1 << TWINT)))
          ;
        if ((TWSR & 0xF8) == 0x80) {
          char data = TWDR;
          PORTB = data;
        }
        if ((TWSR & 0xF8) == 0xA0) {
          _delay_ms(10);
          break;
        }
      }
    }
  }
}
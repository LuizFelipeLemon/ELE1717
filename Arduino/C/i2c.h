#ifndef I2C_LUIB
#define I2C_LUIB
#include <avr/io.h>
#define F_CPU 16000000
#define PI 3.14259265
#define START 0x08
#define MT_SLA_ACK 0x18
#define MT_DATA_ACK 0x28

#define SR_SLA_ACK 0x60
#define SR_DATA_ACK 0x80
#define SR_STOP 0xA0

#include <util/delay.h>

void ERROR() { PORTD ^= (1 << 2); }

void MT(uint8_t data, uint8_t addr) {
  TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);  // Send START CONDITION

  while (!(TWCR & (1 << TWINT))) {
    PORTD ^= (1 << 3);
  }

  if ((TWSR & 0xF8) != START) ERROR();  // Check value of TWI Status Register

  TWDR = addr;                        // Load SLA_W into TWDR Register
  TWCR = (1 << TWINT) | (1 << TWEN);  //  Clear TWINT bit in TWCR
                                      // to start transmission of address

  while (!(TWCR & (1 << TWINT)))  // Wait for TWINT Flag set.
    ;

  if ((TWSR & 0xF8) != MT_SLA_ACK)
    ERROR();  // Check value of TWI Status Register

  TWDR = data;                        // Load DATA into TWDR Register.
  TWCR = (1 << TWINT) | (1 << TWEN);  //  Clear TWINT bit in TWCR
                                      // to start transmission of address

  if ((TWSR & 0xF8) != MT_DATA_ACK)
    ERROR();  // Check value of TWI Status Register.

  TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWSTO);  // Transmit STOP condition
}

void SR(uint8_t addr) {
  TWAR = (addr << 1) | (1 << TWGCE);  // If the LSB is set, the TWI will respond
                                      // to the general ca  ll address
  TWCR = (1 << TWEA) | (1 << TWEN);   // Send START CONDITION

  while (!(TWCR & (1 << TWINT)))
    ;  // Wait for TWINT Flag set.
  // while (1) PORTD ^= (1 << 3);

  if ((TWSR & 0xF8) == SR_SLA_ACK) {
    TWCR = (1 << TWINT) | (1 << TWEA) | (1 << TWEN);
    PORTD = (1 << 3);
    while (!(TWCR & (1 << TWINT)))
      ;  // Wait for TWINT Flag set.

    if ((TWSR & 0xF8) == SR_DATA_ACK) {
      char data = TWDR;
      PORTB = data;
      PORTD = (1 << 4);
      TWCR = (1 << TWINT) | (1 << TWEA) | (1 << TWEN);

      while (!(TWCR & (1 << TWINT)))
        ;  // Wait for TWINT Flag set.

      if ((TWSR & 0xF8) == SR_STOP) {
        PORTD = (1 << 5);
      } else {
        ERROR();
      }
    } else {
      ERROR();
    }
  } else {
    ERROR();
  }
}
#endif
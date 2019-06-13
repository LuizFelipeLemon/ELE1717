# define F_CPU 16000000UL
# include <avr/io.h>
# include <util/delay.h>
#include <math.h>
#include <stdlib.h>
#define estadoa 0
#define estadob 1
#define estadoc 2
#define estadod 45
volatile uint8_t fsm_state = estadoa ;
int  conversorad(int porta)
{
ADMUX =(1<<REFS0); // Aref = AVcc ;
ADCSRA =0x07; // Div factor =128 , (MSB)=9
ADCSRB =0x00; // Free running Mode
ADCSRA|=(1<<ADEN); // Habilitar A/D
ADMUX = porta;
ADCSRA|=(1<<ADSC); // Iniciar convers~ao simples
while (!(ADCSRA & (1<<ADIF)) ) // Aguarde o final da conversao
ADCSRA|=(1<<ADIF); // Limpe o identificador
return ADC;
}

int main ( void )
{
int deslocab;
int xt;
int yt;
int soma=0;
DDRB=0b11111110;
DDRC= 0b11111100; //0 eh entrada
DDRD=0b11111100;
while (1)
{

switch ( fsm_state )
{
case estadoa :
deslocab =(PINB<<6);
deslocab =(deslocab>>7);
if(deslocab==1)	fsm_state = estadob;
break ;
case estadob :
soma=0;
fsm_state = estadoc;
break ;
case estadoc:

for (int i=0; i<=199;i++)
{
xt=conversorad(0);
yt=conversorad(1);
soma=soma+abs(xt-yt);
}
soma=(soma/803);
fsm_state = estadod;

case estadod:

PORTD = ((int)soma)<<2; // SHIFT RIGHT Two bits to start from port 2
PORTB = ((int)soma)>>6;
if (soma>100)
{
PORTB|=(1<<5); // liga o led PB5
}
else PORTB&=~(1<<5); 
default :
break ;
}
}
}
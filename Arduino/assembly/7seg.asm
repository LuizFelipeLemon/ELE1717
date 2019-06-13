.include "m328pdef.inc"
.org 0x0000 ; A pr´oxima instrun¸c~ao ser´a escrita em 0x0000
rjmp main ; salte para main:

delay:
    clr r17 ; defina r17 para 0
    clr r18 ; defina r18 para 0
    ldi r19, 10 ; defina r19 para 10

delay_loop:
    dec r18 ; decremente r18
    brne delay_loop ; salte para delay_loop se r18 n~ao ´e 0
    dec r17 ; decremente r17
    brne delay_loop ; salte para delay_loop se r17 n~ao ´e 0
    dec r19 ; decrament r19
    brne delay_loop ; salte para delay_loop se r19 n~ao ´e 0
    ret ; retorne

main:
    sbi DDRB, 5

loop:
    cbi PORTB, 5
    rcall delay
    sbi PORTB, 5
    rcall delay
    rjmp loop
;
; ESE380_LAB6_multi_key.asm
;
; Created: 10/14/2017 11:06:55 PM
; Author : Myungjun. Song
;


.nolist
.include "m324adef.inc"
.list

.cseg
reset:
    ;Configure port B as an output port - Connected 
    ldi r16, $FF        ;load r16 with all 1s
    out DDRB, r16       ;port B - all bits configured as outputs

    ;Configure port A as an input port
    ldi r16, $0F        ;load r16 with (1000 1111)
	out DDRD, r16       ;port A - PA4,PA5,PA6 are configured as Inputs
						;port A - PA7 is output

	cbi PIND, 7			;clear EO with bar 

Output_Encoder:			
	in r17, PINA				;read Port A pins: PA4,PA5,PA6,PA7
	andi r17, &					;mask bits except PA4,AP5,PA6 (0111 0000)
	
	lsr r17						;shift r17 to right by one (00XX X000)
	lsr r17						;shift r17 to right by one (000X XX00)
	lsr r17						;shift r17 to right by one (0000 XXX0)
	lsr r17						;shift r17 to right by one (0000 0XXX)

	mov r18, r17				;copy r17 and paste it to r18

bcd_7seg_0:						;Connected with Digit 0 Transistor 	
    ldi ZH, high (hextable * 2) ;set Z to point to start of table
    ldi ZL, low (hextable * 2)
    ldi r16, $00                ;add offset to Z pointer
    add ZL, r18
    adc ZH, r16
    lpm r18, Z                  ;load byte from table pointed to by Z

Display:
	out PORTB, r18				;display pushbutton value with seven segment LED digit0
	
	cp r18, r17					;if output value of encoder reamins same
	breq Output_Encoder			;jump to Output_Encoder again.

Newbutton_Pressed:
	mov r20, r17				;Move Display from Ditigt0 to Digit1

bcd_7seg_1:						;Connected with Digit 1 Transistor 	
    ldi ZH, high (hextable * 2) ;set Z to point to start of table
    ldi ZL, low (hextable * 2)
    ldi r16, $00                ;add offset to Z pointer
    add ZL, r20
    adc ZH, r16
    lpm r20, Z                  ;load byte from table pointed to by Z

	out PORTB, r20				;display pushbutton value with seven segment LED digit1 

Read_Newbutton:
	in r17, PINA				;read Port A pins: PA4,PA5,PA6,PA7
	andi r17, $70				;mask bits except PA4,AP5,PA6 (0111 0000)
	
	lsr r17						;shift r17 to right by one (00XX X000)
	lsr r17						;shift r17 to right by one (000X XX00)
	lsr r17						;shift r17 to right by one (0000 XXX0)
	lsr r17						;shift r17 to right by one (0000 0XXX) 

	mov r18, r17				;copy r19 and paste it to r18
	
	out PORTB, r18				;display pushbutton value with seven segment LED digit0

	rjmp Display				;jump back to Display


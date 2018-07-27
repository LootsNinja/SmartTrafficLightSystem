
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0
;NorOp.c,10 :: 		interrupt ()
;NorOp.c,12 :: 		if (INTCON & 0x04){    // check if the interrupt is caused by TMR0
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;NorOp.c,13 :: 		intcon = intcon & 0xFb;
	MOVLW      251
	ANDWF      INTCON+0, 1
;NorOp.c,14 :: 		tick++;
	INCF       _tick+0, 1
	BTFSC      STATUS+0, 2
	INCF       _tick+1, 1
;NorOp.c,15 :: 		TMR0 = 0xFF - 0x50;
	MOVLW      175
	MOVWF      TMR0+0
;NorOp.c,16 :: 		}
L_interrupt0:
;NorOp.c,17 :: 		if (PIR1 & 0x02){      // check if the interrupt is caused by serial receive
	BTFSS      PIR1+0, 1
	GOTO       L_interrupt1
;NorOp.c,18 :: 		Pressed = RCREG;
	MOVF       RCREG+0, 0
	MOVWF      _Pressed+0
;NorOp.c,19 :: 		PORTB = PORTB | 0b00010001;
	MOVLW      17
	IORWF      PORTB+0, 1
;NorOp.c,20 :: 		PORTD = PORTD | 0b00010001;
	MOVLW      17
	IORWF      PORTD+0, 1
;NorOp.c,21 :: 		EmergencyLights = 0b00010001;
	MOVLW      17
	MOVWF      _EmergencyLights+0
;NorOp.c,22 :: 		PIR1 = 0x00;  }
	CLRF       PIR1+0
L_interrupt1:
;NorOp.c,24 :: 		}
L__interrupt34:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_delay:
;NorOp.c,25 :: 		void delay(int sec){       //delay function
;NorOp.c,26 :: 		INTCON = INTCON | 0x20;
	BSF        INTCON+0, 5
;NorOp.c,27 :: 		tick=0;
	CLRF       _tick+0
	CLRF       _tick+1
;NorOp.c,28 :: 		while(tick<sec);
L_delay2:
	MOVLW      128
	XORWF      _tick+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_delay_sec+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__delay35
	MOVF       FARG_delay_sec+0, 0
	SUBWF      _tick+0, 0
L__delay35:
	BTFSC      STATUS+0, 0
	GOTO       L_delay3
	GOTO       L_delay2
L_delay3:
;NorOp.c,29 :: 		INTCON = 0xC0;
	MOVLW      192
	MOVWF      INTCON+0
;NorOp.c,30 :: 		}
	RETURN
; end of _delay

_main:
;NorOp.c,32 :: 		void main (){                                                                                    // Main
;NorOp.c,33 :: 		option_reg = 0x07;        //prescale of 1:256
	MOVLW      7
	MOVWF      OPTION_REG+0
;NorOp.c,34 :: 		TRISB = 0x00; //B is set to output except for B0 excute the intterupt
	CLRF       TRISB+0
;NorOp.c,35 :: 		TRISD = 0x00; //D is set to output
	CLRF       TRISD+0
;NorOp.c,36 :: 		PORTB = 0x00; // inital value = 0
	CLRF       PORTB+0
;NorOp.c,37 :: 		PORTD = 0x00; // inital value = 0
	CLRF       PORTD+0
;NorOp.c,38 :: 		USART_init(); // initialize USART
	CALL       _USART_init+0
;NorOp.c,39 :: 		ADCoN1 = 0b00000110;
	MOVLW      6
	MOVWF      ADCON1+0
;NorOp.c,40 :: 		PORTB = 0b10001000;
	MOVLW      136
	MOVWF      PORTB+0
;NorOp.c,41 :: 		PORTD = 0b10001000;
	MOVLW      136
	MOVWF      PORTD+0
;NorOp.c,42 :: 		delay(10);
	MOVLW      10
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,43 :: 		while (1)
L_main4:
;NorOp.c,48 :: 		PORTB = EmergencyLights | 0b00101000;
	MOVLW      40
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTB+0
;NorOp.c,49 :: 		PORTD = EmergencyLights | 0b10001000;
	MOVLW      136
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTD+0
;NorOp.c,50 :: 		delay(1000);    //Traffic light stays green for 10 seconds
	MOVLW      232
	MOVWF      FARG_delay_sec+0
	MOVLW      3
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,52 :: 		for ( i = 0 ; i<3; i++)
	CLRF       _i+0
	CLRF       _i+1
L_main6:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main36
	MOVLW      3
	SUBWF      _i+0, 0
L__main36:
	BTFSC      STATUS+0, 0
	GOTO       L_main7
;NorOp.c,54 :: 		PORTB = EmergencyLights | 0b00001000;  //Green light off
	MOVLW      8
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTB+0
;NorOp.c,55 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,56 :: 		PORTB = EmergencyLights | 0b00101000;  //Green light on
	MOVLW      40
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTB+0
;NorOp.c,57 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,52 :: 		for ( i = 0 ; i<3; i++)
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;NorOp.c,58 :: 		}
	GOTO       L_main6
L_main7:
;NorOp.c,60 :: 		PORTB = EmergencyLights | 0b01001000;
	MOVLW      72
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTB+0
;NorOp.c,61 :: 		delay(200);
	MOVLW      200
	MOVWF      FARG_delay_sec+0
	CLRF       FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,63 :: 		PORTB = EmergencyLights | 0b10001000;
	MOVLW      136
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTB+0
;NorOp.c,64 :: 		delay(100);
	MOVLW      100
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,65 :: 		emergency ();
	CALL       _emergency+0
;NorOp.c,69 :: 		PORTB = EmergencyLights | 0b10000010;
	MOVLW      130
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTB+0
;NorOp.c,70 :: 		PORTD = EmergencyLights | 0b10001000;
	MOVLW      136
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTD+0
;NorOp.c,71 :: 		delay(1000);    //Traffic light stays green for 10 seconds
	MOVLW      232
	MOVWF      FARG_delay_sec+0
	MOVLW      3
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,73 :: 		for ( i = 0 ; i<3; i++)
	CLRF       _i+0
	CLRF       _i+1
L_main9:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main37
	MOVLW      3
	SUBWF      _i+0, 0
L__main37:
	BTFSC      STATUS+0, 0
	GOTO       L_main10
;NorOp.c,75 :: 		PORTB = EmergencyLights | 0b10000000;  //Green light off
	MOVLW      128
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTB+0
;NorOp.c,76 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,77 :: 		PORTB = EmergencyLights | 0b10000010;  //Green light on
	MOVLW      130
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTB+0
;NorOp.c,78 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,73 :: 		for ( i = 0 ; i<3; i++)
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;NorOp.c,79 :: 		}
	GOTO       L_main9
L_main10:
;NorOp.c,81 :: 		PORTB = EmergencyLights | 0b10000100;
	MOVLW      132
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTB+0
;NorOp.c,82 :: 		delay(200);
	MOVLW      200
	MOVWF      FARG_delay_sec+0
	CLRF       FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,84 :: 		PORTB = EmergencyLights | 0b10001000;
	MOVLW      136
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTB+0
;NorOp.c,85 :: 		delay(100);
	MOVLW      100
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,86 :: 		emergency ();
	CALL       _emergency+0
;NorOp.c,91 :: 		PORTB = EmergencyLights | 0b10001000;
	MOVLW      136
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTB+0
;NorOp.c,92 :: 		PORTD = EmergencyLights | 0b00101000;
	MOVLW      40
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTD+0
;NorOp.c,93 :: 		delay(1000);    //Traffic light stays green for 10 seconds
	MOVLW      232
	MOVWF      FARG_delay_sec+0
	MOVLW      3
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,95 :: 		for ( i = 0 ; i<3; i++)
	CLRF       _i+0
	CLRF       _i+1
L_main12:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main38
	MOVLW      3
	SUBWF      _i+0, 0
L__main38:
	BTFSC      STATUS+0, 0
	GOTO       L_main13
;NorOp.c,97 :: 		PORTD = EmergencyLights | 0b00001000;  //Green light off
	MOVLW      8
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTD+0
;NorOp.c,98 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,99 :: 		PORTD = EmergencyLights | 0b00101000;  //Green light on
	MOVLW      40
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTD+0
;NorOp.c,100 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,95 :: 		for ( i = 0 ; i<3; i++)
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;NorOp.c,101 :: 		}
	GOTO       L_main12
L_main13:
;NorOp.c,103 :: 		PORTD = EmergencyLights | 0b01001000;
	MOVLW      72
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTD+0
;NorOp.c,104 :: 		delay(200);
	MOVLW      200
	MOVWF      FARG_delay_sec+0
	CLRF       FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,106 :: 		PORTD = EmergencyLights | 0b10001000;
	MOVLW      136
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTD+0
;NorOp.c,107 :: 		delay(100);
	MOVLW      100
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,108 :: 		emergency ();
	CALL       _emergency+0
;NorOp.c,113 :: 		PORTB = EmergencyLights | 0b10001000;
	MOVLW      136
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTB+0
;NorOp.c,114 :: 		PORTD = EmergencyLights | 0b10000010;
	MOVLW      130
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTD+0
;NorOp.c,115 :: 		delay(1000);    //Traffic light stays green for 10 seconds
	MOVLW      232
	MOVWF      FARG_delay_sec+0
	MOVLW      3
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,117 :: 		for ( i = 0 ; i<3; i++)
	CLRF       _i+0
	CLRF       _i+1
L_main15:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main39
	MOVLW      3
	SUBWF      _i+0, 0
L__main39:
	BTFSC      STATUS+0, 0
	GOTO       L_main16
;NorOp.c,119 :: 		PORTD = EmergencyLights | 0b10000000;  //Green light off
	MOVLW      128
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTD+0
;NorOp.c,120 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,121 :: 		PORTD = EmergencyLights | 0b10000010;  //Green light on
	MOVLW      130
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTD+0
;NorOp.c,122 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,117 :: 		for ( i = 0 ; i<3; i++)
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;NorOp.c,123 :: 		}
	GOTO       L_main15
L_main16:
;NorOp.c,125 :: 		PORTD = EmergencyLights | 0b10000100;
	MOVLW      132
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTD+0
;NorOp.c,126 :: 		delay(200);
	MOVLW      200
	MOVWF      FARG_delay_sec+0
	CLRF       FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,128 :: 		PORTD = EmergencyLights | 0b10001000;
	MOVLW      136
	IORWF      _EmergencyLights+0, 0
	MOVWF      PORTD+0
;NorOp.c,129 :: 		delay(100);
	MOVLW      100
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,130 :: 		emergency ();
	CALL       _emergency+0
;NorOp.c,131 :: 		} // While
	GOTO       L_main4
;NorOp.c,136 :: 		}
	GOTO       $+0
; end of _main

_emergency:
;NorOp.c,137 :: 		void emergency()
;NorOp.c,139 :: 		while (Pressed == 0x01){    // check if we need first traffic light to be green
L_emergency18:
	MOVF       _Pressed+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_emergency19
;NorOp.c,140 :: 		PORTB = 0b00101001;
	MOVLW      41
	MOVWF      PORTB+0
;NorOp.c,141 :: 		PORTD = 0b10011001;
	MOVLW      153
	MOVWF      PORTD+0
;NorOp.c,142 :: 		while (!(Pressed == 0x05));       // keep it green until we press the reset
L_emergency20:
	MOVF       _Pressed+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_emergency21
	GOTO       L_emergency20
L_emergency21:
;NorOp.c,143 :: 		EmergencyLights = 0x00;
	CLRF       _EmergencyLights+0
;NorOp.c,144 :: 		PORTB = 0b10001000;
	MOVLW      136
	MOVWF      PORTB+0
;NorOp.c,145 :: 		PORTD = 0b10001000;
	MOVLW      136
	MOVWF      PORTD+0
;NorOp.c,146 :: 		delay(100);
	MOVLW      100
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,147 :: 		}
	GOTO       L_emergency18
L_emergency19:
;NorOp.c,148 :: 		while (Pressed == 0x02){     // check if we need second traffic light to be green
L_emergency22:
	MOVF       _Pressed+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_emergency23
;NorOp.c,149 :: 		PORTB = 0b10010010;
	MOVLW      146
	MOVWF      PORTB+0
;NorOp.c,150 :: 		PORTD = 0b10011001;
	MOVLW      153
	MOVWF      PORTD+0
;NorOp.c,151 :: 		while (!(Pressed == 0x05));      // keep it green until we press the reset
L_emergency24:
	MOVF       _Pressed+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_emergency25
	GOTO       L_emergency24
L_emergency25:
;NorOp.c,152 :: 		EmergencyLights = 0x00;
	CLRF       _EmergencyLights+0
;NorOp.c,153 :: 		PORTB = 0b10001000;
	MOVLW      136
	MOVWF      PORTB+0
;NorOp.c,154 :: 		PORTD = 0b10001000;
	MOVLW      136
	MOVWF      PORTD+0
;NorOp.c,155 :: 		delay(100);
	MOVLW      100
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,156 :: 		}
	GOTO       L_emergency22
L_emergency23:
;NorOp.c,157 :: 		while (Pressed == 0x03){     // check if we need third traffic light to be green
L_emergency26:
	MOVF       _Pressed+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_emergency27
;NorOp.c,158 :: 		PORTB = 0b10011001;
	MOVLW      153
	MOVWF      PORTB+0
;NorOp.c,159 :: 		PORTD = 0b00101001;
	MOVLW      41
	MOVWF      PORTD+0
;NorOp.c,160 :: 		while (!(Pressed == 0x05));       // keep it green until we press the reset
L_emergency28:
	MOVF       _Pressed+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_emergency29
	GOTO       L_emergency28
L_emergency29:
;NorOp.c,161 :: 		EmergencyLights = 0x00;
	CLRF       _EmergencyLights+0
;NorOp.c,162 :: 		PORTB = 0b10001000;
	MOVLW      136
	MOVWF      PORTB+0
;NorOp.c,163 :: 		PORTD = 0b10001000;
	MOVLW      136
	MOVWF      PORTD+0
;NorOp.c,164 :: 		delay(100);
	MOVLW      100
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,165 :: 		}
	GOTO       L_emergency26
L_emergency27:
;NorOp.c,166 :: 		while (Pressed == 0x04){     // check if we need fourth traffic light to be green
L_emergency30:
	MOVF       _Pressed+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_emergency31
;NorOp.c,167 :: 		PORTB = 0b10011001;
	MOVLW      153
	MOVWF      PORTB+0
;NorOp.c,168 :: 		PORTD = 0b10010010;
	MOVLW      146
	MOVWF      PORTD+0
;NorOp.c,169 :: 		while (!(Pressed == 0x05));      // keep it green until we press the reset
L_emergency32:
	MOVF       _Pressed+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_emergency33
	GOTO       L_emergency32
L_emergency33:
;NorOp.c,170 :: 		EmergencyLights = 0x00;
	CLRF       _EmergencyLights+0
;NorOp.c,171 :: 		PORTB = 0b10001000;
	MOVLW      136
	MOVWF      PORTB+0
;NorOp.c,172 :: 		PORTD = 0b10001000;
	MOVLW      136
	MOVWF      PORTD+0
;NorOp.c,173 :: 		delay(100);
	MOVLW      100
	MOVWF      FARG_delay_sec+0
	MOVLW      0
	MOVWF      FARG_delay_sec+1
	CALL       _delay+0
;NorOp.c,174 :: 		}
	GOTO       L_emergency30
L_emergency31:
;NorOp.c,176 :: 		}
	RETURN
; end of _emergency

_USART_init:
;NorOp.c,178 :: 		void USART_init(void)
;NorOp.c,180 :: 		TRISC = 0x80;//set the direction for the Tx and Rx Pins
	MOVLW      128
	MOVWF      TRISC+0
;NorOp.c,181 :: 		SPBRG = 51; // High Speed, 9600bps
	MOVLW      51
	MOVWF      SPBRG+0
;NorOp.c,182 :: 		TXSTA = 0x24; //select the Asynchronous mode, 8-bit data, high speed
	MOVLW      36
	MOVWF      TXSTA+0
;NorOp.c,183 :: 		RCSTA = 0x90; // Enable the serial port, 8-bit data, continuous receive
	MOVLW      144
	MOVWF      RCSTA+0
;NorOp.c,184 :: 		INTCON = INTCON | 0xC0;// GIE and PEIE  and tmr0
	MOVLW      192
	IORWF      INTCON+0, 1
;NorOp.c,185 :: 		PIE1 =  PIE1 | 0x20;// Enable the RCIE
	BSF        PIE1+0, 5
;NorOp.c,187 :: 		}
	RETURN
; end of _USART_init

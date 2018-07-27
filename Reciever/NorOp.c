unsigned char Pressed=0x00;
void emergency (void);
unsigned char EmergencyLights = 0x00;
void USART_init(void);
int i;
int tick = 0;
int sec = 0;


interrupt ()
 {
 if (INTCON & 0x04){    // check if the interrupt is caused by TMR0
 intcon = intcon & 0xFb;
 tick++;
 TMR0 = 0xFF - 0x50;
}
 if (PIR1 & 0x02){      // check if the interrupt is caused by serial receive
 Pressed = RCREG;
 PORTB = PORTB | 0b00010001;
 PORTD = PORTD | 0b00010001;
 EmergencyLights = 0b00010001;
 PIR1 = 0x00;  }
 
 }
 void delay(int sec){       //delay function
 INTCON = INTCON | 0x20;
 tick=0;
 while(tick<sec);
 INTCON = 0xC0;
 }
 
 void main (){                                                                                    // Main
     option_reg = 0x07;        //prescale of 1:256
     TRISB = 0x00; //B is set to output except for B0 excute the intterupt
     TRISD = 0x00; //D is set to output
     PORTB = 0x00; // inital value = 0
     PORTD = 0x00; // inital value = 0
     USART_init(); // initialize USART
     ADCoN1 = 0b00000110;
     PORTB = 0b10001000;
     PORTD = 0b10001000;
     delay(10);
     while (1)
     {

                                                                             //Normal Operation
     //Traffic Light 1 is green, the rest are Red
           PORTB = EmergencyLights | 0b00101000;
           PORTD = EmergencyLights | 0b10001000;
           delay(1000);    //Traffic light stays green for 10 seconds
           //Blinking the green light
           for ( i = 0 ; i<3; i++)
           {
            PORTB = EmergencyLights | 0b00001000;  //Green light off
            delay(50);
            PORTB = EmergencyLights | 0b00101000;  //Green light on
            delay(50);
           }
      //Traffic Light 1 is Yellow
           PORTB = EmergencyLights | 0b01001000;
           delay(200);
      //Traffic Light 1 is Red and all the traffic lights are red for safety.
           PORTB = EmergencyLights | 0b10001000;
           delay(100);
           emergency ();


      //Traffic Light 2 is green, the rest are Red
           PORTB = EmergencyLights | 0b10000010;
           PORTD = EmergencyLights | 0b10001000;
           delay(1000);    //Traffic light stays green for 10 seconds
           //Blinking the green light
           for ( i = 0 ; i<3; i++)
           {
            PORTB = EmergencyLights | 0b10000000;  //Green light off
            delay(50);
            PORTB = EmergencyLights | 0b10000010;  //Green light on
            delay(50);
           }
      //Traffic Light 2 is Yellow
           PORTB = EmergencyLights | 0b10000100;
           delay(200);
      //Traffic Light 2 is Red and all the traffic lights are red for safety.
           PORTB = EmergencyLights | 0b10001000;
           delay(100);
           emergency ();



      //Traffic Light 3 is green, the rest are Red
           PORTB = EmergencyLights | 0b10001000;
           PORTD = EmergencyLights | 0b00101000;
           delay(1000);    //Traffic light stays green for 10 seconds
           //Blinking the green light
           for ( i = 0 ; i<3; i++)
           {
            PORTD = EmergencyLights | 0b00001000;  //Green light off
            delay(50);
            PORTD = EmergencyLights | 0b00101000;  //Green light on
            delay(50);
           }
      //Traffic Light 3 is Yellow
           PORTD = EmergencyLights | 0b01001000;
           delay(200);
      //Traffic Light 3 is Red and all the traffic lights are red for safety.
           PORTD = EmergencyLights | 0b10001000;
           delay(100);
           emergency ();



      //Traffic Light 4 is green, the rest are Red
           PORTB = EmergencyLights | 0b10001000;
           PORTD = EmergencyLights | 0b10000010;
           delay(1000);    //Traffic light stays green for 10 seconds
           //Blinking the green light
           for ( i = 0 ; i<3; i++)
           {
            PORTD = EmergencyLights | 0b10000000;  //Green light off
            delay(50);
            PORTD = EmergencyLights | 0b10000010;  //Green light on
            delay(50);
           }
      //Traffic Light 4 is Yellow
           PORTD = EmergencyLights | 0b10000100;
           delay(200);
      //Traffic Light 4 is Red and all the traffic lights are red for safety.
           PORTD = EmergencyLights | 0b10001000;
           delay(100);
           emergency ();
      } // While




}
void emergency()
{
           while (Pressed == 0x01){    // check if we need first traffic light to be green
                 PORTB = 0b00101001;
                 PORTD = 0b10011001;
                 while (!(Pressed == 0x05));       // keep it green until we press the reset
                 EmergencyLights = 0x00;
                 PORTB = 0b10001000;
                 PORTD = 0b10001000;
                 delay(100);
           }
           while (Pressed == 0x02){     // check if we need second traffic light to be green
                 PORTB = 0b10010010;
                 PORTD = 0b10011001;
                 while (!(Pressed == 0x05));      // keep it green until we press the reset
                 EmergencyLights = 0x00;
                 PORTB = 0b10001000;
                 PORTD = 0b10001000;
                 delay(100);
           }
           while (Pressed == 0x03){     // check if we need third traffic light to be green
                 PORTB = 0b10011001;
                 PORTD = 0b00101001;
                 while (!(Pressed == 0x05));       // keep it green until we press the reset
                 EmergencyLights = 0x00;
                 PORTB = 0b10001000;
                 PORTD = 0b10001000;
                 delay(100);
           }
           while (Pressed == 0x04){     // check if we need fourth traffic light to be green
                 PORTB = 0b10011001;
                 PORTD = 0b10010010;
                 while (!(Pressed == 0x05));      // keep it green until we press the reset
                 EmergencyLights = 0x00;
                 PORTB = 0b10001000;
                 PORTD = 0b10001000;
                 delay(100);
           }

}

void USART_init(void)
 {
   TRISC = 0x80;//set the direction for the Tx and Rx Pins
   SPBRG = 51; // High Speed, 9600bps
   TXSTA = 0x24; //select the Asynchronous mode, 8-bit data, high speed
   RCSTA = 0x90; // Enable the serial port, 8-bit data, continuous receive
   INTCON = INTCON | 0xC0;// GIE and PEIE  and tmr0
   PIE1 =  PIE1 | 0x20;// Enable the RCIE

 }

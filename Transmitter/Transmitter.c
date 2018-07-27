  void USART_init(void);
  void USART_Tx(int);
  void delay (int);
  int tick = 0;
  int sec = 0;

  interrupt ()
 {
 if (INTCON & 0x04){    // check if the interrupt is caused by TMR0
 intcon = intcon & 0xFb;
 tick++;
 TMR0 = 0xFF - 0x50;
}
}

void delay(int sec){       //delay function
 INTCON = INTCON | 0x20;
 tick=0;
 while(tick<sec);
 INTCON = 0xC0;
 }


 void main (){
 option_reg = 0x07;        //prescale of 1:256
 PORTB = 0x00;
 TRISB = 0b11111110; //port B all output except B0 for the external interrupt
 TRISD = 0x00;
 USART_init();
 while (1)
 {




 if (portb & 0b00000010) //Check PORT RB1 if pressed
 {
 //Turn on Traffic Light 1
 USART_Tx(0x01);
  while (!(portb & 0b00100000)); //Check PORT RB5 if pressed
  //End the interrupt at the recieving side
 USART_Tx(0x05); //
 }

 if (portb & 0b00000100) //Check PORT RB2 if pressed
 {
 //Turn on Traffic Light 2
  USART_Tx(0x02);
  while (!(portb & 0b00100000)); //Check PORT RB5 if pressed
  //End the interrupt at the recieving side
 USART_Tx(0x05); //
 }
 if (portb & 0b00001000) //Check PORT RB3 if pressed
 {
 //Turn on Traffic Light 3
 USART_Tx(0x03); //
 while (!(portb & 0b00100000)); //Check PORT RB5 if pressed
  //End the interrupt at the recieving side
 USART_Tx(0x05); //
 }
 if (portb & 0b00010000) //Check PORT RB4 if pressed
 {
 //Turn on Traffic Light 4
 USART_Tx(0x04); //
 while (!(portb & 0b00100000)); //Check PORT RB5 if pressed
  //End the interrupt at the recieving side
 USART_Tx(0x05); //
 }



 }  //while
 }  //main

 void USART_init(void){
   TRISC = 0x80;//set the direction for the Tx and Rx Pins
   SPBRG = 51; // High Speed, 9600bps
   TXSTA = 0x24; //select the Asynchronous mode, 8-bit data, high speed
   RCSTA = 0x90; // Enable the serial port, 8-bit data, continuous receive
   INTCON = INTCON | 0xC0;// GIE and PEIE
   PIE1 =  PIE1 | 0x20;// Enable the RCIE

}

   void USART_Tx(int myChar){
   while(!(TXSTA & 0x02));
   TXREG = myChar;
   delay_ms(200);
   /*while (!(portb & 0b000100000)){  //to keep sending the same data as long as RB5 wasn't pressed
   while(!(TXSTA & 0x02));
   TXREG = myChar;
   }              */

}

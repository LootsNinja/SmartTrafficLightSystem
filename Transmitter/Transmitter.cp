#line 1 "C:/Users/sami/Google Drive/University/PSUT/Embedded Systems/Project/NewEmbeddedCodes/Transmitter/Transmitter.c"
 void USART_init(void);
 void USART_Tx(int);
 void delay (int);
 int tick = 0;
 int sec = 0;

 interrupt ()
 {
 if (INTCON & 0x04){
 intcon = intcon & 0xFb;
 tick++;
 TMR0 = 0xFF - 0x50;
}
}

void delay(int sec){
 INTCON = INTCON | 0x20;
 tick=0;
 while(tick<sec);
 INTCON = 0xC0;
 }


 void main (){
 option_reg = 0x07;
 PORTB = 0x00;
 TRISB = 0b11111110;
 TRISD = 0x00;
 USART_init();
 while (1)
 {




 if (portb & 0b00000010)
 {

 USART_Tx(0x01);
 while (!(portb & 0b00100000));

 USART_Tx(0x05);
 }

 if (portb & 0b00000100)
 {

 USART_Tx(0x02);
 while (!(portb & 0b00100000));

 USART_Tx(0x05);
 }
 if (portb & 0b00001000)
 {

 USART_Tx(0x03);
 while (!(portb & 0b00100000));

 USART_Tx(0x05);
 }
 if (portb & 0b00010000)
 {

 USART_Tx(0x04);
 while (!(portb & 0b00100000));

 USART_Tx(0x05);
 }



 }
 }

 void USART_init(void){
 TRISC = 0x80;
 SPBRG = 51;
 TXSTA = 0x24;
 RCSTA = 0x90;
 INTCON = INTCON | 0xC0;
 PIE1 = PIE1 | 0x20;

}

 void USART_Tx(int myChar){
 while(!(TXSTA & 0x02));
 TXREG = myChar;
 delay_ms(200);
#line 94 "C:/Users/sami/Google Drive/University/PSUT/Embedded Systems/Project/NewEmbeddedCodes/Transmitter/Transmitter.c"
}

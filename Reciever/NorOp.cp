#line 1 "C:/Users/sami/Google Drive/University/PSUT/Embedded Systems/Project/NewEmbeddedCodes/Reciever/NorOp.c"
unsigned char Pressed=0x00;
void emergency (void);
unsigned char EmergencyLights = 0x00;
void USART_init(void);
int i;
int tick = 0;
int sec = 0;


interrupt ()
 {
 if (INTCON & 0x04){
 intcon = intcon & 0xFb;
 tick++;
 TMR0 = 0xFF - 0x50;
}
 if (PIR1 & 0x02){
 Pressed = RCREG;
 PORTB = PORTB | 0b00010001;
 PORTD = PORTD | 0b00010001;
 EmergencyLights = 0b00010001;
 PIR1 = 0x00; }

 }
 void delay(int sec){
 INTCON = INTCON | 0x20;
 tick=0;
 while(tick<sec);
 INTCON = 0xC0;
 }

 void main (){
 option_reg = 0x07;
 TRISB = 0x00;
 TRISD = 0x00;
 PORTB = 0x00;
 PORTD = 0x00;
 USART_init();
 ADCoN1 = 0b00000110;
 PORTB = 0b10001000;
 PORTD = 0b10001000;
 delay(10);
 while (1)
 {



 PORTB = EmergencyLights | 0b00101000;
 PORTD = EmergencyLights | 0b10001000;
 delay(1000);

 for ( i = 0 ; i<3; i++)
 {
 PORTB = EmergencyLights | 0b00001000;
 delay(50);
 PORTB = EmergencyLights | 0b00101000;
 delay(50);
 }

 PORTB = EmergencyLights | 0b01001000;
 delay(200);

 PORTB = EmergencyLights | 0b10001000;
 delay(100);
 emergency ();



 PORTB = EmergencyLights | 0b10000010;
 PORTD = EmergencyLights | 0b10001000;
 delay(1000);

 for ( i = 0 ; i<3; i++)
 {
 PORTB = EmergencyLights | 0b10000000;
 delay(50);
 PORTB = EmergencyLights | 0b10000010;
 delay(50);
 }

 PORTB = EmergencyLights | 0b10000100;
 delay(200);

 PORTB = EmergencyLights | 0b10001000;
 delay(100);
 emergency ();




 PORTB = EmergencyLights | 0b10001000;
 PORTD = EmergencyLights | 0b00101000;
 delay(1000);

 for ( i = 0 ; i<3; i++)
 {
 PORTD = EmergencyLights | 0b00001000;
 delay(50);
 PORTD = EmergencyLights | 0b00101000;
 delay(50);
 }

 PORTD = EmergencyLights | 0b01001000;
 delay(200);

 PORTD = EmergencyLights | 0b10001000;
 delay(100);
 emergency ();




 PORTB = EmergencyLights | 0b10001000;
 PORTD = EmergencyLights | 0b10000010;
 delay(1000);

 for ( i = 0 ; i<3; i++)
 {
 PORTD = EmergencyLights | 0b10000000;
 delay(50);
 PORTD = EmergencyLights | 0b10000010;
 delay(50);
 }

 PORTD = EmergencyLights | 0b10000100;
 delay(200);

 PORTD = EmergencyLights | 0b10001000;
 delay(100);
 emergency ();
 }




}
void emergency()
{
 while (Pressed == 0x01){
 PORTB = 0b00101001;
 PORTD = 0b10011001;
 while (!(Pressed == 0x05));
 EmergencyLights = 0x00;
 PORTB = 0b10001000;
 PORTD = 0b10001000;
 delay(100);
 }
 while (Pressed == 0x02){
 PORTB = 0b10010010;
 PORTD = 0b10011001;
 while (!(Pressed == 0x05));
 EmergencyLights = 0x00;
 PORTB = 0b10001000;
 PORTD = 0b10001000;
 delay(100);
 }
 while (Pressed == 0x03){
 PORTB = 0b10011001;
 PORTD = 0b00101001;
 while (!(Pressed == 0x05));
 EmergencyLights = 0x00;
 PORTB = 0b10001000;
 PORTD = 0b10001000;
 delay(100);
 }
 while (Pressed == 0x04){
 PORTB = 0b10011001;
 PORTD = 0b10010010;
 while (!(Pressed == 0x05));
 EmergencyLights = 0x00;
 PORTB = 0b10001000;
 PORTD = 0b10001000;
 delay(100);
 }

}

void USART_init(void)
 {
 TRISC = 0x80;
 SPBRG = 51;
 TXSTA = 0x24;
 RCSTA = 0x90;
 INTCON = INTCON | 0xC0;
 PIE1 = PIE1 | 0x20;

 }

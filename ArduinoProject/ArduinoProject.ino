/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.

  Most Arduinos have an on-board LED you can control. On the Uno and
  Leonardo, it is attached to digital pin 13. If you're unsure what
  pin the on-board LED is connected to on your Arduino model, check
  the documentation at http://arduino.cc

  This example code is in the public domain.

  modified 8 May 2014
  by Scott Fitzgerald
 */
int v;
int led;
boolean led_ences;
int estat_anterior = LOW;
unsigned long t0;
// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin 13 as an output.
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  Serial.begin(115200);

  led_ences = true ;
  t0 = millis();
}

// the loop function runs over and over again forever
  void loop() {
  
  
    if ( Serial.available() > 0  ) {
      v = Serial.read();
      if( v != -1){
        digitalWrite(v, HIGH);
      }
      if(v == 0){
         digitalWrite(2, LOW);
         digitalWrite(3, LOW);
         digitalWrite(4, LOW);
         digitalWrite(5, LOW);
      }
   }
 
}

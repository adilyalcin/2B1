// From bildr article: http://bildr.org/2012/08/rotary-encoder-arduino/
// Timer implementation taken from http://www.letmakerobots.com/node/28278
// props to RobotFreak 

//2/3 are special pins for interrupts
int encoderPin1 = 2;
int encoderPin2 = 3;
int pushbuttonPin = 4; // digital push button pin
int IRledPin = 13;
int IRsensorPin = A0;

int irFreq = 59286;
boolean irout = false;

boolean prox = false;
int lastIRsig = 0;

int m_incr = 1;
int m_decr = 2;
int m_down = 3;
int m_up   = 4;
int lock_on = 5;
int lock_off = 6;

int lastEncoded = 0;

int pushButtonState;
int buttonState = HIGH;

void setup() {
  Serial.begin (9600);

  // initialize timer1 
  noInterrupts();           // disable all interrupts
  TCCR1A = 0;
  TCCR1B = 0;

  TCNT1 = irFreq;            // preload timer 65536-16MHz/256/2Hz
  TCCR1B |= (1 << CS12);    // 256 prescaler 
  TIMSK1 |= (1 << TOIE1);   // enable timer overflow interrupt
  interrupts();             // enable all interrupts

  pinMode(encoderPin1, INPUT);
  pinMode(encoderPin2, INPUT);
  pinMode(pushbuttonPin, INPUT);
  pinMode(IRledPin, OUTPUT);     

  // turn pullup resistor on for digital pins
  digitalWrite(encoderPin1, HIGH); 
  digitalWrite(encoderPin2, HIGH);
  digitalWrite(pushbuttonPin, HIGH);

  // turn on IR LED by default.
  digitalWrite(IRledPin, HIGH);

  //call updateEncoder() when any high/low changed seen
  //on interrupt 0 (pin 2), or interrupt 1 (pin 3) 
  attachInterrupt(0, updateEncoder, CHANGE);
  attachInterrupt(1, updateEncoder, CHANGE);
}

void loop(){
}

ISR(TIMER1_OVF_vect) {
  pushButtonState = digitalRead(pushbuttonPin);

  TCNT1 = irFreq;  // preload timer
  // update IR led state
  irout = !irout;
//  digitalWrite(IRledPin, irout);

  // read analog reader
  int IRsignal = digitalRead(5);
  if(prox == true){
    if(IRsignal==0){
      Serial.println(lock_off); 
      prox = false;
    }
  }
  if(prox==false && IRsignal==1){
    Serial.println(lock_on);
    prox = true;
  }
  lastIRsig = IRsignal;

  // check button state
  if(pushButtonState!=buttonState){
     if (pushButtonState == HIGH) { 
       Serial.println(m_down);
     } else {
       Serial.println(m_up);
     }
     buttonState = pushButtonState;
  }

}

void updateEncoder(){
  int MSB = digitalRead(encoderPin1); //MSB = most significant bit
  int LSB = digitalRead(encoderPin2); //LSB = least significant bit

  int encoded = (MSB << 1) |LSB; //converting the 2 pin value to single number
  int sum  = (lastEncoded << 2) | encoded; //adding it to the previous encoded value

  if(sum == 0b1101 || sum == 0b0100 || sum == 0b0010 || sum == 0b1011) {
    Serial.println(m_incr);
  } else if(sum == 0b1110 || sum == 0b0111 || sum == 0b0001 || sum == 0b1000) {
    Serial.println(m_decr);
  }

  lastEncoded = encoded; // store for next time
}


//From bildr article: http://bildr.org/2012/08/rotary-encoder-arduino/

//these pins can not be changed 2/3 are special pins
int encoderPin1 = 2;
int encoderPin2 = 3;

int m_incr = 1;
int m_decr = 2;
int m_down = 3;
int m_up   = 4;

int pushbuttonPin = 4;

int pushButtonState;

volatile int lastEncoded = 0;
volatile long encoderValue = 0;

long lastencoderValue = 0;

int lastMSB = 0;
int lastLSB = 0;

int buttonState = HIGH;

void setup() {
  Serial.begin (9600);

  pinMode(encoderPin1, INPUT);
  pinMode(encoderPin2, INPUT);
  pinMode(pushbuttonPin, INPUT);

  // turn pullup resistor on for digital pins
  digitalWrite(encoderPin1, HIGH); 
  digitalWrite(encoderPin2, HIGH);
  digitalWrite(pushbuttonPin, HIGH);

  //call updateEncoder() when any high/low changed seen
  //on interrupt 0 (pin 2), or interrupt 1 (pin 3) 
  attachInterrupt(0, updateEncoder, CHANGE);
  attachInterrupt(1, updateEncoder, CHANGE);
}

void loop(){
  pushButtonState = digitalRead(pushbuttonPin);
  if(pushButtonState!=buttonState){
     if (pushButtonState == HIGH) { 
       Serial.println(m_down);
     } else {
       Serial.println(m_up);
     }
     buttonState = pushButtonState;
  }
  delay(50); //just here to slow down the output, and show it will work  even during a delay
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
}

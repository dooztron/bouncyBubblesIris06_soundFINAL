#include <Servo.h>      // include the servo library
Servo servoMotor[5];       // creates an instance of the servo object to control a servo
char servoPin[5] = {2,3,4,5,6};       // array for servo motor
int servoAngle[5] = {1,1,1,1,1};
//char numChars[5] = {'0','1','2','3','4'};
char buttons[5] = {8,9,10,11,12}; //button triggers
long nextTime[5] = {0,0,0,0,0};
boolean buttonPressed[5] = {false,false,false,false,false};
boolean buttonReleased[5] = {true,true,true,true,true};
boolean stateChanged[5] = {false,false,false,false,false};
boolean start = true;


void setup() { 
  Serial.begin(57600);       // initialize serial communications

  for (int i=0; i<5; i++){
    pinMode(buttons[i], OUTPUT);
    Serial.write(servoPin[i]);
    servoMotor[i].write(1);
    servoMotor[i].attach(servoPin[i]);  // attaches the servos
  }
} 

void loop() { 

  for (int i = 0; i<5; i++){
    if (digitalRead(buttons[i]) == HIGH && !buttonPressed[i] && buttonReleased[i]){
      servoAngle[i] = 70; //70
      stateChanged[i] = true;
      nextTime[i] = millis() + 2000;
      buttonPressed[i] = true;
      buttonReleased[i] = false;
      Serial.print(numChars[i]);
    }
    else{
      if(millis() > nextTime[i] && buttonPressed[i]){
        buttonPressed[i] = false;
        servoAngle[i] = 1; //1 
        digitalWrite(14+i, LOW);     //LEDs - turn off when irises close
        stateChanged[i] = true;
      }
      if(!digitalRead(buttons[i])){
        buttonReleased[i] = true;
      }
    }

    if(stateChanged[i]){
      servoMotor[i].write(servoAngle[i]);
      stateChanged[i] = false;
    }
  }
//  if(Serial.available()){
//        char incoming = Serial.read();
//    switch(incoming) {
//    case '0': 
//      digitalWrite(14, HIGH);
//      break;
//    case '1': 
//      digitalWrite(15, HIGH);
//      break;
//    case '2': 
//      digitalWrite(16, HIGH);
//      break;
//    case '3': 
//      digitalWrite(17, HIGH);
//      break;
//    case '4': 
//      digitalWrite(18, HIGH);
//      break;
//    default:
//      break;
//    }
//  }
}



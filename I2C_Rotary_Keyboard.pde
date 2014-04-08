#include <MemoryFree.h>
#include <Rotary.h>
#include <Wire.h>
#include <Button.h>

#define BUTTONS 3
#define ROTTARYS 3

unsigned long lastUpdated=0;

volatile char r1Incr=0;
volatile char r2Incr=0;
volatile char r3Incr=0;

volatile char b1Incr=0;
volatile char b2Incr=0;
volatile char b3Incr=0;

volatile char rottaryIncr[ROTTARYS]={0,0,0};
volatile char buttonIncr[BUTTONS]={0,0,0};
volatile char buttonStates[BUTTONS]={0,0,0};

volatile char changeFlag=0;
unsigned long lastHandledButtons=0;

Rotary r1 = Rotary(4,5);
Rotary r2 = Rotary(6,7);
Rotary r3 = Rotary(8,9);

Button btn1(10, PULLUP);
Button btn2(11, PULLUP);
Button btn3(12, PULLUP);

// todo make rotary array, and button array

void setup() {
  Serial.begin(9600);
  Wire.begin(6);                // join i2c bus with address #6
  Wire.onRequest(requestEvent); // register event
}

void loop() {
  handleRottarys();
  if(lastHandledButtons-millis()>200) // debouncing
  handleButtons();
}

void printMemory(){
  Serial.print("freeMemory()=");
  Serial.println(freeMemory());
}

// todo handle buttons with button array in loop
void handleButtons(){
  lastHandledButtons=millis();
  
  // btn1
  if (btn1.isPressed() && !buttonStates[0]){
    buttonStates[0]=1;
    Serial.println("pressed btn 1");
  }else if(!btn1.isPressed() && buttonStates[0]){
    b1Incr++;
    buttonStates[0]=0;
    changeFlag=1;
    Serial.println("released btn 1");
  }
  
  // btn2
  if (btn2.isPressed() && !buttonStates[1]){
    buttonStates[1]=1;
    Serial.println("pressed btn 2");
  }else if(!btn2.isPressed() && buttonStates[1]){
    b2Incr++;
    buttonStates[1]=0;
    changeFlag=1;
    Serial.println("released btn 2");
  }
  
  // btn3
  if (btn3.isPressed() && !buttonStates[2]){
    buttonStates[2]=1;
    Serial.println("pressed btn 3");
  }else if(!btn3.isPressed() && buttonStates[2]){
    b3Incr++;
    buttonStates[2]=0;
    changeFlag=1;
    Serial.println("released btn 3");
  }
}

// todo handle rotarys with rotary array in loop
void handleRottarys(){
  unsigned char result1 = r1.process();
  unsigned char result2 = r2.process();
  unsigned char result3 = r3.process();
  
  if (result1) {
    handleRotaryResult(result1, r1Incr);
    changeFlag=1;
  }
  if (result2) {
    handleRotaryResult(result2, r2Incr);
    changeFlag=1;
  }
  if (result3) {
    handleRotaryResult(result3, r3Incr);
    changeFlag=1;
  }
}

void handleRotaryResult(unsigned char result, volatile char &varIncr){
    if(result == DIR_CW){
      Serial.println("Right");
      varIncr++;
    }
    else{
      Serial.println("Left");
      varIncr--;
    }
    //printMemory();
}

void readRotarysByTwi_test(){
  r1Incr=0;
  r2Incr=0;
  r3Incr=0;
}

void requestEvent()
{
  /*  msg[0]    - start of message
      msg[1:3]  - rottary values
      msg[4:6]  - button values
      msg[7]    - end of message
  */
  uint8_t msg[8]={10, 0,0,0, 0,0,0, 10};
  
  msg[1]=r1Incr;
  msg[2]=r2Incr;
  msg[3]=r3Incr;
  
  msg[4]=b1Incr;
  msg[5]=b2Incr;
  msg[6]=b3Incr;
  
  if(changeFlag){
    Wire.write_raw(msg,8);   // Wire.write_raw is modified function Wire.write to accept arrays with 0's
    r1Incr=0;
    r2Incr=0;
    r3Incr=0;
    b1Incr=0;
    b2Incr=0;
    b3Incr=0;
    changeFlag=0;
  }
}

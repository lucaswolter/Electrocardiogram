import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

//can't use pins 0 and 1
//analog use A0 as only 0 in int
int pinPot = 0;
int potVal;
int x = 0;
int lastxPos = -1;
float lastheight = -height/2;
float A = 0;
// adjust MeasurementsToAverage
int MeasurementsToAverage = 2;
float[] values = new float[MeasurementsToAverage];
int i = 0;
float heart = 0;
float plotVal = 0;
int count = 0;
// adjust beatHeight
int beatHeight = 60;
int times = 0;
// adjust timeDelay (for bpm)
int timeDelay = 1000;
float lastTime = timeDelay + 1;
float bpm = 0;


void setup() {
  size(600, 400);
  
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  
  //set up all inputs and outputs
  arduino.pinMode(pinPot, Arduino.INPUT);

  //set up background
  background(0, 0, 0);
}

void draw() {
  
  //Draw axis
  //stroke(0, 0, 255);
  //line(0, 375, width, 375);
  //line(10, 0, 10, height);
  
  //value of volts through analog reader
  potVal = arduino.analogRead(pinPot);
   //println(potVal);

  //plot analog values over time
  values[i] = potVal;
  //println(potVal);
  
  i++;
  
  if (i == MeasurementsToAverage) {
    
    for (int j = 0; j < MeasurementsToAverage; j++) {
     heart += values[j];
     }
     
     i = 0;
     
    //print(heart + ",");
    plotVal = heart / MeasurementsToAverage;
    //println(plotVal);
    heart = 0;
    
    float Value = map(potVal,0,1023,0,500);
    //println(Value);
    float mapVal = map(potVal, 0, 1023, 0, (height));
    //println(mapVal);
    translate(0, height);
    A = map(mapVal, 0, 1023, 0, 255);
    stroke(3*A, (255-A)/2, (255-A)/2);
    strokeWeight(3);
    point(x, -mapVal);
    
    if ((lastheight + mapVal) > beatHeight && lastTime > timeDelay) {
      count++;
      if (millis() < timeDelay){
        lastTime = timeDelay + millis() - lastTime;
      }
      else {lastTime = millis() - lastTime;}
    }
    
    line(lastxPos, lastheight, x, -mapVal);
    lastxPos = x;
    lastheight = -mapVal;
    x=x+5;
    
    print(count + ",  ");
    
    if (millis() >= 60*pow(10, 3)*(times + 1)) {
     bpm = count; 
     count = 0;
     times++;
    }
    
    println(bpm);
  
    fill(0);
    stroke(0,0,0);
    rect(x + 1, -height, 50, height);
  }
    

  if (x >= width) {
    x = 0;
    lastxPos = -1;
    fill(0);
    stroke(0,0,0);
    rect(x, -height, 50, height);
  }
  
  
}

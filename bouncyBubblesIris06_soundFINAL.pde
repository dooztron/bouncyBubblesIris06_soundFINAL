import processing.serial.*;     // import the Processing serial library
Serial yayPort;                  // The serial port

import ddf.minim.*;
import ddf.minim.ugens.*;

ArrayList balllls;
float[][] irises = new float[5][2];
boolean irisesOpen[] = new boolean[5];
boolean[] irisFull = new boolean[5]; //did Iris eat a bubble?
int irisRadius = 30;
int irisDiameter = 60;
float startTime = millis(); 
float currTime;
float timer;
float[] closeTime = new float[5];
float closingTimer = 2000;
char[] numChars = {'0','1','2','3','4'};
int score = 0;

PImage BigHead;
Head aHead;

Bleep[] bleeps = new Bleep[5];

Minim       minim;
AudioOutput out;

void setup() {
  size(600, 1000);
  noStroke();

  String portName = Serial.list()[8];
  println(portName);
  yayPort = new Serial(this, portName, 57600);

  balllls = new ArrayList();
  balllls.add(new Ball (random(60, 540), 0, 40));

  for (int i = 0; i < 5; i++) {
    irisesOpen[i] = false;
  }
  for (int i = 0; i < 3; i++) {
    irises[i][0] = 155*i+138;
    irises[i][1] = 900;
  }
  for (int i = 0; i < 2; i++) {
    irises[i+3][0] = 160*i+215;
    irises[i+3][1] = 825;
  }
  
  BigHead = loadImage("http://th305.photobucket.com/albums/nn203/SoopaScrub3d/Misc/th_EDSMILE.gif");
  aHead = new Head(BigHead);
  
  minim = new Minim(this);
  out = minim.getLineOut();

  for (int i = 1; i < 6; i++) {
    bleeps[i-1] = new Bleep(500 + (i*100));
  }
  textSize(32);
}


void draw() {
  background(255);
  text(score, 10, height-7);
  noStroke();
  noFill();
  ellipseMode(CENTER);
  for (int i = 0; i < 5; i++){
    if (bleeps[i].playing) {
      if (millis() >= bleeps[i].stopTime) {
        bleeps[i].stopPlaying();
      }
    }
  }

  //irises
  for (int i = 0; i < 5; i++) {
    
    if (!irisesOpen[i]) {
      stroke(0);
    }
    else {
      stroke(255,0,0);
      noFill();
      if (millis() > closeTime[i]) {
        irisesOpen[i] = false;
        irisFull[i] = false;
      }
    }
    if(irisFull[i]){
      aHead.display(irises[i][0], irises[i][1]);
    }
    ellipse(irises[i][0], irises[i][1], irisDiameter, irisDiameter);
  }


  //timer to add new balls
  timer = 1000;
  currTime = millis() - startTime;
  if (currTime >= timer) {
    startTime = millis();
    balllls.add(new Ball (random(100, 500), 0, 40));
  }

  //ballll behavior
  for (int i = balllls.size()-1; i >0; i--) {
    Ball ball = (Ball) balllls.get(i);
    ball.collide(i);
    ball.move();
    ball.display();
    if (ball.dead() || ball.eaten) {
      balllls.remove(i);
    } 
  }

  if (yayPort.available() != 0) {
    char incoming = yayPort.readChar();
    switch(incoming) {
    case '0': 
      irisesOpen[0] = !irisesOpen[0];
      closeTime[0] = millis() + closingTimer;
      break;
    case '1': 
      irisesOpen[1] = !irisesOpen[1];
      closeTime[1] = millis() + closingTimer;
      break;
    case '2': 
      irisesOpen[2] = !irisesOpen[2];
      closeTime[2] = millis() + closingTimer;
      break;
    case '3': 
      irisesOpen[3] = !irisesOpen[3];
      closeTime[3] = millis() + closingTimer;
      break;
    case '4': 
      irisesOpen[4] = !irisesOpen[4];
      closeTime[4] = millis() + closingTimer;
      break;
    default:
      break;
    }
  }
}

void mouseReleased() {
  for (int i = 0; i <5; i++) {
    if (dist(irises[i][0], irises[i][1], mouseX, mouseY) < irisRadius) {
      irisesOpen[i] = !irisesOpen[i];
      closeTime[i] = millis() + closingTimer;
    }
  }
}

class Bleep {

  Oscil wave;
  public long stopTime;
  public boolean playing = false;

  Bleep(int freq) {
    wave = new Oscil( freq, 0.5f, Waves.SINE );
  }

  public void play() {
    stopTime = millis() + 300;
    wave.patch( out );
    playing = true;
  }

  public void stopPlaying() {
    wave.unpatch( out );
    playing = false;
  }
}


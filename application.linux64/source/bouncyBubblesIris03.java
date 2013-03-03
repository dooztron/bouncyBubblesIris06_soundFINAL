import processing.core.*; 
import processing.data.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class bouncyBubblesIris03 extends PApplet {

     // import the Processing serial library
Serial yayPort;                  // The serial port

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

PImage BigHead;
Head aHead;

public void setup() {
  size(600, 700);
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
    irises[i][0] = 200*i+100;
    irises[i][1] = 600;
  }
  for (int i = 0; i < 2; i++) {
    irises[i+3][0] = 200*i+200;
    irises[i+3][1] = 500;
  }
  
  BigHead = loadImage("http://th305.photobucket.com/albums/nn203/SoopaScrub3d/Misc/th_EDSMILE.gif");
  aHead = new Head(BigHead);
}


public void draw() {
  background(255);
  noStroke();
  noFill();
  ellipseMode(CENTER);

  //irises
  for (int i = 0; i < 5; i++) {
    if (!irisesOpen[i]) {
      //noStroke();
      //fill(255);
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
    balllls.add(new Ball (random(60, 540), 0, 40));
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

public void mouseReleased() {
  for (int i = 0; i <5; i++) {
    if (dist(irises[i][0], irises[i][1], mouseX, mouseY) < irisRadius) {
      irisesOpen[i] = !irisesOpen[i];
      closeTime[i] = millis() + closingTimer;
    }
  }
}

class Ball {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  float spring = 0.12f;
  float gravity = 0.03f;
  float friction = -0.9f;
  boolean eaten = false;

  Ball(float xin, float yin, float din) {
    x = xin;
    y = yin;
    diameter = din;
  } 

  public boolean dead() {
    if (y >= 670) {
      return true;
    }
    else {
      return false;
    }
  }

  public void collide(int id) {

    //ballll collisions
    for (int i = id; i > 0; i--) {
      Ball otherBall = (Ball) balllls.get(i);
      float dx = otherBall.x - x;
      float dy = otherBall.y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = otherBall.diameter/2 + diameter/2;

      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - otherBall.x) * spring;
        float ay = (targetY - otherBall.y) * spring;
        vx -= ax;
        vy -= ay;
        otherBall.vx += ax;
        otherBall.vy += ay;
      }
    }

    //iris collisions   
    for (int i = 0; i <  5; i++) {
      float dx = irises[i][0] - x;
      float dy = irises[i][1] - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = irisRadius + diameter/2;
      if (distance < minDist && !irisesOpen[i]) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - irises[i][0]) * spring;
        float ay = (targetY - irises[i][1]) * spring;
        vx -= ax;
        vy -= ay;
      }
      if (distance < .6f* minDist && irisesOpen[i]) { 
        eaten = true;
        irisFull[i] = true;
        //yayPort.write(numChars[i]);
        //println(numChars[i]);
      }
    }
  }

  public void move() {
    vy += gravity;
    if (vy < 0) {
      vy += gravity;
    }
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction;
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction;
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }

  public void display() {
    noStroke();
    fill(255, 0, 0);
    ellipse(x, y, diameter, diameter);
  }
}

//PImage BigHead; // A variable for the image file

PImage myBigHead;

class Head {
  //float x, y;   // Variables for image location
  //float rot;   // A variable for image rotation


  Head (PImage thatBigHead) { 
    myBigHead = thatBigHead;
   
  }

  public void display(float x, float y) {
    pushMatrix();
    translate(x, y);
   // rotate(rot);

    // Images can be animated just like regular shapes using variables, translate(), rotate(), and so on.
    image(BigHead, -25, -25, 50,50); 
    // Adjust variables for animation
    //x += 1.0;
  //  rot += 0.02;
    popMatrix();
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "bouncyBubblesIris03" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

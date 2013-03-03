class Ball {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  float spring = 0.12;
  float gravity = 0.03;
  float friction = -0.9;
  boolean eaten = false;

  Ball(float xin, float yin, float din) {
    x = xin;
    y = yin;
    diameter = din;
  } 

  boolean dead() {
    if (y >= 970) {
      return true;
    }
    else {
      return false;
    }
  }

  void collide(int id) {

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
      if (distance < .6* minDist && irisesOpen[i]) { 
        eaten = true;
        irisFull[i] = true;

        bleeps[i].play();
        score++;
      }
    }
  }

  void move() {
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

  void display() {
    noStroke();
    fill(255, 0, 0);
    ellipse(x, y, diameter, diameter);
  }
}


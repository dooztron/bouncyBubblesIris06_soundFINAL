
PImage myBigHead;

class Head {

  Head (PImage thatBigHead) { 
    myBigHead = thatBigHead;
   
  }

  void display(float x, float y) {
    pushMatrix();
    translate(x, y);

    // Images can be animated just like regular shapes using variables, translate(), rotate(), and so on.
    image(BigHead, -20, -20, 30,30); 
    popMatrix();
  }
}


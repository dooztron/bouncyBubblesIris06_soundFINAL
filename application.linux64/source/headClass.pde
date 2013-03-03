//PImage BigHead; // A variable for the image file

PImage myBigHead;

class Head {
  //float x, y;   // Variables for image location
  //float rot;   // A variable for image rotation


  Head (PImage thatBigHead) { 
    myBigHead = thatBigHead;
   
  }

  void display(float x, float y) {
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


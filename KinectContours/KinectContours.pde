import gab.opencv.*;
import SimpleOpenNI.*;

PImage src, dst;
SimpleOpenNI  context;
OpenCV opencv;

ArrayList<Contour> contours;

void setup()
{
  size(640, 480);
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  // enable depthMap generation 
  context.enableDepth();
  context.enableUser();
  context.enableRGB();

  src= context.userImage();
  opencv = new OpenCV(this, src);

  opencv.gray();
  opencv.threshold(20);
  dst = opencv.getOutput();

  contours = opencv.findContours();
  println("found " + contours.size() + " contours");
}

void draw()
{
  context.update();
  src = context.userImage();
  contours = opencv.findContours();
  scale(0.5);
  image(src, 0, 0);
  image(dst, src.width, 0);

  noFill();
  strokeWeight(3);
  
  for (Contour contour : contours)
  {
    stroke(0, 255, 0);
    contour.draw();
    
    stroke(255, 0, 0);
    beginShape();
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
      vertex(point.x, point.y);
    }
    endShape();
  }
}


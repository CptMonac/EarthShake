import gab.opencv.*;
import SimpleOpenNI.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.CvType;
import org.opencv.imgproc.Imgproc;

OpenCV opencv;
PImage beforeTower, afterTower, diff;
SimpleOpenNI  context;
int snapshotNumber;
Mat skinHistogram;
String prompt;

void setup()
{
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  //Enable all kinect cameras/sensors
  context.enableDepth();
  context.enableUser();
  context.enableRGB();
  
  //Capture images
  beforeTower = context.depthImage();
  size(beforeTower.width, beforeTower.height);

  opencv = new OpenCV(this, beforeTower);
  snapshotNumber = 0;
}

void draw()
{
  
  context.update();
  //Prompt for before/after pictures
  if (snapshotNumber == 0)
  {
    prompt = "Press enter key to take before snapshot";
    if (keyPressed)
    {
      if (key == '\n')
      {
        background(150);
        beforeTower = context.depthImage();
        opencv = new OpenCV(this, beforeTower);
        snapshotNumber = snapshotNumber + 1;
      }
    }
    else
    {
      textSize(20);
      fill(0, 102, 153);
      text(prompt, width/2 - textWidth(prompt)/2, height/2);
    }
  }
  else
  {
    background(150);
    prompt = "Press enter key to take after snapshot";
    if (keyPressed)
    {
      if (key == '\n')
      {
        afterTower = context.depthImage();
        opencv.diff(afterTower);
        diff = opencv.getSnapshot();
        imageComparison();
        snapshotNumber = 0;
      }
    }
    else
    {
      textSize(20);
      fill(0, 102, 153);
      text(prompt, width/2 - textWidth(prompt)/2, height/2);
    } 
  }

 
}

void imageComparison()
{
  pushMatrix();
  scale(0.5);
  image(beforeTower, 0, 0);
  image(afterTower, beforeTower.width, 0);
  image(diff, beforeTower.width, beforeTower.height);
  popMatrix();
  fill(204, 0, 0);
  text("before", 10, 20);
  text("after", beforeTower.width/2 + 10, 20);
  text("diff", beforeTower.width/2 + 10, beforeTower.height/2 + 20);
}

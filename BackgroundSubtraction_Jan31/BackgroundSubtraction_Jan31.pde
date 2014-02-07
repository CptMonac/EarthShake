import gab.opencv.*;
import SimpleOpenNI.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.CvType;
import org.opencv.imgproc.Imgproc;
import blobDetection.*;


OpenCV opencv;
PImage beforeTower, afterTower, diff, temp;
SimpleOpenNI  context;
int snapshotNumber;
Mat skinHistogram;
String prompt;
String fileName;
int[] dmap1,dmap2;

ArrayList<Contour> contours;
BlobDetection theBlobDetection;


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
  beforeTower = createImage(640, 480, RGB);
  temp = context.depthImage();
  beforeTower = temp.get();
  size(beforeTower.width, beforeTower.height);

  opencv = new OpenCV(this, beforeTower);
  snapshotNumber = 0;
}

void draw()
{
  
  context.update();
  if ((keyPressed) && (key == 'c')) //Take a before picture
  {
    background(150);
    beforeTower = createImage(640, 40, RGB);
    PImage depthImage = context.depthImage();
    depthImage.loadPixels();
    dmap1 = context.depthMap();

    //Strip out error locations
    for (int i = 0; i<context.depthMapSize(); i++)
    {
      if (dmap1[i] == 0)  //Error value
        context.depthImage().pixels[i]=color(0,0,0);

      if (dmap1[i] > 800) //Irrelevant depths
        context.depthImage().pixels[i]=color(0,0,0);
    }

    //Save background image
    temp = context.depthImage();
    beforeTower = temp.get();
    fileName = sketchPath + java.io.File.separator + "beforeTower.jpg";
    beforeTower.save(fileName);
  }
  else
    dmap1 = context.depthMap();

  //Get current depth image
  PImage depthImage = context.depthImage();
  depthImage.loadPixels();
  dmap2 = context.depthMap();

  //Strip out error locations
  for (int i = 0; i<context.depthMapSize(); i++)
  {
    if (dmap2[i] == 0)  //Error value
      context.depthImage().pixels[i]=color(0,0,0);

    if (dmap2[i] > 800) //Irrelevant depths
      context.depthImage().pixels[i]=color(0,0,0);
  }

  //Perform background subtraction
  beforeTower = loadImage("beforeTower.jpg");
  opencv = new OpenCV(this, beforeTower);
  afterTower = context.depthImage();
  opencv.diff(afterTower);
  diff = opencv.getSnapshot();
        
  //Remove error locations
  for (int i = 0; i < context.depthMapSize(); i++)
  {
    if (dmap1[i]==0 || dmap2[i]==0 )
      diff.pixels[i]=color(0,0,0);
  }
  imageComparison();

}

void imageComparison()
{
  pushMatrix();
  scale(0.5);
  image(diff, 0, 0);
  image(afterTower, beforeTower.width, 0);
  image(beforeTower, beforeTower.width, beforeTower.height);
  
  theBlobDetection = new BlobDetection(diff.width, diff.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  theBlobDetection.computeBlobs(diff.pixels);
  drawBlobsAndEdges(true, true);

  popMatrix();
  fill(204, 0, 0);
  text("diff", 10, 20);
  text("after", beforeTower.width/2 + 10, 20);
  text("before", beforeTower.width/2 + 10, beforeTower.height/2 + 20);
}

void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        strokeWeight(2);
        stroke(0, 255, 0);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
            eA.x*width, eA.y*height, 
            eB.x*width, eB.y*height
              );
        }
      }

      // Blobs
      if (drawBlobs)
      {
        strokeWeight(1);
        stroke(255, 0, 0);
        rect(
        b.xMin*width, b.yMin*height, 
        b.w*width, b.h*height
          );
      }
    }
  }
}


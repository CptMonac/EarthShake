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
Mat skinHistogram;
String prompt;
String fileName;
int[] dmap1,dmap2;
ArrayList<Contour> contours;
BlobDetection theBlobDetection;
BlobRect boundingRectangle;


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
  
  //Initialize capture images
  beforeTower = createImage(640, 480, RGB);
  temp = context.depthImage();
  beforeTower = temp.get();
  size(beforeTower.width, beforeTower.height);

  //Initialize openCv
  opencv = new OpenCV(this, beforeTower);
}

void draw()
{
  
  context.update();                 //Update camera image

  if ((keyPressed) && (key == 'c')) //Take a reference picture if camera key pressed
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
  ArrayList<BlobRect> towerContours = mergeBlobs();
  
  if (drawBlobs)
  {
    BlobRect tempBlob;
    for (int i = 0; i<towerContours.size(); i++)
    {
      strokeWeight(2);
      stroke(255, 0, 0);
      tempBlob = towerContours.get(i);
      rect(tempBlob.x, tempBlob.y, tempBlob.blobWidth, tempBlob.blobHeight);
    }
  }
  // for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  // {
  //   b=theBlobDetection.getBlob(n);
  //   if (b!=null)
  //   {
  //     // Edges
  //     if (drawEdges)
  //     {
  //       strokeWeight(2);
  //       stroke(0, 255, 0);
  //       for (int m=0;m<b.getEdgeNb();m++)
  //       {
  //         eA = b.getEdgeVertexA(m);
  //         eB = b.getEdgeVertexB(m);
  //         if (eA !=null && eB !=null)
  //           line(
  //           eA.x*width, eA.y*height, 
  //           eB.x*width, eB.y*height
  //             );
  //       }
  //     }

  //     // Blobs
  //     if (drawBlobs)
  //     {
  //       strokeWeight(1);
  //       stroke(255, 0, 0);
  //       rect(
  //       b.xMin*width, b.yMin*height, 
  //       b.w*width, b.h*height
  //         );
  //     }
  //   }
  // }
}

ArrayList<BlobRect> mergeBlobs()
{
  int blobCount = theBlobDetection.getBlobNb();
  ArrayList<BlobRect> mergedBlobs = new ArrayList<BlobRect>();

  for (int i =0; i<theBlobDetection.getBlobNb(); i++)
  {
    Blob currBlob = theBlobDetection.getBlob(i);
    BlobRect currRect = new BlobRect(currBlob);
    mergedBlobs.add(currRect);

    for (int j = 0; j < mergedBlobs.size(); j++)
    {
      if (rectOverlap(currRect, mergedBlobs.get(j)) && (currRect != mergedBlobs.get(j)))
      {
        mergedBlobs.remove(currRect);
        mergedBlobs.remove(j);
        mergedBlobs.add(boundingRectangle);
      }
    }
  }
  return mergedBlobs;
}

public class BlobRect {
  public float x;
  public float y;
  public float blobWidth;
  public float blobHeight;

  BlobRect(Blob inputBlob)
  {
    x = inputBlob.xMin*width;
    y = inputBlob.yMin*height;
    blobWidth = inputBlob.w*width;
    blobHeight = inputBlob.h*height;
  }

  BlobRect(float inputX, float inputY, float inputWidth, float inputHeight)
  {
    x = inputX;
    y = inputY;
    blobWidth = inputWidth;
    blobHeight = inputHeight;
  }
}
boolean valueInRange(float value, float min, float max)
{
 return (value >= min) && (value <= max);
}
boolean rectOverlap(BlobRect A, BlobRect B)
{
  boolean xOverlap = false;
  boolean yOverlap = false; 
  float boundX = 0;
  float boundY = 0;
  float boundWidth = 0;
  float boundHeight = 0;

  //Horizontal Overlap
  if (valueInRange(A.x, B.x, B.x + B.blobWidth))
  {
    xOverlap = true;
    boundX = min(A.x,B.x);
    boundWidth = max(A.x+A.blobWidth, B.x+B.blobWidth);
  }
  else if (valueInRange(B.x, A.x, A.x + A.blobWidth))
  {
    xOverlap = true;
    boundX = min(A.x,B.x);
    boundWidth = max(A.x+A.blobWidth, B.x+B.blobWidth);
  }

  //Vertical Overlap
  if (valueInRange(A.y, B.y, B.y + B.blobHeight))
  {
    yOverlap = true;
    boundY = min(B.y,A.y);
    boundHeight = max(A.y+A.blobHeight, B.y+B.blobHeight);

  }
  else if (valueInRange(B.y, A.y, A.y + B.blobHeight))
  {
    yOverlap = true;
    boundY = min(A.y,B.y);
    boundHeight = max(A.y+A.blobHeight, B.y+B.blobHeight);
  }

  if (xOverlap && yOverlap)
  {
    boundingRectangle = new BlobRect(boundX, boundY, boundWidth, boundHeight);
    return true;
  }
  else
  {
    boundingRectangle = null;
    return false;
  }
}


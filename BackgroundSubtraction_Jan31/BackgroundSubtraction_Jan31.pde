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
import controlP5.*;


OpenCV opencv, opencv_c;
PImage beforeTower, afterTower, diff, temp, colorTower;
SimpleOpenNI  context;
Mat skinHistogram;
String prompt;
String fileName;
int[] dmap1,dmap2;
ArrayList<Contour> contours;
BlobDetection theBlobDetection;
BlobDetection theColorBlobDetection;
BlobRect boundingRectangle;
ControlP5 controlP5;
ArrayList<BlobRect> staleTowers;
ArrayList<BlobRect> originalTowerLocations; 
ArrayList<BlobRect> staleTowers_c;
ArrayList<BlobRect> originalTowerLocations_c;
boolean gameStarted;
boolean gameFinished;
BlobRect losingTower;

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
  //context.setMirror(true);
  context.alternativeViewPointDepthToImage(); //Calibrate depth and rgb cameras
  //colorMode(HSB, 360);                      //Use HSV Color space
 
  //Initialize capture images
  beforeTower = createImage(640, 480, RGB);
  temp = context.depthImage();
  beforeTower = temp.get();
  size(beforeTower.width, beforeTower.height);
  staleTowers = new ArrayList<BlobRect>();
  originalTowerLocations = new ArrayList<BlobRect>();
  staleTowers_c = new ArrayList<BlobRect>();
  originalTowerLocations_c = new ArrayList<BlobRect>();
  gameStarted = false;
  gameFinished = false;

  //Initialize openCv
  opencv = new OpenCV(this, beforeTower);
  opencv.useColor(HSB);
  
  //Draw GUI
  setupGUI();
  
}

void draw()
{
  
  context.update();                 //Update camera image

  dmap1 = context.depthMap();
  //Get current depth image
  PImage depthImage = context.depthImage();
  colorTower = new PImage(depthImage.getImage());
  depthImage.loadPixels();
  dmap2 = context.depthMap();

  //Strip out error locations
  for (int i = 0; i<context.depthMapSize(); i++)
  {
    if (dmap2[i] == 0)  //Error value
      {
        context.depthImage().pixels[i]=color(0,0,0);
        colorTower.pixels[i]=color(255,255,255);
      }

    if ((dmap2[i] < 600) || (dmap2[i] > 800)) //Irrelevant depths
      {
        context.depthImage().pixels[i]=color(0,0,0);
      }
   
    else if (dmap2[i] > 400 && dmap2[i] < 800)
      colorTower.pixels[i] = context.rgbImage().pixels[i];
 
  }

  opencv_c = new OpenCV(this, colorTower);
  //opencv_c.inRange(92,110); //green
  //opencv_c.inRange(55,80); //blue
  //opencv_c.inRange(118,145); //yellow
  opencv_c.inRange(20,50); //red
  //colorTower = opencv_c.getOutput();

  /*
  for (int i=0; i<context.depthMapSize(); i++)
  {
    if (dmap2[i]>0 && dmap2[i]<800)
      colorTower.pixels[i] = context.rgbImage().pixels[i];
  } */
 
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
  image(colorTower, 0,beforeTower.height);
  image(beforeTower, beforeTower.width, beforeTower.height);
  
  theBlobDetection = new BlobDetection(diff.width, diff.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  theBlobDetection.computeBlobs(diff.pixels);
  drawBlobsAndEdges(true, true);
 
  theColorBlobDetection = new BlobDetection(colorTower.width, colorTower.height);
  theColorBlobDetection.setPosDiscrimination(false);
  theColorBlobDetection.setThreshold(0.38f);
  theColorBlobDetection.computeBlobs(colorTower.pixels);
  //drawBlobsAndEdges_c(true, true);
  
  popMatrix();
  fill(204, 0, 0);
  text("diff", 10, 20);
  text("after", beforeTower.width/2 + 10, 20); 
  text("color", 10, beforeTower.height/2 + 20);
  text("before", beforeTower.width/2 + 10, beforeTower.height/2 + 20);
}

void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges )
{
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  ArrayList<BlobRect> towerContours = mergeBlobs();
  ArrayList<LegoTower> colorContours = detectColor(towerContours);

  if (drawBlobs && gameFinished)
  {
    textSize(26);
    text("FALLEN", losingTower.x + 20, losingTower.y - 30);
    controlP5.getController("startDetection").setLock(false);
    gameStarted = false;
    int bgcolor = controlP5.getController("updateBackground").getColor().getBackground();
    controlP5.getController("startDetection").setColorBackground(color(bgcolor));
    textSize(15);
  }
  else if (drawBlobs && !gameStarted)
  {
    textSize(20);
    strokeWeight(2);
    stroke(255, 0, 0);
    BlobRect tempBlob;
    LegoTower tempTower = new LegoTower();
    
    //Draw blob outlines
    for (int i = 0; i<towerContours.size(); i++)
    {
      tempBlob = towerContours.get(i);
      rect(tempBlob.x, tempBlob.y, tempBlob.blobWidth, tempBlob.blobHeight);
      text(tempBlob.blobHeight, tempBlob.x + 20, tempBlob.y - 30);
    }

    //Draw coloured blobs
    for (int i = 0; i<colorContours.size(); i++)
    {
      tempTower = colorContours.get(i);
      tempTower.drawTower();
    }
  }
  else if (drawBlobs && gameStarted)
  {
    textSize(20);
    strokeWeight(2);
    stroke(255, 0, 0);
    BlobRect oldBlob, currBlob;
    int originalTowerCount = originalTowerLocations.size();
    
    for(int i = 0; i<towerContours.size(); i++)
    {
      if (i < originalTowerCount)
      {
        oldBlob = originalTowerLocations.get(i);
        currBlob = towerContours.get(i);

        rect(currBlob.x, currBlob.y, currBlob.blobWidth, currBlob.blobHeight);
        float heightDiff = (currBlob.blobHeight - oldBlob.blobHeight);
        float widthDiff = (currBlob.blobWidth - oldBlob.blobWidth);
        
        if (heightDiff < -40)
        {
          gameFinished = true;
          losingTower = currBlob;
          text("FALLEN", currBlob.x + 20, currBlob.y - 30);
        }
        else if (widthDiff < -40)
        {
          gameFinished = true;
          losingTower = currBlob;
          text("FALLEN", currBlob.x + 20, currBlob.y - 30);
        }
        else 
          text("STANDING", currBlob.x + 20, currBlob.y - 30);
      }
      else 
      {
        currBlob = towerContours.get(i);
        rect(currBlob.x, currBlob.y, currBlob.blobWidth, currBlob.blobHeight);
        text(currBlob.blobHeight, currBlob.x + 20, currBlob.y - 30);
      }
    }
  }
  textSize(15);
  //detectColor(towerContours);
}

void mouseClicked()
{
  color pixelColor = pixels[mouseY*width + mouseX];
  println(hue(pixelColor) + "\t" + saturation(pixelColor) + "\t" + brightness(pixelColor));
  text("hue:"+hue(pixelColor), 100, 100);
  text("Coords:"+mouseX+","+mouseY, 100, 300);
  if (hue(pixelColor) > 210)
  {
    pixels[mouseY*width + mouseX] = color(255, 165, 0);
    text("Red", mouseX, mouseY);
  }
}

ArrayList<LegoTower> detectColor(ArrayList<BlobRect> inputTowers)
{
  BlobRect tempBlob;
  int offset;
  float pixelValue;

  loadPixels();
  offset = beforeTower.height;
  ArrayList<LegoTower> towerBlobs = new ArrayList<LegoTower>();
  LegoTower tempTower;

  for (int i = 0; i<inputTowers.size(); i++)
  {
    tempBlob = inputTowers.get(i);
    stroke(255,0,0);
    noFill();
    rect(tempBlob.x, tempBlob.y+offset, tempBlob.blobWidth, tempBlob.blobHeight);
    stroke(255,0,0);
    noFill();
    text(tempBlob.x-20+","+tempBlob.y, tempBlob.x, tempBlob.y+offset - 30);
    
    float redOriginX, redOriginY, redFinalX, redFinalY;
    float greenOriginX, greenOriginY, greenFinalX, greenFinalY;
    float yellowOriginX, yellowOriginY, yellowFinalX, yellowFinalY;
    float blueOriginX, blueOriginY, blueFinalX, blueFinalY;

    redOriginY = 0.0;
    redOriginX = 0.0;
    redFinalX = redOriginX;
    redFinalY = redOriginY;
    greenOriginX = 0.0;
    greenOriginY = 0.0;
    greenFinalX = 0.0;
    greenFinalY = 0.0;
    yellowOriginY = 0.0;
    yellowOriginX = 0.0;
    yellowFinalY = 0.0;
    yellowFinalX = 0.0;
    blueOriginY = 0.0;
    blueOriginX = 0.0;
    blueFinalY = 0.0;
    blueFinalX = 0.0;
    
    //This assumes that all relevant colors are in clusters of color
    for(int pixelY = int(tempBlob.y/2 +offset/2); pixelY < tempBlob.blobHeight/2+offset/2+tempBlob.y/2; pixelY++)
    {
      for (int pixelX = int(tempBlob.x/2); pixelX < tempBlob.blobWidth/2+tempBlob.x/2; pixelX++)
      {
        color pixelColor = pixels[pixelY*width + pixelX];
        pixelValue = hue(pixelColor);
        if (pixelValue > 210 && pixelValue < 256)    //Identify Red Hue
        {
          if ((redOriginX <= 0) && (redOriginY <=0))
          {
            redOriginX = pixelX*2;
            redOriginY = pixelY*2;
          }
          else 
          {
            redFinalX = pixelX*2;
            redFinalY = pixelY*2;
          }
          // stroke(255,0,0);
          // ellipse(pixelX*2, pixelY*2, 2, 2);
        }
        else if (pixelValue > 20 && pixelValue < 40) //Identify Yellow hue
        {
          if ((yellowOriginX <= 0) && (yellowOriginY <= 0))
          {
            yellowOriginX = pixelX*2;
            yellowOriginY = pixelY*2;
          }
          else 
          {
            yellowFinalX = pixelX*2;
            yellowFinalY = pixelY*2;
          }
          // stroke(255,255,0);
          // ellipse(pixelX*2, pixelY*2, 2, 2);
        }
        else if (pixelValue > 60 && pixelValue < 75) //Identify Green hue
        {
          if ((greenOriginX <= 0) && (greenOriginY <= 0))
          {
            greenOriginX = pixelX*2;
            greenOriginY = pixelY*2;
          }
          else 
          {
            greenFinalX = pixelX*2;
            greenFinalY = pixelY*2;
          }
          // stroke(0,255,0);
          // ellipse(pixelX*2, pixelY*2, 2, 2);
        }
        else if (pixelValue > 150 && pixelValue < 165) //Identify Blue hue
        {
          if ((blueOriginX <= 0) && (blueOriginY <= 0))
          {
            blueOriginX = pixelX*2;
            blueOriginY = pixelY*2;
          }
          else 
          {
            blueFinalX = pixelX*2;
            blueFinalY = pixelY*2;
          }
          // stroke(0,0,255);
          // ellipse(pixelX*2, pixelY*2, 2, 2);
        }
      }
    }

    //Construct colored blobs
    tempTower = new LegoTower();
    tempTower.updateRedSegment(redOriginX, redOriginY, redFinalX, redFinalY);
    tempTower.updateGreenSegment(greenOriginX, greenOriginY, greenFinalX, greenFinalY);
    tempTower.updateYellowSegment(yellowOriginX, yellowOriginY, yellowFinalX, yellowFinalY);
    tempTower.updateBlueSegment(blueOriginX, blueOriginY, blueFinalX, blueFinalY);
    towerBlobs.add(tempTower);
  }
  return towerBlobs;
}


ArrayList<BlobRect> mergeBlobs()
{
  stroke(255,0,0);
  int blobCount = theBlobDetection.getBlobNb();
  ArrayList<BlobRect> mergedBlobs = new ArrayList<BlobRect>();

  for (int i =0; i<theBlobDetection.getBlobNb(); i++)
  {
    Blob currBlob = theBlobDetection.getBlob(i);
    BlobRect currRect = new BlobRect(currBlob);
    if ((currRect.blobWidth * currRect.blobHeight) > 1200)
      mergedBlobs.add(currRect);

    for (int j = 0; j < mergedBlobs.size(); j++)
    {
      if (rectOverlap(currRect, mergedBlobs.get(j)) && (currRect != mergedBlobs.get(j)))
      {
        //println(currRect.x, mergedBlobs.get(j).x, currRect.blobWidth, mergedBlobs.get(j).blobWidth, boundingRectangle.blobWidth ); 
        //println(currRect.y, mergedBlobs.get(j).y, currRect.blobWidth, mergedBlobs.get(j).blobHeight, boundingRectangle.blobHeight ); 
        mergedBlobs.remove(currRect);
        mergedBlobs.remove(mergedBlobs.get(j));
        mergedBlobs.add(boundingRectangle);
      }
    }
  }
  return mergedBlobs;
}

void drawBlobsAndEdges_c(boolean drawBlobs, boolean drawEdges )
{
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  ArrayList<BlobRect> towerContours = mergeBlobs_c();
  
  if (drawBlobs && gameFinished)
  {
    textSize(26);
    text("FALLEN", losingTower.x + 20, losingTower.y - 30);
    controlP5.getController("startDetection").setLock(false);
    gameStarted = false;
    int bgcolor = controlP5.getController("updateBackground").getColor().getBackground();
    controlP5.getController("startDetection").setColorBackground(color(bgcolor));
    textSize(15);
  }
  else if (drawBlobs && !gameStarted)
  {
    textSize(20);
    strokeWeight(2);
    stroke(255, 0, 0);
    BlobRect tempBlob;
    for (int i = 0; i<towerContours.size(); i++)
    {
      tempBlob = towerContours.get(i);
      rect(tempBlob.x, tempBlob.y+beforeTower.height, tempBlob.blobWidth, tempBlob.blobHeight);
      text(tempBlob.blobHeight, tempBlob.x + 20, tempBlob.y - 30);
    }
  }
  else if (drawBlobs && gameStarted)
  {
    textSize(20);
    strokeWeight(2);
    stroke(255, 0, 0);
    BlobRect oldBlob, currBlob;
    int originalTowerCount = originalTowerLocations_c.size();
    
    for(int i = 0; i<towerContours.size(); i++)
    {
      if (i < originalTowerCount)
      {
        oldBlob = originalTowerLocations_c.get(i);
        currBlob = towerContours.get(i);

        rect(currBlob.x, currBlob.y+beforeTower.height, currBlob.blobWidth, currBlob.blobHeight);
        float heightDiff = (currBlob.blobHeight - oldBlob.blobHeight);
        float widthDiff = (currBlob.blobWidth - oldBlob.blobWidth);
        
        if (heightDiff < -40)
        {
          gameFinished = true;
          losingTower = currBlob;
          text("FALLEN", currBlob.x + 20, currBlob.y - 30);
        }
        else if (widthDiff < -40)
        {
          gameFinished = true;
          losingTower = currBlob;
          text("FALLEN", currBlob.x + 20, currBlob.y - 30);
        }
        else 
          text("STANDING", currBlob.x + 20, currBlob.y - 30);
      }
      else 
      {
        currBlob = towerContours.get(i);
        rect(currBlob.x, currBlob.y+beforeTower.height, currBlob.blobWidth, currBlob.blobHeight);
        text(currBlob.blobHeight, currBlob.x + 20, currBlob.y - 30);
      }
    }
  }
  textSize(15);
}

ArrayList<BlobRect> mergeBlobs_c()
{
  int blobCount = theColorBlobDetection.getBlobNb();
  ArrayList<BlobRect> mergedBlobs_c = new ArrayList<BlobRect>();

  for (int i =0; i<theColorBlobDetection.getBlobNb(); i++)
  {
    Blob currBlob = theColorBlobDetection.getBlob(i);
    BlobRect currRect = new BlobRect(currBlob);
    if ((currRect.blobWidth * currRect.blobHeight) > 1200)
      mergedBlobs_c.add(currRect);

    for (int j = 0; j < mergedBlobs_c.size(); j++)
    {
      if (rectOverlap(currRect, mergedBlobs_c.get(j)) && (currRect != mergedBlobs_c.get(j)))
      {
        mergedBlobs_c.remove(currRect);
        mergedBlobs_c.remove(mergedBlobs_c.get(j));
        mergedBlobs_c.add(boundingRectangle);
      }
    }
  }
  return mergedBlobs_c;
}

public class LegoTower {
  public BlobRect redSegment;
  public BlobRect blueSegment;
  public BlobRect greenSegment;
  public BlobRect yellowSegment;

  LegoTower()
  {
    redSegment = new BlobRect();
    blueSegment = new BlobRect();
    greenSegment = new BlobRect();
    yellowSegment = new BlobRect();
  }

  public void drawTower()
  {
    stroke(255,255,0);
    rect(redSegment.x, redSegment.y, redSegment.blobWidth, redSegment.blobHeight);
    rect(blueSegment.x, blueSegment.y, blueSegment.blobWidth, blueSegment.blobHeight);
    rect(greenSegment.x, greenSegment.y, greenSegment.blobWidth, greenSegment.blobHeight);
    rect(yellowSegment.x, yellowSegment.y, yellowSegment.blobWidth, yellowSegment.blobHeight);
  }

  public void updateRedSegment(float OriginX, float OriginY, float FinalX, float FinalY)
  {
    redSegment.updateBounds(OriginX, OriginY, abs(FinalX - OriginX), abs(FinalY - OriginY));
  }

  public void updateGreenSegment(float OriginX, float OriginY, float FinalX, float FinalY)
  {
    greenSegment.updateBounds(OriginX, OriginY, abs(FinalX - OriginX), abs(FinalY - OriginY));
  }

  public void updateBlueSegment(float OriginX, float OriginY, float FinalX, float FinalY)
  {
    blueSegment.updateBounds(OriginX, OriginY, abs(FinalX - OriginX), abs(FinalY - OriginY));
  }

  public void updateYellowSegment(float OriginX, float OriginY, float FinalX, float FinalY)
  {
    yellowSegment.updateBounds(OriginX, OriginY, abs(FinalX - OriginX), abs(FinalY - OriginY));
  }
  
}


public class BlobRect {
  public float x;
  public float y;
  public float blobWidth;
  public float blobHeight;

  BlobRect()
  {
    x = 0;
    y = 0;
    blobWidth = 0;
    blobHeight = 0;
  }

  BlobRect(Blob inputBlob)
  {
    x = inputBlob.xMin*640;
    y = inputBlob.yMin*480;
    blobWidth = inputBlob.w*640;
    //println(inputBlob.w);
    blobHeight = inputBlob.h*480;
  }

  BlobRect(float inputX, float inputY, float inputWidth, float inputHeight)
  {
    x = inputX;
    y = inputY;
    blobWidth = inputWidth;
    blobHeight = inputHeight;
  }

  public void updateBounds(float inputX, float inputY, float inputWidth, float inputHeight)
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
  if (valueInRange(A.x, B.x, B.x + B.blobWidth + 15))
  {
    xOverlap = true;
    boundX = B.x;
    
    if ((B.x+B.blobWidth)>(A.x+A.blobWidth))
      boundWidth = B.blobWidth;
    else
      boundWidth = (A.blobWidth + A.x - B.x);
  }
  else if (valueInRange(B.x, A.x, A.x + A.blobWidth + 15))
  {
    xOverlap = true;
    boundX = A.x;
    
    if ((A.x+A.blobWidth)>(B.x+B.blobWidth))
      boundWidth = A.blobWidth;
    else
      boundWidth = (B.blobWidth + B.x - A.x );
  }

  //Vertical Overlap
  if (valueInRange(A.y, B.y, B.y + B.blobHeight + 15))
  {
    yOverlap = true;
    boundY = B.y;
    
    if ((B.y+B.blobHeight)>(A.y+A.blobHeight))
      boundHeight = B.blobHeight;
    else
      boundHeight = ((A.y+A.blobHeight) - (B.y));

  }
  else if (valueInRange(B.y, A.y, A.y + A.blobHeight + 15))
  {
    yOverlap = true;
    boundY = A.y;
    
    if ((A.y+A.blobHeight)>(B.y+B.blobHeight))
      boundHeight = A.blobHeight;
    else
      boundHeight = ((B.y+B.blobHeight) - (A.y));
  }


  //Create new bounding rectangle
  if (xOverlap && yOverlap)
  {
    boundingRectangle = new BlobRect(boundX, boundY, boundWidth, boundHeight);
    //println(boundHeight,boundWidth);
     //println(A.x,B.x,boundX,boundWidth); 
    return true;
  }
  else
  {
    boundingRectangle = null;
    return false;
  }
}

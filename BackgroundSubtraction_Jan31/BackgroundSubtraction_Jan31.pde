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


OpenCV opencv;
PImage beforeTower, afterTower, diff, temp, colorTower;
SimpleOpenNI  context;
int[] dmap1,dmap2;
BlobDetection theBlobDetection;
BlobRect boundingRectangle;
ControlP5 controlP5;

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
  
  //Initialize capture images
  beforeTower = createImage(640, 480, RGB);
  temp = context.depthImage();
  beforeTower = temp.get();
  size(beforeTower.width, beforeTower.height);

  //Initialize openCv
  opencv = new OpenCV(this, beforeTower);
  
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
        colorTower.pixels[i]=color(0,0,0);
      }

    if ((dmap2[i] < 600) || (dmap2[i] > 1000)) //Irrelevant depths
      {
        context.depthImage().pixels[i]=color(0,0,0);
      }
   
    else if (dmap2[i] > 400 && dmap2[i] < 1000)
      colorTower.pixels[i] = context.rgbImage().pixels[i];
 
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
  image(colorTower, 0,beforeTower.height);
  image(beforeTower, beforeTower.width, beforeTower.height);
  
  theBlobDetection = new BlobDetection(diff.width, diff.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  theBlobDetection.computeBlobs(diff.pixels);
  blobDebugMode();
  //drawBlobsAndEdges(true, true);
 
  popMatrix();
  fill(204, 0, 0);
  text("diff", 10, 20);
  text("after", beforeTower.width/2 + 10, 20); 
  text("color", 10, beforeTower.height/2 + 20);
  text("before", beforeTower.width/2 + 10, beforeTower.height/2 + 20);
}

void blobDebugMode()
{
  ArrayList<BlobRect> towerContours = mergeBlobs();
  ArrayList<LegoTower> colorContours = analyzeTower(towerContours);
  BlobRect currBlob;
  LegoTower currentTower;

  for (int i = 0; i < towerContours.size(); i++)
  {
    stroke(255, 0, 0);
    noFill();
 
    //Draw blob tower info
    currBlob = towerContours.get(i);
    
    float blobW = currBlob.blobWidth;
    float blobH = currBlob.blobHeight;
    float x = currBlob.x;
    float y = currBlob.y;
    
    rect(x, y, blobW, blobH);
    
    text(blobH, x+20, y-30);

    //Draw coloured blobs
    for (int j = 0; j<colorContours.size(); j++)
    {
      currentTower = colorContours.get(j);
      currentTower.drawTower();
      currentTower.printChart();
    }
  }
}

void gameMode()
{
  ArrayList<BlobRect> towerContours = mergeBlobs();
  ArrayList<LegoTower> towerObjects = analyzeTower(towerContours);
  BlobRect currBlob;
  LegoTower currentTower;
  
  for (int i = 0; i < towerContours.size(); i++)
  {
    stroke(255, 0, 0);
    noFill();
 
    //Get tower info
    currBlob = towerContours.get(i);
    currentTower = towerObjects.get(i);
    
    //Draw blob tower info
    float blobW = currBlob.blobWidth;
    float blobH = currBlob.blobHeight;
    float x = currBlob.x;
    float y = currBlob.y;
    
    rect(x, y, blobW, blobH);
    
    //Detect fallen towers
    float heightDiff = blobH - currentTower.getTowerHeight();
    if (heightDiff < (currentTower.getTowerHeight()*0.10))    //If fallen a distance of 10% of original height, classify as fallen
      text("Fallen", x+20, y-30);
  }
}


// void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges )
// {
//   noFill();
//   Blob b;
//   EdgeVertex eA, eB;
//   ArrayList<BlobRect> towerContours = mergeBlobs();
//   ArrayList<LegoTower> colorContours = analyzeTower(towerContours);

//   if (drawBlobs && gameFinished)
//   {
//     textSize(26);
//     text("FALLEN", losingTower.x + 20, losingTower.y - 30);
//     controlP5.getController("startDetection").setLock(false);
//     gameStarted = false;
//     int bgcolor = controlP5.getController("updateBackground").getColor().getBackground();
//     controlP5.getController("startDetection").setColorBackground(color(bgcolor));
//     textSize(15);
//   }
//   else if (drawBlobs && !gameStarted)
//   {
//     textSize(20);
//     strokeWeight(2);
//     stroke(255, 0, 0);
//     BlobRect tempBlob;
//     LegoTower currentTower;
    
//     //Draw blob outlines
//     for (int i = 0; i<towerContours.size(); i++)
//     {
//       tempBlob = towerContours.get(i);
//       rect(tempBlob.x, tempBlob.y, tempBlob.blobWidth, tempBlob.blobHeight);
//       text(tempBlob.blobHeight, tempBlob.x + 20, tempBlob.y - 30);
//     }

//     //Draw coloured blobs
//     for (int i = 0; i<colorContours.size(); i++)
//     {
//       currentTower = colorContours.get(i);
//       currentTower.drawTower();
//     }
//   }
//   else if (drawBlobs && gameStarted)
//   {
//     textSize(20);
//     strokeWeight(2);
//     stroke(255, 0, 0);
//     BlobRect oldBlob, currBlob;
//     LegoTower currentTower;
//     int originalTowerCount = originalTowerLocations.size();
    
//     for(int i = 0; i<towerContours.size(); i++)
//     {
//       if (i < originalTowerCount)
//       {
//         oldBlob = originalTowerLocations.get(i);
//         currBlob = towerContours.get(i);

//         rect(currBlob.x, currBlob.y, currBlob.blobWidth, currBlob.blobHeight);
//         float heightDiff = (currBlob.blobHeight - oldBlob.blobHeight);
//         float widthDiff = (currBlob.blobWidth - oldBlob.blobWidth);
        
//         if (heightDiff < -40)
//         {
//           gameFinished = true;
//           losingTower = currBlob;
//           text("FALLEN", currBlob.x + 20, currBlob.y - 30);
//         }
//         else if (widthDiff < -40)
//         {
//           gameFinished = true;
//           losingTower = currBlob;
//           text("FALLEN", currBlob.x + 20, currBlob.y - 30);
//         }
//         else 
//           text("STANDING", currBlob.x + 20, currBlob.y - 30);
//       }
//       else 
//       {
//         currBlob = towerContours.get(i);
//         stroke(255, 0, 0);
//         rect(currBlob.x, currBlob.y, currBlob.blobWidth, currBlob.blobHeight);
//         text(currBlob.blobHeight, currBlob.x + 20, currBlob.y - 30);

//         //Draw coloured blobs
//         for (int j = 0; j<colorContours.size(); j++)
//         {
//           currentTower = colorContours.get(j);
//           currentTower.drawTower();
//         }
//       }
//     }
//   }
//   textSize(15);
// }

void mouseClicked()
{
  color pixelColor = pixels[mouseY*width + mouseX];
  println(hue(pixelColor) + "\t" + saturation(pixelColor) + "\t" + brightness(pixelColor));
  text("hue:"+hue(pixelColor), 100, 100);
  text("Coords:"+mouseX+","+mouseY, 100, 300);
}

ArrayList<LegoTower> analyzeTower(ArrayList<BlobRect> inputTowers)
{
  BlobRect inputTower;                //Stores blob object of lego tower
  float pixelValue;                   //Stores rgb value of selected pixel
  
  //Initialize data structures for lego tower analysis
  ArrayList<LegoTower> outputTowers = new ArrayList<LegoTower>();
  LegoTower currentTower;

  //Decompose all input towers into color components
  for (int i = 0; i<inputTowers.size(); i++)
  {
    inputTower = inputTowers.get(i);
    currentTower = new LegoTower(inputTower);
    outputTowers.add(currentTower);
  }
  return outputTowers;
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


boolean valueInRange(float value, float min, float max)
{
 return (value >= min) && (value <= max);
}

//Determines if two input rectangles overlap and calculates smallest bounding rectangle
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

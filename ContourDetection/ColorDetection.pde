//*************************************************** COLOR DETECTION
import java.util.List;
import blobDetection.*;


//OpenCV opencv;
PImage beforeTower, afterTower, diff, temp, colorTower;
//SimpleOpenNI  context;
BlobDetection theBlobDetection;
BlobRect boundingRectangle;
String colorOrder;

String[] blobDebugMode()
{
  ArrayList<BlobRect> towerContours = mergeBlobs();
  println(towerContours.size());
  ArrayList<LegoTower> colorContours = analyzeTower(towerContours);
  println(colorContours.size());
  String[] colorTowers = new String[colorContours.size()];
  BlobRect currBlob;
  LegoTower currentTower;
  
  //Draw coloured blobs
  println(colorContours.size());
  for (int j = 0; j<colorContours.size(); j++)
  {
    currentTower = colorContours.get(j);
    currentTower.drawTower();
    colorOrder = currentTower.towerColor();
    textSize(40);
    if (j==0)
      text(colorOrder, 200, 300);
    else if (j==1)
      text(colorOrder, 400, 300);
    textSize(15);
    println(colorOrder);
    colorTowers[j] = colorOrder;
  }
  //colorTowers = reverse(colorTowers);
  return colorTowers;
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

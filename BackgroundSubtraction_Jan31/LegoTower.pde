/*This class decomposes input lego tower blobs into their constitutent color components
  It assumes that colors are in clusters and not mixed -- BE WARNED!!
*/
public class LegoTower
{
  public BlobRect redSegment;
  public BlobRect blueSegment;
  public BlobRect greenSegment;
  public BlobRect yellowSegment;
  public String colorOrder;

  private PVector RedOrigin, RedFinal;
  private PVector GreenOrigin, GreenFinal;
  private PVector YellowOrigin, YellowFinal;
  private PVector BlueOrigin, BlueFinal;
  private PVector towerOrigin;
  private float towerWidth, towerHeight;

  LegoTower()
  {
    redSegment = new BlobRect();
    blueSegment = new BlobRect();
    greenSegment = new BlobRect();
    yellowSegment = new BlobRect();
  }
  LegoTower(BlobRect inputTower)
  {
    float scaleFactor = 0.5;        //Scale factor to account for mismatched pixel locations -- use as necessary    
    float pixelValue;               //Stores rgb value of selected pixel
    int offset = beforeTower.height;//Offset for display in processing window
    
    //Initialize variables
    towerOrigin = new PVector(inputTower.x, inputTower.y);
    towerWidth = inputTower.blobWidth;
    towerHeight = inputTower.blobHeight;
    colorOrder = "";

    RedOrigin = new PVector(-1, -1);
    RedFinal = new PVector(-1, -1);
    GreenOrigin = new PVector(-1, -1);
    GreenFinal = new PVector(-1, -1);
    YellowOrigin = new PVector(-1, -1);
    YellowFinal = new PVector(-1, -1);
    BlueOrigin = new PVector(-1, -1);
    BlueFinal = new PVector(-1, -1);

    //Load the pixel data for the display window into the pixels[] array
    loadPixels();  
    
    int rowMarker, ignoreColor, prevRowColor, currRowColor; // 0-R, 1-B, 2-G, 3-Y
    int rowColorInt, currBlock, currBlockRowCount, newBlockRowCount, newBlock, newBlockPosition;
    String rowColor = "";
    ignoreColor = -1;
    prevRowColor = -1;
    currRowColor = -1;
    rowMarker = -1;
    int[] colorCounts = {0, 0, 0, 0}; //RBGY
    int[] pastSevenRows = {-1, -1, -1, -1, -1, -1, -1};
    
    //Iterate through pixels in input blob and classify them
    for (int pixelY=int(inputTower.y*scaleFactor); pixelY < (inputTower.blobHeight+offset+inputTower.y)*scaleFactor; pixelY++)
    {
      //reset count for each color before starting new row
      colorCounts[0] = 0;
      colorCounts[1] = 0;
      colorCounts[2] = 0;
      colorCounts[3] = 0;
      
      prevRowColor = rowMarker;
      
      for (int pixelX = int(inputTower.x*scaleFactor); pixelX < (inputTower.blobWidth+inputTower.x)*scaleFactor; pixelX++)
      {
        color pixelColor = pixels[pixelY*width + pixelX];
        pixelValue = hue(pixelColor);

        if (pixelValue > 20 && pixelValue < 40)        //Identify yellow hue
        {        
          colorCounts[3]++;
        }
        else if (pixelValue > 60 && pixelValue < 75)   //Identify green hue
        {
          colorCounts[2]++;
        }
        else if (pixelValue > 150 && pixelValue < 165)  //Identify blue hue
        {
          colorCounts[1]++;
        }
        else if (pixelValue > 210 && pixelValue < 256)  //Identify red hue
        {
          colorCounts[0]++;
        }
      }
      
      rowColorInt = max(colorCounts);
      
      //Find color that had max value
      for (int i=0; i<4; i++) {
        if (rowColorInt == colorCounts[i]) {
          if (i==0) {
            rowColor = "red";
            rowMarker = i;
          }
          else if (i==1) {
            rowColor = "blue";
            rowMarker = i;
          }
          else if (i==2) {
            rowColor = "green";
            rowMarker = i;
          }
          else {
            rowColor = "yellow";
            rowMarker = i;
          }
        }
      }   
      
//      if (rowMarker != ignoreColor)
//        currRowColor = rowMarker;
      
      for (int j=0; j<6; j++) {
        pastSevenRows[j] = pastSevenRows[j+1];
      }
      pastSevenRows[6] = rowMarker;
      
      newBlock = -1;
      newBlockRowCount = 0;
      newBlockPosition = 0;
      if (pastSevenRows[0] == -1)
        currBlock = rowMarker;
      else {
        currBlock = prevRowColor;
        currBlockRowCount = 0;
        newBlockRowCount = 0;
        for (int k=0; k<7; k++) {
          if (pastSevenRows[k] == currBlock)
            currBlockRowCount++;
          else {
            newBlock = pastSevenRows[k];
            if (newBlockRowCount == 0)
              newBlockPosition = k;
            newBlockRowCount++;
          }
        }
        if (currBlock == -1)
          drawOrigin(newBlock, int(inputTower.x*scaleFactor), pixelY-newBlockPosition, scaleFactor); 
        else if (newBlockRowCount > currBlockRowCount) {
          ignoreColor = currBlock;
          drawFinal(currBlock, inputTower.blobWidth+inputTower.x, pixelY-newBlockPosition-1, scaleFactor);
          currBlock = newBlock;
          drawOrigin(newBlock, int(inputTower.x*scaleFactor), pixelY-newBlockPosition, scaleFactor);
        }
      }
      
//      if ((prevRowColor != currRowColor) && (prevRowColor != -1))
//        ignoreColor = prevRowColor;
      
      println("IN ROW "+pixelY+" of "+rowColor);
      
    }
    
    //Classify color segments
    redSegment = new BlobRect(RedOrigin.x, RedOrigin.y, abs(RedFinal.x - RedOrigin.x), abs(RedFinal.y - RedOrigin.y));
    blueSegment = new BlobRect(BlueOrigin.x, BlueOrigin.y, abs(BlueFinal.x - BlueOrigin.x), abs(BlueFinal.y - BlueOrigin.y));
    greenSegment = new BlobRect(GreenOrigin.x, GreenOrigin.y, abs(GreenFinal.x - GreenOrigin.x), abs(GreenFinal.y - GreenOrigin.y));
    yellowSegment = new BlobRect(YellowOrigin.x, YellowOrigin.y, abs(YellowFinal.x - YellowOrigin.x), abs(YellowFinal.y - YellowOrigin.y));

    //Record color order
    float[] colorOrigins = {RedOrigin.y, BlueOrigin.y, GreenOrigin.y, YellowOrigin.y};
    colorOrigins = reverse(sort(colorOrigins));

    for(int i = 0; i < colorOrigins.length; i++)
    {
      if ((colorOrigins[i] == RedOrigin.y) && (RedOrigin.y >=0))
        colorOrder+="R";
      else if ((colorOrigins[i] == BlueOrigin.y) && (BlueOrigin.y >=0))
        colorOrder+="B";
      else if ((colorOrigins[i] == GreenOrigin.y) && (GreenOrigin.y >=0))
        colorOrder+="G";
      else if ((colorOrigins[i] == YellowOrigin.y) && (YellowOrigin.y >=0))
        colorOrder+="Y";
    }
  }

  public void drawTower()
  {
    int offset = beforeTower.height;//Offset for display in processing window

    noFill();
    //Draw red segment
    stroke(255, 0, 0);
    rect(redSegment.x, redSegment.y, redSegment.blobWidth, redSegment.blobHeight);
    //Draw blue segment
    stroke(0, 0, 255);    
    rect(blueSegment.x, blueSegment.y, blueSegment.blobWidth, blueSegment.blobHeight);
    //Draw green segment
    stroke(0, 255, 0);
    rect(greenSegment.x, greenSegment.y, greenSegment.blobWidth, greenSegment.blobHeight);
    //Draw yellow segment
    stroke(255, 255, 0);
    rect(yellowSegment.x, yellowSegment.y, yellowSegment.blobWidth, yellowSegment.blobHeight);
    //Draw color order above tower
    textSize(20);
    stroke(255, 0, 0);
    text(colorOrder, towerOrigin.x + 20, towerOrigin.y - 30 + offset);
    textSize(15);
  }
  
  public void drawOrigin(int newBlock, float pixelX, float pixelY, float scaleFactor) 
  {
    if ((newBlock == 0) && (RedOrigin.x < 0))
      RedOrigin.set(pixelX/scaleFactor, pixelY/scaleFactor);
    else if ((newBlock == 1) && (BlueOrigin.x < 0))
      BlueOrigin.set(pixelX/scaleFactor, pixelY/scaleFactor);    
    else if ((newBlock == 2) && (GreenOrigin.x < 0))
      GreenOrigin.set(pixelX/scaleFactor, pixelY/scaleFactor); 
    else if (YellowOrigin.x < 0)
      YellowOrigin.set(pixelX/scaleFactor, pixelY/scaleFactor);
  }
  
  public void drawFinal(int oldBlock, float pixelX, float pixelY, float scaleFactor) 
  {
    if (oldBlock == 0)
      RedFinal.set(pixelX/scaleFactor, pixelY/scaleFactor);
    else if (oldBlock == 1)
      BlueFinal.set(pixelX/scaleFactor, pixelY/scaleFactor);    
    else if (oldBlock == 2)
      GreenFinal.set(pixelX/scaleFactor, pixelY/scaleFactor); 
    else
      YellowFinal.set(pixelX/scaleFactor, pixelY/scaleFactor);
  }  
}

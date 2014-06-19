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
  
  private PVector RedTopRight, RedBottomLeft;
  private PVector GreenTopRight, GreenBottomLeft;
  private PVector YellowTopRight, YellowBottomLeft;
  private PVector BlueTopRight, BlueBottomLeft;  

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
    
    RedTopRight = new PVector(-1, -1); 
    RedBottomLeft = new PVector(-1, -1);
    GreenTopRight = new PVector(-1, -1);
    GreenBottomLeft = new PVector(-1, -1);
    YellowTopRight = new PVector(-1, -1); 
    YellowBottomLeft = new PVector(-1, -1);
    BlueTopRight = new PVector(-1, -1); 
    BlueBottomLeft = new PVector(-1, -1);

    //Load the pixel data for the display window into the pixels[] array
    loadPixels();  
    
    /******************************
     *** initialize variables 
     ******************************/
    
    //Variables as markers/indices
    //Key: 0-R, 1-B, 2-G, 3-Y 
    int rowColorInt;
    int oldBlock;
    int currBlock, newBlock;
    int temp;
    int prevRowColor = -1; //updated for each new row
    int currRowColor = -1; //updated from rowMarker
    int rowMarker = -1; //max color in each row (temp row color)
    int blockPassed = -1;
    int permNewBlock = -1; //updated when origin is set
    int tempNewBlock = -1;
    
    //Variables for counting/debugging
    int currBlockRowCount = 0;
    int newBlockRowCount = 0;
    int newBlockPosition = 0;
    String rowColor = "";
    int[] pastSevenRows = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};

    //Arrays, all follow RBGY index format
    int[] ignoreColor = {0, 0, 0, 0};
    int[] colorCounts = {0, 0, 0, 0}; 
    
    //Variables for x values
    int xLeft = int(inputTower.x*scaleFactor);
    int xRight = int((inputTower.blobWidth+inputTower.x)*scaleFactor);
    int[] topLeftPix = {xLeft, xLeft, xLeft, xLeft};
    int[] topRightPix = {xRight, xRight, xRight, xRight};
    int[] bottomRightPix = {xRight, xRight, xRight, xRight};
    
    //Variables for y values
    int yUpper = int((inputTower.blobHeight+offset+inputTower.y)*scaleFactor);
    int yLower = int(inputTower.y*scaleFactor);
    int[] upperYLimit = {yUpper, yUpper, yUpper, yUpper};
    int[] lowerYLimit = {yLower, yLower, yLower, yLower};
    
    //Variables used as flags
    int blockInitialized = 0;
    int setTopLeftFlag = 1;      
    int firstRowFlag = 0;
    
    /********************************
     *** end initializing variables 
     ********************************/
    
    /**************************************************
     *** begin processing pixels in inputTower
     **************************************************/
    
    //Iterate through pixels in input blob and classify them
    int setY = yLower;
    int colorPixelFound = 0;
    for (int pixelY=yLower; pixelY < yUpper; pixelY++)
    {
      //Reset count for each color before starting new row
      colorCounts[0] = 0;
      colorCounts[1] = 0;
      colorCounts[2] = 0;
      colorCounts[3] = 0;

      //If block was just initialized, set firstRowFlag, then clear blockInitialized flag      
      if (blockInitialized == 1) {
        setTopLeftFlag = 1;
        firstRowFlag = 1;
        blockInitialized = 0;
      }
      
      int newxRight = xRight;
      int newxLeft = xLeft;
      
      //For each row, classify each pixel and count the number of each color's pixels in row
      //Set topLeft, topRight, and bottomRight when necessary
      for (int pixelX = xLeft; pixelX < xRight; pixelX++)
      {
        color pixelColor = pixels[pixelY*width + pixelX];
        pixelValue = hue(pixelColor);
        //colorPixelFound = 0;
        
        //Identify red hue
        if (pixelColorHue(pixelValue) == 0)  
        {
          colorPixelFound = 1;
//          fill(255,0,0);
//          text("R", pixelX*2, pixelY*2);
//          noFill();
          if (ignoreColor[0] == 0)
             colorCounts[0]++;
          if ((firstRowFlag == 1) && (permNewBlock==0)) {
            topLeftPix[0] = scanForTopLeft(xLeft, xRight, 0, pixelX, pixelY);
            setTopLeftFlag = 0;
            topRightPix[0] = scanForTopRight(xLeft, xRight, 0, pixelY);
          }        
          if (tempNewBlock==0)
            bottomRightPix[tempNewBlock] = scanForBottomRight(xLeft, xRight, 0, pixelY);
        }       
        
        //Identify blue hue
        else if (pixelColorHue(pixelValue) == 1)  
        {
          colorPixelFound = 1;
//          fill(255,255,255);
//          text("B", pixelX*2, pixelY*2);
//          noFill();
          if (ignoreColor[1] == 0)
             colorCounts[1]++;
          if ((firstRowFlag == 1) && (permNewBlock==1)) {
            newxLeft = pixelX;
            //topLeftPix[1] = pixelX;
            topLeftPix[1] = scanForTopLeft(xLeft, xRight, 1, pixelX, pixelY);
            setTopLeftFlag = 0;
            topRightPix[1] = scanForTopRight(xLeft, xRight, 1, pixelY);
          }
          if (tempNewBlock==1)
            bottomRightPix[tempNewBlock] = scanForBottomRight(xLeft, xRight, 1, pixelY);
        }
        
        //Identify green hue
        else if (pixelColorHue(pixelValue) == 2)   
        {
          colorPixelFound = 1;
//          fill(255,255,255);
//          text("G", pixelX*2, pixelY*2);
//          noFill();
          if (ignoreColor[2] == 0)          
            colorCounts[2]++;
          if ((firstRowFlag == 1) && (permNewBlock==2)) {
            newxLeft = pixelX;
            //topLeftPix[2] = pixelX;
            topLeftPix[2] = scanForTopLeft(xLeft, xRight, 2, pixelX, pixelY);
            setTopLeftFlag = 0;
            topRightPix[2] = scanForTopRight(xLeft, xRight, 2, pixelY);
          }
          if (tempNewBlock==2)
            bottomRightPix[tempNewBlock] = scanForBottomRight(xLeft, xRight, 2, pixelY);
        }
                
        //Identify yellow hue
        else if (pixelColorHue(pixelValue) == 3)        
        { 
          colorPixelFound = 1;
//          fill(255,255,0);
//          text("Y", pixelX*2, pixelY*2);
//          noFill();
          if (ignoreColor[3] == 0)
            colorCounts[3]++;
          if ((firstRowFlag == 1) && (permNewBlock==3)) {
            newxLeft = pixelX;
            //topLeftPix[3] = pixelX;
            topLeftPix[3] = scanForTopLeft(xLeft, xRight, 3, pixelX, pixelY);
            setTopLeftFlag = 0;
            topRightPix[3] = scanForTopRight(xLeft, xRight, 3, pixelY);
          }
          if (tempNewBlock==3)
            bottomRightPix[tempNewBlock] = scanForBottomRight(xLeft, xRight, 3, pixelY);
        }         
      }
      
      //If color was found in the row, update bottomRight pixel (here we're at the end of the row)
      if (colorPixelFound == 1) {
        if (tempNewBlock != -1)
          bottomRightPix[tempNewBlock] = scanForBottomRight(xLeft, xRight, tempNewBlock, pixelY);    
        firstRowFlag = 0; 
      }
    
      //Find max value of colors in that row
      rowColorInt = max(colorCounts);
      
      //Match color that had max value
      if (rowColorInt > 0) {
        if ((rowColorInt == colorCounts[0])) {
          rowColor = "red";
          rowMarker = 0;
        }
        else if (rowColorInt == colorCounts[1]) {
          rowColor = "blue";
          rowMarker = 1;
        }
        else if (rowColorInt == colorCounts[2]) {
          rowColor = "green";
          rowMarker = 2;
        }
        else if ((rowColorInt == colorCounts[3])) {
          rowColor = "yellow";
          rowMarker = 3;
        }
      }
  
      //Update the current row color
      currRowColor = rowMarker;
      
      //If a color was found, set tempNewBlock to that color
      //Move the array up a row and insert this row's color into array's last slot
      if ((currRowColor!=-1) && (ignoreColor[currRowColor]==0)) {
        tempNewBlock = currRowColor;

        //Shift array values up a row
        for (int j=0; j<12; j++) {
          temp = pastSevenRows[j+1];
          pastSevenRows[j] = temp;
        }
        pastSevenRows[12] = tempNewBlock;
      }
      
      //Reset current and new block's row counts to 0
      currBlockRowCount = 0;
      newBlockRowCount = 0;

      //Iterate through array to determine if there are more rows of the current block's color
      //  than rows of the new block's color, in the past 13 rows seen
      for (int k=0; k<13; k++) {
        if (pastSevenRows[k] == permNewBlock) {
          currBlockRowCount++;
        }
        else if (pastSevenRows[k] == tempNewBlock) {
          if (newBlockRowCount == 0)
            newBlockPosition = k;
          newBlockRowCount++;
        }
      }

      //First block of tower
      if ((max(ignoreColor)==0) && (newBlockRowCount==9) && (permNewBlock==-1)) {
        blockInitialized = 1;
        newxLeft = topLeftPix[tempNewBlock];
        permNewBlock = tempNewBlock;
        lowerYLimit[permNewBlock] = pixelY;
      }
        
      //Other blocks
      else if ((newBlockRowCount>=8) && (permNewBlock!=-1) && (permNewBlock!=tempNewBlock)) { 
        newxLeft = topLeftPix[tempNewBlock];
        
        if (ignoreColor[tempNewBlock]==0) {
          ignoreColor[permNewBlock] = 1;
          blockInitialized = 1;
          blockPassed = permNewBlock;
          permNewBlock = tempNewBlock;
          upperYLimit[blockPassed] = pixelY;
          lowerYLimit[permNewBlock] = pixelY;
        }
        
        //Special case of drawFinal for bottom-most block of each tower
        int ignoreCt = 0;
        for (int m=0; m<4; m++) {
          if (ignoreColor[m]==0)
            ignoreCt++;
        }       
        if ((ignoreCt==1) || (blockInitialized==1)) {
          setY = pixelY;
          continue;
        }     
      }
    }
    
    /**************************************************
     *** end processing pixels in inputTower
     **************************************************/
    
    //Set origin, final, and top right coordinates of blocks
    for (int c=0; c<4; c++) {
      if ((permNewBlock!=c) && (ignoreColor[c] != 0)) { 
        //for blocks that aren't bottom block
        drawOrigin(c, topLeftPix[c], lowerYLimit[c]-7, scaleFactor);
        drawFinal(c, bottomRightPix[c], upperYLimit[c]-8, scaleFactor);
        drawTopRight(c, topRightPix[c], lowerYLimit[c]-7, scaleFactor);
      }
      else if (permNewBlock==c) { 
        //for bottom block
        if (ignoreColor[c]==0) {
          //special case if there is only one block in tower
          drawOrigin(permNewBlock, topLeftPix[permNewBlock], lowerYLimit[c]-7, scaleFactor);
          drawFinal(permNewBlock, bottomRightPix[permNewBlock], yUpper-1, scaleFactor); 
          drawTopRight(c, topRightPix[c], setY-7, scaleFactor);
        }
        else {
          //general bottom block
          println("drawing bottom block: "+permNewBlock);
          drawOrigin(permNewBlock, topLeftPix[permNewBlock], setY-7, scaleFactor);
          drawFinal(permNewBlock, bottomRightPix[permNewBlock], yUpper-1, scaleFactor); 
          drawTopRight(c, topRightPix[c], setY-7, scaleFactor);
        }
      }
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
  
  //Scans first three lines of a block to determine its topLeft x and y coordinates
  public int scanForTopLeft(int xLeft, int xRight, int blockColor, int pixelLeft, int pixelRow)
  {
    float scaleFactor = 0.5;
    int topLeftFive[] = {0, 0, 0};
    int lookingForFirstPixColor;
    
    //Loop through each row and find left-most block-colored pixel; set value in array
    for (int y=0; y < 3; y++)
    {
      lookingForFirstPixColor = 1;
      int pixelY = pixelRow + y;
      for (int pixelX = xLeft; pixelX < xRight; pixelX++) {
        color pixelColor = pixels[pixelY*width + pixelX];
        float pixelValue = hue(pixelColor);
        if (lookingForFirstPixColor == 1) {
          if (pixelColorHue(pixelValue) == blockColor) {
            topLeftFive[y] = pixelX;
            if (blockColor==1) {
              fill(255,255,255);
              text("B", pixelX*2, pixelY*2);
              noFill();
            }
            else if (blockColor==2) {
              fill(0,255,0);
              text("G", pixelX*2, pixelY*2);
              noFill();
            }
            lookingForFirstPixColor = 0;
          }
        }
      }
    }
    
    //If a row's value was not set, it was probably an error. 
    //Set its value to the max of array to ignore.
    for (int j=0; j<3; j++) {
      if (topLeftFive[j]==0)
        topLeftFive[j] = max(topLeftFive);
    } 
    
    //Left-most pixel is minimum value in array
    return min(topLeftFive);
  }

  //Similar to scanForTopLeft
  //Scans first three lines of a block to determine its topRight x and y coordinates
  public int scanForTopRight(int xLeft, int xRight, int blockColor, int pixelRow)
  {
    float scaleFactor = 0.5;
    int topRightFive[] = {0, 0, 0};
    
    //Loop through each row and find left-most block-colored pixel; set value in array
    for (int y=0; y < 3; y++)
    {
      int pixelY = pixelRow + y;
      for (int pixelX = xLeft; pixelX < xRight; pixelX++) {
        color pixelColor = pixels[pixelY*width + pixelX];
        float pixelValue = hue(pixelColor);
        if (pixelColorHue(pixelValue) == blockColor) {
          topRightFive[y] = pixelX;
        }
      }
    }
    
    //If a row's value was not set, it was probably an error. 
    //Set its value to the min of array to ignore.
    for (int j=0; j<3; j++) {
      if (topRightFive[j]==0)
        topRightFive[j] = min(topRightFive);
    }

    //Right-most pixel is maximum value in array
    return max(topRightFive);
  }
  
  //Similar to scanForTopLeft, but with bottom rows of block
  //Scans last five lines of a block to determine its bottomRight x and y coordinates
  public int scanForBottomRight(int xLeft, int xRight, int blockColor, int pixelRow)
  {
    float scaleFactor = 0.5;
    int botRightFive[] = {0, 0, 0, 0, 0};
    int lookingForFirstPixColor;
    
    //Loop through each row and find right-most block-colored pixel; set value in array 
    for (int y=0; y < 5; y++)
    {
      lookingForFirstPixColor = 1;
      int pixelY = pixelRow - y;
      for (int pixelX = xLeft; pixelX < xRight; pixelX++) {
        color pixelColor = pixels[pixelY*width + pixelX];
        float pixelValue = hue(pixelColor);
        if (pixelColorHue(pixelValue) == blockColor) {
          botRightFive[y] = pixelX;
        }
      }
    }
    
    //If a row's value was not set, it was probably an error. 
    //Set its value to the min of array to ignore.
    for (int j=0; j<5; j++) {
      if ((blockColor==1) && (botRightFive[j]!=0)) {
        fill(0,255,255);
        text("B", botRightFive[j]*2, (pixelRow-j)*2);
        noFill();
      }
      if (botRightFive[j]==0)
        botRightFive[j] = min(botRightFive);
    }
    
    //Right-most pixel is maximum value in array
    return max(botRightFive);
  }
  
  //Determines color (0-R, 1-B, 2-G, 3-Y) from pixel's hue value
  public int pixelColorHue(float pixelValue) {
    int pixelColor = -1;
    if (pixelValue > 230 && pixelValue < 256) // red hue
      pixelColor = 0;
    else if (pixelValue > 150 && pixelValue < 165) // blue hue
      pixelColor = 1;
    else if (pixelValue > 60 && pixelValue < 75) // green hue
      pixelColor = 2;
    else if (pixelValue > 5 && pixelValue < 40) // yellow hue
      pixelColor = 3;
    return pixelColor;
  }

  //Displays visual colored blocks
  public void drawTower()
  {
    int offset = beforeTower.height;//Offset for display in processing window

    noFill();
    
    //Draw red segment
    if (RedFinal.x > 0) {
      //fill(255,0,0);
      stroke(255, 0, 0);
      strokeWeight(3);
      //rect(redSegment.x, redSegment.y, redSegment.blobWidth, redSegment.blobHeight);
      
      float Rx1 = RedOrigin.x;
      //println("Rx1 is "+RedOrigin.x);
      float Ry1 = RedOrigin.y;
      //println("Ry1 is "+RedOrigin.y);
      //float Rx2 = RedTopRight.x;
      float Rx2 = RedOrigin.x + redSegment.blobWidth;
      //println("Rx2 is "+Rx2);
      float Rx3 = RedFinal.x - redSegment.blobWidth;
      float Ry2 = RedFinal.y;
      //println("Ry2 is "+Ry2);
      float Rx4 = RedFinal.x;
      line(Rx1, Ry1, Rx2, Ry1);
      line(Rx2, Ry1, Rx4, Ry2);
      line(Rx4, Ry2, Rx3, Ry2);
      line(Rx3, Ry2, Rx1, Ry1);
    }
    
    //Draw blue segment
    if (BlueFinal.x > 0) {
      //fill(0,0,255);
      stroke(0, 10, 220);    
      strokeWeight(3);
      //rect(blueSegment.x, blueSegment.y, blueSegment.blobWidth, blueSegment.blobHeight);
      
      float Bx1 = BlueOrigin.x;
      //println("Bx1 is "+BlueOrigin.x);
      float By1 = BlueOrigin.y;
      //float Bx2 = BlueTopRight.x;
      float Bx2 = BlueOrigin.x + blueSegment.blobWidth;
      float Bx3 = BlueFinal.x - blueSegment.blobWidth;
      float By2 = BlueFinal.y;
      float Bx4 = BlueFinal.x;
      line(Bx1, By1, Bx2, By1);
      line(Bx2, By1, Bx4, By2);
      line(Bx4, By2, Bx3, By2);
      line(Bx3, By2, Bx1, By1); 
    }
    
    //Draw green segment
    if (GreenFinal.x > 0) {
      //fill(0,255,0);
      stroke(0, 255, 0);
      strokeWeight(3);
      //rect(greenSegment.x, greenSegment.y, greenSegment.blobWidth, greenSegment.blobHeight);
      
      float Gx1 = GreenOrigin.x;
      //println("Gx1 is "+GreenOrigin.x);
      float Gy1 = GreenOrigin.y;
      //float Gx2 = GreenTopRight.x;
      float Gx2 = GreenOrigin.x + greenSegment.blobWidth;
      float Gx3 = GreenFinal.x - greenSegment.blobWidth;
      float Gy2 = GreenFinal.y;
      float Gx4 = GreenFinal.x;
      line(Gx1, Gy1, Gx2, Gy1);
      line(Gx2, Gy1, Gx4, Gy2);
      line(Gx4, Gy2, Gx3, Gy2);
      line(Gx3, Gy2, Gx1, Gy1); 
    }
    
    //Draw yellow segment
    if (YellowFinal.x > 0) {
      //fill(255,255,0);
      stroke(255, 255, 0);
      strokeWeight(3);
      //rect(yellowSegment.x, yellowSegment.y, yellowSegment.blobWidth, yellowSegment.blobHeight);
      
      float Yx1 = YellowOrigin.x;
      //println("Yx1 is "+YellowOrigin.x);
      float Yy1 = YellowOrigin.y;
      //println("Yy1 is "+Yy1);
      //float Yx2 = YellowTopRight.x;
      float Yx2 = YellowOrigin.x + yellowSegment.blobWidth;
      float Yx3 = YellowFinal.x - yellowSegment.blobWidth;
      float Yy2 = YellowFinal.y;
      float Yx4 = YellowFinal.x;
      line(Yx1, Yy1, Yx2, Yy1);
      line(Yx2, Yy1, Yx4, Yy2);
      line(Yx4, Yy2, Yx3, Yy2);
      line(Yx3, Yy2, Yx1, Yy1); 
    }
    
    //Draw color order above tower
    textSize(20);
    noFill();
    stroke(255, 0, 0);
    text(colorOrder, towerOrigin.x + 20, towerOrigin.y - 30 + offset);
    textSize(15);
  }
  
  public void drawOrigin(int newBlock, int pixelX, int pixelY, float scaleFactor) 
  {
    if ((newBlock == 0) && (RedOrigin.x < 0))
      RedOrigin.set(pixelX/scaleFactor, pixelY/scaleFactor);
    else if ((newBlock == 1) && (BlueOrigin.x < 0))
      BlueOrigin.set(pixelX/scaleFactor, pixelY/scaleFactor);    
    else if ((newBlock == 2) && (GreenOrigin.x < 0))
      GreenOrigin.set(pixelX/scaleFactor, pixelY/scaleFactor); 
    else if ((newBlock == 3) && (YellowOrigin.x < 0))
      YellowOrigin.set(pixelX/scaleFactor, pixelY/scaleFactor);
  }
  
  public float getTowerWidth()
  {
    return towerWidth;
  }

  public float getTowerHeight()
  {
    return towerHeight;
  }
  
  //Sets Final x and y coord for block
  public void drawFinal(int oldBlock, int pixelX, int pixelY, float scaleFactor) 
  {
    if (oldBlock == 0) {
      if ((RedOrigin.x > 0))
        RedFinal.set(pixelX/scaleFactor, pixelY/scaleFactor);
    }
    else if (oldBlock == 1) {
      if ((BlueOrigin.x > 0))
        BlueFinal.set(pixelX/scaleFactor, pixelY/scaleFactor);    
    }
    else if (oldBlock == 2) {
      if ((GreenOrigin.x > 0))
        GreenFinal.set(pixelX/scaleFactor, pixelY/scaleFactor); 
    }
    else if (oldBlock == 3) {
      if ((YellowOrigin.x > 0))
        YellowFinal.set(pixelX/scaleFactor, pixelY/scaleFactor);
    }
  }

  //Sets topRight x and y coord for block  
  public void drawTopRight(int block, int pixelX, int pixelY, float scaleFactor) 
  {
    if ((block == 0) && (RedOrigin.x > 0))
      RedTopRight.set(pixelX/scaleFactor, pixelY/scaleFactor);
    else if ((block == 1) && (BlueOrigin.x > 0))
      BlueTopRight.set(pixelX/scaleFactor, pixelY/scaleFactor);    
    else if ((block == 2) && (GreenOrigin.x > 0))
      GreenTopRight.set(pixelX/scaleFactor, pixelY/scaleFactor); 
    else if ((block == 3) && (YellowOrigin.x > 0))
      YellowTopRight.set(pixelX/scaleFactor, pixelY/scaleFactor);
  }

  //Sets bottomLeft x and y coord for block
  public void drawBottomLeft(int block, int pixelX, int pixelY, float scaleFactor) 
  {
    if ((block == 0) && (RedOrigin.x > 0))
      RedBottomLeft.set(pixelX/scaleFactor, pixelY/scaleFactor);
    else if ((block == 1) && (BlueOrigin.x > 0))
      BlueBottomLeft.set(pixelX/scaleFactor, pixelY/scaleFactor);    
    else if ((block == 2) && (GreenOrigin.x > 0))
      GreenBottomLeft.set(pixelX/scaleFactor, pixelY/scaleFactor); 
    else if ((block == 3) && (YellowOrigin.x > 0))
      YellowBottomLeft.set(pixelX/scaleFactor, pixelY/scaleFactor);
  }

  //Displays debugging chart of towers and blocks' height and width on screen
  public void printChart() 
  {
    int yoffset = beforeTower.height;
    int xoffset = beforeTower.width;
    
    textSize(25);
    stroke(255,0,0);
    text("width", xoffset+300, yoffset+90);
    text("height", xoffset+450, yoffset+90);
    if (towerOrigin.x < (beforeTower.width)*0.5) {
      text("Tower 1:", xoffset+30, yoffset+120);
      text("Red:", xoffset+180, yoffset+120);
      text(redSegment.blobWidth, xoffset+300, yoffset+120);
      text(redSegment.blobHeight, xoffset+450, yoffset+120);
      text("Blue:", xoffset+180, yoffset+150);
      text(blueSegment.blobWidth, xoffset+300, yoffset+150);
      text(blueSegment.blobHeight, xoffset+450, yoffset+150);
      println("blue left: "+BlueOrigin.x+" and blue right: "+BlueFinal.x);
      text("Green:", xoffset+180, yoffset+180);
      text(greenSegment.blobWidth, xoffset+300, yoffset+180);
      text(greenSegment.blobHeight, xoffset+450, yoffset+180);
      text("Yellow:", xoffset+180, yoffset+210);
      text(yellowSegment.blobWidth, xoffset+300, yoffset+210);
      text(yellowSegment.blobHeight, xoffset+450, yoffset+210);
    }
    else if (towerOrigin.x > (beforeTower.width)*0.5) {
      text("Tower 2:", xoffset+30, yoffset+240);    
      text("Red:", xoffset+180, yoffset+240);
      text(redSegment.blobWidth, xoffset+300, yoffset+240);
      text(redSegment.blobHeight, xoffset+450, yoffset+240);
      text("Blue:", xoffset+180, yoffset+270);
      text(blueSegment.blobWidth, xoffset+300, yoffset+270);
      text(blueSegment.blobHeight, xoffset+450, yoffset+270);
      text("Green:", xoffset+180, yoffset+300);
      text(greenSegment.blobWidth, xoffset+300, yoffset+300);
      text(greenSegment.blobHeight, xoffset+450, yoffset+300);
      text("Yellow:", xoffset+180, yoffset+330);
      text(yellowSegment.blobWidth, xoffset+300, yoffset+330);
      text(yellowSegment.blobHeight, xoffset+450, yoffset+330);
    }
    textSize(15);
  }  
}

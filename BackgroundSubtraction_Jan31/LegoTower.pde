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
    
    int rowMarker, prevRowColor, currRowColor; // 0-R, 1-B, 2-G, 3-Y
    int rowColorInt, oldBlock;
    int currBlock, currBlockRowCount, newBlockRowCount, newBlock, newBlockPosition;
    int temp;
    String rowColor = "";
    prevRowColor = -1;
    currRowColor = -1;
    rowMarker = -1;
    int[] ignoreColor = {0, 0, 0, 0};
    int[] colorCounts = {0, 0, 0, 0}; //RBGY
    int[] pastSevenRows = {-1, -1, -1, -1, -1, -1, -1};
    
    //Iterate through pixels in input blob and classify them
    int yLower = int(inputTower.y*scaleFactor);
    int yUpper = int((inputTower.blobHeight+offset+inputTower.y)*scaleFactor);
    for (int pixelY=yLower; pixelY < yUpper; pixelY++)
    {
      //reset count for each color before starting new row
      colorCounts[0] = 0;
      colorCounts[1] = 0;
      colorCounts[2] = 0;
      colorCounts[3] = 0;
      
      prevRowColor = rowMarker;
      
      int xLeft = int(inputTower.x*scaleFactor);
      int xRight = int((inputTower.blobWidth+inputTower.x)*scaleFactor);
      int newxRight = xRight;
      int colorPixelFound;
      
      for (int pixelX = xLeft; pixelX < xRight; pixelX++)
      {
        color pixelColor = pixels[pixelY*width + pixelX];
        pixelValue = hue(pixelColor);
        colorPixelFound = 0;

        //Identify yellow hue
        if (pixelValue > 20 && pixelValue < 40)        
        { 
          colorPixelFound = 1;
          /* fill(255,255,0);
          text("Y", pixelX*2, pixelY*2);
          noFill(); */
          if (ignoreColor[3] == 0)
             colorCounts[3]++;
        }
        
        //Identify green hue
        else if (pixelValue > 60 && pixelValue < 75)   
        {
          colorPixelFound = 1;
          /* fill(0,255,0);
          text("G", pixelX*2, pixelY*2);
          noFill(); */
          if (ignoreColor[2] == 0)          
            colorCounts[2]++;
        }
        
        //Identify blue hue
        else if (pixelValue > 150 && pixelValue < 165)  
        {
          colorPixelFound = 1;
          /* fill(0,0,255);
          text("B", pixelX*2, pixelY*2);
          noFill(); */
          if (ignoreColor[1] == 0)
             colorCounts[1]++;
        }
        
        //Identify red hue
        else if (pixelValue > 220 && pixelValue < 256)  
        {
          colorPixelFound = 1;
          /* fill(255,0,0);
          text("R", pixelX*2, pixelY*2);
          noFill(); */
          if (ignoreColor[0] == 0)
             colorCounts[0]++;
        }
        
        if (colorPixelFound == 1)
          newxRight = pixelX;
      }
      
      rowColorInt = max(colorCounts);
      
      //Find color that had max value
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

      println("before");
      println("k=0 "+pastSevenRows[0]);
      println("k=1 "+pastSevenRows[1]);
      println("k=2 "+pastSevenRows[2]);
      println("k=3 "+pastSevenRows[3]);
      println("k=4 "+pastSevenRows[4]);
      println("k=5 "+pastSevenRows[5]);
      println("k=6 "+pastSevenRows[6]);
        
      for (int j=0; j<6; j++) {
        temp = pastSevenRows[j+1];
        pastSevenRows[j] = temp;
      }
      pastSevenRows[6] = rowMarker;

      newBlock = -1;
      newBlockRowCount = 0;
      newBlockPosition = 0;

      currBlock = prevRowColor;
      currBlockRowCount = 0;
      newBlockRowCount = 0;
      
      if (rowColor != "")
        println("rowColor "+rowColor);
      
      println("after");
      println("k=0 "+pastSevenRows[0]);
      println("k=1 "+pastSevenRows[1]);
      println("k=2 "+pastSevenRows[2]);
      println("k=3 "+pastSevenRows[3]);
      println("k=4 "+pastSevenRows[4]);
      println("k=5 "+pastSevenRows[5]);
      println("k=6 "+pastSevenRows[6]);
      
      for (int k=0; k<7; k++) {
        if (pastSevenRows[k] == currBlock) {
          currBlockRowCount++;
        }
        else {
          if ((newBlockRowCount == 0) && (pastSevenRows[k] != -1)) {
            newBlock = pastSevenRows[k];
            println("newBlock "+newBlock);
            newBlockPosition = k;
          }
          newBlockRowCount++;
        }
      }
      /*
      if (currBlock!= -1) {
        println("currBlock is "+currBlock+", currBlockRowCount "+currBlockRowCount);
        println("newBlock is "+newBlock+", newBlockRowCount "+newBlockRowCount);
      }
      */
      if (prevRowColor == -1) {
        drawOrigin(newBlock, xLeft, yLower+int(offset*scaleFactor), scaleFactor);
      }  
      
      if ((currBlockRowCount < newBlockRowCount) && (currBlock != -1)) {
        oldBlock = currBlock;
        if (ignoreColor[currBlock] == 0) {
          drawFinal(currBlock, xRight, pixelY-abs(2-newBlockPosition), scaleFactor);
          currBlock = newBlock;
          drawOrigin(oldBlock, xLeft, pixelY-abs(3-newBlockPosition), scaleFactor);
          println("drew new block");
          println("newBlockRowCount was "+newBlockRowCount);
          println("oldBlockRowCount was "+currBlockRowCount);
          if (newBlockRowCount == 7) {
            for (int p=0; p<7; p++) {
              pastSevenRows[p] = currBlock;
            }
          } 
        }
        
        if (newBlock != -1)
          ignoreColor[newBlock] = 1;
      }

    }
    
    //println("ignoreColor: "+ignoreColor[0]+","+ignoreColor[1]+","+ignoreColor[2]+","+ignoreColor[3]);
    
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
    //fill(255,0,0);
    stroke(255, 0, 0);
    //strokeWeight(3);
    rect(redSegment.x, redSegment.y, redSegment.blobWidth, redSegment.blobHeight);
    
    //Draw blue segment
    //fill(0,0,255);
    stroke(0, 0, 255);    
    //strokeWeight(3);
    rect(blueSegment.x, blueSegment.y, blueSegment.blobWidth, blueSegment.blobHeight);
    
    //Draw green segment
    //fill(0,255,0);
    stroke(0, 255, 0);
    //strokeWeight(3);
    rect(greenSegment.x, greenSegment.y, greenSegment.blobWidth, greenSegment.blobHeight);
    
    //Draw yellow segment
    //fill(255,255,0);
    stroke(255, 255, 0);
    //strokeWeight(3);
    rect(yellowSegment.x, yellowSegment.y, yellowSegment.blobWidth, yellowSegment.blobHeight);
    
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
}

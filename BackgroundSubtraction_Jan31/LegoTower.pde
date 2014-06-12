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
    int currBlock; 
    int currBlockRowCount, newBlockRowCount, newBlock;
    int newBlockPosition = 0;
    int temp;
    String rowColor = "";
    prevRowColor = -1;
    currRowColor = -1;
    rowMarker = -1;
    int[] ignoreColor = {0, 0, 0, 0};
    int[] colorCounts = {0, 0, 0, 0}; //RBGY
    
    int xLeft = int(inputTower.x*scaleFactor);
    int[] topLeftPix = {xLeft, xLeft, xLeft, xLeft};
    
    int[] pastSevenRows = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};
    int blockInitialized = 0;
    int setInitXFlag = 0;      
    int blockJustDrawn = -1; //updated when origin is set
    int tempNewBlock = -1;

      currBlockRowCount = 0;
      newBlockRowCount = 0;
    
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
      
      if (blockInitialized == 1) {
        setInitXFlag = 1;
        blockInitialized = 0;
      }
      
      //int xLeft = int(inputTower.x*scaleFactor);
      int xRight = int((inputTower.blobWidth+inputTower.x)*scaleFactor);
      //println("xLeft is "+xLeft);
      //println("xRight is "+xRight+" and blobWidth is "+inputTower.blobWidth*scaleFactor);
      int newxRight = xRight;
      int colorPixelFound;
      int newxLeft = xLeft;
      
      for (int pixelX = xLeft; pixelX < xRight; pixelX++)
      {
        color pixelColor = pixels[pixelY*width + pixelX];
        pixelValue = hue(pixelColor);
        colorPixelFound = 0;
        //Identify red hue
        if (pixelValue > 230 && pixelValue < 256)  
        {
          colorPixelFound = 1;
//          fill(255,0,0);
//          text("R", pixelX*2, pixelY*2);
//          noFill();
          if (ignoreColor[0] == 0)
             colorCounts[0]++;
          if (setInitXFlag == 1) {
            newxLeft = pixelX;
            topLeftPix[0] = pixelX;
            //println(newxLeft+" for red");
            setInitXFlag = 0;
          }        
        }       
        
        //Identify blue hue
        else if (pixelValue > 150 && pixelValue < 165)  
        {
          colorPixelFound = 1;
//          fill(255,255,255);
//          text("B", pixelX*2, pixelY*2);
//          noFill();
          if (ignoreColor[1] == 0)
             colorCounts[1]++;
          if (setInitXFlag == 1) {
            newxLeft = pixelX;
            topLeftPix[1] = pixelX;
            //println(newxLeft+" for blue");
            setInitXFlag = 0;
          }
        }
        
        //Identify green hue
        else if (pixelValue > 60 && pixelValue < 75)   
        {
          colorPixelFound = 1;
//          fill(0,255,0);
//          text("G", pixelX*2, pixelY*2);
//          noFill();
          if (ignoreColor[2] == 0)          
            colorCounts[2]++;
          if (setInitXFlag == 1) {
            newxLeft = pixelX;
            topLeftPix[2] = pixelX;
            //println(newxLeft+" for green");
            setInitXFlag = 0;
          }
        }
                
        //Identify yellow hue
        else if (pixelValue > 20 && pixelValue < 40)        
        { 
          colorPixelFound = 1;
//          fill(255,255,0);
//          text("Y", pixelX*2, pixelY*2);
//          noFill();
          if (ignoreColor[3] == 0)
            colorCounts[3]++;
          if (setInitXFlag == 1) {
            newxLeft = pixelX;
            topLeftPix[3] = pixelX;
            //println(newxLeft+" for yellow");
            setInitXFlag = 0;
          }
        }
        
        if (colorPixelFound == 1) {
          newxRight = pixelX;
        }
          
        //println("newLeft pre-exiting pixelX loop is "+newxLeft);  
      }
      
      //println("newLeft after pixelX loop is "+newxLeft);
      /*if (newxLeft != xLeft) {
      println("topLeftPix: 0: "+topLeftPix[0]);
      println("            1: "+topLeftPix[1]);
      println("            2: "+topLeftPix[2]);
      println("            3: "+topLeftPix[3]);
      println("back in upper loop");        
      println("currBlockRowCount: "+currBlockRowCount+" for block "+blockJustDrawn);
      println("newBlockRowCount: "+newBlockRowCount+" for block "+tempNewBlock);*/
      int oldNBRC = newBlockRowCount;
      //}
      
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
      
      currRowColor = rowMarker;
      if ((currRowColor!=-1) && (ignoreColor[currRowColor]==0)) {
        
        tempNewBlock = currRowColor;

        //Shift array up a row
        for (int j=0; j<12; j++) {
          temp = pastSevenRows[j+1];
          pastSevenRows[j] = temp;
        }
        pastSevenRows[12] = tempNewBlock;
        
      }
      
      currBlockRowCount = 0;
      newBlockRowCount = 0;
      
      /*
      if (rowColor != "") {
        println("rowColor "+rowColor);
        //println(pixelY);
      } */
      
      //println("newLeft midway is "+newxLeft);

      for (int k=0; k<13; k++) {
        if (pastSevenRows[k] == blockJustDrawn) {
          currBlockRowCount++;
        }
        else if (pastSevenRows[k] == tempNewBlock) {
          if (newBlockRowCount == 0)
            newBlockPosition = k;
          newBlockRowCount++;
        }
      }

      println("bloop");        
      println("currBlockRowCount: "+currBlockRowCount+" for block "+blockJustDrawn);
      println("newBlockRowCount: "+newBlockRowCount+" for block "+tempNewBlock);
      
      int newCBRC = currBlockRowCount;
      
      //println("xLeft is "+xLeft);
      //println("xRight is "+xRight);
      
      //First block of tower
      //if ((max(ignoreColor)==0) && (newBlockRowCount==7) && (blockJustDrawn==-1)) {
      if ((max(ignoreColor)==0) && (newBlockRowCount==9) && (blockJustDrawn==-1)) {
        newxLeft = topLeftPix[tempNewBlock];
        drawOrigin(tempNewBlock, newxLeft, yLower+int(offset*scaleFactor), scaleFactor);
        println("drawing first block");
        println("newxLeft is "+newxLeft+" for block "+tempNewBlock);
        blockInitialized = 1;
        blockJustDrawn = tempNewBlock;
      }
        
      //Other blocks
      //else if ((newCBRC-oldNBRC==1) && (blockJustDrawn!=-1) && (blockJustDrawn!=tempNewBlock)) {
      else if ((currBlockRowCount < newBlockRowCount) && (blockJustDrawn!=-1) && (blockJustDrawn!=tempNewBlock)) {
        
        println("currBlockRowCount: "+currBlockRowCount+" for block "+blockJustDrawn);
        println("newBlockRowCount: "+newBlockRowCount+" for block "+tempNewBlock);
        println("blockJustDrawn != -1 != tempNewBlock");
        
        newxLeft = topLeftPix[tempNewBlock];
        
        if (ignoreColor[tempNewBlock]==0) {
          //println("newBlockPosition "+newBlockPosition+" for block "+blockJustDrawn);
          drawFinal(blockJustDrawn, newxRight, pixelY/*-abs(7-newBlockPosition)*/-7, scaleFactor);
          ignoreColor[blockJustDrawn] = 1;
          
          drawOrigin(tempNewBlock, xLeft, pixelY/*-abs(6-newBlockPosition)*/-6, scaleFactor);
          println("drawing other blocks");
          println("newxLeft is "+newxLeft+" for block "+tempNewBlock);
          blockInitialized = 1;
          blockJustDrawn = tempNewBlock;
        }
        
        //Special case of drawFinal for bottom-most block of each tower
        int ignoreCt = 0;
        for (int m=0; m<4; m++) {
          if (ignoreColor[m]==0)
            ignoreCt++;
        }       
        if (ignoreCt==1)
          drawFinal(blockJustDrawn, newxRight, yUpper, scaleFactor);      
      }
      
      println("end legotower functions");
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
    
    println("end iteration");
    
  }

  public void drawTower()
  {
    int offset = beforeTower.height;//Offset for display in processing window

    noFill();
    
    //Draw red segment
    if (RedFinal.x > 0) {
    //fill(255,0,0);
    stroke(255, 0, 0);
    //strokeWeight(3);
    //rect(redSegment.x, redSegment.y, redSegment.blobWidth, redSegment.blobHeight);
    float Rx1 = RedOrigin.x;
    //println("Rx1 is "+RedOrigin.x);
    float Ry1 = RedOrigin.y;
    //println("Ry1 is "+RedOrigin.y);
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
    stroke(0, 0, 255);    
    //strokeWeight(3);
    //rect(blueSegment.x, blueSegment.y, blueSegment.blobWidth, blueSegment.blobHeight);
    float Bx1 = BlueOrigin.x;
    //println("Bx1 is "+BlueOrigin.x);
    float By1 = BlueOrigin.y;
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
    //strokeWeight(3);
    //rect(greenSegment.x, greenSegment.y, greenSegment.blobWidth, greenSegment.blobHeight);
    float Gx1 = GreenOrigin.x;
    //println("Gx1 is "+GreenOrigin.x);
    float Gy1 = GreenOrigin.y;
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
    //if (YellowFinal.x > 0) {
    //fill(255,255,0);
    stroke(255, 255, 0);
    //strokeWeight(3);
    //rect(yellowSegment.x, yellowSegment.y, yellowSegment.blobWidth, yellowSegment.blobHeight);
    float Yx1 = YellowOrigin.x;
    println("Yx1 is "+YellowOrigin.x);
    float Yy1 = YellowOrigin.y;
    println("Yy1 is "+Yy1);
    float Yx2 = YellowOrigin.x + yellowSegment.blobWidth;
    float Yx3 = YellowFinal.x - yellowSegment.blobWidth;
    float Yy2 = YellowFinal.y;
    float Yx4 = YellowFinal.x;
    line(Yx1, Yy1, Yx2, Yy1);
    line(Yx2, Yy1, Yx4, Yy2);
    line(Yx4, Yy2, Yx3, Yy2);
    line(Yx3, Yy2, Yx1, Yy1);
    //}
    
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

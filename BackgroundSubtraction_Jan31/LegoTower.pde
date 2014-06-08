/*This class decomposes input lego tower blobs into their constitutent color components
  It assumes that colors are in clusters and not mixed -- BE WARNED!!
*/
public class LegoTower
{
  public BlobRect redSegment;
  public BlobRect blueSegment;
  public BlobRect greenSegment;
  public BlobRect yellowSegment;

  private PVector RedOrigin, RedFinal;
  private PVector GreenOrigin, GreenFinal;
  private PVector YellowOrigin, YellowFinal;
  private PVector BlueOrigin, BlueFinal;

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
    int offset = beforeTower.height;    //Offset for display in processing window
    
    //Initialize variables
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
    
    //Iterate through pixels in input blob and classify them
    for (int pixelY=int(inputTower.y*scaleFactor); pixelY < (inputTower.blobHeight+offset+inputTower.y)*scaleFactor; pixelY++)
    {
      for (int pixelX = int(inputTower.x*scaleFactor); pixelX < (inputTower.blobWidth+inputTower.x)*scaleFactor; pixelX++)
      {
        color pixelColor = pixels[pixelY*width + pixelX];
        pixelValue = hue(pixelColor);

        if (pixelValue > 20 && pixelValue < 40)        //Identify yellow hue
        {
          if (YellowOrigin.x < 0)
            YellowOrigin.set(pixelX/scaleFactor, pixelY/scaleFactor);
          else 
            YellowFinal.set(pixelX/scaleFactor, pixelY/scaleFactor);
        }
        else if (pixelValue > 60 && pixelValue < 75)   //Identify green hue
        {
          if (GreenOrigin.x < 0)
            GreenOrigin.set(pixelX/scaleFactor, pixelY/scaleFactor);
          else 
            GreenFinal.set(pixelX/scaleFactor, pixelY/scaleFactor);
        }
        else if (pixelValue > 150 && pixelValue < 165)  //Identify blue hue
        {
          if (BlueOrigin.x < 0)
            BlueOrigin.set(pixelX/scaleFactor, pixelY/scaleFactor);
          else 
            BlueFinal.set(pixelX/scaleFactor, pixelY/scaleFactor);
        }
        else if (pixelValue > 210 && pixelValue < 256)  //Identify red hue
        {
          if (RedOrigin.x < 0)
            RedOrigin.set(pixelX/scaleFactor, pixelY/scaleFactor);
          else 
            RedFinal.set(pixelX/scaleFactor, pixelY/scaleFactor);
        }
      }
    }
    //Classify color segments
    redSegment = new BlobRect(RedOrigin.x, RedOrigin.y, abs(RedFinal.x - RedOrigin.x), abs(RedFinal.y - RedOrigin.y));
    blueSegment = new BlobRect(BlueOrigin.x, BlueOrigin.y, abs(BlueFinal.x - BlueOrigin.x), abs(BlueFinal.y - BlueOrigin.y));
    greenSegment = new BlobRect(GreenOrigin.x, GreenOrigin.y, abs(GreenFinal.x - GreenOrigin.x), abs(GreenFinal.y - GreenOrigin.y));
    yellowSegment = new BlobRect(YellowOrigin.x, YellowOrigin.y, abs(YellowFinal.x - YellowOrigin.x), abs(YellowFinal.y - YellowOrigin.y));
  }

  public void drawTower()
  {
    noFill();
    stroke(255, 0, 0);
    if (RedOrigin.x > 0)
      rect(redSegment.x, redSegment.y, redSegment.blobWidth, redSegment.blobHeight);
    stroke(0, 0, 255);    
    if (BlueOrigin.x > 0)
      rect(blueSegment.x, blueSegment.y, blueSegment.blobWidth, blueSegment.blobHeight);
    stroke(0, 255, 0);
    if (GreenOrigin.x > 0)
      rect(greenSegment.x, greenSegment.y, greenSegment.blobWidth, greenSegment.blobHeight);
    stroke(255, 255, 0);
    if (YellowOrigin.x > 0)
      rect(yellowSegment.x, yellowSegment.y, yellowSegment.blobWidth, yellowSegment.blobHeight);
  }
}
void cleanKinectInput()
{
  int[] inputDepthMap = context.depthMap();
  context.depthImage().loadPixels();

  //Remove erroneous pixels
  for (int i=0; i<context.depthMapSize();i++)
  {
    if (inputDepthMap[i] == 0) { //Error depth map value 
      context.depthImage().pixels[i] = color(0,0,0); 
      colorTower.pixels[i] = color(0,0,0);
    }

    if ((inputDepthMap[i]< 600) || (inputDepthMap[i] > 1000)) { //Irrelevant depths
      context.depthImage().pixels[i] = color(0,0,0);
      colorTower.pixels[i] = color(0,0,0);
    }

    else if ((inputDepthMap[i] > 400) && (inputDepthMap[i] < 1000))
      colorTower.pixels[i] = context.rgbImage().pixels[i];
  }
}

void imageComparison() 
{
  pushMatrix();
  image(colorTower, -780, 0);
//  scale(scaleFactorx);
//  image(colorTower, 0, 0);

  theBlobDetection = new BlobDetection(srcImage.width, srcImage.height);
  println("WxH "+srcImage.width+"x"+srcImage.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  srcImage = get(780,0,640,480);
  theBlobDetection.computeBlobs(srcImage.pixels);
  currentTowerColors = blobDebugMode(); 
  
  popMatrix();
}

void trackLegoTowers()
{
  Contour tempContour, originalContour;
  ArrayList<Contour> filteredContours;
  /*
  rect(354,372,190,113);
  rect(910,355,106,77); */

  legoTowers = extractLegoTowers();
  for (Contour contour: legoTowers)
  {
    originalBoundingBoxes.add(contour.getBoundingBox());
  }

  if (legoTowers.size() > 0)
  {
    filteredContours = extractLegoTowers();

    Boolean leftDown = false;
    Boolean rightDown = false;
    Boolean hasLeft = false;
    Boolean hasRight = false;
    Boolean leftStanding = false;
    Boolean rightStanding = false;

    for (int i=0; i<legoTowers.size(); i++) 
    {    

      ArrayList<Rectangle> currentBoundingBoxes = new ArrayList<Rectangle>();
      ArrayList<String> noteArray = new ArrayList<String>();
      
      for(int j=0; j<filteredContours.size(); j++)
      {
        tempContour = filteredContours.get(j);
        Rectangle tempBoundingBox = tempContour.getBoundingBox();
        currentBoundingBoxes.add(tempBoundingBox);
        
        int currentx = currentBoundingBoxes.get(j).x;
        int currenth = currentBoundingBoxes.get(j).height;
        
        if (currentx < 640/2) {
          hasLeft = true;
          if (currenth > 100)
            leftStanding = true;
        }
        if (currentx > 640/2) {
          hasRight = true;
          if (currenth > 100) {
            rightStanding = true;
          }
        }
        
        text("currTwrlen "+currentTowerColors.length+" filtctrs "+filteredContours.size(), 400, 35);
        if ((filteredContours.size() <= 2) && (currentTowerColors.length==filteredContours.size())) {
          
          noteArray.add(getBestTowerMatch(tempContour, currentTowerColors[j]));    
          //String note = getBestTowerMatch(tempContour, currentTowerColors[j]);
              
          text(noteArray.get(j), 400, 50+(50*j));
          text(currentBoundingBoxes.get(j).height, 400, 75+(50*j));
          
          //if (originalBoundingBoxes.get(j).height - currentBoundingBoxes.get(j).height > 40)
          if (currentBoundingBoxes.get(j).height < 100) 
          {
            if (filteredContours.size()==1) 
            {
              if (hasLeft==true)
                leftDown = true;
              else if (hasRight==true)
                rightDown = true;
            }
            else if ((j==0) && (noteArray.get(0)!="Unknown Tower") && (hasRight==true))
              rightDown = true;
            else if ((j==0) && (noteArray.get(0)=="Unknown Tower") && (hasLeft==true))
              leftDown = true;
            else if (j==1)
              rightDown = true;
          }
        }
      }
      
      if (leftDown==true)
        text("Fallen", 167, 320);
      if (rightDown==true)
        text("Fallen", 400, 320);
        
      if (leftStanding==true)
        text("LEFT STANDING", 167, 270);
      if (rightStanding==true)
        text("RIGHT STANDING", 400, 270);
        
      if (noteArray.size()==1) 
      {
        if ((leftDown==false) && (hasLeft==true)) 
        {
          text("Standing L", 167, 320);
          text(getBestTowerMatch(filteredContours.get(0), currentTowerColors[0]), 167, 290);
          text(currentTowerColors[0], 167, 305);
          //call getbesttowermatch
        }
        else if ((rightDown==false) && (hasRight==true))
        {
          text("Standing R", 400, 320);
          text(noteArray.get(0), 400, 290);
          text(currentTowerColors[0], 400, 305);
          //call besttowermatch
        } 
      }
      else if (noteArray.size()==2)
      {
        if (leftDown==false)
        {
          text("Standing", 167, 320);
          text(noteArray.get(0), 167, 290);
          text(currentTowerColors[0], 167, 305);
        }
        else
          text("Fallen", 167, 320);
        if (rightDown==false)
        {
          text("Standing", 400, 320);
          text(noteArray.get(1), 400, 290);
          text(currentTowerColors[1], 400, 305);
        }
      }
     text(noteArray.size(), 140, 320); 
    }
  }
}

ArrayList<Contour> extractLegoTowers()
{
  //Find all contours in input image
  ArrayList<Contour> towerContours = opencv.findContours();
  ArrayList<Contour> filteredContours = new ArrayList<Contour>();
  
  //Filter contours to only lego towers
  for (Contour contour: towerContours)
  {
    if(contour.area() > 1500)
    {
      filteredContours.add(contour);

      
      contour.draw();
      //fill(0,0,255);
      
      //Draw polygon approximation
//      if (playgame1==true)
//        stroke(255, 0, 0);
//      else if (playgame2==true)
        stroke(0, 255, 0);

     
        beginShape();
        for (PVector point : contour.getPolygonApproximation().getPoints())
        {
          vertex(point.x, point.y);
        }
        endShape();
    }
  }
  //fill(255, 255, 255);
  return filteredContours;
}

//String global1, global2, global3;

String getBestTowerMatch(Contour inputTower, String inputColor)
{
  double bestSimilarity=10;
  double currentSimilarity=1000;
  String towerType="Unknown Tower";
  towerColors = loadTowerColors();

  println(contourDBList.size());
  println(inputColor);
  
  for(int c=0; c < contourDBList.size(); c++)
  {
    Contour srcContour = contourDBList.get(c);

    //Use hu-moments for image which are invariant to translation, rotation, scale, and skew for comparison
    currentSimilarity = Imgproc.matchShapes(srcContour.pointMat, inputTower.pointMat, Imgproc.CV_CONTOURS_MATCH_I2, 0);
      
    if ((inputColor.equals(towerColors.get(c))==true))
    {
//      global1 = "tower "+inputTower+" "+currentSimilarity;
      
        println(" COLOR MATCHED tower "+pImgNames.get(c)+" "+currentSimilarity);
      
      
      
      if (currentSimilarity < bestSimilarity)
      {  
        //check if tower is one of the two gorilla towers
        //if (towerType == leftToMatch || towerType == rightToMatch)
        towerType = pImgNames.get(c); // if towerType = leftToMatch or rightToMatch
        
          bestSimilarity = currentSimilarity;
        
        println("****** high "+towerType+" "+bestSimilarity);
      }
    }
  }
  
  
  return towerType;
}



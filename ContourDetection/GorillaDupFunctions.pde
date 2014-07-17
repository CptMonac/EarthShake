String leftToMatch;
String rightToMatch;
Boolean scene2, scene3, scene4;
Boolean foundLeftMatch, foundRightMatch;

void gameSetup()
{
  leftToMatch = "F1";
  rightToMatch = "F2";
  foundLeftMatch = false;
  foundRightMatch = false;
  if (scene2==false)
    image(startScreen, 0, 0);
  if (scene2==true)
    image(screen1, 0, 0);
}

void gameplay()
{
  if (scene3!=true)
    instr_place_tower();
}

void mousePressed()
{
  if (scene3==true && scene4==false)
  {
    if (foundLeftMatch==true && foundRightMatch==true)
      scene4 = true;
  }
  if (scene2==true && scene3==false)
    scene3 = true;
  if (scene2==false)
    scene2 = true;
}

ArrayList<Contour> extractLegoTowers_g()
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

      //contour.draw();
      
      //Draw polygon approximation
//      stroke(255, 0, 0);
//      fill(0,0,255);
//
//        beginShape();
//        for (PVector point : contour.getPolygonApproximation().getPoints())
//        {
//          vertex(point.x, point.y);
//        }
//        endShape();
    }
  }
  //fill(255, 255, 255);
  return filteredContours;
}

void trackLegoTowers_g()
{ 
    
  Contour tempContour, originalContour;
  ArrayList<Contour> filteredContours;

  legoTowers = extractLegoTowers_g();
  for (Contour contour: legoTowers)
  {
    originalBoundingBoxes.add(contour.getBoundingBox());
  }
  
  if (legoTowers.size() > 0)
  {
    filteredContours = extractLegoTowers_g();

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
        
        if ((filteredContours.size() <= 2) && (currentTowerColors.length==filteredContours.size())) {
          
          noteArray.add(getBestTowerMatch(tempContour, currentTowerColors[j]));    
          
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
      
      if (leftDown==true) {}
        //text("Fallen", 167, 320);
      if (rightDown==true) {}
        //text("Fallen", 400, 320);
        
      if (leftStanding==true) {}
        //text("LEFT STANDING", 167, 270);
      if (rightStanding==true) {}
        //text("RIGHT STANDING", 400, 270);
        
      if (noteArray.size()==1) 
      {
        if ((leftDown==false) && (hasLeft==true)) 
        {
          if (noteArray.get(0)==leftToMatch)
          {
            if (scene3==true && scene4==false)
              match_left_image();
            foundLeftMatch = true;
          }
          else 
          {
            mismatch_left_image();
          }
        }
        else if ((rightDown==false) && (hasRight==true))
        {
          if (noteArray.get(0)==rightToMatch)
          {
            if (scene3==true && scene4==false)
              match_right_image();
            foundRightMatch = true;
          }
          else
          {
            mismatch_right_image();
          }
        } 
      }
      else if (noteArray.size()==2)
      {
        if (leftDown==false)
        {
          if (noteArray.get(0)==leftToMatch)
          {
            if (scene3==true && scene4==false)
              match_left_image();
            foundLeftMatch = true;
          }
          else 
          {
            mismatch_left_image();
          }
        }
        if (rightDown==false)
        {
          if (noteArray.get(1)==rightToMatch)
          {
            if (scene3==true && scene4==false)
              match_right_image();
            foundRightMatch = true;
          }
          else 
          {
            mismatch_right_image();
          }
        }
      } 
    }
  }
  if (scene3==true && scene4==false)
    checkTowerMatch();
}

void checkTowerMatch()
{
  if ((foundLeftMatch==false) && (foundRightMatch==false) && ((legoTowers.size()==0)||(legoTowers.size()==2)))
    neither_match_text();
  else if ((foundLeftMatch==false) && (foundRightMatch==true) && (legoTowers.size()==2))
    mismatch_left_text();
  else if ((foundLeftMatch==true) && (foundRightMatch==false) && (legoTowers.size()==2))
    mismatch_right_text();      
  else if ((foundLeftMatch==true) && (foundRightMatch==true))
    both_match_text();
  else if (foundLeftMatch==true)
    match_left_text();
  else if (foundRightMatch==true)
    match_right_text();
}

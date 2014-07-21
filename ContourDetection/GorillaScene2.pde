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
    }
  }
  return filteredContours;
}

void trackLegoTowers_g2()
{ 
    
  Contour tempContour, originalContour;
  ArrayList<Contour> filteredContours;

  legoTowers = extractLegoTowers_g();
  for (Contour contour: legoTowers)
  {
    originalBoundingBoxes.add(contour.getBoundingBox());
  }
  
  if (legoTowers.size() == 0) {
    instr_place_tower();
    if (scene3==false)
      instr_place_images();
  }
  
  if (legoTowers.size() > 0)
  {
    placingTowers = true;
    
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
            if (scene2==true && scene3==false)
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
            if (scene2==true && scene3==false)
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
            if (scene2==true && scene3==false)
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
            if (scene2==true && scene3==false)
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
    
    if (hasLeft==false)
      image(leftToMatchImg, 380, 160);
    if (hasRight==false)
      image(rightToMatchImg, 580, 160);
      
//    if (hasLeft==true && hasRight==true) {
//      if (scene3==true)
//        if (leftDown==true) {
//          image(wrongTower, 370, 160);
//          text("FALLEN!", 380, 330);
//        }
//        if (rightDown==true) {
//          image(wrongTower, 570, 160);
//          text("FALLEN!", 580, 330);
//        }
//    }    
  }
  if (scene2==true && scene3==false)
    checkTowerMatch();
}

void checkTowerMatch()
{
  if ((foundLeftMatch==false) && (foundRightMatch==false) && (legoTowers.size()==2))
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

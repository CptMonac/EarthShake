String leftToMatch;
String rightToMatch;

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
      //stroke(255, 0, 0);
      //fill(0,0,255);

        beginShape();
        for (PVector point : contour.getPolygonApproximation().getPoints())
        {
          vertex(point.x, point.y);
        }
        endShape();
    }
  }
  fill(255, 255, 255);
  return filteredContours;
}

void trackLegoTowers_g()
{
  leftToMatch = "F1";
  rightToMatch = "F2";
  text_welcome();
  
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
              
//          text(noteArray.get(j), 400, 50+(50*j));
//          text(currentBoundingBoxes.get(j).height, 400, 75+(50*j));
          
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
          //text("Standing L", 167, 320);
          //text(noteArray.get(0), 167, 290);
          //text(currentTowerColors[0], 167, 305);
          if (noteArray.get(0)==leftToMatch)
            match_left();
          else 
            mismatch_left();
        }
        else if ((rightDown==false) && (hasRight==true))
        {
          //text("Standing R", 400, 320);
          //text(noteArray.get(0), 400, 290);
          //text(currentTowerColors[0], 400, 305);
          if (noteArray.get(0)==rightToMatch)
            match_right();
          else
            mismatch_right();
        } 
      }
      else if (noteArray.size()==2)
      {
        if (leftDown==false)
        {
//          text("Standing", 167, 320);
//          text(noteArray.get(0), 167, 290);
//          text(currentTowerColors[0], 167, 305);
          if (noteArray.get(0)==leftToMatch)
            match_left();
          else
            mismatch_left();
        }
        if (rightDown==false)
        {
//          text("Standing", 400, 320);
//          text(noteArray.get(1), 400, 290);
//          text(currentTowerColors[1], 400, 305);
          if (noteArray.get(1)==rightToMatch)
            match_right();
          else 
            mismatch_right();
        }
      } 
    }
  }
}

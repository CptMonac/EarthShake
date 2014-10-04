
//**********************************************************************************
//************************************************************ SCENE 2 begin *******
//**********************************************************************************

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
  legoTowers = extractLegoTowers_g();
  
  if (legoTowers.size() == 0) {
    instr_place_tower();
    if (scene3==false) {
      instr_place_left_img();
      instr_place_right_img();
    }
  }
  
  if ((scene3==false) || (scene5==true))
    placementcircles();
  
  if (!skipThese())
  {
    Contour tempContour, originalContour;
    ArrayList<Contour> filteredContours;  
    
    initMatchVariables();
    
    for (Contour contour: legoTowers)
    {
      originalBoundingBoxes.add(contour.getBoundingBox());
    }
      
    if (legoTowers.size() > 0)
    {
      placingTowers = true;
      
      filteredContours = extractLegoTowers_g();
    
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
          
        if (noteArray.size()==1) 
        {
          if ((leftDown==false) && (hasLeft==true)) 
          {
            if (noteArray.get(0)==leftToMatch)
            {
              foundLeftMatch = true;
            }
          }
          else if ((rightDown==false) && (hasRight==true))
          {
            if (noteArray.get(0)==rightToMatch)
            {
              foundRightMatch = true;
            }
          } 
        }
        else if (noteArray.size()==2)
        {
          if (leftDown==false)
          {
            if (noteArray.get(0)==leftToMatch)
            {
              foundLeftMatch = true;
            }
          }
          if (rightDown==false)
          {
            if (noteArray.get(1)==rightToMatch)
            {
              foundRightMatch = true;
            }
          }
        } 
      } 
    }    
  }
    
  if (scene2==true && scene3==false)
  {
    checkTowerImage();
    if (legoTowers.size() > 0)
    {
      //FANCY IGGY
      checkTowerMatch();
    }
  }
    
  if (scene4==true)
  {
    if ((rightStanding==true) && (leftStanding==false))
      fallen = 1;
    else if ((rightStanding==false) && (leftStanding==true)) 
      fallen = 2;
    if ((towerPredictionNumber==1) && (fallen==1))
    {
      correctGuess = true;
    }  
    if ((towerPredictionNumber==2) && (fallen==2))
    {
      correctGuess = true;
    }
  }
   
}

void initMatchVariables()
{
  leftDown = false;
  rightDown = false;
  hasLeft = false;
  hasRight = false;
  leftStanding = false;
  rightStanding = false;  
  
  foundLeftMatch = false;
  foundRightMatch = false;  
}

Boolean skipThese()
{  
  if (legoTowers.size() >= 3)
    return true;
    
  ArrayList<Contour> filteredContours = extractLegoTowers_g();  
  for (int i=0; i<legoTowers.size(); i++) 
  {    
    ArrayList<Rectangle> currentBoundingBoxes = new ArrayList<Rectangle>();
    
    for(int j=0; j<filteredContours.size(); j++)
    {
      Contour tempContour = filteredContours.get(j);
      Rectangle tempBoundingBox = tempContour.getBoundingBox();  
      println("YYYYYYYYYYYYYYYYY " + tempBoundingBox.y);
      if ((tempBoundingBox.y <= 280) || (tempBoundingBox.height >= 200))
        return true;
    }
  }
  return false;     
}

void checkTowerImage()
{
  if (explain==false)
  {
    if (hasLeft==false)
      instr_place_left_img();
    if (hasRight==false)
      instr_place_right_img();
    if ((hasLeft==true) && (foundLeftMatch==false))
      mismatch_left_image();
    if ((hasLeft==true) && (foundLeftMatch==true))
      match_left_image();
    if ((hasRight==true) && (foundRightMatch==false))
      mismatch_right_image();
    if ((hasRight==true) && (foundRightMatch==true))
      match_right_image();
  }
}

void checkTowerMatch()
{
  //if toweriteration==0 and no towers
  
  if ((hasLeft==true) && (hasRight==true))
  {
    //x x
    if ((foundLeftMatch==false) && (foundRightMatch==false))
      neither_match_text();
      
    //x v 
    else if ((foundLeftMatch==false) && (foundRightMatch==true))
      mismatch_left_text();
    
    //v x
    else if ((foundLeftMatch==true) && (foundRightMatch==false))
      mismatch_right_text();  

    //v v  
    else if ((foundLeftMatch==true) && (foundRightMatch==true))
      both_match_text();
  }
  
  else if ((hasLeft==true) && (hasRight==false))
  {
    //x o  
    if ((foundLeftMatch==false))
      display_place_wrong_left_only();
        
    //v o  
    else //if ((foundLeftMatch==true))
      match_left_text();     
  } 
    
  else if ((hasLeft==false) && (hasRight==true))
  {  
    //o x  
    if ((foundRightMatch==false))
      display_place_wrong_right_only();
      
    //o v  
    else //if ((foundRightMatch==true))
      match_right_text();
  }
}

//**********************************************************************************
//************************************************************ SCENE 3 begin *******
//**********************************************************************************

void drawLegoContours_g()
{
  //Find all contours in input image
  ArrayList<Contour> towerContours = opencv.findContours();
  
  int adjustx = 0; 
  int adjusty = 1*gorHeight/16+50; 
    
  //Filter contours to only lego towers
  for (Contour contour: towerContours)
  {
    if(contour.area() > 1500)
    {
      //Draw outline approximation
      int side = 0;
      
      if ((contour.getPolygonApproximation().getPoints().get(0).x) < 640/2) {
        side = 1; //left
        adjustx = 10*gorWidth/32;
        if (contour.getBoundingBox().height < 100)
        {
          fill(255, 140, 140);
          stroke(255, 0, 0);
        }
        else
        {
          fill(140, 255, 140);
          stroke(0, 255, 0);
        }
      }
      else {
        side = 2; //right
        adjustx = 7*gorWidth/32;
        if (contour.getBoundingBox().height < 100)  
        {
          fill(255, 140, 140);
          stroke(255, 0, 0);
        }
        else
        {
          fill(140, 255, 140);   
          stroke(0, 255, 0);
        }
      }
      translate(adjustx,-adjusty);
      contour.draw();
      translate(-adjustx,adjusty);
      noFill();
    }
  }
}

void drawLegoContours_static()
{
  //Find all contours in input image
  ArrayList<Contour> towerContours = opencv.findContours();
    
  int side = 0;
  
  if ((leftStanding==false) || (rightStanding==false))
  {
    if (scenarioNumber==1)
    {
      image(LTMfallen, 7*gorWidth/16, 9*gorHeight/16);
      image(RTMstanding, 23*gorWidth/32, 5*gorHeight/16);
    }
    
    else if (scenarioNumber==2)
    {
      image(LTMstanding, 1*gorWidth/2, 5*gorHeight/16);
      image(RTMfallen, 23*gorWidth/32, 9*gorHeight/16);
    }
    
    else if (scenarioNumber==3)
    {
      image(LTMfallen, 7*gorWidth/16, 9*gorHeight/16);
      image(RTMstanding, 23*gorWidth/32, 5*gorHeight/16);
    }
    
    else if (scenarioNumber==4)
    {
      image(LTMfallen, 7*gorWidth/16, 9*gorHeight/16);
      image(RTMstanding, 23*gorWidth/32, 5*gorHeight/16);
    }
    
    else if (scenarioNumber==5)
    {
      image(LTMfallen, 7*gorWidth/16, 9*gorHeight/16);
      image(RTMstanding, 23*gorWidth/32, 5*gorHeight/16);
    }
  }
  
  else
  {
    image(LTMstanding, 1*gorWidth/2, 5*gorHeight/16);    
    image(RTMstanding, 23*gorWidth/32, 5*gorHeight/16);
  }
}

void newRoundOfTowers()
{
  if (extractLegoTowers_g().size() == 0)
  {
    resetVariables();
    scene2 = true;
  }
  else
  {
    scene2 = false;
    scene3 = false;
    displayText(t_clear_table);
    
    
  }
}


String leftToMatch, rightToMatch;
Boolean scene2, scene3, scene3a, scene3b, scene4;
Boolean foundLeftMatch, foundRightMatch;
Boolean placingTowers;
String towerPredictionString;
int towerPredictionNumber;
Boolean correctGuess;
int fallen;

Boolean leftDown = false;
Boolean rightDown = false;
Boolean hasLeft = false;
Boolean hasRight = false;
Boolean leftStanding = false;
Boolean rightStanding = false;

PImage startScreen, pretzel;
PImage F1_tower, F1_wrong, F1_correct;
PImage F2_tower, F2_wrong, F2_correct;

void gameSetup()
{
  leftToMatch = "F1";
  rightToMatch = "F2";
  
  leftToMatchImg = F1_tower;
  LTMwrong = F1_wrong;
  LTMcorrect = F1_correct;
  rightToMatchImg = F2_tower;
  RTMwrong = F2_wrong;
  RTMcorrect = F2_correct;
  
  if (scene2==false) {
    image(startScreen, 0, 0);
    continue_button();
  }
  if (scene2==true) {
    image(screen1, 0, 0);
  }
}

void gameplay()
{
}

void mousePressed()
{ 
  if (scene3b==true && scene4==false)
  {
    if (continue_pressed()==true) {
      scene3b = false;
      scene4 = true;
    }
  }
  
  if (scene3==true && scene3a==true && scene3b==false)
  {
    if ((tower1_selected()==true)||(same_selected()==true)||(tower2_selected()==true)) {
      scene3a = false;
      scene3b = true;      
    }
  }
  
  if (scene2==true && scene3==false)
  {
    if (continue_pressed()==true) {
      scene3 = true;
      scene3a = true;
    }
  }
    
  if (scene2==false)
  {
    if (continue_pressed()==true)
      scene2 = true;
  }
}


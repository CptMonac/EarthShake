String leftToMatch, rightToMatch;
Boolean scene2, scene3, scene3a, scene3b, scene4, scene5;
Boolean foundLeftMatch, foundRightMatch;
Boolean leftDown, rightDown, hasLeft, hasRight;
Boolean leftStanding, rightStanding;
Boolean placingTowers;
String towerPredictionString;
int towerPredictionNumber;
Boolean correctGuess;
int fallen;

/* buttons etc */
PImage startScreen, pretzel;
PImage continueButton, tower1, tower2, same, shake;
PImage pred_thinner, pred_symm, pred_weight, pred_taller;

/* color tower images */
PImage A1_tower, A1_wrong, A1_correct;
PImage A2_tower, A2_wrong, A2_correct;
PImage B1_tower, B1_wrong, B1_correct;
PImage B2_tower, B2_wrong, B2_correct;
PImage C1_tower, C1_wrong, C1_correct;
PImage C2_tower, C2_wrong, C2_correct;
PImage D1_tower, D1_wrong, D1_correct;
PImage D2_tower, D2_wrong, D2_correct;
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
  if (scene4==true && scene5==false) 
  {
    if (explanation() != 0) {
      scene2 = false;
      scene3 = false;
      scene4 = false;
      scene5 = true;
    }
  }
  
  if (scene3b==true && scene4==false)
  {
    if (shake_pressed()==true) {
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
    if ((continue_pressed()==true) && (foundLeftMatch==true) && (foundRightMatch==true)) {
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

void loadColorTowers()
{
//  A1_tower = loadImage("color/A1_tower.png");
  A1_tower = loadImage("color/A1_arrow.png");
  A1_wrong = loadImage("color/A1_wrong.png");
  A1_correct = loadImage("color/A1_correct.png");
//  A2_tower = loadImage("color/A2_tower.png");
  A2_tower = loadImage("color/A2_arrow.png");
  A2_wrong = loadImage("color/A2_wrong.png");
  A2_correct = loadImage("color/A2_correct.png");
//  B1_tower = loadImage("color/B1_tower.png");
  B1_tower = loadImage("color/B1_arrow.png");
  B1_wrong = loadImage("color/B1_wrong.png");
  B1_correct = loadImage("color/B1_correct.png");
//  B2_tower = loadImage("color/B2_tower.png");
  B2_tower = loadImage("color/B2_arrow.png");
  B2_wrong = loadImage("color/B2_wrong.png");
  B2_correct = loadImage("color/B2_correct.png");
//  C1_tower = loadImage("color/C1_tower.png");
  C1_tower = loadImage("color/C1_arrow.png");
  C1_wrong = loadImage("color/C1_wrong.png");
  C1_correct = loadImage("color/C1_correct.png");
//  C2_tower = loadImage("color/C2_tower.png");
  C2_tower = loadImage("color/C2_arrow.png");
  C2_wrong = loadImage("color/C2_wrong.png");
  C2_correct = loadImage("color/C2_correct.png");
//  D1_tower = loadImage("color/D1_tower.png");
  D1_tower = loadImage("color/D1_arrow.png");
  D1_wrong = loadImage("color/D1_wrong.png");
  D1_correct = loadImage("color/D1_correct.png");
//  D2_tower = loadImage("color/D2_tower.png");
  D2_tower = loadImage("color/D2_arrow.png");
  D2_wrong = loadImage("color/D2_wrong.png");
  D2_correct = loadImage("color/D2_correct.png");
//  F1_tower = loadImage("color/F1_tower.png");
  F1_tower = loadImage("color/F1_arrow.png");
  F1_wrong = loadImage("color/F1_wrong.png");
  F1_correct = loadImage("color/F1_correct.png");
//  F2_tower = loadImage("color/F2_tower.png");
  F2_tower = loadImage("color/F2_arrow.png");
  F2_wrong = loadImage("color/F2_wrong.png");
  F2_correct = loadImage("color/F2_correct.png");   
}

void loadButtons()
{
  continueButton = loadImage("buttons/continue.png");
  same = loadImage("buttons/same.png");
  tower1 = loadImage("buttons/first.png");
  tower2 = loadImage("buttons/second.png");  
  shake = loadImage("buttons/shake.png");
  pred_symm = loadImage("buttons/pred_symm.png");
  pred_taller = loadImage("buttons/pred_taller.png");
  pred_thinner = loadImage("buttons/pred_thinner.png");
  pred_weight = loadImage("buttons/pred_weight.png");
}


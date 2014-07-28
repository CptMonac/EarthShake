String leftToMatch, rightToMatch;
Boolean scene2, scene3, scene3a, scene3b, scene4, scene5;
Boolean foundLeftMatch, foundRightMatch;
Boolean leftDown, rightDown, hasLeft, hasRight;
Boolean leftStanding, rightStanding;
Boolean placingTowers;
String towerPredictionString;
int towerPredictionNumber;
Boolean correctGuess;
int fallen, fallen_reason;

/* buttons etc */
PImage startScreen, pretzel;
PImage continueButton, tower1, tower2, same, shake;
PImage pred_thinner, pred_symm, pred_weight, pred_taller;

/* text bubbles */
PImage t_expl_correct_symm, t_expl_correct_taller, t_expl_correct_thinner, t_expl_correct_weight;
PImage t_expl_wrong_symm, t_expl_wrong_taller, t_expl_wrong_thinner, t_expl_wrong_weight;
PImage t_hyp_correct_left, t_hyp_correct_right, t_hyp_wrong_left, t_hyp_wrong_right;
PImage t_place_both, t_place_continue, t_place_left, t_place_right;
PImage t_place_wrong_both, t_place_wrong_left, t_place_wrong_right;
PImage t_pred_intro, t_pred_left, t_pred_right, t_pred_same;

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
  int scenarioNumber = int(random(1,6));
  loadScenario(scenarioNumber);
  
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

void loadScenario(int scenarioNumber)
{
  if (scenarioNumber==1)
  {
    leftToMatch = "A1";
    rightToMatch = "A2";
    
    leftToMatchImg = A1_tower;
    LTMwrong = A1_wrong;
    LTMcorrect = A1_correct;
    rightToMatchImg = A2_tower;
    RTMwrong = A2_wrong;
    RTMcorrect = A2_correct;
    
    fallen_reason = 4; //symm
  }
  
  else if (scenarioNumber==2)
  {
    leftToMatch = "B1";
    rightToMatch = "B2";
    
    leftToMatchImg = B1_tower;
    LTMwrong = B1_wrong;
    LTMcorrect = B1_correct;
    rightToMatchImg = B2_tower;
    RTMwrong = B2_wrong;
    RTMcorrect = B2_correct;
    
    fallen_reason = 3; //weight
  }  
  
  else if (scenarioNumber==3)
  {
    leftToMatch = "C1";
    rightToMatch = "C2";
    
    leftToMatchImg = C1_tower;
    LTMwrong = C1_wrong;
    LTMcorrect = C1_correct;
    rightToMatchImg = C2_tower;
    RTMwrong = C2_wrong;
    RTMcorrect = C2_correct;
    
    fallen_reason = 4; //symm
  }    

  else if (scenarioNumber==4)
  {
    leftToMatch = "D1";
    rightToMatch = "D2";
    
    leftToMatchImg = D1_tower;
    LTMwrong = D1_wrong;
    LTMcorrect = D1_correct;
    rightToMatchImg = D2_tower;
    RTMwrong = D2_wrong;
    RTMcorrect = D2_correct;
    
    fallen_reason = 2; //thinner
  }  

  else if (scenarioNumber==5)
  {
    leftToMatch = "F1";
    rightToMatch = "F2";
    
    leftToMatchImg = F1_tower;
    LTMwrong = F1_wrong;
    LTMcorrect = F1_correct;
    rightToMatchImg = F2_tower;
    RTMwrong = F2_wrong;
    RTMcorrect = F2_correct;
    
    fallen_reason = 4; //symm
  }   
    
  else
  {
    leftToMatch = "";
    rightToMatch = "";
    
    leftToMatchImg = pretzel;
    LTMwrong = pretzel;
    LTMcorrect = pretzel;
    rightToMatchImg = pretzel;
    RTMwrong = pretzel;
    RTMcorrect = pretzel;
    
    fallen_reason = 0;
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

ArrayList<PImage> createColorImageArray()
{
  ArrayList<PImage> colorImages = new ArrayList<PImage>();
  loadColorTowers();
  
  colorImages.add(A1_tower);
  colorImages.add(A2_tower);
  colorImages.add(B1_tower);
  colorImages.add(B2_tower);
  colorImages.add(C1_tower);
  colorImages.add(C2_tower);
  colorImages.add(D1_tower);
  colorImages.add(D2_tower);
  colorImages.add(F1_tower);
  colorImages.add(F2_tower);
  
  colorImages.add(A1_correct);
  colorImages.add(A2_correct);
  colorImages.add(B1_correct);
  colorImages.add(B2_correct);
  colorImages.add(C1_correct);
  colorImages.add(C2_correct);
  colorImages.add(D1_correct);
  colorImages.add(D2_correct);
  colorImages.add(F1_correct);
  colorImages.add(F2_correct);
  
  colorImages.add(A1_wrong);
  colorImages.add(A2_wrong);
  colorImages.add(B1_wrong);
  colorImages.add(B2_wrong);
  colorImages.add(C1_wrong);
  colorImages.add(C2_wrong);
  colorImages.add(D1_wrong);
  colorImages.add(D2_wrong);
  colorImages.add(F1_wrong);
  colorImages.add(F2_wrong);
  
  return colorImages;
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

void loadText()
{
  t_expl_correct_symm = loadImage("text/expl_correct_symm.png");
  t_expl_correct_taller = loadImage("text/expl_correct_taller.png");
  t_expl_correct_thinner = loadImage("text/expl_correct_thinner.png");
  t_expl_correct_weight = loadImage("text/expl_correct_weight.png");
  t_expl_wrong_symm = loadImage("text/expl_wrong_symm.png");
  t_expl_wrong_taller = loadImage("text/expl_wrong_taller.png");
  t_expl_wrong_thinner = loadImage("text/expl_wrong_thinner.png");
  t_expl_wrong_weight = loadImage("text/expl_wrong_weight.png");
  t_hyp_correct_left = loadImage("text/hypothesis_correct_left.png");
  t_hyp_correct_right = loadImage("text/hypothesis_correct_right.png");
  t_hyp_wrong_left = loadImage("text/hypothesis_wrong_left.png");
  t_hyp_wrong_right = loadImage("text/hypothesis_wrong_right.png");
  t_place_both = loadImage("text/place_both.png");
  t_place_continue = loadImage("text/place_continue.png");
  t_place_left = loadImage("text/place_left.png");
  t_place_right = loadImage("text/place_right.png");
  t_place_wrong_both = loadImage("text/place_wrong_both.png");
  t_place_wrong_left = loadImage("text/place_wrong_left.png");
  t_place_wrong_right = loadImage("text/place_wrong_right.png");
  t_pred_intro = loadImage("text/prediction_intro.png");
  t_pred_left = loadImage("text/prediction_left_first.png");
  t_pred_right = loadImage("text/prediction_right_first.png");
  t_pred_same = loadImage("text/prediction_same_first.png");
}


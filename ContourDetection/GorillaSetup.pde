String leftToMatch, rightToMatch;
Boolean scene1, scene2, scene3, scene3a, scene3b, scene4, scene5, scene6;
Boolean foundLeftMatch, foundRightMatch;
Boolean leftDown, rightDown, hasLeft, hasRight;
Boolean leftStanding, rightStanding;
Boolean placingTowers;
String towerPredictionString;
int towerPredictionNumber;
Boolean correctGuess; 
Boolean explain = false;
int fallen, fallen_reason;
int scenarioNumber;
int expl_guess = 0;
int towerIteration, currentPair;
IntList towerPairs;
Boolean playgame1, playgame2;

/* buttons etc */
PImage pretzel;
PImage game1, game2;
PImage continueButton, tower1, tower2, same, shake;
PImage continueButton_hover, tower1_hover, tower2_hover, same_hover, shake_hover;
PImage pred_thinner, pred_symm, pred_weight, pred_taller;
PImage pred_thinner_hover, pred_symm_hover, pred_weight_hover, pred_taller_hover;

/* text bubbles */
PImage t_expl_correct_symm, t_expl_correct_taller, t_expl_correct_thinner, t_expl_correct_weight;
PImage t_expl_wrong_symm, t_expl_wrong_taller, t_expl_wrong_thinner, t_expl_wrong_weight;
PImage t_hyp_correct_left, t_hyp_correct_right, t_hyp_wrong_left, t_hyp_wrong_right;
PImage t_place_both, t_place_continue, t_place_left, t_place_right;
PImage t_place_wrong_both, t_place_wrong_left, t_place_wrong_right;
PImage t_place_wrong_left_only, t_place_wrong_right_only;
PImage t_pred_intro, t_pred_left, t_pred_right, t_pred_same;
PImage t_clear_table;

/* color tower images */
PImage A1_guide, A1_wrong, A1_correct;
PImage A1_tower, A1_fallen, A1_expl;
PImage A2_guide, A2_wrong, A2_correct;
PImage A2_tower, A2_fallen, A2_expl;
PImage B1_guide, B1_wrong, B1_correct;
PImage B1_tower, B1_fallen, B1_expl;
PImage B2_guide, B2_wrong, B2_correct;
PImage B2_tower, B2_fallen, B2_expl;
PImage C1_guide, C1_wrong, C1_correct;
PImage C1_tower, C1_fallen, C1_expl;
PImage C2_guide, C2_wrong, C2_correct;
PImage C2_tower, C2_fallen, C2_expl;
PImage D1_guide, D1_wrong, D1_correct;
PImage D1_tower, D1_fallen, D1_expl;
PImage D2_guide, D2_wrong, D2_correct;
PImage D2_tower, D2_fallen, D2_expl;
PImage F1_guide, F1_wrong, F1_correct;
PImage F1_tower, F1_fallen, F1_expl;
PImage F2_guide, F2_wrong, F2_correct;
PImage F2_tower, F2_fallen, F2_expl;

void resetScenes()
{
  //scene1 = true;
  //scene2 = false;
  scene3 = false;
  scene3a = false;
  scene3b = false;
  scene4 = false;
  scene5 = false;
  scene6 = false;
}

void resetTowerVars()
{
  towerPredictionNumber = 0;
  towerPredictionString = "";
  correctGuess = false;
  explain = false;
  fallen = 0;  
}

void mousePressed()
{ 
  if (exit_pressed()==true)
  {
    scene1 = true;
    playgame1 = false;
    playgame2 = false;
    resetScenes();
    resetTowerVars();
  }
  
  if (scene6==true)
  {
//    if (continue_pressed()==true)
//    {
//      resetVariables();
//      scene2 = true;
//    }
  }
  
  if (scene5==true && scene6==false)
  {
    if (continue_pressed()==true)
    {
      generateNewSet();
      //scene2 = false;
      scene5 = false;
      scene6 = true;
    }
  }
  
  if (scene4==true && scene5==false) 
  {
    if (explanation() != 0) {
      scene4 = false;
      scene5 = true;
    }
  }
  
  if (scene3b==true && scene4==false)
  {
    if (shake_pressed()==true) {
      scene3b = false;
      //scene2 = false;
      //scene3 = false;
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
    
//  if (scene1==true && scene2==false)
//  {
//    
//    if (playgame1==true)
//    {
//      scene1 = false;
//      scene2 = true;
//    }
//  }
  
  if (playgame1==false && playgame2==false)
    gameSelection();
}

void generateNewSet()
{
  if (towerIteration >= 4)
  {
    scene1 = true;
    //scene2 = false;
    resetScenes();
    
    //instead of pretzel go to ayo's game
    playgame 2 =true;
  }
  else
  {
    int newPair = generateTowerPairOrder();
    loadScenario(newPair);
    scenarioNumber = newPair;
  }
}

void initTowerPairOrder()
{
  towerPairs = new IntList();
  towerPairs.append(1); //A
  towerPairs.append(2); //B
  //towerPairs.append(3); //C
  towerPairs.append(4); //D
  towerPairs.append(5); //F
  towerPairs.shuffle();
  towerIteration = 0;
}

int generateTowerPairOrder()
{
  currentPair = towerPairs.get(towerIteration);
  towerIteration++;
  return currentPair;
}

void loadScenario(int scenarioNumber)
{
  if (scenarioNumber==1)
  {
    leftToMatch = "A1";
    rightToMatch = "A2";
    
    leftToMatchImg = A1_guide;
    LTMwrong = A1_wrong;
    LTMcorrect = A1_correct;
    LTMstanding = A1_tower;
    LTMfallen = A1_fallen;
    LTMfinal = A1_expl;
    
    rightToMatchImg = A2_guide;
    RTMwrong = A2_wrong;
    RTMcorrect = A2_correct;
    RTMstanding = A2_tower;
    RTMfallen = A2_fallen;
    RTMfinal = A2_expl;
    
    fallen_reason = 4; //symm
  }
  
  else if (scenarioNumber==2)
  {
    leftToMatch = "B2";
    rightToMatch = "B1";
    
    leftToMatchImg = B2_guide;
    LTMwrong = B2_wrong;
    LTMcorrect = B2_correct;
    LTMstanding = B2_tower;
    LTMfallen = B2_fallen;
    LTMfinal = B2_expl;

    rightToMatchImg = B1_guide;
    RTMwrong = B1_wrong;
    RTMcorrect = B1_correct;
    RTMstanding = B1_tower;
    RTMfallen = B1_fallen;
    RTMfinal = B1_expl;
    
    fallen_reason = 3; //weight
  }  
  
  else if (scenarioNumber==3)
  {
    leftToMatch = "C1";
    rightToMatch = "C2";
    
    leftToMatchImg = C1_guide;
    LTMwrong = C1_wrong;
    LTMcorrect = C1_correct;
    LTMstanding = C1_tower;
    LTMfallen = C1_fallen;
    LTMfinal = C1_expl;
    
    rightToMatchImg = C2_guide;
    RTMwrong = C2_wrong;
    RTMcorrect = C2_correct;
    RTMstanding = C2_tower;
    RTMfallen = C2_fallen;
    RTMfinal = C2_expl;
    
    fallen_reason = 4; //symm
  }    

  else if (scenarioNumber==4)
  {
    leftToMatch = "D1";
    rightToMatch = "D2";
    
    leftToMatchImg = D1_guide;
    LTMwrong = D1_wrong;
    LTMcorrect = D1_correct;
    LTMstanding = D1_tower;
    LTMfallen = D1_fallen;
    LTMfinal = D1_expl;
    
    rightToMatchImg = D2_guide;
    RTMwrong = D2_wrong;
    RTMcorrect = D2_correct;
    RTMstanding = D2_tower;
    RTMfallen = D2_fallen;
    RTMfinal = D2_expl;
    
    fallen_reason = 2; //thinner
  }  

  else if (scenarioNumber==5)
  {
    leftToMatch = "F1";
    rightToMatch = "F2";
    
    leftToMatchImg = F1_guide;
    LTMwrong = F1_wrong;
    LTMcorrect = F1_correct;
    LTMstanding = F1_tower;
    LTMfallen = F1_fallen;
    LTMfinal = F1_expl;
    
    rightToMatchImg = F2_guide;
    RTMwrong = F2_wrong;
    RTMcorrect = F2_correct;
    RTMstanding = F2_tower;
    RTMfallen = F2_fallen;
    RTMfinal = F2_expl;
    
    fallen_reason = 4; //symm
  }   
    
  else
  {
    leftToMatch = "";
    rightToMatch = "";
    
    leftToMatchImg = pretzel;
    LTMwrong = pretzel;
    LTMcorrect = pretzel;
    LTMstanding = pretzel;
    LTMfallen = pretzel;
    LTMfinal = pretzel;
    
    rightToMatchImg = pretzel;
    RTMwrong = pretzel;
    RTMcorrect = pretzel;
    RTMstanding = pretzel;
    RTMfallen = pretzel;
    RTMfinal = pretzel;
    
    fallen_reason = 0;
  }  
    
}

void loadColorTowers()
{
  A1_tower = loadImage("color/A1_tower.png");
  A1_guide = loadImage("color/A1_arrow.png");
  A1_wrong = loadImage("color/A1_wrong.png");
  A1_correct = loadImage("color/A1_correct.png");
  A1_fallen = loadImage("color/A1_fallen.png");
  A1_expl = loadImage("color/A1_expl.png");

  A2_tower = loadImage("color/A2_tower.png");
  A2_guide = loadImage("color/A2_arrow.png");
  A2_wrong = loadImage("color/A2_wrong.png");
  A2_correct = loadImage("color/A2_correct.png");
  A2_fallen = loadImage("color/A2_fallen.png");
  A2_expl = loadImage("color/A2_expl.png");

  B1_tower = loadImage("color/B1_tower.png");
  B1_guide = loadImage("color/B1_arrow.png");
  B1_wrong = loadImage("color/B1_wrong.png");
  B1_correct = loadImage("color/B1_correct.png");
  B1_fallen = loadImage("color/B1_fallen.png");
  B1_expl = loadImage("color/B1_expl.png");

  B2_tower = loadImage("color/B2_tower.png");
  B2_guide = loadImage("color/B2_arrow.png");
  B2_wrong = loadImage("color/B2_wrong.png");
  B2_correct = loadImage("color/B2_correct.png");
  B2_fallen = loadImage("color/B2_fallen.png");
  B2_expl = loadImage("color/B2_expl.png");

  C1_tower = loadImage("color/C1_tower.png");
  C1_guide = loadImage("color/C1_arrow.png");
  C1_wrong = loadImage("color/C1_wrong.png");
  C1_correct = loadImage("color/C1_correct.png");
  C1_fallen = loadImage("color/C1_fallen.png");
  C1_expl = loadImage("color/C1_expl.png");

  C2_tower = loadImage("color/C2_tower.png");
  C2_guide = loadImage("color/C2_arrow.png");
  C2_wrong = loadImage("color/C2_wrong.png");
  C2_correct = loadImage("color/C2_correct.png");
  C2_fallen = loadImage("color/C2_fallen.png");
  C2_expl = loadImage("color/C2_expl.png");

  D1_tower = loadImage("color/D1_tower.png");
  D1_guide = loadImage("color/D1_arrow.png");
  D1_wrong = loadImage("color/D1_wrong.png");
  D1_correct = loadImage("color/D1_correct.png");
  D1_fallen = loadImage("color/D1_fallen.png");
  D1_expl = loadImage("color/D1_expl.png");

  D2_tower = loadImage("color/D2_tower.png");
  D2_guide = loadImage("color/D2_arrow.png");
  D2_wrong = loadImage("color/D2_wrong.png");
  D2_correct = loadImage("color/D2_correct.png");
  D2_fallen = loadImage("color/D2_fallen.png");
  D2_expl = loadImage("color/D2_expl.png");

  F1_tower = loadImage("color/F1_tower.png");
  F1_guide = loadImage("color/F1_arrow.png");
  F1_wrong = loadImage("color/F1_wrong.png");
  F1_correct = loadImage("color/F1_correct.png");
  F1_fallen = loadImage("color/F1_fallen.png");
  F1_expl = loadImage("color/F1_expl.png");

  F2_tower = loadImage("color/F2_tower.png");
  F2_guide = loadImage("color/F2_arrow.png");
  F2_wrong = loadImage("color/F2_wrong.png");
  F2_correct = loadImage("color/F2_correct.png");   
  F2_fallen = loadImage("color/F2_fallen.png");
  F2_expl = loadImage("color/F2_expl.png");
}
//
//ArrayList<PImage> createColorImageArray()
//{
//  ArrayList<PImage> colorImages = new ArrayList<PImage>();
//  loadColorTowers();
//  
//  colorImages.add(A1_tower);
//  colorImages.add(A2_tower);
//  colorImages.add(B1_tower);
//  colorImages.add(B2_tower);
//  colorImages.add(C1_tower);
//  colorImages.add(C2_tower);
//  colorImages.add(D1_tower);
//  colorImages.add(D2_tower);
//  colorImages.add(F1_tower);
//  colorImages.add(F2_tower);
//  
//  colorImages.add(A1_correct);
//  colorImages.add(A2_correct);
//  colorImages.add(B1_correct);
//  colorImages.add(B2_correct);
//  colorImages.add(C1_correct);
//  colorImages.add(C2_correct);
//  colorImages.add(D1_correct);
//  colorImages.add(D2_correct);
//  colorImages.add(F1_correct);
//  colorImages.add(F2_correct);
//  
//  colorImages.add(A1_wrong);
//  colorImages.add(A2_wrong);
//  colorImages.add(B1_wrong);
//  colorImages.add(B2_wrong);
//  colorImages.add(C1_wrong);
//  colorImages.add(C2_wrong);
//  colorImages.add(D1_wrong);
//  colorImages.add(D2_wrong);
//  colorImages.add(F1_wrong);
//  colorImages.add(F2_wrong);
//  
//  return colorImages;
//}

void loadButtons()
{
  game1 = loadImage("buttons/playgame1.png");
  game2 = loadImage("buttons/playgame2.png");
  continueButton = loadImage("buttons/continue.png");
  continueButton_hover = loadImage("buttons/continue_hover.png");
  same = loadImage("buttons/same.png");
  same_hover = loadImage("buttons/same_hover.png");
  tower1 = loadImage("buttons/first.png");
  tower1_hover = loadImage("buttons/first_hover.png");
  tower2 = loadImage("buttons/second.png");  
  tower2_hover = loadImage("buttons/second_hover.png");
  shake = loadImage("buttons/shake.png");
  shake_hover = loadImage("buttons/shake_hover.png");
  pred_symm = loadImage("buttons/pred_symm.png");
  pred_symm_hover = loadImage("buttons/pred_symm_hover.png");
  pred_taller = loadImage("buttons/pred_taller.png");
  pred_taller_hover = loadImage("buttons/pred_taller_hover.png");
  pred_thinner = loadImage("buttons/pred_thinner.png");
  pred_thinner_hover = loadImage("buttons/pred_thinner_hover.png");
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
  t_place_wrong_left_only = loadImage("text/place_wrong_left_only.png");
  t_place_wrong_right = loadImage("text/place_wrong_right.png");
  t_place_wrong_right_only = loadImage("text/place_wrong_right_only.png");
  t_pred_intro = loadImage("text/prediction_intro.png");
  t_pred_left = loadImage("text/prediction_left_first.png");
  t_pred_right = loadImage("text/prediction_right_first.png");
  t_pred_same = loadImage("text/prediction_same_first.png");
  t_clear_table = loadImage("text/clear_table.png");
}


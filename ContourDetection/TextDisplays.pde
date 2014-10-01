PImage wrongTower, correctTower;
PImage leftToMatchImg, rightToMatchImg;
PImage LTMwrong, LTMcorrect, RTMwrong, RTMcorrect;
PImage LTMfallen, RTMfallen, LTMstanding, RTMstanding;
PImage LTMfinal, RTMfinal;

//****************************************************** GENERAL THINGS
void displayText(PImage textBubble)
{
  image(textBubble, 1*gorWidth/4, 0);
}

void game_buttons()
{
  image(game1, 1*gorWidth/2, 1*gorHeight/2);
  image(game2, 1*gorWidth/2, 3*gorHeight/4);  
}

//****************************************************** PLACING TOWERS
void placementcircles()
{
  image(circle, 1*gorWidth/2, 21*gorHeight/32);
  image(circle, 23*gorWidth/32, 21*gorHeight/32);
}

void continue_button()
{
  image(continueButton, 17*gorWidth/32, 13*gorHeight/16);
}

//****************************************************** images *******
void place_leftside_table(PImage img)
{
  //leftToMatchImg, LTMcorrect, LTMwrong
  image(img, 1*gorWidth/2, 5*gorHeight/16);
}

void place_rightside_table(PImage img)
{
  //rightToMatchImg, RTMcorrect, RTMwrong
  image(img, 23*gorWidth/32, 5*gorHeight/16);
}

void instr_place_left_img()
{
  image(leftToMatchImg, 1*gorWidth/2, 5*gorHeight/16);
}

void instr_place_right_img()
{
  image(rightToMatchImg, 23*gorWidth/32, 5*gorHeight/16);
}

void match_left_image()
{
  image(LTMcorrect, 1*gorWidth/2, 5*gorHeight/16);
}

void match_right_image()
{
  image(RTMcorrect, 23*gorWidth/32, 5*gorHeight/16);
}

void mismatch_left_image()
{
  image(LTMwrong, 1*gorWidth/2, 5*gorHeight/16);
}

void mismatch_right_image()
{
  image(RTMwrong, 23*gorWidth/32, 5*gorHeight/16);
}


//****************************************************** text *******
void instr_place_tower() 
{
  displayText(t_place_both);
}

void match_left_text()
{
  displayText(t_place_right);
}

void match_right_text()
{
  displayText(t_place_left);
}

void mismatch_left_text()
{
  displayText(t_place_wrong_left);
}

void mismatch_right_text()
{
  displayText(t_place_wrong_right);
}

void both_match_text()
{
  displayText(t_place_continue);
  continue_button();
}

void neither_match_text()
{
  displayText(t_place_wrong_both);
}

//*************************************************** PREDICTION SCREENS
void prediction_tower_buttons()
{
  image(tower1, 15*gorWidth/32, 9*gorHeight/32);
  image(same, 5*gorWidth/8, 9*gorHeight/32);
  image(tower2, 25*gorWidth/32, 9*gorHeight/32);
}

void prediction_intro()
{
  displayText(t_pred_intro);
  prediction_tower_buttons();
}

void prediction_discusschoice()
{
  if (towerPredictionNumber==1)
    displayText(t_pred_left);
  else if (towerPredictionNumber==2)
    displayText(t_pred_right);    
  else if (towerPredictionNumber==3)
    displayText(t_pred_same);
  shake_button();
}

void shake_button()
{
  image(shake, 9*gorWidth/16, 13*gorHeight/16);
}

//********************************************************* POST SHAKE
void guess_message()
{
  String fallenTower = "";
  if (fallen==1)
    fallenTower = "left";
  else if (fallen==2)
    fallenTower = "right";
  
  if (correctGuess==true)
  {
    if (towerPredictionNumber==1)
      displayText(t_hyp_correct_left);
    else if (towerPredictionNumber==2) 
      displayText(t_hyp_correct_right);
  }
  else if ((fallen!=0) && (correctGuess==false))
  {
    if (fallen==1)
      displayText(t_hyp_wrong_left);
    else if (fallen==2)
      displayText(t_hyp_wrong_right);
  }

  if (fallen!=0)
    pred_buttons();
}

void pred_buttons()
{
  image(pred_taller, 3*gorWidth/8, 1*gorHeight/4);
  image(pred_weight, 3*gorWidth/8, 3*gorHeight/8);
  image(pred_thinner, 21*gorWidth/32, 1*gorHeight/4);
  image(pred_symm, 21*gorWidth/32, 3*gorHeight/8);  
}

//****************************************************** EXPLANATION
void fallen_correct(int fr)
{
  if (fr==1)
    displayText(t_expl_correct_taller);
  else if (fr==2)
    displayText(t_expl_correct_thinner);
  else if (fr==3)
    displayText(t_expl_correct_weight);
  else if (fr==4)
    displayText(t_expl_correct_symm);
}

void fallen_wrong(int fr)
{
  if (fr==1)
    displayText(t_expl_wrong_taller);
  else if (fr==2)
    displayText(t_expl_wrong_thinner);
  else if (fr==3)
    displayText(t_expl_wrong_weight);
  else if (fr==4)
    displayText(t_expl_wrong_symm);
}

void expl_result()
{
  if (expl_guess == fallen_reason)
    fallen_correct(fallen_reason);
  else
    fallen_wrong(fallen_reason);
  expl_towerImages();
  continue_button();
  //scene2 = false;
  //scene3 = false;
}


void expl_towerImages()
{
  explain = true;
  image(LTMfinal, 1*gorWidth/2, 5*gorHeight/16);
  image(RTMfinal, 23*gorWidth/32, 5*gorHeight/16);
}

//****************************************************** TRANSITION
//void transition_screen()
//{
//  image(pretzel, 0, 0);
//  if (legoTowers.size()==0)
//    continue_button();
//}


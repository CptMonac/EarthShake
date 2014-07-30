PImage wrongTower, correctTower;
PImage leftToMatchImg, rightToMatchImg;
PImage LTMwrong, LTMcorrect, RTMwrong, RTMcorrect;
PImage LTMfinal, RTMfinal;

//****************************************************** PLACING TOWERS
void placementcircles()
{
  image(circle, 1*gorWidth/2, 21*gorHeight/32);
  image(circle, 23*gorWidth/32, 21*gorHeight/32);
}

void continue_button()
{
  image(continueButton, 17*gorWidth/32, 13*gorHeight/16);
//  float xleft = 17*gorWidth/32;
//  float xright = xleft + 3*gorWidth/8;
//  float ytop = 13*gorHeight/16;
//  float ybot = ytop + 1*gorHeight/8;
//  if ((mouseX >= xleft) && (mouseX <= xright) && (mouseY >= ytop) && (mouseY <= ybot))
//  {
//    image(continueButton_hover, 17*gorWidth/32, 13*gorHeight/16);
//  }
}

void instr_place_tower() 
{
  image(t_place_both, 1*gorWidth/4, 0);
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

void match_left_text()
{
  image(t_place_right, 1*gorWidth/4, 0);
}

void match_right_image()
{
  image(RTMcorrect, 23*gorWidth/32, 5*gorHeight/16);
}

void match_right_text()
{
  image(t_place_left, 1*gorWidth/4, 0);
}

void mismatch_left_image()
{
  image(LTMwrong, 1*gorWidth/2, 5*gorHeight/16);
}

void mismatch_left_text()
{
  image(t_place_wrong_left, 1*gorWidth/4, 0);
}

void mismatch_right_image()
{
  image(RTMwrong, 23*gorWidth/32, 5*gorHeight/16);
}

void mismatch_right_text()
{
  image(t_place_wrong_right, 1*gorWidth/4, 0);
}

void both_match_text()
{
  image(t_place_continue, 1*gorWidth/4, 0);
  continue_button();
}

void neither_match_text()
{
  image(t_place_wrong_both, 1*gorWidth/4, 0);
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
  image(t_pred_intro, 1*gorWidth/4, 0);
  prediction_tower_buttons();
}

void prediction_discusschoice()
{
  if (towerPredictionNumber==1)
    image(t_pred_left, 1*gorWidth/4, 0);
  else if (towerPredictionNumber==2)
    image(t_pred_right, 1*gorWidth/4, 0);    
  else if (towerPredictionNumber==3)
    image(t_pred_same, 1*gorWidth/4, 0);
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
      image(t_hyp_correct_left, 1*gorWidth/4, 0);
    else if (towerPredictionNumber==2) 
      image(t_hyp_correct_right, 1*gorWidth/4, 0);
  }
  else if ((fallen!=0) && (correctGuess==false))
  {
    if (fallen==1)
      image(t_hyp_wrong_left, 1*gorWidth/4, 0);
    else if (fallen==2)
      image(t_hyp_wrong_right, 1*gorWidth/4, 0);
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
    image(t_expl_correct_taller, 1*gorWidth/4, 0);
  else if (fr==2)
    image(t_expl_correct_thinner, 1*gorWidth/4, 0);
  else if (fr==3)
    image(t_expl_correct_weight, 1*gorWidth/4, 0);
  else if (fr==4)
    image(t_expl_correct_symm, 1*gorWidth/4, 0);
}

void fallen_wrong(int fr)
{
  if (fr==1)
    image(t_expl_wrong_taller, 1*gorWidth/4, 0);
  else if (fr==2)
    image(t_expl_wrong_thinner, 1*gorWidth/4, 0);
  else if (fr==3)
    image(t_expl_wrong_weight, 1*gorWidth/4, 0);
  else if (fr==4)
    image(t_expl_wrong_symm, 1*gorWidth/4, 0);
}

void expl_result()
{
  if (expl_guess == fallen_reason)
    fallen_correct(fallen_reason);
  else
    fallen_wrong(fallen_reason);
  scene2 = false;
  scene3 = false;
  expl_towerImages();
  continue_button();
}


void expl_towerImages()
{
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


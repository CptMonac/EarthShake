PImage wrongTower, correctTower;
PImage leftToMatchImg, rightToMatchImg;
PImage LTMwrong, LTMcorrect, RTMwrong, RTMcorrect;

//****************************************************** PLACING TOWERS
void placementcircles()
{
  image(circle, 17*gorWidth/32, 11*gorHeight/16);
  image(circle, 24*gorWidth/32, 11*gorHeight/16);
}

void continue_button()
{
  image(continueButton, 9*gorWidth/16, 13*gorHeight/16);
}

void instr_place_tower() 
{
  textSize(25);
  text("Place these towers on the table.", 250, 50, 450, 70);
  textSize(15);
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
  textSize(22);
  text("Good job! The left tower matches. Now place the right tower.", 230, 30, 450, 70);    
  textSize(15);
}

void match_right_image()
{
  image(RTMcorrect, 23*gorWidth/32, 5*gorHeight/16);
}

void match_right_text()
{
  textSize(22);
  text("Good job! The right tower matches. Now place the left tower.", 230, 30, 450, 70);
  textSize(15);
}

void mismatch_left_image()
{
  image(LTMwrong, 1*gorWidth/2, 5*gorHeight/16);
}

void mismatch_left_text()
{
  textSize(22);
  text("Uh oh! You placed the wrong tower on the left. Please place the correct tower.", 230, 30, 450, 70);
  textSize(15);
}

void mismatch_right_image()
{
  image(RTMwrong, 23*gorWidth/32, 5*gorHeight/16);
}

void mismatch_right_text()
{
  textSize(22);
  text("Uh oh! You placed the wrong tower on the right. Please place the correct tower.", 230, 30, 450, 70);
  textSize(15);
}

void both_match_text()
{
  textSize(25);
  text("Good job! Click to continue.", 250, 70);
  continue_button();
  textSize(15);
}

void neither_match_text()
{
  textSize(22);
  text("Uh oh! Neither tower is correct. Please try placing the towers again.", 230, 30, 450, 70);
  textSize(15);
}

//*************************************************** PREDICTION SCREENS
void prediction_tower_buttons()
{
  image(tower1, int(1*gorWidth/2), int(3*gorHeight/8));
  image(same, int(5*gorWidth/8), int(3*gorHeight/8));
  image(tower2, int(3*gorWidth/4), int(3*gorHeight/8));
}

void prediction_intro()
{
  textSize(22);
  text("Which tower do you think will fall first when I shake the table?", 230, 30, 450, 70);
  towerPredictionNumber = 0;
  towerPredictionString = "";
  prediction_tower_buttons();
  textSize(15);
}

void prediction_discusschoice()
{
  text("You chose that "+towerPredictionString+" Why do you think so? Discuss with a friend. When you are done, click SHAKE to see the result.", 230, 30, 450, 70);
  shake_button();
  correctGuess = false;
  fallen = 0;
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
      text("Good job! Your hypothesis was right. The left tower fell first. Why do you think it fell first?", 230, 30, 450, 70);
    else if (towerPredictionNumber==2) 
      text("Good job! Your hypothesis was right. The right tower fell first. Why do you think it fell first?", 230, 30, 450, 70);
  }
  else if (fallen!=0)
    text("Oh no! Your hypothesis was incorrect. Why do you think the "+fallenTower+" tower fell first?", 230, 30, 450, 70);

  if (fallen!=0)
    pred_buttons();
}

void pred_buttons()
{
  image(pred_taller, 7*gorWidth/16, 1*gorHeight/4);
  image(pred_weight, 7*gorWidth/16, 3*gorHeight/8);
  image(pred_thinner, 23*gorWidth/32, 1*gorHeight/4);
  image(pred_symm, 23*gorWidth/32, 3*gorHeight/8);  
}

//****************************************************** EXPLANATION


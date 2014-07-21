PImage wrongTower, correctTower;
PImage leftToMatchImg, rightToMatchImg;
PImage LTMwrong, LTMcorrect, RTMwrong, RTMcorrect;
PImage continueButton, tower1, tower2, same;

//****************************************************** PLACING TOWERS
void continue_button()
{
  //replace this function with "image(continue, etc, etc)" later
  image(continueButton, 9*780/16, 13*500/16);
}

void instr_place_tower() 
{
  textSize(25);
  text("Place these towers on the table.", 250, 50, 450, 70);
  textSize(15);
}

void instr_place_images()
{
  image(leftToMatchImg, int(1*780/2), int(3*500/8));
  image(rightToMatchImg, int(11*780/16), int(3*500/8));
}

void match_left_image()
{
  image(LTMcorrect, 1*780/2, 5*500/16);
}

void match_left_text()
{
  textSize(22);
  textSize(22);
  text("Good job! The left tower matches. Now place the right tower.", 230, 30, 450, 70);    
  textSize(15);
}

void match_right_image()
{
  image(RTMcorrect, 11*780/16, 5*500/16);
  textSize(15);
}

void match_right_text()
{
  textSize(22);
  text("Good job! The right tower matches. Now place the left tower.", 230, 30, 450, 70);
  textSize(15);
}

void mismatch_left_image()
{
  image(LTMwrong, 1*780/2, 5*500/16);
}

void mismatch_left_text()
{
  textSize(22);
  text("Uh oh! You placed the wrong tower on the left. Please place the correct tower.", 230, 30, 450, 70);
  textSize(15);
}

void mismatch_right_image()
{
  image(RTMwrong, 11*780/16, 5*500/16);
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
  image(tower1, int(1*780/2), int(11*500/16));
  image(same, int(5*780/8), int(11*500/16));
  image(tower2, int(3*780/4), int(11*500/16));
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
  continue_button();
  correctGuess = false;
  fallen = 0;
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
    text("Oh no! Your hypothesis was incorrect. Why do you think the "+fallenTower+" fell first?", 230, 30, 450, 70);
}

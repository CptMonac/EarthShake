PImage wrongTower, correctTower;
PImage leftToMatchImg, rightToMatchImg;
PImage LTMwrong, LTMcorrect, RTMwrong, RTMcorrect;
PImage continueButton, tower1, tower2, same;

//****************************************************** PLACING TOWERS
void continue_button()
{
  //replace this function with "image(continue, etc, etc)" later
  /*
  fill(0,0,155);
  noStroke();
  rect(470,130,100,40);
  fill(255,255,255);
  stroke(255,255,255);  */
  image(continueButton, int(9*780/16), int(13*500/16));
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
  textSize(25);
  image(LTMcorrect, int(1*780/2), int(3*500/8));
  //text("MATCH!", 380, 330);
  textSize(15);
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
  textSize(25);
  image(RTMcorrect, int(11*780/16), int(3*500/8));
  //text("MATCH!", 580, 330);
  textSize(15);
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
  textSize(25);
  image(LTMwrong, int(1*780/2), int(3*500/8));
  //text("oops!", 410, 330);
  textSize(15);
}

void mismatch_left_text()
{
  textSize(22);
  text("Uh oh! You placed the wrong tower on the left. Please place the correct tower.", 230, 30, 450, 70);
  textSize(15);
}

void mismatch_right_image()
{
  textSize(25);
  //tint(255,0);
  image(RTMwrong, int(11*780/16), int(3*500/8));
  //noTint();
  //text("oops!", 610, 330);
  textSize(15);
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
  prediction_tower_buttons();
  textSize(15);
}

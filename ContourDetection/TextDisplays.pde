PImage wrongTower, correctTower;
PImage leftToMatchImg, rightToMatchImg;
PImage LTMwrong, LTMcorrect, RTMwrong, RTMcorrect;

void continue_button()
{
  //replace this function with "image(continue, etc, etc)" later
  fill(0,0,155);
  noStroke();
  rect(470,130,100,40);
  fill(255,255,255);
  stroke(255,255,255);  
}

void instr_place_tower() 
{
  textSize(25);
  text("Place these towers on the table.", 250, 50, 450, 70);
  textSize(15);
}

void instr_place_images()
{
  image(leftToMatchImg, 380, 160);
  image(rightToMatchImg, 580, 160);
}

void match_left_image()
{
  textSize(25);
  image(LTMcorrect, 370, 160);
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
  image(RTMcorrect, 570, 160);
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
  image(LTMwrong, 370, 160);
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
  image(RTMwrong, 570, 160);
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

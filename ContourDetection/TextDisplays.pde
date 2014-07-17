PImage wrongTower, correctTower;

void instr_place_tower() 
{
  textSize(25);
  text("Place these towers on the table.", 250, 70);
  text(leftToMatch, 390, 250);
  text(rightToMatch, 590, 250);
  textSize(15);
}

void match_left()
{
  textSize(25);
  image(correctTower, 390, 210);
  text("MATCH!", 380, 330);
  textSize(15);
}

void match_right()
{
  textSize(25);
  image(correctTower, 590, 210);
  text("MATCH!", 580, 330);
  textSize(15);
}

void mismatch_left_image()
{
  textSize(25);
  image(wrongTower, 390, 210);
  text("oops!", 410, 330);
  textSize(15);
}

void mismatch_left_text()
{
  textSize(20);
  text("You placed the wrong tower on the left. Please place the correct tower.", 230, 30, 450, 70);
  textSize(15);
}

void mismatch_right_image()
{
  textSize(25);
  //tint(255,0);
  image(wrongTower, 590, 210);
  //noTint();
  text("oops!", 610, 330);
  textSize(15);
}

void mismatch_right_text()
{
  textSize(20);
  text("You placed the wrong tower on the right. Please place the correct tower.", 230, 30, 450, 70);
  textSize(15);
}

PImage wrongTower, correctTower;

void instr_place_tower() 
{
  textSize(25);
  text("Place these towers on the table.", 250, 70);
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

void mismatch_left()
{
  textSize(25);
  image(wrongTower, 390, 210);
  text("oops!", 410, 330);
  textSize(15);
}

void mismatch_right()
{
  textSize(25);
  //tint(255,0);
  image(wrongTower, 590, 210);
  //noTint();
  text("oops!", 610, 330);
  textSize(15);
}

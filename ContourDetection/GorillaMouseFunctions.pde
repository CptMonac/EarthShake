
Boolean continue_pressed()
{
  int xleft = int(9*gorWidth/16);
  int xright = xleft + int(3*gorWidth/16);
  int ytop = int(13*gorHeight/16);
  int ybot = ytop + int(1*gorHeight/16);
  if ((mouseX >= xleft) && (mouseX <= xright) && (mouseY >= ytop) && (mouseY <= ybot))
    return true;
  else
    return false;
}

Boolean tower1_selected()
{
  int xleft = int(1*gorWidth/2);
  int xright = xleft + int(1*gorWidth/16);
  int ytop = int(11*gorHeight/16);
  int ybot = ytop + int(1*gorHeight/16);
  if ((mouseX >= xleft) && (mouseX <= xright) && (mouseY >= ytop) && (mouseY <= ybot)) {
    towerPredictionNumber = 1;
    towerPredictionString = "TOWER 1 will fall first.";
    return true;
  }
  else
    return false;
}

Boolean same_selected()
{
  int xleft = int(5*gorWidth/8);
  int xright = xleft + int(1*gorWidth/16);
  int ytop = int(11*gorHeight/16);
  int ybot = ytop + int(1*gorHeight/16);
  if ((mouseX >= xleft) && (mouseX <= xright) && (mouseY >= ytop) && (mouseY <= ybot)) {
    towerPredictionNumber = 3;
    towerPredictionString = "BOTH TOWERS will fall at the same time.";
    return true;
  }
  else
    return false;
}

Boolean tower2_selected()
{
  int xleft = int(3*gorWidth/4);
  int xright = xleft + int(1*gorWidth/16);
  int ytop = int(11*gorHeight/16);
  int ybot = ytop + int(1*gorHeight/16);
  if ((mouseX >= xleft) && (mouseX <= xright) && (mouseY >= ytop) && (mouseY <= ybot)) {
    towerPredictionNumber = 2;
    towerPredictionString = "TOWER 2 will fall first.";
    return true;
  }
  else
    return false;
}

Boolean shake_pressed()
{
  float xleft = 9*gorWidth/16;
  float xright = xleft + 200;
  float ytop = 13*gorHeight/16;
  float ybot = ytop + 1*gorHeight/16;
  if ((mouseX >= xleft) && (mouseX <= xright) && (mouseY >= ytop) && (mouseY <= ybot)) 
    return true;
  else
    return false;
}

int explanation()
{
  int expl_guess = 0;
  
  //pred_taller = 1
  if ((mouseX >= 7*gorWidth/16) && (mouseX <= 10*gorWidth/16) && (mouseY >= 1*gorHeight/4) && (mouseY < 7*gorHeight/16))
    expl_guess = 1;
    
  //pred_thinner = 2
  if ((mouseX >= 23*gorWidth/32) && (mouseX <= 29*gorWidth/32) && (mouseY >= 1*gorHeight/4) && (mouseY < 7*gorHeight/16))
    expl_guess = 2;
    
  //pred_weight = 3
  if ((mouseX >= 7*gorWidth/16) && (mouseX <= 10*gorWidth/16) && (mouseY >= 3*gorHeight/8) && (mouseY <= 9*gorHeight/16))
    expl_guess = 3;
    
  //pred_symm = 4;  
  if ((mouseX >= 23*gorWidth/32) && (mouseX <= 29*gorWidth/32) && (mouseY >= 3*gorHeight/8) && (mouseY <= 9*gorHeight/16))
    expl_guess = 4;
    
  return expl_guess;
}



Boolean continue_pressed()
{
  float xleft = 17*gorWidth/32;
  float xright = xleft + 3*gorWidth/8;
  float ytop = 13*gorHeight/16;
  float ybot = ytop + 1*gorHeight/8;
  if ((mouseX >= xleft) && (mouseX <= xright) && (mouseY >= ytop) && (mouseY <= ybot))
    return true;
  else
    return false;
}

Boolean tower1_selected()
{
  float xleft = 15*gorWidth/32;
  float xright = xleft + 1*gorWidth/8; //+100
  float ytop = 9*gorHeight/32;
  float ybot = ytop + 1*gorHeight/16;
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
  float xleft = 5*gorWidth/8;
  float xright = xleft + 1*gorWidth/8; //+100
  float ytop = 9*gorHeight/32;
  float ybot = ytop + 1*gorHeight/16;
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
  float xleft = 25*gorWidth/32;
  float xright = xleft + 1*gorWidth/8; //+100
  float ytop = 9*gorHeight/32;
  float ybot = ytop + 1*gorHeight/16;
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
  float ybot = ytop + 1*gorHeight/8;
  if ((mouseX >= xleft) && (mouseX <= xright) && (mouseY >= ytop) && (mouseY <= ybot)) 
    return true;
  else
    return false;
}

int explanation()
{ 
  // width/4 wide, height/8 tall
  
  //pred_taller = 1
  if ((mouseX >= 3*gorWidth/8) && (mouseX <= 5*gorWidth/8) && (mouseY >= 1*gorHeight/4) && (mouseY < 3*gorHeight/8))
    expl_guess = 1;
    
  //pred_thinner = 2
  if ((mouseX >= 21*gorWidth/32) && (mouseX <= 29*gorWidth/32) && (mouseY >= 1*gorHeight/4) && (mouseY < 3*gorHeight/8))
    expl_guess = 2;
    
  //pred_weight = 3
  if ((mouseX >= 3*gorWidth/8) && (mouseX <= 5*gorWidth/8) && (mouseY >= 3*gorHeight/8) && (mouseY <= 4*gorHeight/8))
    expl_guess = 3;
    
  //pred_symm = 4;  
  if ((mouseX >= 21*gorWidth/32) && (mouseX <= 29*gorWidth/32) && (mouseY >= 3*gorHeight/8) && (mouseY <= 4*gorHeight/8))
    expl_guess = 4;
    
  return expl_guess;
}


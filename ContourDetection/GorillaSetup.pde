String leftToMatch;
String rightToMatch;
Boolean scene2, scene3, scene3a;
Boolean foundLeftMatch, foundRightMatch;
Boolean placingTowers;

void gameSetup()
{
  leftToMatch = "F1";
  rightToMatch = "F2";
  
  leftToMatchImg = F1_tower;
  LTMwrong = F1_wrong;
  LTMcorrect = F1_correct;
  rightToMatchImg = F2_tower;
  RTMwrong = F2_wrong;
  RTMcorrect = F2_correct;
  
  foundLeftMatch = false;
  foundRightMatch = false;
  if (scene2==false) {
    image(startScreen, 0, 0);
    continue_button();
  }
  if (scene2==true) {
    image(screen1, 0, 0);
  }
}

void gameplay()
{
}

void mousePressed()
{ 
  if (scene2==true && scene3==false)
  {
    if (continue_pressed()==true)
      scene3 = true;
  }
    
  if (scene2==false)
  {
    if (continue_pressed()==true)
      scene2 = true;
  }
}

Boolean continue_pressed()
{
  int xleft = int(9*780/16);
  int xright = xleft + int(3*780/16);
  int ytop = int(13*500/16);
  int ybot = ytop + int(1*500/16);
  if ((mouseX >= xleft) && (mouseX <= xright) && (mouseY >= ytop) && (mouseY <= ybot))
    return true;
  else
    return false;
}

Boolean tower1_selected()
{
  int xleft = int(1*780/2);
  int xright = xleft + int(1*780/16);
  int ytop = int(11*500/16);
  int ybot = ytop + int(1*500/16);
  if ((mouseX >= xleft) && (mouseX <= xright) && (mouseY >= ytop) && (mouseY <= ybot))
    return true;
  else
    return false;
}

Boolean same_selected()
{
  int xleft = int(5*780/8);
  int xright = xleft + int(1*780/16);
  int ytop = int(11*500/16);
  int ybot = ytop + int(1*500/16);
  if ((mouseX >= xleft) && (mouseX <= xright) && (mouseY >= ytop) && (mouseY <= ybot))
    return true;
  else
    return false;
}

Boolean tower2_selected()
{
  int xleft = int(3*780/4);
  int xright = xleft + int(1*780/16);
  int ytop = int(11*500/16);
  int ybot = ytop + int(1*500/16);
  if ((mouseX >= xleft) && (mouseX <= xright) && (mouseY >= ytop) && (mouseY <= ybot))
    return true;
  else
    return false;
}

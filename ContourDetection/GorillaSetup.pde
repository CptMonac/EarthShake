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
  rightToMatchImg = F1_tower;
  RTMwrong = F1_wrong;
  RTMcorrect = F1_correct;
  
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
    if ((mouseX >= 470) && (mouseX <= 570) && (mouseY >= 130) && (mouseY <= 170))
      scene3 = true;
  }
    
  if (scene2==false)
  {
    if ((mouseX >= 470) && (mouseX <= 570) && (mouseY >= 130) && (mouseY <= 170))
      scene2 = true;
  }
}


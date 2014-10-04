PImage wrongTower, correctTower;
PImage leftToMatchImg, rightToMatchImg;
PImage LTMwrong, LTMcorrect, RTMwrong, RTMcorrect;
PImage LTMfallen, RTMfallen, LTMstanding, RTMstanding;
PImage LTMfinal, RTMfinal;

boolean entered_place_both,entered_place_right,entered_place_left,entered_place_wrong_left,entered_place_wrong_right,entered_place_continue,entered_place_wrong_both,entered_place_wrong_left_only,entered_place_wrong_right_only=false;

//****************************************************** GENERAL THINGS
void displayText(PImage textBubble)
{
  image(textBubble, 1*gorWidth/4, 0);
}

void game_buttons()
{
  image(game1, 1*gorWidth/2, 1*gorHeight/2);
  image(game2, 1*gorWidth/2, 3*gorHeight/4);  
}

//****************************************************** PLACING TOWERS
void placementcircles()
{
  image(circle, 1*gorWidth/2, 21*gorHeight/32);
  image(circle, 23*gorWidth/32, 21*gorHeight/32);
}

void continue_button()
{
  image(continueButton, 17*gorWidth/32, 13*gorHeight/16);
}

//****************************************************** images *******
void place_leftside_table(PImage img)
{
  //leftToMatchImg, LTMcorrect, LTMwrong
  image(img, 1*gorWidth/2, 5*gorHeight/16);
}

void place_rightside_table(PImage img)
{
  //rightToMatchImg, RTMcorrect, RTMwrong
  image(img, 23*gorWidth/32, 5*gorHeight/16);
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

void match_right_image()
{
  image(RTMcorrect, 23*gorWidth/32, 5*gorHeight/16);
}

void mismatch_left_image()
{
  image(LTMwrong, 1*gorWidth/2, 5*gorHeight/16);
}

void mismatch_right_image()
{
  image(RTMwrong, 23*gorWidth/32, 5*gorHeight/16);
}


//****************************************************** text *******
void instr_place_tower() 
{
  displayText(t_place_both);
  
  if(entered_place_both == false){
        //adding sound 
        minim = new Minim(this);
        player = minim.loadFile("audio/place_both.wav", 2048);
        player.play();
  }
   
   println("instr_place_tower"); 
    entered_place_both = true;
    entered_place_right = false;
    entered_place_left = false;
    entered_place_wrong_left = false;
    entered_place_wrong_right = false;
    entered_place_continue = false;
    entered_place_wrong_both = false;
    entered_place_wrong_left_only = false;
    entered_place_wrong_right_only = false;
  
}

void match_left_text()
{
  displayText(t_place_right);
  
  if(entered_place_right == false){
        //adding sound 
        minim = new Minim(this);
        player = minim.loadFile("audio/place_right.wav", 2048);
        player.play();
  }
    
    println("match_left_text");
    entered_place_both = false;
    entered_place_right = true;
    entered_place_left = false;
    entered_place_wrong_left = false;
    entered_place_wrong_right = false;
    entered_place_continue = false;
    entered_place_wrong_both = false;
    entered_place_wrong_left_only = false;
    entered_place_wrong_right_only = false;

}

void match_right_text()
{
  displayText(t_place_left);
  
  /*
  if(entered_place_left == false){
        //adding sound 
        minim = new Minim(this);
        player = minim.loadFile("audio/place_left.wav", 2048);
        player.play();
  }
    
    println("match_right_text");
    entered_place_both = false;
    entered_place_right = false;
    entered_place_left = true;
    entered_place_wrong_left = false;
    entered_place_wrong_right = false;
    entered_place_continue = false;
    entered_place_wrong_both = false;
    entered_place_wrong_left_only = false;
    entered_place_wrong_right_only = false;
    */
}

void mismatch_left_text()
{
  displayText(t_place_wrong_left);
  
  /*
  if(entered_place_wrong_left == false){
        //adding sound 
        minim = new Minim(this);
        player = minim.loadFile("audio/place_wrong_left.wav", 2048);
        player.play();
  }
    
     println("mismatch_left_text");
    entered_place_both = false;
    entered_place_right = false;
    entered_place_left = false;
    entered_place_wrong_left = true;
    entered_place_wrong_right = false;
    entered_place_continue = false;
    entered_place_wrong_both = false;
    entered_place_wrong_left_only = false;
    entered_place_wrong_right_only = false;
    */
}

void display_place_wrong_left_only() {
  
  displayText(t_place_wrong_left_only);
  
  /*
  if(entered_place_wrong_left_only == false){
        //adding sound 
        minim = new Minim(this);
        player = minim.loadFile("audio/place_wrong_left_only.wav", 2048);
        player.play();
  }
    
     println("mismatch_left_text");
    entered_place_both = false;
    entered_place_right = false;
    entered_place_left = false;
    entered_place_wrong_left = false;
    entered_place_wrong_right = false;
    entered_place_continue = false;
    entered_place_wrong_both = false;
    entered_place_wrong_left_only = true;
    entered_place_wrong_right_only = false;
  */
}

void display_place_wrong_right_only() {
  
  displayText(t_place_wrong_right_only);
  /*
  
  if(entered_place_wrong_right_only == false){
        //adding sound 
        minim = new Minim(this);
        player = minim.loadFile("audio/place_wrong_right_only.wav", 2048);
        player.play();
  }
    
     println("mismatch_left_text");
    entered_place_both = false;
    entered_place_right = false;
    entered_place_left = false;
    entered_place_wrong_left = false;
    entered_place_wrong_right = false;
    entered_place_continue = false;
    entered_place_wrong_both = false;
    entered_place_wrong_left_only = false;
    entered_place_wrong_right_only = true;
    */
  
}

void mismatch_right_text()
{
  displayText(t_place_wrong_right);
  
  /*
  
  if(entered_place_wrong_right == false){
        //adding sound 
        minim = new Minim(this);
        player = minim.loadFile("audio/place_wrong_right.wav", 2048);
        player.play();
  }
    
    println("mismatch_right_text");
    entered_place_both = false;
    entered_place_right = false;
    entered_place_left = false;
    entered_place_wrong_left = false;
    entered_place_wrong_right = true;
    entered_place_continue = false;
    entered_place_wrong_both = false;
    entered_place_wrong_left_only = false;
    entered_place_wrong_right_only = false;
    */
}

void both_match_text()
{
  displayText(t_place_continue);
  continue_button();
  
  if(entered_place_continue == false){
        //adding sound 
        minim = new Minim(this);
        player = minim.loadFile("audio/place_continue.wav", 2048);
        player.play();
  }
    println("both_match_text");
    entered_place_both = false;
    entered_place_right = false;
    entered_place_left = false;
    entered_place_wrong_left = false;
    entered_place_wrong_right = false;
    entered_place_continue = true;
    entered_place_wrong_both = false;
    entered_place_wrong_left_only = false;
    entered_place_wrong_right_only = false;
}

void neither_match_text()
{
  displayText(t_place_wrong_both);
  
  /*
  if(entered_place_wrong_both == false){
        //adding sound 
        minim = new Minim(this);
        player = minim.loadFile("audio/place_wrong_both.wav", 2048);
        player.play();
        
  }
    
    println("neither_match_text");
    entered_place_both = false;
    entered_place_right = false;
    entered_place_left = false;
    entered_place_wrong_left = false;
    entered_place_wrong_right = false;
    entered_place_continue = false;
    entered_place_wrong_both = true;
    entered_place_wrong_left_only = false;
    entered_place_wrong_right_only = false;
    */
    
}

//*************************************************** PREDICTION SCREENS
void prediction_tower_buttons()
{
  image(tower1, 15*gorWidth/32, 9*gorHeight/32);
  image(same, 5*gorWidth/8, 9*gorHeight/32);
  image(tower2, 25*gorWidth/32, 9*gorHeight/32);
}

void prediction_intro()
{
  displayText(t_pred_intro);
  prediction_tower_buttons();
}

void prediction_discusschoice()
{
  if (towerPredictionNumber==1)
    displayText(t_pred_left);
  else if (towerPredictionNumber==2)
    displayText(t_pred_right);    
  else if (towerPredictionNumber==3)
    displayText(t_pred_same);
  shake_button();
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
      displayText(t_hyp_correct_left);
    else if (towerPredictionNumber==2) 
      displayText(t_hyp_correct_right);
  }
  else if ((fallen!=0) && (correctGuess==false))
  {
    if (fallen==1)
      displayText(t_hyp_wrong_left);
    else if (fallen==2)
      displayText(t_hyp_wrong_right);
  }

  if (fallen!=0)
    pred_buttons();
}

void pred_buttons()
{
  image(pred_taller, 3*gorWidth/8, 1*gorHeight/4);
  image(pred_weight, 3*gorWidth/8, 3*gorHeight/8);
  image(pred_thinner, 21*gorWidth/32, 1*gorHeight/4);
  image(pred_symm, 21*gorWidth/32, 3*gorHeight/8);  
}

//****************************************************** EXPLANATION
void fallen_correct(int fr)
{
  if (fr==1)
    displayText(t_expl_correct_taller);
  else if (fr==2)
    displayText(t_expl_correct_thinner);
  else if (fr==3)
    displayText(t_expl_correct_weight);
  else if (fr==4)
    displayText(t_expl_correct_symm);
}

void fallen_wrong(int fr)
{
  if (fr==1)
    displayText(t_expl_wrong_taller);
  else if (fr==2)
    displayText(t_expl_wrong_thinner);
  else if (fr==3)
    displayText(t_expl_wrong_weight);
  else if (fr==4)
    displayText(t_expl_wrong_symm);
}

void expl_result()
{
  if (expl_guess == fallen_reason)
    fallen_correct(fallen_reason);
  else
    fallen_wrong(fallen_reason);
  expl_towerImages();
  continue_button();
  //scene2 = false;
  //scene3 = false;
}


void expl_towerImages()
{
  explain = true;
  image(LTMfinal, 1*gorWidth/2, 5*gorHeight/16);
  image(RTMfinal, 23*gorWidth/32, 5*gorHeight/16);
}

//****************************************************** TRANSITION
//void transition_screen()
//{
//  image(pretzel, 0, 0);
//  if (legoTowers.size()==0)
//    continue_button();
//}


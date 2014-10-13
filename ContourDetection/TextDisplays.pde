PImage wrongTower, correctTower;
PImage leftToMatchImg, rightToMatchImg;
PImage LTMwrong, LTMcorrect, RTMwrong, RTMcorrect;
PImage LTMfallen, RTMfallen, LTMstanding, RTMstanding;
PImage LTMfinal, RTMfinal;

boolean entered_expl_wrong_symm = false, entered_expl_correct_symm = false, entered_expl_wrong_thinner = false, entered_expl_correct_thinner = false, entered_expl_wrong_taller = false, entered_expl_correct_taller = false, entered_expl_wrong_weight = false, entered_expl_correct_weight = false, entered_hyp_wrong_right = false, entered_hyp_wrong_left = false, entered_hyp_correct_right = false, entered_hyp_correct_left = false, entered_pred_intro= false,entered_pred_right= false, entered_pred_left= false, entered_pred_same= false, entered_place_both=false, entered_place_right=false, entered_place_left=false, entered_place_wrong_left=false, entered_place_wrong_right=false, entered_place_continue=false, entered_place_wrong_both=false, entered_place_wrong_left_only=false, entered_place_wrong_right_only=false;

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

  if (entered_place_both == false) {
    //adding sound 
    text("play place_both",300,300);
    //minim = new Minim(this);
    //minim.stop();
    
    player_place_both.close();
    player_place_left.close();
    player_place_right.close();
    player_place_continue.close();
    
    player_place_both = minim.loadFile("audio/place_both.wav", 2048);
    
    
    player_place_both.play();
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
  //"good job! the left tower matches. now place the right tower."
  displayText(t_place_right);

  if (entered_place_right == false) {
    //adding sound 
    text("play place_right",300,300);
    //minim = new Minim(this);
    //minim.stop();
    
    player_place_both.close();
    player_place_left.close();
    player_place_right.close();
    player_place_continue.close();
  
    player_place_right = minim.loadFile("audio/place_right.wav", 2048);
    
    player_place_right.play();
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
  //"good job! the right tower matches. now place the left tower."
  displayText(t_place_left);

  
  if(entered_place_left == false){
   //adding sound 
   text("play place_left",300,300);
   //minim = new Minim(this);
   //minim.stop();
    player_place_both.close();
    player_place_left.close();
    player_place_right.close();
    player_place_continue.close();
    
   player_place_left = minim.loadFile("audio/place_left.wav", 2048);
   
   player_place_left.play();
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
   
}

void mismatch_left_text()
{
  //"uh oh! you placed the wrong tower on the left. please place the correct tower."
  displayText(t_place_wrong_left);

  /*
  if(entered_place_wrong_left == false){
   //adding sound 
   text("play place_wrong",300,300);
   minim = new Minim(this);
   minim.stop();
   player_place_wrong_left = minim.loadFile("audio/place_wrong_left.wav", 2048);
   player_place_wrong_left.play();
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
  //"the left tower is incorrect. please place the correct tower."
  displayText(t_place_wrong_left_only);

  /*
  if(entered_place_wrong_left_only == false){
   //adding sound 
   text("play place_wrong_left_only",300,300);
   minim = new Minim(this);
   minim.stop();
   player_place_wrong_left_only = minim.loadFile("audio/place_wrong_left_only.wav", 2048);
   player_place_wrong_left_only.play();

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
  //"the right tower is incorrect. please place the correct tower."
  displayText(t_place_wrong_right_only);
  
  /*
   if(entered_place_wrong_right_only == false){
   //adding sound 
   text("play place_wrong_right_only",300,300);
   minim = new Minim(this);
   minim.stop();
   player_place_wrong_right_only = minim.loadFile("audio/place_wrong_right_only.wav", 2048);
   player_place_wrong_right_only.play();
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
  //"uh oh! you placed the wrong tower on the left. please place the correct tower."
  displayText(t_place_wrong_right);

/*
   if(entered_place_wrong_right == false){
   //adding sound 
   text("play place_wrong_right",300,300);
   minim = new Minim(this);
   minim.stop();
   player_place_wrong_right = minim.loadFile("audio/place_wrong_right.wav", 2048);
   player_place_wrong_right.play();
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
  //"good job! click to continue."
  displayText(t_place_continue);
  continue_button();

  println("entered_place_continue" + entered_place_continue);
  
  if (entered_place_continue == false) {
    //adding sound 
    text("play place_continue",300,300);
    //minim = new Minim(this);
    //minim.stop();
    
    player_place_both.close();
    player_place_left.close();
    player_place_right.close();
    player_place_continue.close();
    
    player_place_continue = minim.loadFile("audio/place_continue.wav", 2048);
    
    player_place_continue.play();
    
  }
  
  println("playyyyyy place_continue");
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
  //"uh oh! neither tower is correct. please try placing the towers again."
  displayText(t_place_wrong_both);

  /*
  if(entered_place_wrong_both == false){
   //adding sound 
   text("play place_wrong_both",300,300);
   minim = new Minim(this);
   minim.stop();
   player_place_wrong_both = minim.loadFile("audio/place_wrong_both.wav", 2048);
   player_place_wrong_both.play();
   
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
  
  
  if (entered_pred_intro == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
        
      player_pred_intro = minim.loadFile("audio/prediction_intro.wav", 2048);
        
      player_pred_intro.play();
  }
  
  entered_pred_intro = true;
  
  println("predictionnnnnnnnnnnnn");
  
  
}

void prediction_discusschoice()
{
  if (towerPredictionNumber==1){
    displayText(t_pred_left);
    
    if (entered_pred_left == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
        
      player_pred_left = minim.loadFile("audio/prediction_left_first.wav", 2048);
        
      player_pred_left.play();
  }
  
  entered_pred_left = true;
  entered_pred_intro =false;
  entered_pred_same = false;
  entered_pred_right = false;
  
  }
  else if (towerPredictionNumber==2){
    displayText(t_pred_right);  
  
  if (entered_pred_right == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
        
      player_pred_right = minim.loadFile("audio/prediction_right_first.wav", 2048);
        
      player_pred_right.play();
  }
  
  entered_pred_left = false;
  entered_pred_intro =false;
  entered_pred_same = false;
  entered_pred_right = true;
  
  }
  else if (towerPredictionNumber==3){
    displayText(t_pred_same);
    
    if (entered_pred_same == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
        
      player_pred_same = minim.loadFile("audio/prediction_same_first.wav", 2048);
        
      player_pred_same.play();
  }
  
  entered_pred_left = false;
  entered_pred_intro =false;
  entered_pred_same = true;
  entered_pred_right = false;
  
  }
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
    if (towerPredictionNumber==1){
      displayText(t_hyp_correct_left);
      
      if (entered_hyp_correct_left == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
      player_hyp_correct_left.close();
      
      player_hyp_correct_left = minim.loadFile("audio/hypothesis_correct_left.wav", 2048);
        
      player_hyp_correct_left.play();
      }
      
      entered_pred_left = false;
      entered_pred_intro =false;
      entered_pred_same = false;
      entered_pred_right = false;
      entered_hyp_correct_left = true;
  
    }
    else if (towerPredictionNumber==2){ 
      displayText(t_hyp_correct_right);
      
      if (entered_hyp_correct_left == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
      player_hyp_correct_left.close();
      player_hyp_correct_right.close();
      
      player_hyp_correct_right = minim.loadFile("audio/hypothesis_correct_right.wav", 2048);
        
      player_hyp_correct_right.play();
      }
      
      entered_pred_left = false;
      entered_pred_intro =false;
      entered_pred_same = false;
      entered_pred_right = false;
      entered_hyp_correct_left = false;
      entered_hyp_correct_right = false;
      
    }
  } else if ((fallen!=0) && (correctGuess==false))
  {
    if (fallen==1){
      displayText(t_hyp_wrong_left);
      
      if (entered_hyp_wrong_left == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
      player_hyp_correct_left.close();
      player_hyp_correct_right.close();
      player_hyp_wrong_left.close();
      
      player_hyp_wrong_left = minim.loadFile("audio/hypothesis_wrong_left.wav", 2048);
        
      player_hyp_wrong_left.play();
      }
      
      entered_pred_left = false;
      entered_pred_intro =false;
      entered_pred_same = false;
      entered_pred_right = false;
      entered_hyp_correct_left = false;
      entered_hyp_correct_right = false;
      entered_hyp_wrong_left = true;
      
    }
    else if (fallen==2){
      displayText(t_hyp_wrong_right);
      
      if (entered_hyp_wrong_right == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
      player_hyp_correct_left.close();
      player_hyp_correct_right.close();
      player_hyp_wrong_left.close();
      player_hyp_wrong_right.close();
      
      player_hyp_wrong_right = minim.loadFile("audio/hypothesis_wrong_right.wav", 2048);
        
      player_hyp_wrong_right.play();
      }
      
      entered_pred_left = false;
      entered_pred_intro =false;
      entered_pred_same = false;
      entered_pred_right = false;
      entered_hyp_correct_left = false;
      entered_hyp_correct_right = false;
      entered_hyp_wrong_left = false;
      entered_hyp_wrong_right = true;
    }
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
  if (fr==1){
    displayText(t_expl_correct_taller);
    
    if (entered_expl_correct_taller == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
      player_hyp_correct_left.close();
      player_hyp_correct_right.close();
      player_hyp_wrong_left.close();
      player_hyp_wrong_right.close();
      player_expl_correct_taller.close();
      
      player_expl_correct_taller = minim.loadFile("audio/expl_correct_taller.wav", 2048);
        
      player_expl_correct_taller.play();
      }
      
      entered_pred_left = false;
      entered_pred_intro =false;
      entered_pred_same = false;
      entered_pred_right = false;
      entered_hyp_correct_left = false;
      entered_hyp_correct_right = false;
      entered_hyp_wrong_left = false;
      entered_hyp_wrong_right = false;
      entered_expl_correct_taller = true;
  }
  else if (fr==2){
    displayText(t_expl_correct_thinner);
    
    if (entered_expl_correct_thinner == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
      player_hyp_correct_left.close();
      player_hyp_correct_right.close();
      player_hyp_wrong_left.close();
      player_hyp_wrong_right.close();
      player_expl_correct_taller.close();
      player_expl_correct_thinner.close();
      
      player_expl_correct_thinner = minim.loadFile("audio/expl_correct_thinner.wav", 2048);
        
      player_expl_correct_thinner.play();
      }
      
      entered_pred_left = false;
      entered_pred_intro =false;
      entered_pred_same = false;
      entered_pred_right = false;
      entered_hyp_correct_left = false;
      entered_hyp_correct_right = false;
      entered_hyp_wrong_left = false;
      entered_hyp_wrong_right = false;
      entered_expl_correct_taller = false;
      entered_expl_correct_thinner = true;
  }
  else if (fr==3){
    displayText(t_expl_correct_weight);
    
    if (entered_expl_correct_weight == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
      player_hyp_correct_left.close();
      player_hyp_correct_right.close();
      player_hyp_wrong_left.close();
      player_hyp_wrong_right.close();
      player_expl_correct_taller.close();
      player_expl_correct_thinner.close();
      player_expl_correct_weight.close();
      
      player_expl_correct_weight = minim.loadFile("audio/expl_correct_weight.wav", 2048);
        
      player_expl_correct_weight.play();
      }
      
      entered_pred_left = false;
      entered_pred_intro =false;
      entered_pred_same = false;
      entered_pred_right = false;
      entered_hyp_correct_left = false;
      entered_hyp_correct_right = false;
      entered_hyp_wrong_left = false;
      entered_hyp_wrong_right = false;
      entered_expl_correct_taller = false;
      entered_expl_correct_thinner = false;
      entered_expl_correct_weight = true;
  }
  else if (fr==4){
    displayText(t_expl_correct_symm);
    
    if (entered_expl_correct_symm == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
      player_hyp_correct_left.close();
      player_hyp_correct_right.close();
      player_hyp_wrong_left.close();
      player_hyp_wrong_right.close();
      player_expl_correct_taller.close();
      player_expl_correct_thinner.close();
      player_expl_correct_weight.close();
      player_expl_correct_symm.close();
      
      player_expl_correct_symm = minim.loadFile("audio/expl_correct_symm.wav", 2048);
        
      player_expl_correct_symm.play();
      }
      
      entered_pred_left = false;
      entered_pred_intro =false;
      entered_pred_same = false;
      entered_pred_right = false;
      entered_hyp_correct_left = false;
      entered_hyp_correct_right = false;
      entered_hyp_wrong_left = false;
      entered_hyp_wrong_right = false;
      entered_expl_correct_taller = false;
      entered_expl_correct_thinner = false;
      entered_expl_correct_weight = false;
      entered_expl_correct_symm = true;
  }
}

void fallen_wrong(int fr)
{
  if (fr==1){
    displayText(t_expl_wrong_taller);
    
    if (entered_expl_wrong_taller == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
      player_hyp_correct_left.close();
      player_hyp_correct_right.close();
      player_hyp_wrong_left.close();
      player_hyp_wrong_right.close();
      player_expl_correct_taller.close();
      player_expl_correct_thinner.close();
      player_expl_correct_weight.close();
      player_expl_correct_symm.close();
      player_expl_wrong_taller.close();
      
      player_expl_wrong_taller = minim.loadFile("audio/expl_wrong_taller.wav", 2048);
        
      player_expl_wrong_taller.play();
      }
      
      entered_pred_left = false;
      entered_pred_intro =false;
      entered_pred_same = false;
      entered_pred_right = false;
      entered_hyp_correct_left = false;
      entered_hyp_correct_right = false;
      entered_hyp_wrong_left = false;
      entered_hyp_wrong_right = false;
      entered_expl_correct_taller = false;
      entered_expl_correct_thinner = false;
      entered_expl_correct_weight = false;
      entered_expl_correct_symm = false;
      entered_expl_wrong_taller = true;
  }
  else if (fr==2){
    displayText(t_expl_wrong_thinner);
    
    if (entered_expl_wrong_thinner == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
      player_hyp_correct_left.close();
      player_hyp_correct_right.close();
      player_hyp_wrong_left.close();
      player_hyp_wrong_right.close();
      player_expl_correct_taller.close();
      player_expl_correct_thinner.close();
      player_expl_correct_weight.close();
      player_expl_correct_symm.close();
      player_expl_wrong_thinner.close();
      
      player_expl_wrong_thinner = minim.loadFile("audio/expl_wrong_thinner.wav", 2048);
        
      player_expl_wrong_thinner.play();
      }
      
      entered_pred_left = false;
      entered_pred_intro =false;
      entered_pred_same = false;
      entered_pred_right = false;
      entered_hyp_correct_left = false;
      entered_hyp_correct_right = false;
      entered_hyp_wrong_left = false;
      entered_hyp_wrong_right = false;
      entered_expl_correct_taller = false;
      entered_expl_correct_thinner = false;
      entered_expl_correct_weight = false;
      entered_expl_correct_symm = false;
      entered_expl_wrong_thinner = true;
  }
  else if (fr==3){
    displayText(t_expl_wrong_weight);
    
    if (entered_expl_wrong_weight == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
      player_hyp_correct_left.close();
      player_hyp_correct_right.close();
      player_hyp_wrong_left.close();
      player_hyp_wrong_right.close();
      player_expl_correct_taller.close();
      player_expl_correct_thinner.close();
      player_expl_correct_weight.close();
      player_expl_correct_symm.close();
      player_expl_wrong_weight.close();
      
      player_expl_wrong_weight = minim.loadFile("audio/expl_wrong_weight.wav", 2048);
        
      player_expl_wrong_weight.play();
      }
      
      entered_pred_left = false;
      entered_pred_intro =false;
      entered_pred_same = false;
      entered_pred_right = false;
      entered_hyp_correct_left = false;
      entered_hyp_correct_right = false;
      entered_hyp_wrong_left = false;
      entered_hyp_wrong_right = false;
      entered_expl_correct_taller = false;
      entered_expl_correct_thinner = false;
      entered_expl_correct_weight = false;
      entered_expl_correct_symm = false;
      entered_expl_wrong_weight = true;
  }
  else if (fr==4){
    displayText(t_expl_wrong_symm);
    
    if (entered_expl_wrong_symm == false) {
      player_place_both.close();
      player_place_left.close();
      player_place_right.close();
      player_place_continue.close();
      player_pred_intro.close();
      player_pred_left.close();
      player_pred_right.close();
      player_pred_same.close();
      player_hyp_correct_left.close();
      player_hyp_correct_right.close();
      player_hyp_wrong_left.close();
      player_hyp_wrong_right.close();
      player_expl_correct_taller.close();
      player_expl_correct_thinner.close();
      player_expl_correct_weight.close();
      player_expl_correct_symm.close();
      player_expl_wrong_symm.close();
      
      player_expl_wrong_symm = minim.loadFile("audio/expl_wrong_symm.wav", 2048);
        
      player_expl_wrong_symm.play();
      }
      
      entered_pred_left = false;
      entered_pred_intro =false;
      entered_pred_same = false;
      entered_pred_right = false;
      entered_hyp_correct_left = false;
      entered_hyp_correct_right = false;
      entered_hyp_wrong_left = false;
      entered_hyp_wrong_right = false;
      entered_expl_correct_taller = false;
      entered_expl_correct_thinner = false;
      entered_expl_correct_weight = false;
      entered_expl_correct_symm = false;
      entered_expl_wrong_symm = true;
  }
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


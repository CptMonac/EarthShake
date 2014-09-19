//ayo
ControlGroup messageBox;
ControlP5 guiController;
boolean shakeVisible, timerVisible;
PImage timerImage;
int debounceCount = 0;
boolean gameStarted, shakeStarted, buttonPressed, rulerComparison;
PImage startScreen, timerControl, shakeScreen;
PImage towerFallen, towerStanding, rulerMatchScreen;
Contour towerInitial;
PImage countdown;

float startTime, elapsedTime, stopTime, finishTime;
float rulerHeight = 45;

void setupgame2()
{
  //// AYO STUFF
  
//  //Enable all kinect cameras/sensors
//    setupKinect();
//
    //Initialize lego towers
    setupTowers();

    //Initialize GUI
    initializeGUI();
    initializeGame();
    
    image(startScreen, 0, 0);
    //drawgame2();
}

void initializeGame()
{
  gameStarted = false;
  shakeStarted = false;  
  buttonPressed = false;
  rulerComparison = false;
  towerInitial = null;
  startTime = 0.0;
  elapsedTime = 0.0;
  stopTime = 0.0;
  finishTime = 0.0;
  
  guiController.controller("shake").hide();
  guiController.controller("tryagain").hide();
  guiController.controller("continueTower").hide();
}

void initializeGUI()
{
  //Load assets
  startScreen = loadImage("images/startScreen.jpg");
  timerControl = loadImage("images/timer.png");
  shakeScreen = loadImage("images/shakeScreen.jpg");
  countdown = loadImage("images/countdownScreen.jpg");
  towerFallen = loadImage("images/towerFallen.jpg");
  towerStanding = loadImage("images/towerStanding.jpg");
  rulerMatchScreen = loadImage("images/rulerScreen.jpg");
  PImage[] shakeIcon = {loadImage("images/shake.png"), loadImage("images/shake_hover.png"), loadImage("images/shake.png")};
  PImage[] continueIcon = {loadImage("images/continue.png"), loadImage("images/continue_hover.png"), loadImage("images/continue.png")};
  
  //Create GUI instance
  float btnPositionX = 9*gorWidth/16;
  float btnPositionY = 13*gorHeight/16 + 15;
  guiController = new ControlP5(this);

  guiController.addButton("shake")
           .setValue(128)
           .setPosition(btnPositionX, btnPositionY)
           .setImages(shakeIcon)
           .updateSize();
  guiController.controller("shake").hide();

  guiController.addButton("tryagain")
            .setValue(128)
            .setPosition(btnPositionX, btnPositionY)
            .setImages(continueIcon)
            .updateSize();
  guiController.controller("tryagain").hide();

  guiController.addButton("continueTower")
            .setValue(128)
            .setPosition(btnPositionX, btnPositionY)
            .setImages(continueIcon)
            .updateSize();
  guiController.controller("continueTower").hide();  
  
  
}

void drawgame2()
{
  /*
  context.update();
  cleanKinectInput();

  opencv = new OpenCV(this, context.depthImage());
  opencv.gray();
  opencv.threshold(70);
  */
  legoTowers = extractLegoTowers_game2();
  
  if (gameStarted && rulerComparison && singleTowerCheck())
  {
    //Display prompt and comparison ruler
    image(rulerMatchScreen, 0, 0);
    fill(200,200,0);
    rect(130, -75, 15, rulerHeight);
    
    //Extract lego tower
    Contour tempContour = legoTowers.get(0);
    float contourHeight = tempContour.getBoundingBox().height;
    if (contourHeight >= rulerHeight)
    {
      stroke(10, 240, 10);
      strokeWeight(4);
      noFill();
      
      drawContour(tempContour); 
      guiController.controller("shake").setVisible(true);
    }
    else 
    {
      stroke(240, 10, 10);
      strokeWeight(4);
      noFill();
      drawContour(tempContour);

      textSize(15);
      fill(240, 10, 10);
      text("Your tower's not quite tall enough yet.", 380, 350);
      guiController.controller("shake").hide();
    }
  }
  else if (gameStarted && singleTowerCheck() && shakeStarted)
  {
    elapsedTime = millis();
    float timeDiff = (elapsedTime - startTime)/1000;
    image(countdown, 0, 0);
    textSize(25);

    if (towerInitial == null)
      towerInitial = legoTowers.get(0);

    Contour tempContour = legoTowers.get(0);
    float contourDifference = (tempContour.getBoundingBox().height - towerInitial.getBoundingBox().height);
    println("Contour diff:"+contourDifference);

    if (contourDifference < -20)
    {
      if (stopTime == 0.0)
        stopTime = millis();
      
      float elapsedStopTime = (stopTime - startTime)/1000;
      image(towerFallen, 0, 0);
      fill(255, 140, 140);
      stroke(255, 0, 0);
      strokeWeight(3);
      drawContour(legoTowers);
      fill(255,255,255);
      textSize(20);
      String timeDiffString = "Your tower fell in:"+ String.format("%.2f", elapsedStopTime) + " seconds";
      text(timeDiffString, 250, 95);
      guiController.controller("tryagain").setVisible(true); 
    }
    else if (timeDiff >= 10.0)
    {
      if (finishTime == 0.0)
          finishTime = millis();

      float elapsedStopTime = (finishTime - startTime)/1000; 
      image(towerStanding, 0, 0);
      fill(140, 255, 140);   
      stroke(0, 255, 0);
      strokeWeight(3);
      drawContour(tempContour);
      fill(255,255,255);
      textSize(20);
      guiController.controller("continueTower").setVisible(true);
    }
    else 
    {
      fill(140, 255, 140);   
      stroke(0, 255, 0);
      strokeWeight(3);
      drawContour(tempContour);
      fill(100,100,100);
      textSize(15);
      String timeDiffString = String.format("%.2f", timeDiff) + " seconds";
      translate(-280,0);
      text(timeDiffString, 610, 200);
    }
  }
  else if (gameStarted && singleTowerCheck() && !shakeStarted)
  {
    image(startScreen, 0, 0);
    Contour tempContour = legoTowers.get(0);
    fill(140, 255, 140);   
    stroke(0, 255, 0);
    strokeWeight(3);
    drawContour(tempContour);
    guiController.controller("shake").setVisible(true); 
  }
  else
  {
    //image(startScreen, 0, 0);
    if (singleTowerCheck())
      gameStarted = true;  
    else if (legoTowers.size() == 0)
    {
      gameStarted = false;
      textSize(15);
      fill(204, 10, 10);
      if (!shakeStarted)
       { text("Place a tower on the table", 380, 350);}
      guiController.controller("shake").hide();
    }
    else if (legoTowers.size() > 1)
    {
      gameStarted = false;
      textSize(15);
      fill(204, 10, 10);
      if (!shakeStarted)
      {  text("Place only one tower on the table", 380, 350);}
      guiController.controller("shake").hide();
    }  
  }
}

void drawContour(Contour inputContour)
{
  //pushMatrix();
    translate(200, -75);
    inputContour.draw();
    
    beginShape();
        for (PVector point : inputContour.getPolygonApproximation().getPoints())
        {
          vertex(point.x, point.y);
        }
        endShape();
  //popMatrix();
}

void drawContour(ArrayList<Contour> inputContours)
{
  for (int i=0; i<inputContours.size(); i++)
  {
//    pushMatrix();
      translate(200, -75);
      inputContours.get(i).draw(); 
      beginShape();
        for (PVector point : inputContours.get(i).getPolygonApproximation().getPoints())
        {
          vertex(point.x, point.y);
        }
        endShape();
//    popMatrix();
  }
}

void mouseClicked()
{
  buttonPressed = true;
}

void setupKinect()
{
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
   println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
   exit();
   return;  
  }
  //Enable all kinect cameras/sensors
  context.enableDepth();
  context.enableUser();
  context.enableRGB();
  //Calibrate depth and rgb cameras
  context.alternativeViewPointDepthToImage(); 

  //Initialize image variable
  srcImage = context.depthImage();
  //Initialize openCv
  opencv = new OpenCV(this, srcImage);
  //Initialize screen size
  size(srcImage.width, srcImage.height);
}

void setupTowers()
{
  //Extract lego towers in the current scene
  legoTowers = extractLegoTowers();
  contourDBList = legoTowers;

  //Build lego database
  //buildLegoDatabase();
}

//public void shake()
//{
//  debounceCount++;
//  if (shakeVisible && debounceCount > 1)
//  {
//    controlP5.hide();
//    println("Timer activated!");
//    timerVisible = true;  
//    startTime = millis();
//  }
//}

public void shake()
{
  if (buttonPressed)
  {
    shakeStarted = true;
    guiController.controller("shake").hide();
    println("Timer activated!");  
    startTime = millis();
    guiController.controller("shake").hide();
    buttonPressed = false;
  }
  draw();
}

public void tryagain()
{
  if (buttonPressed)
  {
    initializeGame();
  }
}

public void continueTower()
{
  if (buttonPressed)
  {
    rulerComparison = true;
    initializeGame();
  }
}


ArrayList<Contour> buildLegoDatabase()
{
  String imagePath = sketchPath + "/bw/";
  println(imagePath);
  File imageFolder = new File(imagePath);
  File[] imageArray = imageFolder.listFiles();
  ArrayList<Contour> legoDatabase = new ArrayList<Contour>();

  //Loop through all images in directory and create lego contours 
  for(int i =0; i<imageArray.length; i++)
  {
    PImage towerImage = loadImage(imageArray[i].getAbsolutePath());
    opencv = new OpenCV(this, towerImage);
    opencv.gray();
    opencv.threshold(70);
    legoDatabase.addAll(extractLegoTowers());
  }
        opencv = new OpenCV(this, context.depthImage());

  return legoDatabase;
}

boolean singleTowerCheck()
{
  println(legoTowers.size());
  
  if (legoTowers.size() > 1)
  {
  
    return false;
  }
  else if (legoTowers.size() == 1)
  {
    //messageBox.hide();
    return true;
  }
         else
         {
           return false;
         }
}

ArrayList<Contour> extractLegoTowers_game2()
{
  //Find all contours in input image
  ArrayList<Contour> towerContours = opencv.findContours();
  ArrayList<Contour> filteredContours = new ArrayList<Contour>();
  
  //translate(-780,0);
  
  //Filter contours to only lego towers
  for (Contour contour: towerContours)
  {
    if(contour.area() > 1500)
    {
      filteredContours.add(contour);
    }
  }
  
  //translate(780,0);
  
  return filteredContours;
}


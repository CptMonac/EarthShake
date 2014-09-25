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
  float btnPositionX = 9*width/16;
  float btnPositionY = 13*height/16 + 15;
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

public void shake()
{
  debounceCount++;
  if (shakeVisible && debounceCount > 1)
  {
    controlP5.hide();
    println("Timer activated!");
    timerVisible = true;  
    startTime = millis();
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
    messageBox.hide();
    return true;
  }
         else
         {
           return false;
         }
}


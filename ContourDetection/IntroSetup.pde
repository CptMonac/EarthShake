import gab.opencv.*;
import SimpleOpenNI.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.CvType;
import org.opencv.core.MatOfPoint;
import org.opencv.imgproc.Imgproc;
import java.awt.Rectangle;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import javax.swing.*;
import ddf.minim.*;

AudioPlayer player;
Minim minim;//audio context
/*** VARIABLES start *******************************************/
OpenCV opencv;
PImage srcImage, srcImage2, editedImage, colorImage, screen1, mainmenu, circle;
SimpleOpenNI  context;

ArrayList<Contour> legoTowers;
ArrayList<Rectangle> originalBoundingBoxes;
PImage A1, A1_left, A1_right, A2, A2_left, A2_right;
PImage B1, B1_left, B1_right, B2, B2_left, B2_right;
PImage C1, C1_left, C1_right, C2, C2_left, C2_right;
PImage D1, D1_left, D1_right, D2, D2_left, D2_right;
PImage E1, E1_left, E1_right, E2, E2_left, E2_right;
PImage F1, F1_left, F1_right, F2, F2_left, F2_right;
PImage G1, G1_left, G1_right, G2, G2_left, G2_right;
PImage M1, M1_left, M1_right, M2, M2_left, M2_right;
PImage M3, M3_left, M3_right, M4, M4_left, M4_right;
PImage towerx, towerx_left, towerx_right, start; 

ArrayList<PImage> PImgArray;
ArrayList<Contour> contourDBList;
ArrayList<String> pImgNames;
String[] currentTowerColors;
ArrayList<String> towerColors;

int gorWidth = 780;
int gorHeight = 500;
int legoWidth = 640;
int legoHeight = 480;

float scaleFactorx = 0.45; // 640/(640+780)
float scaleFactory = 0.96; // 480/(480+500)

ImagePanel view2;
PImage viewport2 = new PImage(780,500,RGB);

/*** VARIABLES end *********************************************/


void setKinectElements() 
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
}

void setup()
{
  setKinectElements();
  
  //Initialize image variable
  srcImage = context.depthImage();
  //Initialize openCv
  opencv = new OpenCV(this, srcImage);

  //Setup screen elements
  size(640+780, 480+20);
  //size(640+780, 480+20, P3D);
  
  legoTowers = new ArrayList<Contour>();
  originalBoundingBoxes = new ArrayList<Rectangle>();
  
  PImgArray = createPImageArray(); 
  contourDBList = createContourDatabase(PImgArray);
  println("sizeof pimgarray = "+PImgArray.size());
  println("sizeof contourDBList = "+contourDBList.size()); 
  pImgNames = loadPImgStrings();
  
  screen1 = loadImage("gorilla.jpg");
  mainmenu = loadImage("mainmenu.jpg");
  wrongTower = loadImage("wrongtower.png");
  correctTower = loadImage("correctTower.png");
  //startScreen = screen1;
  pretzel = loadImage("pretzel.png");
  circle = loadImage("placementcircle.png");
  
  loadColorTowers();
  loadButtons(); 
  loadText();
  
  resetVariables();
  scene1 = true;
  scene2 = false;
  playgame1 = false;
  playgame2 = false;
  //initMatchVariables();
  
  frame.setSize(780,500);
  frame.setTitle("gorilla window");

  view2 = new ImagePanel((BufferedImage)viewport2.getNative());
  JFrame v2 = new JFrame("debug window");
  v2.setSize(640,480);
  v2.add(view2);
  v2.show();  
  
//  scenarioNumber = int(random(1,6));
//  loadScenario(scenarioNumber);
  initTowerPairOrder();
  generateNewSet();
  
  //AYO
    //Initialize lego towers
    setupTowers();

    //Initialize GUI
    initializeGUI();
    initializeGame();
  
  /*
  //adding sound 
  minim = new Minim(this);
  player = minim.loadFile("Scenario1_1.mp3", 2048);
  player.play();
  */
  
}



void draw()
{
  //Update camera image
  context.update();     
  
  PImage depthImage = context.depthImage();
  colorTower = new PImage(640,480);
    
  //Clean the input image
  cleanKinectInput();
  srcImage = context.depthImage();
  opencv = new OpenCV(this, srcImage);
  opencv.gray();
  opencv.threshold(70);
 
  pushMatrix();
    translate(780, 0);
    image(context.depthImage(),0,0);
    editedImage = opencv.getOutput();
    trackLegoTowers();
    imageComparison(); 
  popMatrix();
 
  pushMatrix();
    translate(0, 0);
    
    //TURN MAINMENU OFF TO SEE DEBUG COLORS (1/3)
    image(mainmenu, 0, 0);
    
    if (playgame1==false && playgame2==false) {
      game_buttons();
    }
    
    if (playgame2==true) {
      
      //TURN SCREEN1 OFF TO SEE DEBUG COLORS (2/3)
      image(screen1, 0, 0);
      
      gameStarted = true;
      drawgame2();
    }
    
    else if (playgame1==true) {
//      if (scene2==false)
//        continue_button();

      //TURN SCREEN1 OFF TO SEE DEBUG COLORS (3/3)
      image(screen1, 0, 0);
      
      if (scene2==true) {
        placingTowers = false;
        trackLegoTowers_g2();
      }
      if (scene3==true) {
        if (scene3a==true)
          prediction_intro();
        if (scene3b==true)
          prediction_discusschoice();
        if (explain==false)
          drawLegoContours_g();
          //drawLegoContours_static();
      }
      if (scene4==true)
        guess_message();
      if (scene5==true)
        expl_result();
      if (scene6==true)
        newRoundOfTowers();
    }

  popMatrix();
  
  viewport2 = get(780,20,640,480);
  view2.setImage((BufferedImage)viewport2.getNative());   
}


void loadPImages()
{
  A1 = loadImage("bw/A1_b.png");
  A1_left = loadImage("bw/A1_left.png");
  A1_right = loadImage("bw/A1_right.png");
  A2 = loadImage("bw/A2_b.png");
  A2_left = loadImage("bw/A2_left.png");
  A2_right = loadImage("bw/A2_right.png");
  B1 = loadImage("bw/B1_b.png");
  B1_left = loadImage("bw/B1_left.png");
  B1_right = loadImage("bw/B1_right.png");
  B2 = loadImage("bw/B2_b.png");
  B2_left = loadImage("bw/B2_left.png");
  B2_right = loadImage("bw/B2_right.png");
  C1 = loadImage("bw/C1.png");
  C1_left = loadImage("bw/C1_left.png");
  C1_right = loadImage("bw/C1_right.png");
  C2 = loadImage("bw/C2.png");
  C2_left = loadImage("bw/C2_left.png");
  C2_right = loadImage("bw/C2_right.png");
  D1 = loadImage("bw/D1_b.png");
  D1_left = loadImage("bw/D1_left.png");
  D1_right = loadImage("bw/D1_right.png");
  D2 = loadImage("bw/D2_b.png");
  D2_left = loadImage("bw/D2_left.png");
  D2_right = loadImage("bw/D2_right.png");
  E1 = loadImage("bw/E1_b.png");
  E1_left = loadImage("bw/E1_left.png");
  E1_right = loadImage("bw/E1_right.png");  
  E2 = loadImage("bw/E2_b.png");
  E2_left = loadImage("bw/E2_left.png");
  E2_right = loadImage("bw/E2_right.png"); 
  F1 = loadImage("bw/F1.png");
  F1_left = loadImage("bw/F1_left.png");
  F1_right = loadImage("bw/F1_right.png"); 
  F2 = loadImage("bw/F2_b.png");
  F2_left = loadImage("bw/F2_left.png");
  F2_right = loadImage("bw/F2_right.png"); 
  G1 = loadImage("bw/G1_b.png");
  G1_left = loadImage("bw/G1_left.png");
  G1_right = loadImage("bw/G1_right.png"); 
  //G2 = loadImage("G2_b.png");
  M1 = loadImage("bw/M1_b.png");
  M1_left = loadImage("bw/M1_left.png");
  M1_right = loadImage("bw/M1_right.png"); 
  M2 = loadImage("bw/M2_b.png");
  M2_left = loadImage("bw/M2_left.png");
  M2_right = loadImage("bw/M2_right.png"); 
  M3 = loadImage("bw/M3_b.png");
  M3_left = loadImage("bw/M3_left.png");
  M3_right = loadImage("bw/M3_right.png"); 
  M4 = loadImage("bw/M4_b.png"); 
  M4_left = loadImage("bw/M4_left.png");
  M4_right = loadImage("bw/M4_right.png"); 
  towerx = loadImage("bw/x_b.png");  
  towerx_left = loadImage("bw/x_left.png"); 
  towerx_right = loadImage("bw/x_right.png"); 
  start = loadImage("bw/start.png");
}

ArrayList<PImage> createPImageArray()
{
  ArrayList<PImage> database = new ArrayList<PImage>();
  loadPImages();
  database.add(A1);  
  database.add(A1_left);
  database.add(A1_right);
  database.add(A2);  
  database.add(A2_left);
  database.add(A2_right);
  database.add(B1);  
  database.add(B1_left);
  database.add(B1_right);
  database.add(B2); 
  database.add(B2_left);
  database.add(B2_right);
  database.add(C1); 
  database.add(C1_left);
  database.add(C1_right); 
  database.add(C2);   
  database.add(C2_left);
  database.add(C2_right); 
  database.add(D1);  
  database.add(D1_left);
  database.add(D1_right); 
  database.add(D2); 
  database.add(D2_left);
  database.add(D2_right); 
  database.add(E1);  
  database.add(E1_left);
  database.add(E1_right);
  database.add(E2); 
  database.add(E2_left);
  database.add(E2_right);
  database.add(F1);  
  database.add(F1_left);
  database.add(F1_right);
  database.add(F2);
  database.add(F2_left);
  database.add(F2_right);
  database.add(G1);  
  database.add(G1_left);
  database.add(G1_right);
  //database.add(G2);
  database.add(M1); 
  database.add(M1_left);
  database.add(M1_right);  
  database.add(M2);
  database.add(M2_left);
  database.add(M2_right);
  database.add(M3);  
  database.add(M3_left);
  database.add(M3_right);
  database.add(M4);
  database.add(M4_left);
  database.add(M4_right);
  database.add(towerx);
  database.add(towerx_left);
  database.add(towerx_right);
  database.add(start);
  return database;
}

ArrayList<String> loadPImgStrings()
{
  ArrayList<String> pImgNames = new ArrayList<String>();
  pImgNames.add("A1");
  pImgNames.add("A1");
  pImgNames.add("A1");
  pImgNames.add("A2");
  pImgNames.add("A2");
  pImgNames.add("A2");
  pImgNames.add("B1");
  pImgNames.add("B1");
  pImgNames.add("B1");
  pImgNames.add("B2");
  pImgNames.add("B2");
  pImgNames.add("B2"); 
  pImgNames.add("C1"); 
  pImgNames.add("C1");
  pImgNames.add("C1");
  pImgNames.add("C2");
  pImgNames.add("C2");
  pImgNames.add("C2");
  pImgNames.add("D1");
  pImgNames.add("D1");
  pImgNames.add("D1"); 
  pImgNames.add("D2");
  pImgNames.add("D2");
  pImgNames.add("D2");
  pImgNames.add("E1");
  pImgNames.add("E1");
  pImgNames.add("E1"); 
  pImgNames.add("E2");
  pImgNames.add("E2");
  pImgNames.add("E2");
  pImgNames.add("F1");
  pImgNames.add("F1");
  pImgNames.add("F1"); 
  pImgNames.add("F2");
  pImgNames.add("F2");
  pImgNames.add("F2");
  pImgNames.add("G1");
  pImgNames.add("G1");
  pImgNames.add("G1"); 
  pImgNames.add("M1");
  pImgNames.add("M1");
  pImgNames.add("M1");
  pImgNames.add("M2");
  pImgNames.add("M2");
  pImgNames.add("M2"); 
  pImgNames.add("M3");
  pImgNames.add("M3");
  pImgNames.add("M3");
  pImgNames.add("M4");
  pImgNames.add("M4");
  pImgNames.add("M4"); 
  pImgNames.add("X");
  pImgNames.add("X");
  pImgNames.add("X");
  pImgNames.add("start");
  return pImgNames;                               
}

ArrayList<String> loadTowerColors() 
{
  ArrayList<String> towerColors = new ArrayList<String>();
  towerColors.add("RYGB"); //A1
  towerColors.add("RYGB"); //A1
  towerColors.add("RYGB"); //A1
  towerColors.add("RYBG"); //A2
  towerColors.add("RYBG"); //A2
  towerColors.add("RYBG"); //A2
  towerColors.add("YRGB"); //B1
  towerColors.add("YRGB"); //B1
  towerColors.add("YRGB"); //B1
  towerColors.add("rGRYB"); //B2
  towerColors.add("rGRYB"); //B2
  towerColors.add("rGRYB"); //B2
  towerColors.add("RGYB"); //C1
  towerColors.add("RGYB"); //C1
  towerColors.add("RGYB"); //C1
  towerColors.add("RYGB"); //C2
  towerColors.add("RYGB"); //C2
  towerColors.add("RYGB"); //C2
  towerColors.add("YRBG"); //D1
  towerColors.add("YRBG"); //D1
  towerColors.add("YRBG"); //D1
  towerColors.add("BYGR"); //D2
  towerColors.add("BYGR"); //D2
  towerColors.add("BYGR"); //D2
  towerColors.add("YrBRG"); //E1
  towerColors.add("YrBRG"); //E1
  towerColors.add("YrBRG"); //E1
  towerColors.add("rYRG"); //E2
  towerColors.add("BrYRG"); //E2
  towerColors.add("yBrYRG"); //E2
  towerColors.add("GYR"); //F1
  towerColors.add("gBGYR"); //F1
  towerColors.add("BGYR"); //F1
  towerColors.add("gBGRY"); //F2
  towerColors.add("GRY"); //F2
  towerColors.add("BGRY"); //F2
  towerColors.add("YGRB"); //G1
  towerColors.add("YGRB"); //G1
  towerColors.add("YGRB"); //G1
  towerColors.add("YGBR"); //M1
  towerColors.add("YGBR"); //M1
  towerColors.add("YGBR"); //M1
  towerColors.add("BYRG"); //M2
  towerColors.add("BYRG"); //M2
  towerColors.add("BYRG"); //M2
  towerColors.add("GYRB"); //M3
  towerColors.add("GYRB"); //M3
  towerColors.add("GYRB"); //M3
  towerColors.add("yBYRG"); //M4
  towerColors.add("yBYRG"); //M4
  towerColors.add("yBYRG"); //M4
  towerColors.add("GYBR"); //X
  towerColors.add("yGYBR"); //X
  towerColors.add("GYBR"); //X
  towerColors.add(":)"); //start
  return towerColors;
}

ArrayList<Contour> createContourDatabase(ArrayList<PImage> PImgArray)
{
  ArrayList<Contour> newContours = new ArrayList<Contour>();
  ArrayList<Contour> contourDB = new ArrayList<Contour>();
  
  println("in create contour "+PImgArray.size());  
  for (PImage srcImage: PImgArray)
  {
    opencv = new OpenCV(this, srcImage);
    opencv.gray();
    opencv.threshold(70);    
    newContours = extractLegoTowers();
    //for (Contour contour: newContours)
    for (int a = 0; a<newContours.size(); a++)
    {
      contourDB.add(newContours.get(a));
    }
  }
  return contourDB;
}

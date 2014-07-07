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
import controlP5.*;


OpenCV opencv;
PImage srcImage, editedImage,colorImage;
SimpleOpenNI  context;
ControlP5 controlP5;
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

void setup()
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

  //Setup screen elements
  size(srcImage.width, srcImage.height);
  legoTowers = new ArrayList<Contour>();
  originalBoundingBoxes = new ArrayList<Rectangle>();
  
  PImgArray = createPImageArray(); 
  contourDBList = createContourDatabase(PImgArray);
  println("sizeof pimgarray = "+PImgArray.size());
  println("sizeof contourDBList = "+contourDBList.size()); 
  pImgNames = loadPImgStrings();
  
}

void draw()
{
  //Update camera image
  context.update();     

  PImage depthImage = context.depthImage();
  colorTower = new PImage(depthImage.getImage());
  
  //Clean the input image
  cleanKinectInput();
  srcImage = context.depthImage();
  opencv = new OpenCV(this, srcImage);
  opencv.gray();
  opencv.threshold(70);
  
  image(context.depthImage(),0,0);
  editedImage = opencv.getOutput();

  //Find lego towers
  imageComparison();
  trackLegoTowers();
  
  
}

void cleanKinectInput()
{
  int[] inputDepthMap = context.depthMap();
  context.depthImage().loadPixels();

  //Remove erroneous pixels
  for (int i=0; i<context.depthMapSize();i++)
  {
    if (inputDepthMap[i] == 0)  //Error depth map value
      context.depthImage().pixels[i] = color(0,0,0);

    if ((inputDepthMap[i]< 600) || (inputDepthMap[i] > 1000)) //Irrelevant depths
      context.depthImage().pixels[i] = color(0,0,0);

    else if ((inputDepthMap[i] > 400) && (inputDepthMap[i] < 1000))
      colorTower.pixels[i] = context.rgbImage().pixels[i];
  }
}

void imageComparison() 
{
  pushMatrix();
  scale(0.5);
  image(colorTower, 0, 0);
  
  theBlobDetection = new BlobDetection(srcImage.width, srcImage.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.38f);
  theBlobDetection.computeBlobs(srcImage.pixels);
  currentTowerColors = blobDebugMode(); 
  
  popMatrix();
  fill(204,0,0);
}

void trackLegoTowers()
{
  Contour tempContour, originalContour;
  ArrayList<Contour> filteredContours;

  legoTowers = extractLegoTowers();
  for (Contour contour: legoTowers)
  {
    originalBoundingBoxes.add(contour.getBoundingBox());
  }

  if (legoTowers.size() > 0)
  {
    filteredContours = extractLegoTowers();

    Boolean leftDown = false;
    Boolean rightDown = false;
    Boolean hasLeft = false;
    Boolean hasRight = false;
    Boolean leftStanding = false;
    Boolean rightStanding = false;

      ArrayList<Rectangle> currentBoundingBoxes = new ArrayList<Rectangle>();
      ArrayList<String> noteArray = new ArrayList<String>();
      
      for(int j=0; j<filteredContours.size(); j++)
      {
        //leftDown = false;
        //rightDown = false;
        
        tempContour = filteredContours.get(j);
        Rectangle tempBoundingBox = tempContour.getBoundingBox();
        currentBoundingBoxes.add(tempBoundingBox);
        
        int currentx = currentBoundingBoxes.get(j).x;
        int currenty = currentBoundingBoxes.get(j).y;
        
        if (currentx < srcImage.width/2) {
          hasLeft = true;
          if (currenty > 50)
            leftStanding = true;
        }
        if (currentx > srcImage.width/2) {
          hasRight = true;
          if (currenty > 50) {
            rightStanding = true;
          }
        }
        
        if ((filteredContours.size() <= 2) && (currentTowerColors.length==filteredContours.size())) {
          
          noteArray.add(getBestTowerMatch(tempContour, currentTowerColors[j]));    
          String note = getBestTowerMatch(tempContour, currentTowerColors[j]);
              
          text(noteArray.get(j), 400, 50+(50*j));
          text(currentBoundingBoxes.get(j).height, 400, 75+(50*j));
          
          //if (originalBoundingBoxes.get(j).height - currentBoundingBoxes.get(j).height > 40)
          if (currentBoundingBoxes.get(j).height < 50) 
          {
            if (filteredContours.size()==1) 
            {
              if (hasLeft==true)
                leftDown = true;
              else if (hasRight==true)
                rightDown = true;
            }
            else if ((j==0) && (note!="Unknown Tower") && (hasRight==true))
              rightDown = true;
            else if ((j==0) && (note=="Unknown Tower") && (hasLeft==true))
              leftDown = true;
            else if (j==1)
              rightDown = true;
          }
        }
      }
      
      if (leftDown==true)
        text("Fallen", 167, 320);
      if (rightDown==true)
        text("Fallen", 400, 320);
        
      if (leftStanding==true)
        text("LEFT STANDING", 167, 270);
      if (rightStanding==true)
        text("RIGHT STANDING", 400, 270);
        
      if (noteArray.size()==1) 
      {
        if ((leftDown==false) && (hasLeft==true)) 
        {
          text("Standing L", 167, 320);
          text(noteArray.get(0), 167, 290);
          text(currentTowerColors[0], 167, 305);
        }
        else if ((rightDown==false) && (hasRight==true))
        {
          text("Standing R", 400, 320);
          text(noteArray.get(0), 400, 290);
          text(currentTowerColors[0], 400, 305);
        } 
      }
      else if (noteArray.size()==2)
      {
        if (leftDown==false)
        {
          text("Standing", 167, 320);
          text(noteArray.get(0), 167, 290);
          text(currentTowerColors[0], 167, 305);
        }
        if (rightDown==false)
        {
          text("Standing", 400, 320);
          text(noteArray.get(1), 400, 290);
          text(currentTowerColors[1], 400, 305);
        }
      }
    }
  }

ArrayList<Contour> extractLegoTowers()
{
  //Find all contours in input image
  ArrayList<Contour> towerContours = opencv.findContours();
  ArrayList<Contour> filteredContours = new ArrayList<Contour>();
  
  //Filter contours to only lego towers
  for (Contour contour: towerContours)
  {
    if(contour.area() > 1500)
    {
      filteredContours.add(contour);
      
      contour.draw();
      //println(contour.area());
      
      //Draw polygon approximation
      stroke(255, 0, 0);
      
     
        beginShape();
        for (PVector point : contour.getPolygonApproximation().getPoints())
        {
          vertex(point.x, point.y);
        }
        endShape();
      
    }
  }
  
  return filteredContours;
}

void loadPImages()
{
  A1 = loadImage("A1_b.png");
  A1_left = loadImage("A1_left.png");
  A1_right = loadImage("A1_right.png");
  A2 = loadImage("A2_b.png");
  A2_left = loadImage("A2_left.png");
  A2_right = loadImage("A2_right.png");
  B1 = loadImage("B1_b.png");
  B1_left = loadImage("B1_left.png");
  B1_right = loadImage("B1_right.png");
  B2 = loadImage("B2_b.png");
  B2_left = loadImage("B2_left.png");
  B2_right = loadImage("B2_right.png");
  C1 = loadImage("C1.png");
  C1_left = loadImage("C1_left.png");
  C1_right = loadImage("C1_right.png");
  C2 = loadImage("C2.png");
  C2_left = loadImage("C2_left.png");
  C2_right = loadImage("C2_right.png");
  D1 = loadImage("D1_b.png");
  D1_left = loadImage("D1_left.png");
  D1_right = loadImage("D1_right.png");
  D2 = loadImage("D2_b.png");
  D2_left = loadImage("D2_left.png");
  D2_right = loadImage("D2_right.png");
  E1 = loadImage("E1_b.png");
  E1_left = loadImage("E1_left.png");
  E1_right = loadImage("E1_right.png");  
  E2 = loadImage("E2_b.png");
  E2_left = loadImage("E2_left.png");
  E2_right = loadImage("E2_right.png"); 
  F1 = loadImage("F1.png");
  F1_left = loadImage("F1_left.png");
  F1_right = loadImage("F1_right.png"); 
  F2 = loadImage("F2_b.png");
  F2_left = loadImage("F2_left.png");
  F2_right = loadImage("F2_right.png"); 
  G1 = loadImage("G1_b.png");
  G1_left = loadImage("G1_left.png");
  G1_right = loadImage("G1_right.png"); 
  //G2 = loadImage("G2_b.png");
  M1 = loadImage("M1_b.png");
  M1_left = loadImage("M1_left.png");
  M1_right = loadImage("M1_right.png"); 
  M2 = loadImage("M2_b.png");
  M2_left = loadImage("M2_left.png");
  M2_right = loadImage("M2_right.png"); 
  M3 = loadImage("M3_b.png");
  M3_left = loadImage("M3_left.png");
  M3_right = loadImage("M3_right.png"); 
  M4 = loadImage("M4_b.png"); 
  M4_left = loadImage("M4_left.png");
  M4_right = loadImage("M4_right.png"); 
  towerx = loadImage("x_b.png");  
  towerx_left = loadImage("x_left.png"); 
  towerx_right = loadImage("x_right.png"); 
  start = loadImage("start.png");
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
  pImgNames.add("A1 left");
  pImgNames.add("A1 right");
  pImgNames.add("A2");
  pImgNames.add("A2 left");
  pImgNames.add("A2 right");
  pImgNames.add("B1");
  pImgNames.add("B1 left");
  pImgNames.add("B1 right");
  pImgNames.add("B2");
  pImgNames.add("B2 left");
  pImgNames.add("B2 right"); 
  pImgNames.add("C1"); 
  pImgNames.add("C1 left");
  pImgNames.add("C1 right");
  pImgNames.add("C2");
  pImgNames.add("C2 left");
  pImgNames.add("C2 right");
  pImgNames.add("D1");
  pImgNames.add("D1 left");
  pImgNames.add("D1 right"); 
  pImgNames.add("D2");
  pImgNames.add("D2 left");
  pImgNames.add("D2 right");
  pImgNames.add("E1");
  pImgNames.add("E1 left");
  pImgNames.add("E1 right"); 
  pImgNames.add("E2");
  pImgNames.add("E2 left");
  pImgNames.add("E2 right");
  pImgNames.add("F1");
  pImgNames.add("F1 left");
  pImgNames.add("F1 right"); 
  pImgNames.add("F2");
  pImgNames.add("F2 left");
  pImgNames.add("F2 right");
  pImgNames.add("G1");
  pImgNames.add("G1 left");
  pImgNames.add("G1 right"); 
  pImgNames.add("M1");
  pImgNames.add("M1 left");
  pImgNames.add("M1 right");
  pImgNames.add("M2");
  pImgNames.add("M2 left");
  pImgNames.add("M2 right"); 
  pImgNames.add("M3");
  pImgNames.add("M3 left");
  pImgNames.add("M3 right");
  pImgNames.add("M4");
  pImgNames.add("M4 left");
  pImgNames.add("M4 right"); 
  pImgNames.add("X");
  pImgNames.add("X left");
  pImgNames.add("X right");
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
  towerColors.add("YGRB"); //D1
  towerColors.add("YGRB"); //D1
  towerColors.add("YGRB"); //D1
  towerColors.add("BYGR"); //D2
  towerColors.add("BYGR"); //D2
  towerColors.add("BYGR"); //D2
  towerColors.add("yBrYRG"); //E1
  towerColors.add("rBRG"); //E1
  towerColors.add("BrYRG"); //E1
  towerColors.add("rYRG"); //E2
  towerColors.add("BrYRG"); //E2
  towerColors.add("yBrYRG"); //E2
  towerColors.add("GYR"); //F1
  towerColors.add("BGYR"); //F1
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
  towerColors.add("GYBR"); //X
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

String getBestTowerMatch(Contour inputTower, String inputColor)
{
  double bestSimilarity=10;
  double currentSimilarity=1000;
  String towerType="Unknown Tower";
  towerColors = loadTowerColors();

  println(contourDBList.size());
  println(inputColor);
  for(int c=0; c < contourDBList.size(); c++)
  {
    Contour srcContour = contourDBList.get(c);

    //Use hu-moments for image which are invariant to translation, rotation, scale, and skew for comparison
    currentSimilarity = Imgproc.matchShapes(srcContour.pointMat, inputTower.pointMat, Imgproc.CV_CONTOURS_MATCH_I2, 0);
    
    if (pImgNames.get(c)=="D1" || pImgNames.get(c)=="M3")
      println(pImgNames.get(c) + " " + towerColors.get(c) + " " + currentSimilarity);
      
    if (currentSimilarity < bestSimilarity)
    {
      if ((inputColor.equals(towerColors.get(c))==true))
      {  
        bestSimilarity = currentSimilarity;
        towerType = pImgNames.get(c);
        println("****** high "+towerType+" "+bestSimilarity);
        if (pImgNames.get(c)=="D1")
          text(currentSimilarity + " " + pImgNames.get(c), 450, 50);
        if (pImgNames.get(c)=="M3")
          text(currentSimilarity + " " + pImgNames.get(c), 450, 150);
      }
    }
  }
  /*
  if (towerType=="Unknown Tower") {
    println("unknowntower");
    inputTower.draw();
    stroke(255,255,255);
    strokeWeight(10);
  } */
  
  return towerType;
}



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
PImage srcImage, editedImage;
SimpleOpenNI  context;
ControlP5 controlP5;
ArrayList<Contour> legoTowers;
ArrayList<Rectangle> originalBoundingBoxes;
PImage A1, A2, B1, B2, C1, C2, D1, D2, E1, E2, F1, F2, G1, G2;
PImage M1, M2, M3, M4, towerx; 


ArrayList<PImage> PImgArray;
ArrayList<Contour> contourDBList;
ArrayList<String> pImgNames;

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
  //setupGUI();
  
  PImgArray = createPImageArray(); 
  contourDBList = createContourDatabase(PImgArray);
  //println("sizeof pimgarray = "+PImgArray.size());
  //println("sizeof contourDBList = "+contourDBList.size()); 
  pImgNames = loadPImgStrings();
  
}

void draw()
{
  //Update camera image
  context.update();                 
  
  //Clean the input image
  cleanKinectInput();
  srcImage = context.depthImage();
  opencv = new OpenCV(this, srcImage);
  opencv.gray();
  opencv.threshold(70);
  image(context.depthImage(),0,0);
  editedImage = opencv.getOutput();
 
  //Find lego towers
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
  }
}

void trackLegoTowers()
{
  Contour tempContour, originalContour;
  ArrayList<Contour> filteredContours;

  if (legoTowers.size() > 0)
  {
    filteredContours = extractLegoTowers();
    
    for(int i=0; i<legoTowers.size();i++)
    {
      originalContour = legoTowers.get(i);
      String note = checkDatabase(originalContour);

      ArrayList<Rectangle> currentBoundingBoxes = new ArrayList<Rectangle>();
      ArrayList<String> noteArray = new ArrayList<String>();
      
      for(int j=0; j<filteredContours.size(); j++)
      {
        tempContour = filteredContours.get(j);
        Rectangle tempBoundingBox = tempContour.getBoundingBox();
        currentBoundingBoxes.add(tempBoundingBox);
        noteArray.add(getBestTowerMatch(tempContour));
        //println("checkdatabase says: "+checkDatabase(tempContour));
        //println("size of noteArray: "+noteArray.size());
      }
      
      for (int z = 0; z < originalBoundingBoxes.size();z++)
      {
        if (currentBoundingBoxes.size() >= originalBoundingBoxes.size())
        {
          if ((originalBoundingBoxes.get(z).height - currentBoundingBoxes.get(z).height) > 40)
          {
            text("Fallen", currentBoundingBoxes.get(z).x, currentBoundingBoxes.get(z).y-10);
          }
          else 
          {
             text("Standing", currentBoundingBoxes.get(z).x, currentBoundingBoxes.get(z).y-10);
             text(noteArray.get(z), currentBoundingBoxes.get(z).x, currentBoundingBoxes.get(z).y-100);
          }
        }
      }
    }
  }
  else 
   {
     legoTowers = extractLegoTowers();
      for (Contour contour: legoTowers)
      {
        originalBoundingBoxes.add(contour.getBoundingBox());
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
    if(contour.area() > 2000)
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

boolean towerMatch(Contour towerReference, Contour inputTower)
{
  //Use hu-moments for image which are invariant to translation, rotation, scale, and skew for comparison
  double similarity = Imgproc.matchShapes(towerReference.pointMat, inputTower.pointMat, Imgproc.CV_CONTOURS_MATCH_I1, 0);
  
  if (similarity < 1)  //The lower the result, the better the match
  {
    println("match similarity: "+similarity);
    return true;
  }
  else 
  {
    println("no match: "+similarity);
    return false;
  }
}

void loadPImages()
{
  A1 = loadImage("A1_b.png");
  A2 = loadImage("A2_b.png");
  B1 = loadImage("B1_b.png");
  B2 = loadImage("B2_b.png");
  C1 = loadImage("C1_b.png");
  C2 = loadImage("C2_b.png");
  D1 = loadImage("D1_b.png");
  D2 = loadImage("D2_b.png");
  E1 = loadImage("E1_b.png");
  E2 = loadImage("E2_b.png");
  F1 = loadImage("F1_b.png");
  F2 = loadImage("F2_b.png");
  G1 = loadImage("G1_b.png");
  //G2 = loadImage("G2_b.png");
  M1 = loadImage("M1_b.png");
  M2 = loadImage("M2_b.png");
  M3 = loadImage("M3_b.png");
  M4 = loadImage("M4_b.png"); 
  towerx = loadImage("x_b.png");  
}

ArrayList<PImage> createPImageArray()
{
  ArrayList<PImage> database = new ArrayList<PImage>();
  loadPImages();
  database.add(A1);  
  database.add(A2);  
  database.add(B1);  
  database.add(B2); 
  database.add(C1);  
  database.add(C2);   
  database.add(D1);  
  database.add(D2); 
  database.add(E1);  
  database.add(E2); 
  database.add(F1);  
  database.add(F2);
  database.add(G1);  
  //database.add(G2);
  database.add(M1);  
  database.add(M2);
  database.add(M3);  
  database.add(M4);
  database.add(towerx);
  /*
  println("A1: "+A1);
  println("db A1? "+database.get(0));
  println("db A1? "+database.get(17));
  
  println("A2: "+A2);
  println("B1: "+B1);
  println("B2: "+B2);
  println("C1: "+C1);
  println("C2: "+C2);
  println("D1: "+D1);
  println("D2: "+D2);
  println("E1: "+E1);
  println("E2: "+E2);
  println("F1: "+F1);
  println("F2: "+F2);
  println("G1: "+G1);
  println("M1: "+M1);
  println("M2: "+M2);
  println("M1: "+M1);
  println("M2: "+M2);  */
  return database;
}

ArrayList<String> loadPImgStrings()
{
  ArrayList<String> pImgNames = new ArrayList<String>();
  pImgNames.add("A1");
  //pImgNames.add("A1");
  pImgNames.add("A2");
  //pImgNames.add("A2");
  pImgNames.add("B1");
  //pImgNames.add("B1");
  pImgNames.add("B2"); 
  //pImgNames.add("B2"); 
  pImgNames.add("C1"); 
  //pImgNames.add("C1"); 
  pImgNames.add("C2");
  //pImgNames.add("C2"); 
  pImgNames.add("D1"); 
  //pImgNames.add("D1"); 
  pImgNames.add("D2");
  //pImgNames.add("D2"); 
  pImgNames.add("E1"); 
  //pImgNames.add("E1"); 
  pImgNames.add("E2");
  //pImgNames.add("E2");
  pImgNames.add("F1"); 
  //pImgNames.add("F1"); 
  pImgNames.add("F2");
  //pImgNames.add("F2"); 
  pImgNames.add("G1"); 
  //pImgNames.add("G1"); 
  pImgNames.add("M1");
  //pImgNames.add("M1");
  pImgNames.add("M2"); 
  //pImgNames.add("M2");
  pImgNames.add("M3");
  //pImgNames.add("M3"); 
  pImgNames.add("M4"); 
  //pImgNames.add("M4"); 
  pImgNames.add("X");
  //pImgNames.add("X");
  return pImgNames;                               
}

ArrayList<Contour> createContourDatabase(ArrayList<PImage> PImgArray)
{
  ArrayList<Contour> newContours = new ArrayList<Contour>();
  ArrayList<Contour> contourDB = new ArrayList<Contour>();
    
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

String checkDatabase(Contour tempContour)
{
  String note = "no match found :(";

  for (int c=0; c<contourDBList.size(); c++)
  {
    println(pImgNames.get(c));
    //println("contour "+c+" area = "+contourDBList.get(c).area());
    if (towerMatch(contourDBList.get(c), tempContour)) {
      println("match with "+pImgNames.get(c));
      note = "MATCH! with "+pImgNames.get(c);
      break;
      //note = "MATCH! with: "+contour;
    }  
  }
  return note;  
}


String getBestTowerMatch(Contour inputTower)
{
  double highestSimilarity=1000;
  double currentSimilarity=1000;
  String towerType="Unknown Tower";

  for(int c=0; c<contourDBList.size(); c++)
  {
    Contour srcContour = contourDBList.get(c);

    //Use hu-moments for image which are invariant to translation, rotation, scale, and skew for comparison
    currentSimilarity = Imgproc.matchShapes(srcContour.pointMat, inputTower.pointMat, Imgproc.CV_CONTOURS_MATCH_I1, 0);
    if (currentSimilarity < highestSimilarity)
    {
      highestSimilarity = currentSimilarity;
      towerType = pImgNames.get(c);
    }
  }
  return towerType;
}

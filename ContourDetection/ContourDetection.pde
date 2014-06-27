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
ArrayList<Contour> databaseContours;
ArrayList<String> fileNames;

PImage A1, A2, B1, B2, C1, C2, D1, D2, E1, E2, F1, F2, G1, G2;
PImage M1, M2, M3, M4, towerx; 

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
  databaseContours = new ArrayList<Contour>();
  originalBoundingBoxes = new ArrayList<Rectangle>();
  fileNames = new ArrayList<String>();
  //setupGUI();
  
  createContourDatabase();
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

void createContourDatabase() 
{
  //Load Lego tower types into program
  PImage inputTower;
  String towerName;
  ArrayList<Contour> inputContour;
  fileNames = getTowerFileNames();
  String inputFilename;
  
  //Extract contours from input images
  for (int i=0; i < fileNames.size(); i++)
  {
    inputFilename = fileNames.get(i);
    inputTower = loadImage(inputFilename);
    inputContour = createTowerContour(inputTower);
    databaseContours.add(inputContour.get(0));
  }
}

ArrayList<String> getTowerFileNames()
{
  ArrayList<String> pImgNames = new ArrayList<String>();
  pImgNames.add("A1_b.png");
  pImgNames.add("A2_b.png");
  pImgNames.add("B1_b.png");
  pImgNames.add("B2_b.png"); 
  pImgNames.add("C1_b.png"); 
  pImgNames.add("C2_b.png");
  pImgNames.add("D1_b.png"); 
  pImgNames.add("D2_b.png");
  pImgNames.add("E1_b.png"); 
  pImgNames.add("E2_b.png");
  pImgNames.add("F1_b.png"); 
  pImgNames.add("F2_b.png");
  pImgNames.add("G1_b.png"); 
  pImgNames.add("M1_b.png");
  pImgNames.add("M2_b.png"); 
  pImgNames.add("M3_b.png");
  pImgNames.add("M4_b.png"); 
  pImgNames.add("x_b.png");
  return pImgNames;                               
}

ArrayList<Rectangle> recordCurrentSnapshot()
{
  ArrayList<Contour> currentTowers;
  ArrayList<Rectangle> boundingRectangles = new ArrayList<Rectangle>();
  
  //Extract all contours from current scene
  currentTowers = extractLegoTowers();
  for (Contour contour: currentTowers)
  {
    boundingRectangles.add(contour.getBoundingBox());
  }
  return boundingRectangles;
}

void trackLegoTowers()
{ /*
  ArrayList<Contour> currentTowerContours;
  //ArrayList<LegoTower> currentTowers = new ArrayList<LegoTower>();
  ArrayList<Rectangle> currentBoundingBoxes = new ArrayList<Rectangle>();
  //LegoTower tempTower;
  
  //Record original tower locations
  if (originalBoundingBoxes.isEmpty())
    originalBoundingBoxes = recordCurrentSnapshot();
   
  ArrayList<String> noteArray = new ArrayList<String>();
  
//  if (originalBoundingBoxes.isEmpty())
//  {
//    currentTowerContours = extractLegoTowers();
//    for (Contour contour: legoTowers)
//    {
//      originalBoundingBoxes.add(contour.getBoundingBox());
//    } 
//  }
    
  //Get current status of Lego towers
  currentTowerContours = extractLegoTowers();
  for (Contour contour: currentTowerContours)
  {
    //tempTower = new LegoTower(contour);
    //currentTowers.add(tempTower);
    //currentTowerBounds.add(tempTower.towerBounds);
    //tempTower.draw();
    Rectangle tempBoundingBox = contour.getBoundingBox();
    currentBoundingBoxes.add(tempBoundingBox);
    noteArray.add(getBestTowerMatch(contour));
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
         //println("for tower "+i+", text is "+note);
         text(noteArray.get(z), currentBoundingBoxes.get(z).x, currentBoundingBoxes.get(z).y-25);
      }
    }
  } */
  
  Contour tempContour, originalContour;
  ArrayList<Contour> filteredContours;

  if (legoTowers.size()>0)  
  {
    filteredContours = extractLegoTowers();
    
    for (int i=0; i < legoTowers.size(); i++)
    {
      originalContour = legoTowers.get(i);
      ArrayList<Rectangle> currentBoundingBoxes = new ArrayList<Rectangle>();
      ArrayList<String> noteArray = new ArrayList<String>();
      
      for (int j=0; j < filteredContours.size(); j++)
      {
        tempContour = filteredContours.get(j);
        Rectangle tempBoundingBox = tempContour.getBoundingBox();
        currentBoundingBoxes.add(tempBoundingBox);
        noteArray.add(checkDatabase(tempContour));
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
             //println("for tower "+i+", text is "+note);
             text(noteArray.get(z), currentBoundingBoxes.get(z).x, currentBoundingBoxes.get(z).y-25);
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
  ArrayList<Contour> rawContours = opencv.findContours();
  ArrayList<Contour> towerContours = new ArrayList<Contour>();
  //Filter contours to only lego towers
  for (Contour contour: rawContours)
  {
    if(contour.area() > 2000)
    {
      towerContours.add(contour);
      
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
  
  return towerContours;
}

boolean towerMatch(Contour towerReference, Contour inputTower)
{
  //Use hu-moments for image which are invariant to translation, rotation, scale, and skew for comparison
  double similarity = Imgproc.matchShapes(towerReference.pointMat, inputTower.pointMat, Imgproc.CV_CONTOURS_MATCH_I1, 0);
  
  if (similarity < 0.10)  //The lower the result, the better the match
  {
    println("similarity "+similarity);
    return true;
  }
  else 
    return false;
}

ArrayList<Contour> createTowerContour(PImage inputDepthImage)
{
  //Filter input image
  opencv = new OpenCV(this, inputDepthImage);
  opencv.gray();
  opencv.threshold(70);    
  
  //Extract contours from filtered image
  return opencv.findContours();
}

String getBestTowerMatch(Contour inputTower)
{
  double highestSimilarity=1000;
  double currentSimilarity=1000;
  String towerType="Unknown Tower";

  for(int c=0; c<databaseContours.size(); c++)
  {
    String towerName = fileNames.get(c);
    Contour srcContour = databaseContours.get(c);

    //Use hu-moments for image which are invariant to translation, rotation, scale, and skew for comparison
    currentSimilarity = Imgproc.matchShapes(srcContour.pointMat, inputTower.pointMat, Imgproc.CV_CONTOURS_MATCH_I3, 0);
    if (currentSimilarity < highestSimilarity)
    {
      highestSimilarity = currentSimilarity;
      towerType = towerName;
    }
  }
  println(highestSimilarity);
  return towerType;
}

String checkDatabase(Contour tempContour)
{
  String note = "no match found :(";
  for (int c=0; c<databaseContours.size(); c++)
  {
    //println("contour "+c+" area = "+contourDBList.get(c).area());
    if (towerMatch(databaseContours.get(c), tempContour))
      note = "MATCH! with "+fileNames.get(c);
      break;
      //note = "MATCH! with: "+contour;
  }
  return note;  
}

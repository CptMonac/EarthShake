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
  ArrayList<String> noteArray = new ArrayList<String>();

  if (legoTowers.size() > 0)
  {
    filteredContours = extractLegoTowers();
    
    for(int i=0; i<legoTowers.size();i++)
    {
      originalContour = legoTowers.get(i);

      ArrayList<Rectangle> currentBoundingBoxes = new ArrayList<Rectangle>();
      
      for(int j=0; j<filteredContours.size(); j++)
      {
        println("filtered contours "+filteredContours.size());
        tempContour = filteredContours.get(j);
        Rectangle tempBoundingBox = tempContour.getBoundingBox();
        currentBoundingBoxes.add(tempBoundingBox);
        noteArray.add(checkDatabase(tempContour));
        println(noteArray.get(j));
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
             text(noteArray.get(z), currentBoundingBoxes.get(z).x, currentBoundingBoxes.get(z).y-25);
          }
        }
      }
              
//        if (towerMatch(originalContour, tempContour))
//        {
//          float OriginalBox = originalContour.getBoundingBox().y;
//          float TempBox = tempContour.getBoundingBox().y;
//          if (abs(OriginalBox - TempBox ) < 100 )
//          {
//            text("Standing", originalContour.getBoundingBox().x, originalContour.getBoundingBox().y-10);
//          }
//          else 
//          {
//            text("Fallen", tempContour.getBoundingBox().x, tempContour.getBoundingBox().y-10);
//          }
//          break;
//        }
      // }
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
      println(contour.area());
      
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
  
  if (similarity < 0.10)  //The lower the result, the better the match
    return true;
  else 
    return false;
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
  return database;
}

ArrayList<Contour> createContourDatabase(ArrayList<PImage> PImgArray)
{
  ArrayList<Contour> newContours = new ArrayList<Contour>();
  ArrayList<Contour> contourDB = new ArrayList<Contour>();
  
  opencv = new OpenCV(this, srcImage);
  opencv.gray();
  opencv.threshold(70);
    
  for (PImage srcImage: PImgArray)
  {
    newContours = extractLegoTowers();
    for (Contour contour: newContours)
    {
      contourDB.add(contour);
    }
  }
  return contourDB;
}

String checkDatabase(Contour tempContour)
{
  String note = "no match found :(";
  ArrayList<PImage> PImgArray = createPImageArray(); 
  ArrayList<Contour> contourDBList = createContourDatabase(PImgArray); 
  for (Contour contour: contourDBList)
  {
    if (towerMatch(tempContour, contour))
      note = "MATCH!";
      //note = "MATCH! with: "+contour;
  }
  return note;  
}

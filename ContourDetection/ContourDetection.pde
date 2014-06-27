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
import java.util.Map;
import controlP5.*;


OpenCV opencv;
PImage srcImage, editedImage;
SimpleOpenNI context;
ControlP5 controlP5;
ArrayList<Rectangle> originTowerBounds;
HashMap<String, Contour> towerDatabase;

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
  towerDatabase = new HashMap<String, Contour>();
  originTowerBounds = new ArrayList<Rectangle>();
  
  //Load lego tower types into towerDatabase
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

//Create structure that stores lego tower types with their names
void createContourDatabase()
{
  //Load lego towers types into program
  PImage inputTower;
  String towerName;
  ArrayList<Contour> inputContour;
  ArrayList<String> fileNames = getTowerFileNames();

  //Extract contours from input images
  for(String inputFilename: fileNames)
  {
    inputTower = loadImage(inputFilename);
    inputContour = createTowerContour(inputTower);
    towerName = inputFilename.substring(0,inputFilename.length()-3);
    towerDatabase.put(towerName, inputContour.get(0));
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

ArrayList<Contour> extractLegoTowers()
{
  ArrayList<Contour> rawContours;
  ArrayList<Contour> towerContours = new ArrayList<Contour>();

  //Extract all contours from current scene
  rawContours =  opencv.findContours();
  for (Contour contour: rawContours)
  {
    //Filter out lego towers from scene
    if(contour.area() > 2000)
      towerContours.add(contour);
  }
  return towerContours;
}

//Creates contours from input depth image
ArrayList<Contour> createTowerContour(PImage inputDepthImage)
{
  //Filter input image
  opencv = new OpenCV(this, inputDepthImage);
  opencv.gray();
  opencv.threshold(70);
  
  //Extract contours from filtered image
  return opencv.findContours();
}

void trackLegoTowers()
{
  ArrayList<Contour> currentTowerContours;
  ArrayList<LegoTower> currentTowers = new ArrayList<LegoTower>();
  ArrayList<Rectangle> currentTowerBounds = new ArrayList<Rectangle>();
  LegoTower tempTower;

  //Record original tower locations
  if (originTowerBounds.isEmpty())
    originTowerBounds = recordCurrentSnapshot();

  //Get current status of lego towers
  currentTowerContours = extractLegoTowers();
  for (Contour contour: currentTowerContours)
  {
    tempTower = new LegoTower(contour);
    currentTowers.add(tempTower);
    currentTowerBounds.add(tempTower.towerBounds);
    tempTower.draw();
  }

  //Track changes in lego tower status
  for (int i =0; i < originTowerBounds.size(); i++)
  {
    if (currentTowerBounds.size() >= originTowerBounds.size())
    {
      if ((originTowerBounds.get(i).height - currentTowerBounds.get(i).height) > 40)
      {
        currentTowers.get(i).towerStatus = "Fallen";
      }
      else 
      {
        currentTowers.get(i).towerStatus = "Standing";
      }
      currentTowers.get(i).draw();
    }
  }
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

String getBestTowerMatch(Contour inputTower)
{
  double highestSimilarity=1000;
  double currentSimilarity=1000;
  String towerType="Unknown Tower";

  for(Map.Entry srcTower: towerDatabase.entrySet())
  {
    String srcTower_type = srcTower.getKey().toString();
    Contour srcContour = towerDatabase.get(srcTower_type);

    //Use hu-moments for image which are invariant to translation, rotation, scale, and skew for comparison
    currentSimilarity = Imgproc.matchShapes(srcContour.pointMat, inputTower.pointMat, Imgproc.CV_CONTOURS_MATCH_I1, 0);
    if (currentSimilarity < highestSimilarity)
    {
      highestSimilarity = currentSimilarity;
      towerType = srcTower_type;
    }
  }
  return towerType;
}
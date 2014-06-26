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
SimpleOpenNI  context;
ControlP5 controlP5;
ArrayList<Contour> legoTowers;
ArrayList<Rectangle> originalBoundingBoxes;
PImage A1, A2, B1, B2, C1, C2, D1, D2, E1, E2, F1, F2, G1, G2;
PImage M1, M2, M3, M4, towerx; 
ArrayList<Contour> newContours;
ArrayList<Rectangle> originTowerBounds;
ArrayList<String> fileNames;

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
  
  //Load Lego tower types into towerDatabase
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
  //Load lego towers types into program
  PImage inputTower;
  String towerName;
  ArrayList<Contour> inputContour;
  //ArrayList<Contour> newContours = new ArrayList<Contour>;
  fileNames = getTowerFileNames();
  
  String inputFilename;
  //Extract contours from input images
  for (int f=0; f<filenames.size(); f++)
  {
    inputFilename = filenames.get(f);
    inputTower = loadImage(inputFilename);
    inputContour = createTowerContour(inputTower);
    newContours.add(inputContour.get(0));
  }
}

ArrayList<Contour> getTowerFilenames()
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

boolean towerMatch(Contour towerReference, Contour inputTower)
{
  //Use hu-moments for image which are invariant to translation, rotation, scale, and skew for comparison
  double similarity = Imgproc.matchShapes(towerReference.pointMat, inputTower.pointMat, Imgproc.CV_CONTOURS_MATCH_I1, 0);
  
  if (similarity < 0.10)  //The lower the result, the better the match
    return true;
  else 
    return false;
}

//Creates contours from input depth image
ArrayList<Contour> createTowerContour(PImage inputDepthImage)
{
  //Filter input image
  opencv = new OpenCV(this, srcImage);
  opencv.gray();
  opencv.threshold(70);  
  
  //Extract contours from filtered image
  return opencv.findContours();
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
  rawContours = opencv.findContours();
  for (Contour contour: rawContours)
  {
    //Filter out lego towers from scene
    if (contour.area() > 2000)
      towerContours.add(contour);
  }
  return towerContours;
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
    
  //Get current status of Lego towers
  currentTowerContours = extractLegoTowers();
  for (Contour contour: currentTowerContours)
  {
    tempTower = new LegoTower(contour);
    currentTowers.add(tempTower);
    currentTowerBounds.add(tempTower.towerBounds);
    tempTower.draw();
  }
  
  //Track changes in Lego tower status
  for(int i=0; i<originTowerBounds.size();i++)
  { 
    if (currentTowerBounds.size() >= originTowerBounds.size())
    {
      if ((originTowerBounds.get(i).height - currentTowerBounds.get(i).height) > 40)
      {
        currentTowers.get(i).towerStatus = "Fallen";
        //text("Fallen", currentTowerBounds.get(i).x, currentTowerBounds.get(i).y-10);
      }
      else 
      {
         currentTowers.get(i).towerStatus = "Standing";
         //text("Standing", currentTowerBounds.get(i).x, currentTowerBounds.get(i).y-10);
      }
      currentTowers.get(i).draw();
    }
  }
}

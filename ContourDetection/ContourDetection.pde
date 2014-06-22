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
import controlP5.*;


OpenCV opencv;
PImage srcImage, editedImage;
SimpleOpenNI  context;
ControlP5 controlP5;
ArrayList<Contour> legoTowers;

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

  if (legoTowers.size() > 0)
  {
    filteredContours = extractLegoTowers();
    
    for(int i=0; i<legoTowers.size();i++)
    {
      originalContour = legoTowers.get(i);

      for(int j=0; j<filteredContours.size(); j++)
      {
        tempContour = filteredContours.get(j);
        if (towerMatch(originalContour, tempContour))
        {
          if (abs(originalContour.area() - tempContour.area() ) < 400 )
          {
            text("Standing", originalContour.getBoundingBox().x, originalContour.getBoundingBox().y-10);
          }
          else 
          {
            text("Fallen", tempContour.getBoundingBox().x, tempContour.getBoundingBox().y-10);
          }
          break;
        }
       }
    }
  }
  else 
    legoTowers = extractLegoTowers();
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

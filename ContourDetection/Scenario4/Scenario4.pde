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
SimpleOpenNI context;			
ArrayList<Contour> legoTowers;
ArrayList<Contour> contourDBList;
ArrayList<String> pImgNames;
ControlP5 controlP5;
ControlGroup messageBox;
String[] currentTowerColors;
ArrayList<Rectangle> originalBoundingBoxes;
ArrayList<String> towerColors;
boolean shakeVisible, timerVisible;
PImage startScreen,timerImage;

float scaleFactorx = 0.45;
float scaleFactory = 0.96; 
float startTime, elapsedTime;
int debounceCount = 0;

void setup()
{
  	//Enable all kinect cameras/sensors
  	setupKinect();

  	//Initialize lego towers
  	setupTowers();

  	//Initialize GUI
  	controlP5 = new ControlP5(this);
  	messageBox = controlP5.addGroup("messageBox", width/2 - 150,100,300);
  	shakeVisible = false;
  	timerVisible = false;
  	startScreen = loadImage("startscreen.jpg");
  	timerImage = loadImage("timer.png");
}

void draw()
{
	if (singleTowerCheck())
	{
		if (!shakeVisible)
		{
			shakeVisible = true;
			PImage[] shakeIcon = {loadImage("shakehovercircle.png"), loadImage("shakehover.png"), loadImage("shake.png")};
   			//noTint();
			controlP5.addButton("shake")
					 .setValue(128)
					 .setPosition(width/2 -120, height/2 -90)
					 .setImages(shakeIcon)
					 .setSize(100,40)
					 .updateSize();
		    image(startScreen,0,0);
		}
		else if (shakeVisible)
		{
			tint(150, 50);
			image(startScreen, 0,0);
			tint(255,255);
		}

		if (timerVisible)
		{
			elapsedTime = millis();
			tint(150,50);
			image(startScreen, 0,0);
			tint(255,255);
			image(timerImage, width/2 - 140, height/2 - 30);
			textSize(32);
			text((elapsedTime - startTime)/1000, width/2 - 100, height/2 - 40);
		}
	}
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
	buildLegoDatabase();
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
	return legoDatabase;
}

boolean singleTowerCheck()
{
	if (legoTowers.size() > 1)
	{
		messageBox.setBackgroundHeight(120);
		messageBox.setBackgroundColor(color(0,128));
		messageBox.hideBar();

		Textlabel messagelabel = controlP5.addTextlabel("messageBoxLabel", "Please place only one tower on the table.", 20, 20);
		messagelabel.moveTo(messageBox);
		messageBox.show();
		return false;
	}
	else
	{
		messageBox.hide();
		return true;
	}
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
  towerColors.add("yBrYRG"); //E1
  towerColors.add("rBRG"); //E1
  towerColors.add("BrYRG"); //E1
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
  towerColors.add("GYBR"); //X
  towerColors.add("GYBR"); //X
  towerColors.add(":)"); //start
  return towerColors;
}

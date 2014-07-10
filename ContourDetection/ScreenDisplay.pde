
public class PFrame extends Frame {
  public PFrame() {
    setBounds(0, 0, 780, 500);
    s = new SecondApplet();
    add(s);
    s.init();
    show();
    setTitle("gorilla");
  }
}

public class SecondApplet extends PApplet {
  public void setup() {
    size(780, 500);
    PImage screen1 = loadImage("screen1.jpg");    
    
    //setKinectElements();
    //Initialize image variable
    PImage srcImage2 = context.depthImage();
    //Initialize openCv
    OpenCV opencv = new OpenCV(this, srcImage2);
    /*
    ArrayList<Contour> legoTowers = new ArrayList<Contour>();
    ArrayList<Rectangle> originalBoundingBoxes = new ArrayList<Rectangle>();
    
    ArrayList<PImage> PImgArray = createPImageArray(); 
    ArrayList<Contour> contourDBList = createContourDatabase(PImgArray);
    println("sizeof pimgarray = "+PImgArray.size());
    println("sizeof contourDBList = "+contourDBList.size()); 
    ArrayList<String> pImgNames = loadPImgStrings(); */
  }
  public void draw() {
    image(screen1, 0, 0);
    
    //Update camera image
    //context.update();
    
    PImage clone = colorTower.get();   
    /*
    PImage depthImage = context.depthImage();
    colorTower2 = new PImage(depthImage.getImage());
    
    //Clean the input image    cleanKinectInput2();
    srcImage2 = context.depthImage();
    opencv = new OpenCV(this, srcImage2);
    opencv.gray();
    opencv.threshold(70);
    
    PImage editedImage = opencv.getOutput();
    */
    scale(0.5);
    image(clone, 500, 200);
    
    //Find legotowers
    //trackLegoTowers();
    //imageComparison2();
  } 
  /*
  void cleanKinectInput2()
  {
    int[] inputDepthMap = context.depthMap();
    context.depthImage().loadPixels();
  
    //Remove erroneous pixels
    for (int i=0; i<context.
    {
      if (inputDepthMap[i] == 0) { //Error depth map value 
        context.depthImage().pixels[i] = color(0,0,0);
        colorTower2.pixels[i] = color(0,0,0);
      }
  
      if ((inputDepthMap[i]< 600) || (inputDepthMap[i] > 1000)) { //Irrelevant depths
        context.depthImage().pixels[i] = color(0,0,0);
        colorTower2.pixels[i] = color(0,0,0);
      }
  
      else if ((inputDepthMap[i] > 400) && (inputDepthMap[i] < 1000))
        colorTower2.pixels[i] = context.rgbImage().pixels[i];
    }
  }  
  void imageComparison2() 
  {
    pushMatrix();

    theBlobDetection = new BlobDetection(srcImage2.width, srcImage2.height);
    println("WxH "+srcImage2.width+"x"+srcImage2.height);
    theBlobDetection.setPosDiscrimination(false);
    theBlobDetection.setThreshold(0.38f);
    theBlobDetection.computeBlobs(srcImage2.pixels);
    currentTowerColors = blobDebugMode(); 
    
    popMatrix();
  }
  */
}


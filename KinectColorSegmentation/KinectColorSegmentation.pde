import gab.opencv.*;
import SimpleOpenNI.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.CvType;
import org.opencv.imgproc.Imgproc;

OpenCV opencv;
PImage src,dst, hist, histMask;
SimpleOpenNI  context;
Mat skinHistogram;

void setup()
{
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  // enable depthMap generation 
  context.enableDepth();
  context.enableUser();
  context.enableRGB();
  
  src= context.rgbImage();
  //src = loadImage("test.jpg");
  //src.resize(src.width/2, 0);
  size(src.width*2 + 256, src.height, P2D);
  // third argument is: useColor
  opencv = new OpenCV(this, src, true);  

  skinHistogram = Mat.zeros(256, 256, CvType.CV_8UC1);
  Core.ellipse(skinHistogram, new Point(113.0, 155.6), new Size(40.0, 25.2), 43.0, 0.0, 360.0, new Scalar(255, 255, 255), Core.FILLED);

  //Generate PImage
  histMask = createImage(256,256, ARGB);
  
  //update();
  opencv.toPImage(skinHistogram, histMask);
  dst = opencv.getOutput();
  dst.loadPixels();
 
  for(int i = 0; i < dst.pixels.length; i++)
  {
    
    Mat input = new Mat(new Size(1, 1), CvType.CV_8UC3);
    input.setTo(colorToScalar(dst.pixels[i]));
    Mat output = opencv.imitate(input);
    Imgproc.cvtColor(input, output, Imgproc.COLOR_BGR2YCrCb );
    double[] inputComponents = output.get(0,0);
    if(skinHistogram.get((int)inputComponents[1], (int)inputComponents[2])[0] > 0)
      dst.pixels[i] = color(255);
    else 
      dst.pixels[i] = color(0);
  }
  dst.updatePixels();
}

 // in BGR
Scalar colorToScalar(color c)
{
  return new Scalar(blue(c), green(c), red(c));
}


void draw()
{
  context.update();
  src = context.rgbImage();
  image(src,0,0);
  image(dst, src.width, 0);
  //update();
}

void update()
{
  opencv.toPImage(skinHistogram, histMask);
    
  dst = opencv.getOutput();
  dst.loadPixels();
 
  for(int i = 0; i < dst.pixels.length; i++)
  {
    
    Mat input = new Mat(new Size(1, 1), CvType.CV_8UC3);
    input.setTo(colorToScalar(dst.pixels[i]));
    Mat output = opencv.imitate(input);
    Imgproc.cvtColor(input, output, Imgproc.COLOR_BGR2YCrCb );
    double[] inputComponents = output.get(0,0);
    if(skinHistogram.get((int)inputComponents[1], (int)inputComponents[2])[0] > 0)
      dst.pixels[i] = color(255);
    else 
      dst.pixels[i] = color(0);
  }
  dst.updatePixels(); 
}

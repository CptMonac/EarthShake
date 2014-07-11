//Based on GUI.PDE from Generative Gestaltung by Harmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni

void setupGUI()
{
  PFont pfont = createFont("Arial",9); 
  color activeColor = color(0, 130, 164);
  controlP5 = new ControlP5(this);
  controlP5.setControlFont(pfont);

  int controlWidth = int(textWidth("startDetection"))+25;
  Button startDetection = controlP5.addButton("startDetection")
                                   .setValue(0)
                                   .setPosition(43, 8)
                                   .setSize(controlWidth, 20);

}

void drawGUI()
{
  controlP5.show();
  controlP5.draw();
}

public void updateBackground(int inputValue)
{
  String fileName;

  background(150);
  beforeTower = createImage(640, 40, RGB);
  PImage depthImage = context.depthImage();
  depthImage.loadPixels();
  int[] inputDepthMap = context.depthMap();

  //Strip out error locations
  for (int i = 0; i<context.depthMapSize(); i++)
  {
    if (inputDepthMap[i] == 0)  //Error value
      context.depthImage().pixels[i]=color(0,0,0);

    if (inputDepthMap[i] > 800) //Irrelevant depths
      context.depthImage().pixels[i]=color(0,0,0);
  }

  //Save background image
  temp = context.depthImage();
  beforeTower = temp.get();
  fileName = sketchPath + java.io.File.separator + "beforeTower.jpg";
  beforeTower.save(fileName);
}

public void startDetection(int inputValue)
{
  controlP5.getController("startDetection").setLock(true);
  controlP5.getController("startDetection").setColorBackground(color(112,112,112));
}




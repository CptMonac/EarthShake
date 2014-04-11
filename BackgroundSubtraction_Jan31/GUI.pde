//Based on GUI.PDE from Generative Gestaltung by Harmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni

void setupGUI()
{
  PFont pfont = createFont("Arial",9); 
  color activeColor = color(0, 130, 164);
  controlP5 = new ControlP5(this);
  controlP5.setControlFont(pfont);
  int controlWidth = int(textWidth("updateBackground")) + 18;
  ControlGroup ctrl = controlP5.addGroup("Controls", width - 150, 25, controlWidth);
  ctrl.setBackgroundHeight(130);
  ctrl.setBackgroundColor(color(190,190,190));
  ctrl.setBarHeight(15);
  ctrl.activateEvent(true);
  ctrl.setColorLabel(color(255));
  ctrl.showArrow();
  ctrl.close();

  Knob cameraAngle = controlP5.addKnob("cameraAngle")
                              .setRange(0, 30)
                              .setValue(5)
                              .setPosition(20,40)
                              .setRadius(18)
                              .setNumberOfTickMarks(5)
                              .setTickMarkLength(4)
                              .snapToTickMarks(true)
                              .setDragDirection(Knob.HORIZONTAL);


  controlWidth = int(textWidth("updateBackground"))+ 8;
  Button updateButton = controlP5.addButton("updateBackground")
                                  .setValue(0)
                                  .setPosition(2,10)
                                  .setSize(controlWidth,20);

  controlWidth = int(textWidth("startDetection"))+25;
  Button startDetection = controlP5.addButton("startDetection")
                                   .setValue(0)
                                   .setPosition(43, 8)
                                   .setSize(controlWidth, 20);

  cameraAngle.setGroup(ctrl);
  updateButton.setGroup(ctrl);                            
}

void drawGUI()
{
  controlP5.show();
  controlP5.draw();
}

public void updateBackground(int inputValue)
{
    background(150);
    beforeTower = createImage(640, 40, RGB);
    PImage depthImage = context.depthImage();
    depthImage.loadPixels();
    dmap1 = context.depthMap();

    //Strip out error locations
    for (int i = 0; i<context.depthMapSize(); i++)
    {
      if (dmap1[i] == 0)  //Error value
        context.depthImage().pixels[i]=color(0,0,0);

      if (dmap1[i] > 800) //Irrelevant depths
        context.depthImage().pixels[i]=color(0,0,0);
    }

    //Save background image
    temp = context.depthImage();
    beforeTower = temp.get();
    fileName = sketchPath + java.io.File.separator + "beforeTower.jpg";
    beforeTower.save(fileName);
}

public void cameraAngle(int inputValue)
{
  println("not yet implemented!");
}

public void startDetection(int inputValue)
{
  if (!gameStarted && gameFinished)
  {
    gameStarted = true;
    controlP5.getController("startDetection").setLock(true);
    controlP5.getController("startDetection").setColorBackground(color(112,112,112));
    originalTowerLocations = mergeBlobs();
  }
  else if(!gameStarted)
    gameStarted = true;
  else  
  {
    controlP5.getController("startDetection").setLock(true);
    controlP5.getController("startDetection").setColorBackground(color(112,112,112));
    originalTowerLocations = mergeBlobs();
  }
  gameFinished = false;
}




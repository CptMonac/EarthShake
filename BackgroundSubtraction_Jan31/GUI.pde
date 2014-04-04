//Based on GUI.PDE from Generative Gestaltung by Harmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni

void setupGUI()
{
  int controlWidth = int(textWidth("Controls")) + 15;
  color activeColor = color(0, 130, 164);
  controlP5 = new ControlP5(this);
  ControlGroup ctrl = controlP5.addGroup("Controls", width - 130, 25, controlWidth);
  ctrl.setBackgroundHeight(100);
  ctrl.activateEvent(true);
  ctrl.setColorLabel(color(255));
  ctrl.showArrow();
  ctrl.close();

  Knob cameraAngle = controlP5.addKnob("cameraAngle")
                              .setRange(0, 30)
                              .setValue(5)
                              .setPosition(5,10)
                              .setRadius(20)
                              .setNumberOfTickMarks(5)
                              .setTickMarkLength(4)
                              .snapToTickMarks(true)
                              .setDragDirection(Knob.HORIZONTAL);


  controlWidth = int(textWidth("captureBackground"));
  Button captureButton = controlP5.addButton("captureBackground")
                                  .setValue(0)
                                  .setPosition(-5,70)
                                  .setSize(controlWidth,15);


  cameraAngle.setGroup(ctrl);
  captureButton.setGroup(ctrl);                            
}

void drawGUI()
{
  controlP5.show();
  controlP5.draw();
}

public void captureBackground(int inputValue)
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




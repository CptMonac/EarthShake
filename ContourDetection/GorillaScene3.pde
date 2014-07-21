void drawLegoContours_g()
{
  //Find all contours in input image
  ArrayList<Contour> towerContours = opencv.findContours();
  ArrayList<Contour> filteredContours = new ArrayList<Contour>();
  
  int adjust = 0;  
    
  //Filter contours to only lego towers
  for (Contour contour: towerContours)
  {
    if(contour.area() > 1500)
    {
      //Draw polygon approximation
      stroke(0, 0, 255);
      fill(0,0,255);

        beginShape();
        for (PVector point : contour.getPolygonApproximation().getPoints())
        {
          if (point.x < 640/2)
            adjust = 20;
          else
            adjust = -20;
          vertex(point.x+170+adjust, point.y-180);
        }
        endShape();
    }
  }
  fill(255, 255, 255);
}

void prediction_3a()
{
  
}


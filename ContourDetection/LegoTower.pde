public class LegoTower
{
  public Contour legoContour;
  public String towerType;
  public Rectangle towerBounds;
  public String towerStatus;
  
  LegoTower(Contour inputContour)
  {
    legoContour = inputContour;
    towerBounds = legoContour.getBoundingBox();
    determineTowerType();
    towerStatus = "Unknown status...";
  }

  void draw()
  {
    //Draw outline
    legoContour.draw();

    //Draw polygon approximation
    stroke(255, 0, 0);
    beginShape();
      for (PVector point : legoContour.getPolygonApproximation().getPoints())
      {
        vertex(point.x, point.y);
      }
    endShape();

    //Draw status
    text(towerStatus, towerBounds.x, towerBounds.y-15);

    //Draw type
    text(towerType, towerBounds.x, towerBounds.y - 30);
  }
  
  //Matches tower to database of lego towers
  void determineTowerType()
  {
    for(Map.Entry srcTower: towerDatabase.entrySet())
    {
      String srcTower_type = srcTower.getKey().toString();
      Contour srcContour = towerDatabase.get(srcTower_type);

      if (towerMatch(srcContour, legoContour))
      {
        towerType = srcTower_type;
        break;
      }
      else 
        towerType = "Unknown Tower";
    }
  }
}

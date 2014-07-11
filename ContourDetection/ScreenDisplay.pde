import controlP5.*;
ControlP5 controlP5;

public class ImagePanel extends JPanel 
{
  private BufferedImage image;
  
  public ImagePanel(BufferedImage img) {
    setImage(img);
  }
  
  public void setImage(BufferedImage img) {
    image = img;
    this.repaint();
  }
  
  @Override
  protected void paintComponent(Graphics g) {
    super.paintComponent(g);
    g.drawImage(image, 0, 0, null);
  }
}


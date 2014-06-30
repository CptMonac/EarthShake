public class BlobRect
{
  public float x;
  public float y;
  public float blobWidth;
  public float blobHeight;

  BlobRect()
  {
    x = 0;
    y = 0;
    blobWidth = 0;
    blobHeight = 0;
  }

  BlobRect(Blob inputBlob)
  {
    x = inputBlob.xMin*width;
    y = inputBlob.yMin*height;
    blobWidth = inputBlob.w*width;
    blobHeight = inputBlob.h*height;
  }

  BlobRect(float inputX, float inputY, float inputWidth, float inputHeight)
  {
    x = inputX;
    y = inputY;
    blobWidth = inputWidth;
    blobHeight = inputHeight;
  }

  public void updateBounds(float inputX, float inputY, float inputWidth, float inputHeight)
  {
    x = inputX;
    y = inputY;
    blobWidth = inputWidth;
    blobHeight = inputHeight;
  }
}

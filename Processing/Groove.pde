void setup()
{
  size(512, 512);
  background(0);
  
  noFill();
  stroke(255);
  strokeWeight(1);
  
  float v = 0.04 * height;
  while (v < 0.56 * height)
  {
    int n = 5 + (int)random(8);
    while (n > 0 && v < 0.56 * height)
    {
      line(0, v, width, v);
      v += 3;
      n--;
    }
    v += 6;
  }
    
  save("Groove.png");
}



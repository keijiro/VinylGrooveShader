int resolution = 1024;

float groove_start = 0.04 * resolution;
float groove_end = 0.56 * resolution;
float groove_interval = 2;
float song_length = 0.02 * resolution;
float song_interval = 0.006 * resolution;
float noise_strength = 0.2f;

float random_song_length()
{
  return random(0.7, 1.3) * song_length;
}

void draw_groove(int y)
{
  for (int x = 0; x < width; x++)
  {
    set(x, y, color(255 - random(noise_strength) * 255));
  }
}

void setup()
{
  size(resolution, resolution);
  background(0);
  noFill();
  stroke(255);
  
  float y = groove_start;
  float song = random_song_length();
  
  while (y < groove_end)
  {
    draw_groove((int)y);
    
    if (song > 0)
    {
      y += groove_interval;
      song -= 1;
    }
    else
    {
      y += song_interval;
      song = random_song_length();
    }
  }
  
  save("Groove.png");
}


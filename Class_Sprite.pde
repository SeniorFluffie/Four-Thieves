abstract class Sprite {
  // image array
  PImage[] images;
  // frame, timer, and run variables
  int startFrame, maxFrame, currentFrame;
  float fRate, timer = 0;
  boolean run;
  String name;
  // location and size variables
  float x, y, w, h;

  Sprite(String n, String fileType, int start, int max, float fr, boolean r) {
    name = n;
    startFrame = start;
    maxFrame = max;
    images = new PImage[maxFrame];
    fRate = 1000/(float)fr;
    run = r;
    timer = millis();

    // goes through all the images and displays the sprite
    for (int i = startFrame; i < maxFrame; i++) {
      String filename = name + i +"." + fileType;
      images[i] = loadImage(filename);
    }
  }
 abstract void display(float initX, float initY, float wid, float hei);
}
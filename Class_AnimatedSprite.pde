class AnimatedSprite extends Sprite {
  // constructor for the animated sprite
  AnimatedSprite(String n, String fileType, int start, int max, float fr, boolean r) {
    super(n, fileType, start, max, fr, r);
    currentFrame = 0;
  }

  // draw the animated sprite
  void display(float initX, float initY, float wid, float hei) {
    x = initX;
    y = initY;
    w = wid;
    h = hei;
    
    // continuously loop the animation of the sprite (as long as it is active)
    if (millis() > timer && run == true) {
      if (currentFrame + 1 < maxFrame) {
        currentFrame +=1;
        timer = millis();
      } else
        run = false;
      timer+=fRate;
    }
    image(images[currentFrame], x, y, w, h);
  }
}
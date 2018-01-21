  class StaticSprite extends Sprite {
    // constructor of a still image sprite
    StaticSprite(String n, String fileType, int start, int max, float fr, boolean r) {
      super(n, fileType, start, max, fr, r);
      currentFrame = 0;
    }
    
   // display function to draw the sprite
   void display(float initX, float initY, float wid, float hei) {
      x = initX;
      y = initY;
      w = wid;
      h = hei;
      
      // if the sprite is active, draw it
      if(run)
        image(images[currentFrame], x, y, w, h);
    } 
  }
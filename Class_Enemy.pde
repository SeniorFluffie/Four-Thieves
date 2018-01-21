class Enemy extends StaticSprite { 
  // setting up Enemy location and images
  float x, y;
  float speedx, speedy, introSpeed;
  // variables for Enemy stats
  int currentHP = 15, maxHP = 15, armor = 10;
  int moveCounter, moveTimer;
  int damageTimer = 50, damageCounter = damageTimer, hitImmunity = 255;
  int attackCounter = 0, attackTimer, attackDamage, attackDuration;
  float attackRadiusMax, attackRadiusMin;
  // setup variables to determine what state the object is in
  boolean isMoving = false, isAttacking = false;
  String type;

  // constructor
  Enemy(String name, float initX, float initY) {
    // default intializer (coordinates)
    super(name, "png", 0, 4, 60, true);
    x = initX*tileSize+20;
    y = initY*tileSize+20;
    w = tileSize;
    h = tileSize;
    type = name;
    
    // switch case (based on object name, assigns stat values)    
    switch(type) {
    case "goblin":
      maxHP = 20; 
      currentHP = maxHP; 
      armor = 5;
      attackTimer = (int) random(200, 375);
      attackRadiusMin = 0;
      attackRadiusMax = tileSize*1;
      attackDamage = 34;
      attackDuration = 100;
      moveTimer = int(random(100, 250));
      break;
    case "demon":
      maxHP = 22; 
      currentHP = maxHP; 
      armor = 4;
      attackTimer = (int) random(100, 225);
      attackRadiusMin = 0;
      attackRadiusMax = tileSize*1;
      attackDamage = 28;
      attackDuration = 50;
      moveTimer = int(random(50, 125));
      break;
    case "eye":
      maxHP = 14; 
      currentHP = maxHP; 
      armor = 5;
      attackTimer = (int) random(400, 550);
      attackRadiusMin = 0;
      attackRadiusMax = tileSize*2+1;
      attackDamage = 42;
      attackDuration = 200;
      moveTimer = int(random(300, 450));
      break;
    case "rat":
      maxHP = 18; 
      currentHP = maxHP; 
      armor = 6;
      attackTimer = (int) random(150, 300);
      attackRadiusMin = 0;
      attackRadiusMax = tileSize*2+1;
      attackDamage = 30;
      attackDuration = 75;
      moveTimer = int(random(150, 230));
      break;
    case "ragumiz":
      maxHP = 30; 
      currentHP = maxHP; 
      armor = 15;
      attackTimer = (int) random(150, 300);
      attackRadiusMin = 0;
      attackRadiusMax = tileSize*2+1;
      attackDamage = 50;
      attackDuration = 120;
      moveTimer = int(random(50, 150));
    }
  }

  // draw the object
  void display() {
    tint(255, hitImmunity);
    super.display(x, y, w, h);
  }

  // update the attack, damage, and counter timers (allows for immunity frames and attack frames) 
  void update() {
    if (damageCounter <= damageTimer) {
      damageCounter++;
      hitImmunity = 100;
    } else
      hitImmunity = 255;
    if (isAttacking) {
      attackCounter++;
      attack();
    }
  }

  // sprite movement in all possible directions
  void moveUp() {
    if (coords[mapNumber][(int)(y-tileSize)/tileSize][(int)(x/tileSize)] == 2 || coords[mapNumber][(int)(y-tileSize)/tileSize][(int)(x/tileSize)] == 3 || coords[mapNumber][(int)(y-tileSize)/tileSize][(int)(x/tileSize)] == 4)
      y-=tileSize;
  }
  void moveRight() {
    if (coords[mapNumber][(int)(y/tileSize)][(int)(x+tileSize)/tileSize] == 2 || coords[mapNumber][(int)(y/tileSize)][(int)(x+tileSize)/tileSize] == 3 || coords[mapNumber][(int)(y/tileSize)][(int)(x+tileSize)/tileSize] == 4) 
      x+=tileSize;
    currentFrame = 0;
  }
  void moveDown() {
    if (coords[mapNumber][(int)(y+tileSize)/tileSize][(int)(x/tileSize)] == 2 || coords[mapNumber][(int)(y+tileSize)/tileSize][(int)(x/tileSize)] == 3 || coords[mapNumber][(int)(y+tileSize)/tileSize][(int)(x/tileSize)] == 4)
      y+=tileSize;
  }
  void moveLeft() {
    if (coords[mapNumber][(int)(y/tileSize)][(int)(x-tileSize)/tileSize] == 2 || coords[mapNumber][(int)(y/tileSize)][(int)(x-tileSize)/tileSize] == 3 || coords[mapNumber][(int)(y/tileSize)][(int)(x-tileSize)/tileSize] == 4)
      x-=tileSize;
    currentFrame = 1;
  }

  // function to determine the randomized enemy movement
  void movement() {
    moveCounter++;
    if (moveCounter > moveTimer && moveCounter != 0 || isMoving) {
      isMoving = true;
      int z = (int) random(0, 4);
      if (z == 0)
        moveUp();
      else if (z == 1)
        moveRight();
      else if (z == 2)
        moveDown();
      else if (z == 3)
        moveLeft();
      if (type == "goblin")
        moveTimer = int(random(100, 250));
      else if (type == "demon")
        moveTimer = int(random(50, 125));
      else if (type == "eye")
        moveTimer = int(random(300, 450));
      else if (type == "rat")
        moveTimer = int(random(150, 230));
      moveCounter = 0;
      isMoving = false;
      return;
    }
  }

  // allows the enemy to take a specific amount of damage
  void takeDamage(int attack) {
    if (damageCounter > damageTimer && currentHP > 0) {
      int avg = maxHP / currentHP;
      currentHP -= (int) random((attack / armor)-avg, (attack / armor)+ avg);
      damageCounter = 0;
    }
  }

  // randomized attack states and timings depending on the enemy
  void attack() {
    attackCounter++;
    if (attackCounter > attackTimer - attackDuration) {
      isAttacking = true;
      if (currentFrame == 1)
        currentFrame = 3;
      else if (currentFrame == 0)
        currentFrame = 2;
    }
    if (attackCounter > attackTimer && isAttacking) {
      currentFrame = 0;
      if (type == "goblin") {
        goblinSound.trigger();
        attackTimer = (int) random(200, 375);
      } else if (type == "demon") {
        demonSound.trigger();
        attackTimer = (int) random(100, 225);
      } else if (type == "eye") {
        eyeSound.trigger();
        attackTimer = (int) random(400, 550);
      } else if (type == "rat") {
        ratSound.trigger();
        attackTimer = (int) random(150, 300);
      }
      attackCounter = 0;
      isAttacking = false;
      return;
    }
  }
}
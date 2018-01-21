class Thief extends StaticSprite { 
  // setting up thief location and images
  PImage thief;
  float x, y;
  float speedx, speedy, introSpeed;
  // frame and image related variables
  final int N = 0, E = 1, S = 2, W = 3;
  // variables for thief stats
  int currentHP, currentMana;
  int maxHP, maxMana, armor, exp = 0;
  int damageTimer = 60, damageCounter = damageTimer, hitImmunity = 255;
  int attackCounter = 0, attackTimer, attackDamage; 
  float attackRadiusMax, attackRadiusMin;
  boolean isAttacking = false;
  String type; 
  boolean alive = true;

  // constructor for the thief characters
  Thief(String name, float initX, float initY) {
    // preset tile size and image size
    super(name, "png", 0, 8, 60, true);
    x = initX*tileSize+20;
    y = initY*tileSize+20;
    w = tileSize;
    h = tileSize;
    type = name;
    
    // switch case for the different character stats (classes both M and F)
    switch(type) {
    case "thiefm":
      maxHP = 12; 
      maxMana = 13; 
      currentHP = maxHP; 
      currentMana = maxMana; 
      armor = 10;
      attackTimer = 10; 
      attackRadiusMin = tileSize*1;
      attackRadiusMax = tileSize*1;
      attackDamage = 30;
      break;
    case "thieff":
      maxHP = 10; 
      maxMana = 15; 
      currentHP = maxHP; 
      currentMana = maxMana; 
      armor = 10;
      attackTimer = 10; 
      attackRadiusMin = tileSize*1;
      attackRadiusMax = tileSize*1;
      attackDamage = 30;
      break;

    case "rangerm":
      maxHP = 10; 
      maxMana = 15; 
      currentHP = maxHP; 
      currentMana = maxMana; 
      armor = 9;
      attackTimer = 15; 
      attackRadiusMin = tileSize*2;
      attackRadiusMax = tileSize*2;
      attackDamage = 40;
      break;
    case "rangerf":
      maxHP = 10; 
      maxMana = 15; 
      currentHP = maxHP; 
      currentMana = maxMana; 
      armor = 7;
      attackTimer = 15; 
      attackRadiusMin = tileSize*2;
      attackRadiusMax = tileSize*2;
      attackDamage = 45;
      break;

    case "magem":
      maxHP = 15; 
      maxMana = 20; 
      currentHP = maxHP; 
      currentMana = maxMana; 
      armor = 10;
      attackTimer = 25; 
      attackRadiusMin = 0;
      attackRadiusMax = tileSize*1.5;
      attackDamage = 45;
      break;
    case "magef":
      maxHP = 15; 
      maxMana = 20; 
      currentHP = maxHP; 
      currentMana = maxMana; 
      armor = 10;
      attackTimer = 48; 
      attackRadiusMin = 0;
      attackRadiusMax = tileSize*1.5;
      attackDamage = 48;
      break;

    case "warriorm":
      maxHP = 18; 
      maxMana = 12; 
      currentHP = maxHP; 
      currentMana = maxMana; 
      armor = 9;
      attackTimer = 30; 
      attackRadiusMin = tileSize*1;
      attackRadiusMax = tileSize*2;
      attackDamage = 32;
      break;
    case "warriorf":
      maxHP = 17; 
      maxMana = 13; 
      currentHP = maxHP; 
      currentMana = maxMana; 
      armor = 11;
      attackTimer = 30; 
      attackRadiusMin = tileSize*1;
      attackRadiusMax = tileSize*2;
      attackDamage = 28;
      break;
    }
  }

  // draw the thief
  void display() {
    tint(255, hitImmunity);
    super.display(x, y, w, h);
  }

  // update the attack and damage timers and counters of the thief.
  void update() {
    if (currentHP <= 0) 
      alive = false;
    if (!alive) {
      for (int i = 0; i < fourThieves.length; i++) {
        if (fourThieves[i].alive) {
          fourThieves[i].x = fourThieves[selectedThief].x;
          fourThieves[i].y = fourThieves[selectedThief].y;
          selectedThief = i;
          break;
        }
      }
    }
    if (damageCounter <= damageTimer) {
      damageCounter++;
      hitImmunity = 100;
    } else
      hitImmunity = 255;
    if (isAttacking) {
      attackCounter++;
      attack();
    }
    attackDetection();
    collisionDetection();

    if (coords[mapNumber][(int)(y/tileSize)][(int)(x/tileSize)] == 14 && mapNumber > 0) {
      setupMaps();
      setupEnemies();
      x = startPos[mapNumber][0]*tileSize+20;
      y = startPos[mapNumber][1]*tileSize+20;
    } else if (coords[mapNumber][(int)(y/tileSize)][(int)(x/tileSize)] == 15 && mapNumber > 1) {
      mapNumber-=2;
      setupMaps();
      setupEnemies();
      x = endPos[mapNumber][0]*tileSize+20;
      y = endPos[mapNumber][1]*tileSize+20;
    }

    if (exp >= 100) {
      maxHP +=3;
      maxMana += 2;
      armor +=2;
      currentHP = maxHP;
      currentMana = maxMana;
      exp = 0;
    }
  }

  // ---------------------- CODE INVOLVING INTRO MOVEMENT START ------------ \\
  void moveTowardsChest() {
    x+=speedx;
    y+=speedy;
  }

  boolean yMove = false;
  void introPath() {
    if (yMove == false) {
      x+=(width-x)/65;
      currentFrame = E;
    } 

    if (x >= width-560 && y > height - 360) {
      yMove = true;
      y-=8;
      x+=(width-x)/55;
      currentFrame = N;
    }

    if (x >= width-400) {
      yMove = false;
      currentFrame = E;
    }
  }

  // Method to check if the intro path should restart the movement
  boolean isIntroFinished() {
    if (x > 770)
      return true;
    return false;
  }

  // ---------------------- CODE INVOLVING INTRO MOVEMENT END ------------ \\
  // movement of the thiefs in all possible directions
  void moveUp() {
    if (coords[mapNumber][(int)(y-tileSize)/tileSize][(int)(x/tileSize)] == 2 || coords[mapNumber][(int)(y-tileSize)/tileSize][(int)(x/tileSize)] == 3 || coords[mapNumber][(int)(y-tileSize)/tileSize][(int)(x/tileSize)] == 4 
      || coords[mapNumber][(int)(y-tileSize)/tileSize][(int)(x/tileSize)] == 14 || coords[mapNumber][(int)(y-tileSize)/tileSize][(int)(x/tileSize)] == 15)
      y-=tileSize;
    currentFrame = N;
  }
  void moveRight() {
    if (coords[mapNumber][(int)(y/tileSize)][(int)(x+tileSize)/tileSize] == 2 || coords[mapNumber][(int)(y/tileSize)][(int)(x+tileSize)/tileSize] == 3 || coords[mapNumber][(int)(y/tileSize)][(int)(x+tileSize)/tileSize] == 4 
      || coords[mapNumber][(int)(y/tileSize)][(int)(x+tileSize)/tileSize]  == 14 || coords[mapNumber][(int)(y/tileSize)][(int)(x+tileSize)/tileSize] == 15) 
      x+=tileSize;
    currentFrame = E;
  }
  void moveDown() {
    if (coords[mapNumber][(int)(y+tileSize)/tileSize][(int)(x/tileSize)] == 2 || coords[mapNumber][(int)(y+tileSize)/tileSize][(int)(x/tileSize)] == 3 || coords[mapNumber][(int)(y+tileSize)/tileSize][(int)(x/tileSize)] == 4 
      || coords[mapNumber][(int)(y+tileSize)/tileSize][(int)(x/tileSize)] == 14 || coords[mapNumber][(int)(y+tileSize)/tileSize][(int)(x/tileSize)] == 15)
      y+=tileSize;
    currentFrame = S;
  }
  void moveLeft() {
    if (coords[mapNumber][(int)(y/tileSize)][(int)(x-tileSize)/tileSize] == 2 || coords[mapNumber][(int)(y/tileSize)][(int)(x-tileSize)/tileSize] == 3 || coords[mapNumber][(int)(y/tileSize)][(int)(x-tileSize)/tileSize] == 4 
      || coords[mapNumber][(int)(y/tileSize)][(int)(x-tileSize)/tileSize] == 14 || coords[mapNumber][(int)(y/tileSize)][(int)(x-tileSize)/tileSize] == 15 && mapNumber > 1)
      x-=tileSize;
    currentFrame = W;
  }

  // function to be active when the thief takes damage
  void takeDamage(int attack) {
    if (damageCounter > damageTimer && currentHP > 0) {
      int avg = maxHP / currentHP;
      currentHP -= (int) random((attack / armor)-avg, (attack / armor)+ avg);
      damageCounter = 0;
    }
  }

  // different frames for when the thief attacks in each direction
  void attack() {
    switch(currentFrame) {
    case N:
      currentFrame = 4;
      break;

    case E:
      currentFrame = 5;
      break;

    case S:
      currentFrame = 6;
      break;

    case W:
      currentFrame = 7;
      break;
    }

    if (attackCounter > attackTimer) {
      currentFrame = currentFrame-4;
      attackCounter = 0;
      isAttacking = false;
      if (type.equals("magem") || type.equals("magef"))
        currentMana--;
      return;
    }
  }

  // function to determine if the thiefs attacks hit any entities
  void attackDetection() {
    for (int i = 0; i < numEnemies[mapNumber]; i++) {
      if (type.equals("magem") || type.equals("magef")) {
        if (getDist(enemies.get(i).x, enemies.get(i).y, fourThieves[selectedThief].x, fourThieves[selectedThief].y) >= attackRadiusMin && getDist(enemies.get(i).x, enemies.get(i).y, fourThieves[selectedThief].x, fourThieves[selectedThief].y) <= attackRadiusMax && fourThieves[selectedThief].isAttacking)
          enemies.get(i).takeDamage(attackDamage);
      } else {
        if (((((x - attackRadiusMin) == enemies.get(i).x || (x - attackRadiusMax) == enemies.get(i).x || (x + attackRadiusMin) == enemies.get(i).x || (x + attackRadiusMax) == enemies.get(i).x) && y == enemies.get(i).y) || 
          (((y - attackRadiusMin) == enemies.get(i).y || (y - attackRadiusMax) == enemies.get(i).y || (y + attackRadiusMin) == enemies.get(i).y || (y + attackRadiusMax) == enemies.get(i).y) && x == enemies.get(i).x) ||
          x == enemies.get(i).x && y == enemies.get(i).y) && isAttacking)
          enemies.get(i).takeDamage(attackDamage);
      }

      if (getDist(x, y, enemies.get(i).x, enemies.get(i).y) >= enemies.get(i).attackRadiusMin && getDist(x, y, enemies.get(i).x, enemies.get(i).y) <= enemies.get(i).attackRadiusMax && enemies.get(i).isAttacking)
        takeDamage(enemies.get(i).attackDamage);
    }
  }
  
  // function to determine if the thief collides with any enemies
  void collisionDetection() {
    for (int i = 0; i < numEnemies[mapNumber]; i++) {
      if (getDist(fourThieves[selectedThief].x, fourThieves[selectedThief].y, enemies.get(i).x, enemies.get(i).y) < 1)
        fourThieves[selectedThief].takeDamage(25);
    }
  }
}
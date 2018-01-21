class Item extends StaticSprite { 
  // setting up item location and images
  PImage Item;
  String n, t;
  int p;

  // constructor
  Item(String name, String title, int price) {
    super(name, "png", 0, 1, 60, true);
    n = name;
    t = title;
    p = price;
  }

  // draw function
  void display() {
    super.display(x, y, w, h);
  }
  
  // function to upgrade the characters stats (when purchased)
  void increaseStats() {
    for (Thief f : fourThieves) {
      if (n.equals("dmg")) 
        f.attackDamage+=5;
      else if (n.equals("amr")) 
        f.armor +=1;
      else if (n.equals("maxhp")) {
        f.maxHP+=2;
        f.currentHP = f.maxHP;
      } else if (n.equals("maxmana")) {
        f.maxMana+=2;
        f.currentMana = f.maxMana;
      } else if (n.equals("atkspeed")) 
        f.attackTimer-=2;
    }
  }
}
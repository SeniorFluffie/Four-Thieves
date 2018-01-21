// import sound and image libraries
import java.util.*;
import ddf.minim.*;
Minim minim;

// import the audio players and animated sprite objects
AudioPlayer curtainMusic, openingMusic, chestOpenSound, titleMusic, creationMusic, dungeonMusic, shopMusic;
AudioSample heartbeat, coinDrop, goblinSound, demonSound, eyeSound, ratSound;
AnimatedSprite curtain;
// import the map textures
PImage waterTexture, grassTexture, dirtTexture, stoneTexture1, stoneTexture2, stoneTexture3, wallTexture1, wallTexture2, wallTexture3, 
  blueflowerTexture, yellowFlowerTexture, pinkFlowerTexture, shrubTexture, doorTexture, stairTexture1, stairTexture2, UI, heart, coin, exp, mana, bow, shield, spear, sword, magic, decoy, stealth, blink, armor, shopWalls, shopCounter;
Thief fourThieves[];
// array of the map coordinates
final int tileSize = 40;
int mapNumber = -1;
PImage maps[][][] = new PImage[12][15][20];
int coords[][][] = {
  // intro screen map
  { {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 5, 2, 4, 2}, 
    {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 3, 2, 2}, 
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 12, 1, 1, 1, 1, 5, 2, 3}, 
    {0, 1, 1, 1, 1, 1, 1, 9, 1, 1, 1, 1, 1, 1, 1, 11, 1, 1, 7, 3}, 
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 2}, 
    {1, 1, 1, 1, 9, 1, 1, 11, 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 13}, 
    {1, 1, 1, 1, 1, 1, 1, 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 13}, 
    {1, 1, 10, 1, 1, 1, 1, 8, 8, 8, 8, 1, 1, 1, 1, 1, 10, 1, 7, 2}, 
    {1, 1, 1, 1, 1, 8, 8, 8, 8, 8, 1, 1, 1, 1, 1, 1, 1, 1, 7, 2}, 
    {8, 8, 8, 8, 8, 8, 8, 8, 8, 1, 1, 1, 1, 1, 1, 9, 1, 5, 3, 2}, 
    {8, 8, 8, 8, 8, 8, 8, 11, 1, 1, 12, 1, 9, 1, 1, 1, 5, 2, 2, 3}, 
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 12, 1, 1, 1, 6, 4, 2, 2}, 
    {1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 11, 1, 5, 2, 2, 2}, 
    {1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 5, 2, 4, 2}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 6, 2, 2, 3} }, 
  // first dungeon room map
  { {7, 5, 5, 6, 5, 5, 5, 5, 6, 7, 7, 5, 5, 6, 5, 5, 5, 5, 6, 7}, 
    {5, 2, 3, 2, 2, 2, 3, 2, 4, 3, 2, 5, 6, 4, 3, 4, 2, 2, 14, 5}, 
    {5, 2, 6, 5, 2, 4, 2, 2, 5, 3, 2, 5, 2, 2, 3, 5, 5, 2, 2, 6}, 
    {5, 4, 5, 2, 2, 2, 5, 5, 3, 5, 3, 4, 2, 3, 6, 5, 5, 3, 2, 5}, 
    {15, 2, 2, 3, 3, 5, 4, 3, 2, 4, 2, 3, 2, 5, 6, 5, 2, 3, 5, 5}, 
    {7, 2, 4, 6, 5, 2, 2, 3, 5, 3, 2, 2, 6, 5, 5, 5, 2, 5, 5, 7}, 
    {7, 3, 3, 2, 5, 3, 3, 6, 5, 5, 3, 4, 2, 3, 6, 5, 3, 4, 5, 7}, 
    {5, 4, 2, 4, 5, 4, 2, 3, 6, 2, 2, 3, 2, 2, 5, 6, 2, 2, 3, 5}, 
    {5, 3, 2, 6, 5, 5, 3, 2, 5, 2, 4, 5, 6, 2, 2, 4, 2, 5, 4, 5}, 
    {6, 2, 2, 5, 5, 3, 2, 4, 3, 5, 3, 2, 5, 4, 5, 2, 3, 2, 3, 5}, 
    {5, 2, 4, 2, 2, 2, 3, 2, 2, 5, 2, 3, 4, 2, 2, 5, 3, 4, 2, 6}, 
    {7, 6, 5, 5, 5, 5, 6, 5, 5, 7, 7, 5, 6, 5, 5, 5, 6, 5, 5, 7}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
  {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}}, 
  // second dungeon room map
  { {7, 6, 5, 5, 6, 5, 5, 5, 6, 7, 7, 5, 6, 6, 5, 5, 5, 5, 5, 7}, 
    {5, 4, 3, 4, 3, 2, 4, 3, 3, 2, 2, 2, 3, 4, 6, 15, 3, 5, 3, 5}, 
    {6, 2, 5, 2, 2, 4, 3, 2, 5, 2, 2, 2, 6, 5, 5, 3, 4, 5, 2, 6}, 
    {5, 2, 3, 5, 6, 5, 5, 4, 2, 6, 2, 3, 5, 4, 2, 2, 3, 6, 4, 5}, 
    {6, 2, 2, 4, 3, 2, 6, 5, 2, 5, 3, 2, 6, 4, 3, 2, 5, 3, 2, 5}, 
    {7, 6, 5, 2, 5, 6, 5, 4, 2, 5, 3, 2, 6, 2, 4, 5, 2, 4, 3, 7}, 
    {7, 4, 5, 2, 2, 14, 6, 3, 5, 5, 4, 2, 6, 2, 5, 2, 4, 3, 2, 7}, 
    {5, 2, 6, 3, 5, 5, 6, 2, 4, 6, 2, 3, 5, 2, 4, 3, 4, 2, 2, 5}, 
    {5, 3, 5, 2, 4, 3, 6, 5, 2, 6, 2, 2, 6, 5, 5, 4, 3, 2, 5, 6}, 
    {6, 2, 3, 5, 2, 4, 5, 2, 3, 6, 2, 4, 5, 4, 3, 2, 2, 4, 3, 5}, 
    {6, 2, 2, 4, 3, 4, 5, 2, 6, 6, 2, 3, 3, 2, 4, 3, 5, 2, 4, 5}, 
    {7, 6, 5, 5, 6, 5, 6, 5, 5, 7, 7, 6, 5, 6, 6, 5, 5, 6, 5, 7}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
  {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}}, 
  // third dungeon room map
  {
    {7, 6, 5, 5, 6, 5, 6, 6, 5, 7, 7, 5, 5, 6, 5, 6, 5, 5, 6, 7}, 
    {5, 3, 4, 2, 2, 3, 4, 2, 4, 3, 4, 6, 6, 5, 5, 2, 2, 3, 3, 6}, 
    {5, 4, 2, 3, 2, 3, 5, 2, 4, 3, 4, 2, 2, 3, 2, 4, 3, 2, 4, 6}, 
    {5, 2, 3, 6, 2, 5, 5, 4, 2, 6, 3, 4, 2, 2, 5, 4, 3, 2, 4, 5}, 
    {6, 2, 2, 3, 4, 2, 4, 6, 5, 4, 5, 3, 6, 5, 2, 2, 4, 3, 2, 5}, 
    {7, 2, 4, 6, 3, 4, 2, 2, 5, 3, 4, 5, 2, 4, 4, 3, 2, 2, 4, 7}, 
    {7, 3, 6, 2, 5, 15, 4, 3, 6, 4, 4, 6, 14, 3, 2, 2, 5, 5, 5, 7}, 
    {6, 5, 3, 4, 2, 4, 2, 4, 5, 3, 2, 6, 4, 4, 3, 5, 2, 5, 5, 5}, 
    {6, 2, 4, 3, 4, 4, 2, 5, 6, 2, 3, 2, 5, 5, 6, 4, 2, 4, 3, 5}, 
    {6, 2, 2, 5, 5, 2, 6, 3, 4, 2, 2, 3, 3, 4, 4, 3, 3, 2, 2, 5}, 
    {6, 3, 3, 3, 4, 2, 2, 4, 3, 2, 2, 4, 3, 4, 4, 3, 5, 3, 3, 5}, 
    {7, 6, 5, 5, 6, 5, 5, 5, 6, 7, 7, 5, 5, 6, 5, 5, 6, 5, 5, 7}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
  {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}}, 
  // fourth dungeon room map
  { {7, 6, 5, 5, 6, 5, 5, 5, 6, 7, 7, 5, 5, 5, 5, 6, 6, 5, 5, 7}, 
    {5, 3, 2, 3, 3, 2, 6, 5, 5, 2, 4, 3, 4, 2, 2, 4, 3, 2, 2, 6}, 
    {5, 4, 3, 4, 2, 2, 2, 6, 4, 3, 2, 2, 4, 2, 3, 4, 4, 6, 2, 5}, 
    {6, 5, 3, 2, 5, 4, 2, 4, 3, 4, 6, 5, 5, 5, 6, 2, 2, 4, 3, 5}, 
    {6, 5, 2, 4, 6, 3, 4, 2, 2, 3, 5, 5, 6, 5, 5, 2, 4, 2, 3, 5}, 
    {7, 4, 4, 4, 6, 5, 6, 5, 6, 5, 5, 3, 2, 2, 2, 3, 2, 4, 2, 7}, 
    {7, 3, 3, 2, 4, 2, 3, 4, 4, 3, 5, 2, 15, 2, 2, 3, 4, 5, 2, 7}, 
    {6, 4, 5, 4, 3, 2, 6, 4, 3, 4, 5, 2, 4, 4, 3, 2, 4, 2, 3, 5}, 
    {5, 5, 4, 2, 2, 6, 4, 5, 2, 3, 5, 6, 5, 5, 5, 4, 4, 2, 3, 6}, 
    {5, 2, 2, 4, 6, 2, 3, 4, 5, 4, 3, 2, 2, 4, 5, 4, 3, 6, 4, 5}, 
    {5, 2, 2, 4, 3, 4, 2, 2, 3, 5, 4, 2, 4, 14, 5, 4, 3, 2, 2, 6}, 
    {7, 6, 5, 5, 6, 5, 5, 6, 5, 7, 7, 5, 5, 5, 6, 5, 5, 5, 6, 7}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
  {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}}, 
  // five dungeon room map
  { {7, 6, 5, 5, 6, 5, 5, 6, 5, 7, 7, 5, 5, 6, 5, 5, 6, 5, 5, 7}, 
    {5, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 6}, 
    {5, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 5}, 
    {6, 2, 4, 2, 3, 2, 3, 3, 4, 4, 2, 3, 2, 2, 4, 3, 3, 3, 4, 5}, 
    {5, 17, 17, 17, 17, 17, 17, 4, 3, 2, 2, 3, 17, 17, 17, 17, 17, 17, 17, 6}, 
    {7, 2, 4, 3, 2, 4, 4, 3, 3, 2, 2, 4, 2, 3, 4, 2, 2, 3, 4, 7}, 
    {7, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 7}, 
    {5, 2, 4, 2, 3, 2, 4, 2, 2, 3, 3, 4, 2, 3, 4, 4, 2, 3, 2, 5}, 
    {6, 4, 2, 3, 4, 2, 3, 2, 4, 2, 3, 4, 4, 2, 3, 2, 4, 2, 3, 5}, 
    {5, 4, 2, 2, 2, 3, 4, 2, 2, 4, 3, 3, 3, 2, 4, 4, 2, 3, 3, 6}, 
    {5, 5, 6, 5, 5, 14, 6, 5, 5, 5, 6, 5, 5, 5, 15, 5, 5, 6, 5, 5}, 
    {7, 6, 5, 5, 5, 6, 5, 5, 5, 7, 7, 5, 6, 5, 5, 5, 5, 6, 5, 7}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
  {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}}, 
  // six dungeon room map
  {  {7, 5, 5, 5, 5, 5, 5, 5, 5, 7, 7, 5, 5, 5, 5, 5, 5, 5, 5, 7}, 
    {5, 3, 2, 2, 2, 3, 4, 2, 3, 2, 2, 5, 4, 3, 2, 6, 2, 4, 3, 5}, 
    {5, 2, 2, 5, 3, 5, 4, 5, 6, 5, 2, 6, 2, 5, 3, 5, 2, 14, 4, 5}, 
    {5, 5, 5, 6, 2, 5, 3, 2, 4, 2, 3, 5, 2, 5, 2, 5, 4, 3, 2, 5}, 
    {5, 2, 3, 4, 2, 3, 2, 5, 2, 6, 4, 3, 2, 2, 4, 2, 3, 6, 5, 5}, 
    {7, 2, 5, 4, 5, 3, 2, 6, 2, 5, 4, 5, 5, 3, 5, 6, 2, 5, 2, 7}, 
    {7, 4, 6, 3, 6, 2, 2, 4, 3, 2, 2, 3, 4, 2, 3, 2, 4, 3, 2, 7}, 
    {5, 2, 5, 4, 5, 5, 5, 5, 5, 6, 5, 3, 5, 2, 2, 4, 3, 2, 2, 5}, 
    {5, 4, 3, 2, 2, 2, 3, 6, 4, 2, 3, 2, 5, 2, 5, 5, 4, 6, 5, 5}, 
    {5, 3, 2, 2, 3, 2, 4, 5, 2, 3, 2, 2, 4, 3, 2, 2, 2, 5, 3, 5}, 
    {5, 4, 5, 5, 2, 15, 2, 5, 3, 6, 4, 3, 5, 3, 2, 6, 2, 4, 3, 5}, 
    {7, 5, 5, 5, 5, 5, 5, 5, 5, 7, 7, 5, 5, 5, 5, 5, 5, 5, 5, 7}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
  {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}}, 
  // seventh dungeon map
  {  {7, 5, 5, 5, 5, 5, 5, 5, 5, 7, 7, 5, 5, 5, 5, 5, 5, 5, 5, 7}, 
    {5, 2, 3, 2, 4, 5, 3, 3, 2, 3, 2, 3, 3, 4, 3, 2, 5, 15, 5, 5}, 
    {5, 3, 3, 2, 4, 6, 3, 2, 3, 5, 5, 6, 3, 2, 4, 3, 6, 3, 6, 5}, 
    {5, 2, 3, 2, 2, 5, 3, 3, 4, 5, 2, 5, 4, 3, 3, 2, 5, 2, 5, 5}, 
    {5, 3, 4, 3, 3, 2, 3, 2, 4, 5, 3, 5, 3, 2, 2, 3, 3, 4, 6, 5}, 
    {7, 2, 5, 6, 5, 6, 5, 5, 5, 6, 2, 5, 6, 5, 5, 5, 6, 5, 5, 7}, 
    {7, 3, 5, 14, 3, 4, 2, 3, 2, 3, 3, 4, 2, 3, 2, 3, 4, 3, 2, 7}, 
    {5, 3, 6, 5, 5, 5, 3, 5, 5, 6, 5, 5, 6, 5, 5, 6, 2, 5, 4, 5}, 
    {5, 3, 2, 3, 3, 6, 2, 5, 4, 3, 2, 3, 3, 2, 3, 5, 4, 5, 3, 5}, 
    {5, 3, 2, 3, 4, 5, 5, 6, 3, 2, 3, 3, 3, 2, 3, 5, 6, 5, 4, 5}, 
    {5, 3, 2, 3, 2, 3, 3, 4, 3, 2, 2, 3, 3, 4, 3, 2, 3, 3, 2, 5}, 
    {7, 5, 5, 5, 5, 5, 5, 5, 5, 7, 7, 5, 5, 5, 5, 5, 5, 5, 5, 7}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
  {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}}, 
  // eighth dungeon map
  {  {7, 5, 5, 5, 5, 5, 5, 5, 5, 7, 7, 5, 5, 5, 5, 5, 5, 5, 5, 7}, 
    {5, 4, 6, 3, 2, 3, 3, 3, 2, 4, 5, 2, 5, 3, 6, 2, 5, 4, 6, 5}, 
    {5, 2, 2, 3, 4, 5, 2, 5, 2, 4, 3, 2, 2, 4, 3, 2, 4, 5, 2, 5}, 
    {5, 3, 5, 4, 6, 4, 5, 3, 6, 2, 5, 2, 2, 3, 5, 4, 6, 2, 5, 5}, 
    {5, 2, 3, 5, 4, 2, 2, 3, 4, 5, 2, 6, 2, 5, 3, 2, 3, 6, 4, 5}, 
    {7, 2, 5, 3, 2, 4, 5, 3, 2, 2, 5, 3, 4, 2, 6, 3, 5, 2, 5, 7}, 
    {7, 6, 4, 15, 2, 6, 3, 2, 4, 5, 2, 3, 2, 6, 4, 3, 4, 2, 3, 7}, 
    {5, 2, 6, 3, 5, 4, 2, 3, 5, 2, 6, 3, 5, 3, 4, 2, 5, 2, 6, 5}, 
    {5, 3, 2, 6, 4, 5, 3, 5, 2, 5, 2, 3, 4, 5, 2, 6, 3, 5, 2, 5}, 
    {5, 4, 5, 2, 3, 2, 4, 2, 3, 2, 3, 4, 5, 2, 3, 2, 14, 4, 6, 5}, 
    {5, 2, 2, 3, 4, 5, 2, 6, 2, 2, 3, 5, 4, 5, 2, 5, 3, 5, 2, 5}, 
    {7, 5, 5, 5, 5, 5, 5, 5, 5, 7, 7, 5, 5, 5, 5, 5, 5, 5, 5, 7}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
  {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}}, 
  // ninth dungeon map
  {   {7, 5, 5, 5, 5, 5, 5, 5, 5, 7, 7, 5, 5, 5, 5, 5, 5, 5, 5, 7}, 
    {5, 4, 2, 3, 2, 5, 3, 3, 4, 6, 5, 2, 2, 3, 5, 4, 3, 2, 2, 5}, 
    {5, 4, 5, 6, 3, 2, 5, 6, 2, 5, 6, 4, 6, 5, 3, 2, 6, 5, 2, 5}, 
    {5, 3, 5, 3, 3, 4, 2, 2, 3, 4, 3, 3, 2, 2, 4, 3, 2, 5, 2, 5}, 
    {5, 4, 5, 3, 5, 6, 2, 3, 5, 2, 4, 6, 3, 2, 5, 6, 2, 6, 4, 5}, 
    {7, 3, 6, 2, 5, 2, 5, 5, 6, 4, 3, 5, 5, 5, 2, 5, 2, 5, 4, 7}, 
    {7, 3, 5, 2, 5, 2, 4, 3, 5, 2, 2, 5, 4, 3, 4, 5, 2, 5, 2, 7}, 
    {5, 3, 5, 4, 6, 2, 2, 3, 5, 5, 5, 6, 4, 2, 2, 6, 3, 5, 4, 5}, 
    {5, 6, 2, 2, 3, 5, 4, 2, 2, 5, 5, 3, 4, 2, 5, 2, 2, 3, 6, 5}, 
    {5, 4, 2, 3, 2, 6, 5, 2, 6, 5, 5, 5, 4, 5, 6, 3, 2, 2, 4, 5}, 
    {5, 3, 2, 14, 2, 3, 4, 2, 3, 5, 6, 2, 4, 2, 3, 2, 15, 4, 2, 5}, 
    {7, 5, 5, 5, 5, 5, 5, 5, 5, 7, 7, 5, 5, 5, 5, 5, 5, 5, 5, 7}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
  {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}}, 
  // tenth dungeon map
  {   {7, 6, 5, 5, 6, 5, 5, 6, 5, 7, 7, 5, 5, 6, 5, 5, 6, 5, 5, 7}, 
    {5, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 6}, 
    {5, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 5}, 
    {6, 2, 4, 2, 3, 2, 3, 3, 4, 4, 2, 3, 2, 2, 4, 3, 3, 3, 4, 5}, 
    {5, 17, 17, 17, 17, 17, 17, 4, 3, 2, 2, 3, 17, 17, 17, 17, 17, 17, 17, 6}, 
    {7, 2, 4, 3, 2, 4, 4, 3, 3, 2, 2, 4, 2, 3, 4, 2, 2, 3, 4, 7}, 
    {7, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 7}, 
    {5, 2, 4, 2, 3, 2, 4, 2, 2, 3, 3, 4, 2, 3, 4, 4, 2, 3, 2, 5}, 
    {6, 4, 2, 3, 4, 2, 3, 2, 4, 2, 3, 4, 4, 2, 3, 2, 4, 2, 3, 5}, 
    {5, 4, 2, 2, 2, 3, 4, 2, 2, 4, 3, 3, 3, 2, 4, 4, 2, 3, 3, 6}, 
    {5, 5, 6, 5, 5, 15, 6, 5, 5, 5, 6, 5, 5, 5, 14, 5, 5, 6, 5, 5}, 
    {7, 6, 5, 5, 5, 6, 5, 5, 5, 7, 7, 5, 6, 5, 5, 5, 5, 6, 5, 7}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
  {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}}, 
  // elenventh dungeon map
  { {7, 5, 6, 5, 5, 5, 6, 5, 5, 7, 7, 5, 6, 5, 5, 5, 5, 6, 5, 7}, 
    {5, 3, 3, 2, 4, 3, 3, 3, 2, 2, 3, 4, 2, 2, 3, 2, 4, 2, 3, 6}, 
    {5, 4, 4, 2, 3, 2, 4, 4, 3, 2, 2, 4, 4, 3, 2, 2, 2, 3, 4, 5}, 
    {6, 2, 4, 4, 3, 2, 2, 3, 4, 4, 2, 3, 2, 2, 4, 3, 2, 4, 4, 5}, 
    {5, 3, 2, 2, 3, 2, 4, 2, 3, 4, 4, 3, 2, 2, 2, 3, 2, 4, 2, 6}, 
    {7, 3, 4, 2, 4, 3, 4, 2, 2, 3, 2, 4, 2, 3, 4, 2, 2, 3, 4, 7}, 
    {7, 2, 4, 3, 2, 2, 4, 3, 2, 4, 2, 2, 3, 4, 2, 4, 2, 3, 2, 7}, 
    {5, 4, 2, 3, 4, 2, 2, 3, 4, 2, 4, 3, 3, 4, 2, 3, 3, 2, 4, 5}, 
    {6, 2, 4, 3, 4, 2, 2, 3, 3, 4, 2, 3, 2, 3, 3, 4, 2, 3, 4, 5}, 
    {5, 4, 2, 3, 2, 2, 3, 4, 2, 4, 4, 3, 2, 4, 2, 3, 2, 4, 2, 6}, 
    {5, 4, 3, 3, 2, 2, 3, 4, 2, 4, 2, 3, 2, 4, 3, 2, 15, 2, 3, 5}, 
    {7, 6, 5, 5, 5, 6, 5, 5, 5, 7, 7, 5, 6, 5, 5, 5, 5, 6, 5, 7}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
    {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}, 
  {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}}
};

void setup() {
  size(800, 600);
  frameRate(20);
  minim = new Minim(this);
  openingMusic = minim.loadFile("openingMusic.mp3");
  curtainMusic = minim.loadFile("applause.mp3");
  curtainMusic.cue(5000);
  chestOpenSound = minim.loadFile("chestOpenSound.mp3");
  chestOpenSound.setGain(-10);
  titleMusic = minim.loadFile("titleMusic.mp3");
  dungeonMusic = minim.loadFile("dungeonMusic.wav");
  creationMusic = minim.loadFile("creationMusic.mp3");
  heartbeat = minim.loadSample("heartbeat.mp3");
  coinDrop = minim.loadSample("coinDrop.mp3");
  goblinSound = minim.loadSample("goblinSound.mp3");
  demonSound = minim.loadSample("demonSound.mp3");
  eyeSound = minim.loadSample("eyeSound.mp3");
  ratSound = minim.loadSample("ratSound.mp3");
  // setup the animations
  curtain = new AnimatedSprite("curtain", "gif", 0, 12, 10, true);

  // fonts
  font = createFont("titleFont.TTF", 70);
  pixelFont = createFont("pixelFont.TTF", 70);
  endFont = loadFont("Pieces.vlw");

  // setup Textures
  imageMode(CENTER);
  waterTexture = loadImage("water0.png");
  grassTexture = loadImage("grass0.png");
  stoneTexture1 = loadImage("stone0.png");
  stoneTexture2 = loadImage("stone1.png");
  stoneTexture3 = loadImage("stone2.png");
  wallTexture1 = loadImage("wall0.png");
  wallTexture2 = loadImage("wall1.png");
  wallTexture3 = loadImage("wall2.png");
  dirtTexture = loadImage("dirt0.png");
  blueflowerTexture = loadImage("blueflower0.png");
  yellowFlowerTexture = loadImage("yellowflower0.png");
  pinkFlowerTexture = loadImage("pinkflower0.png");
  shrubTexture = loadImage("shrub0.png");
  doorTexture = loadImage("door0.png");
  stairTexture1 = loadImage("stair0.png");
  stairTexture2 = loadImage("stair1.png");
  UI = loadImage("UI0.png");
  shopWalls = loadImage("shop0.png");
  shopCounter = loadImage("shop1.png");
  heart = loadImage("heart0.png");
  coin = loadImage("goldCoin1.png");
  exp = loadImage("exp0.png");
  mana = loadImage("mana0.png");
  bow = loadImage("bow0.png");
  shield = loadImage("shield0.png");
  spear = loadImage("spear0.png");
  sword = loadImage("sword0.png");
  decoy = loadImage("decoy0.png");
  magic = loadImage("magic0.png");
  blink = loadImage("blink0.png");
  stealth = loadImage("stealth0.png");
  armor = loadImage("armor0.png");
  // setup the shop images
  shopItems = new Item[5];
  shopItems[0] = new Item("dmg", "Damage Boost", 6);
  shopItems[1]= new Item("amr", "Armor Boost", 6);
  shopItems[2]= new Item("maxhp", "Max HP Boost", 8);
  shopItems[3]= new Item("maxmana", "Max Mana Boost", 8);
  shopItems[4]= new Item("atkspeed", "Attack Speed Boost", 10);

  mapNumber = -1;
  setupMaps();
  // setup the intro Thief
  initialThief = new Thief("thiefm", 0, 9.5);
}

Item[] shopItems;

void draw() {
  clear();
  if (curtainIntro || chestIntro || titleIntro)
    introScreen();
  else if (characterCreation) 
    characterCreation();
  else if (playGame) 
    playGame();
  else if (gameOver)
    gameOver();
}

// -------------------------- CODE INVOLVING INTRO START ---paint--------- \\
PFont font, pixelFont;
float fadeIn=255, fadeOut = 0, titleFade = 0, mapFade = 0, mapFadeTimer = 255;
boolean curtainIntro = true, chestIntro = false, titleIntro = false, gameOver = false;
boolean characterCreation = false, playGame = false;
int blinkTimer = 150, blinkCounter = 0, introThiefCounter = 0; 
Thief[] introThief = new Thief[4];
float[][] characterPos = {{0.5, 0.5}, {0.5, 13.5}, {18.5, 0.5}, {18.5, 13.5}};
StaticSprite chest;
Thief initialThief;

void introScreen() {
  // introScreen properties and settings
  frameRate(60);
  textSize(60);
  // play the intro screen
  if (curtainIntro) {
    background(fadeIn);
    // stops the background from changing when it turns white
    if (fadeIn == 0) {
      fadeIn = 0;
      curtainMusic.play();
      // displays the curtain animation, when it is not on the last frame
      if (curtain.currentFrame < curtain.maxFrame-1 && curtainIntro) 
        curtain.display(width/2, height/2, width, height);
      // on the last frame, stop the animation from looping/running
      else {
        curtain.run = false;
        curtainIntro = false;
        chestIntro = true;
      }
      // increments the background to turn white, from black
    } else
      fadeIn-=1;
  } 
  // if the curtain is done the animation, then...
  else if (chestIntro) {
    background(0);
    openingMusic.play();
    blinkCounter++;
    // make the background blink (using the timer variables)
    if (blinkCounter > 50 && blinkCounter < 100) 
      background(255);

    // ater it blinks create each character and then display them
    if (blinkCounter > blinkTimer && introThiefCounter < 4) {
      heartbeat.trigger();
      introThief[introThiefCounter] = new Thief("thiefm", characterPos[introThiefCounter][0], characterPos[introThiefCounter][1]);
      introThief[introThiefCounter].currentFrame = 2;
      introThiefCounter++;
      blinkCounter = 0;
    }
    for (int i = 0; i < introThiefCounter; i++)
      introThief[i].display();
    if (blinkCounter > 50 && blinkCounter < 100) 
      background(255);

    if (chest != null) {
      chest.display(width/2, height/2, 100, 100);
      for (int i = 0; i <introThiefCounter; i++) {
        if (getDist(chest.x, chest.y, introThief[i].x, introThief[i].y) > 10) {
          introThief[i].speedx= (chest.x-introThief[i].x)/(tileSize);
          introThief[i].speedy= (chest.y-introThief[i].y)/(tileSize);
          introThief[i].moveTowardsChest();
        } else {
          chestOpenSound.play();
          chest.currentFrame = 1;
          fill(255, 255, 255, fadeOut);
          strokeWeight(3);
          ellipse(chest.x, chest.y, fadeOut*8, fadeOut*8);
          fadeOut+=0.5;
          fill(255, 0, 0);
          if (fadeOut > width / 4 ) {
            background(255);
            titleIntro = true;
            chestIntro = false;
            openingMusic.shiftGain(openingMusic.getGain(), -100, 3000);
            titleMusic.shiftGain(-100, -16, 3000);
          }
        }
      }
    } else if (introThiefCounter == 4 && blinkCounter > blinkTimer) {
      chest = new StaticSprite("chest", "png", 0, 2, 0, true);
    }
  } else if (titleIntro) {
    titleMusic.play();
    clear();
    if (mapFade < mapFadeTimer)
      mapFade+=3;
    tint(255, mapFade);
    drawMap();
    initialThief.hitImmunity = (int) (width - initialThief.x - 20);
    initialThief.display();
    initialThief.introPath();

    if (initialThief.isIntroFinished()) {
      initialThief.x = 0; 
      initialThief.y = 400;
      initialThief.yMove = false;
    }
    textAlign(NORMAL);
    textFont(font);
    fill(0, 0, 0, mapFade);
    text("Four Thieves", width/4-2, height/3.5);
    text("Four Thieves", width/4+2, height/3.5);
    text("Four Thieves", width/4, height/3.5+2);
    text("Four Thieves", width/4, height/3.5-2);
    text("Click to Start", width/2-200-2, height-100);
    text("Click to Start", width/2-200+2, height-100);
    text("Click to Start", width/2-200, height-100+2);
    text("Click to Start", width/2-200, height-100-2);
    fill(random(139, 255), 0, 0, mapFade);
    text("Click to Start", width/2-200, height-100);
    titleFade+=2;
    text("Four Thieves", width/4, height/3.5);

    if (mousePressed && mapFade >= mapFadeTimer) {
      titleIntro = false;
      characterCreation = true;
      fourThieves = new Thief[4];
      titleMusic.shiftGain(titleMusic.getGain(), -100, 3000);
      creationMusic.shiftGain(-100, -20, 3000);
    }
  }
}

double getDist(float x1, float y1, float x2, float y2) {
  return Math.sqrt(Math.pow(x1-x2, 2) + Math.pow(y1-y2, 2));
}
// -------------------------- CODE INVOLVING INTRO END ------------ \\
// ----------------- CODE INVOLVING CHARACTER CREATION START ------------ \\
String primaryCounter = "", secondaryCounter = "";  
String gender = "M";
int genderSwap = 0, genderSwapTimer = 15;
int characterCount = 0, bgCol = 1, colIncrement = 1;
void characterCreation() {
  creationMusic.play();
  textFont(pixelFont);
  int creationSlotX = 100, creationSlotY = 100, creationSlotD = 65;

  bgCol+=colIncrement;
  if (bgCol >= 255)
    colIncrement=-2;
  else if (bgCol <= 0)
    colIncrement=2;

  background(100, bgCol, bgCol);
  textSize(15);
  strokeWeight(5);
  noFill();
  rectMode(CENTER);

  // setup primary weapon
  if (characterCount < 4) {
    fill(0);
    if (mousePressed && mouseX < creationSlotX-50 + creationSlotD/2 && mouseX > creationSlotX-50 - creationSlotD/2 && mouseY < creationSlotY + creationSlotD/2 && mouseY > creationSlotY - creationSlotD/2 && mouseButton==LEFT) {
      primaryCounter = "thief";
    } else if (mousePressed && mouseX < creationSlotX + 100 + creationSlotD/2 && mouseX >creationSlotX + 100 - creationSlotD/2 && mouseY < creationSlotY + creationSlotD/2 &&mouseY > creationSlotY - creationSlotD/2 && mouseButton == LEFT) {
      primaryCounter = "mage";
    } else if (mousePressed && mouseX < creationSlotX + 500 + creationSlotD/2 && mouseX > creationSlotX + 500 - creationSlotD/2 && mouseY < creationSlotY + creationSlotD/2 && mouseY > creationSlotY - creationSlotD/2 && mouseButton == LEFT) {
      primaryCounter = "ranger";
    } else if (mousePressed && mouseX< creationSlotX + 650 + creationSlotD/2 && mouseX > creationSlotX + 650 - creationSlotD/2 && mouseY < creationSlotY + creationSlotD/2 && mouseY > creationSlotY - creationSlotD/2 && mouseButton == LEFT) {
      primaryCounter = "warrior";
    } 

    // setup secondary weapon
    if (mousePressed && mouseX < creationSlotX - 50 + creationSlotD/2 && mouseX > creationSlotX - 50 - creationSlotD/2 && mouseY < creationSlotY + 150 + creationSlotD/2 && mouseY > creationSlotY + 150 - creationSlotD/2 && mouseButton == LEFT && primaryCounter != "") {
      secondaryCounter = "magic";
    } else if (mousePressed && mouseX < creationSlotX + 80 + creationSlotD/2 && mouseX > creationSlotX + 80 - creationSlotD/2 && mouseY < creationSlotY + 150 + creationSlotD/2 && mouseY > creationSlotY + 150 - creationSlotD/2 && mouseButton == LEFT && primaryCounter != "") {
      secondaryCounter = "stealth";
    } else if (mousePressed && mouseX < creationSlotX + 530 + creationSlotD/2 && mouseX > creationSlotX + 530 - creationSlotD/2 && mouseY < creationSlotY + 150 + creationSlotD/2 && mouseY > creationSlotY + 150 - creationSlotD/2 && mouseButton == LEFT && primaryCounter != "") {
      secondaryCounter = "blink";
    } else if (mousePressed && mouseX < creationSlotX + 650 + creationSlotD/2 && mouseX>creationSlotX + 650 - creationSlotD/2 && mouseY < creationSlotY + 150 + creationSlotD/2 && mouseY > creationSlotY + 150 - creationSlotD/2 && mouseButton == LEFT && primaryCounter != "") {
      secondaryCounter = "decoy";
    }

    // gender selection
    if (mousePressed && mouseX < width/2 + 310 + 25 && mouseX > width/2 + 295 - 25 && mouseY < height - 160 + 25 && mouseY > height - 160 - 25 && genderSwap > genderSwapTimer) {
      if (gender == "M")
        gender = "F"; 
      else
        gender = "M";
      genderSwap = 0;
    }
    text(gender, width/2-135, height/3+35);
  }

  // draw the character creation screen
  // primary weapon slots
  stroke(#27C2F0);
  fill(0);
  textSize(18);
  tint(255, 255);
  rect(creationSlotX-50, creationSlotY, creationSlotD, creationSlotD, 2); 
  rect(creationSlotX+100, creationSlotY, creationSlotD, creationSlotD, 2);
  rect(creationSlotX+500, creationSlotY, creationSlotD, creationSlotD, 2);
  rect(creationSlotX+650, creationSlotY, creationSlotD, creationSlotD, 2);
  text("Sword", creationSlotX-86, creationSlotD-5);
  text("Shield", creationSlotX+58, creationSlotD-5);
  text("Bow", creationSlotX+477, creationSlotD-5);
  text("Spear", creationSlotX+611, creationSlotD-5);
  image(sword, creationSlotX-50, creationSlotY, creationSlotD, creationSlotD); 
  image(shield, creationSlotX+100, creationSlotY+2, creationSlotD, creationSlotD);
  image(bow, creationSlotX+500, creationSlotY, creationSlotD, creationSlotD);
  image(spear, creationSlotX+650, creationSlotY, creationSlotD, creationSlotD);
  // secondary weapon slots
  stroke(#1BF244);
  rect(creationSlotX-50, creationSlotY+150, creationSlotD, creationSlotD); 
  rect(creationSlotX+80, creationSlotY+150, creationSlotD, creationSlotD);
  rect(creationSlotX+530, creationSlotY+150, creationSlotD, creationSlotD);
  rect(creationSlotX+650, creationSlotY+150, creationSlotD, creationSlotD);
  text("Magic", creationSlotX-85, creationSlotD-5+150);
  text("Stealth", creationSlotX+28, creationSlotD-5+150);
  text("Blink", creationSlotX+497, creationSlotD-5+150);
  text("Decoy", creationSlotX+615, creationSlotD-5+150);
  image(magic, creationSlotX-50, creationSlotY+150, creationSlotD, creationSlotD); 
  image(stealth, creationSlotX+82, creationSlotY+154, creationSlotD, creationSlotD);
  image(blink, creationSlotX+530, creationSlotY+150, creationSlotD, creationSlotD);
  image(decoy, creationSlotX+650, creationSlotY+150, creationSlotD, creationSlotD);
  // character display boxes
  stroke(#E4FF3B);
  rect(creationSlotX, creationSlotY+400, 125, 175, 2); 
  rect(creationSlotX+150, creationSlotY+400, 125, 175, 2);
  rect(creationSlotX+300, creationSlotY+400, 125, 175, 2);
  rect(creationSlotX+450, creationSlotY+400, 125, 175, 2);

  // weapon description box
  stroke(255, 134, 0);
  rect(width/2, height/3, 300, 300, 6);

  // description box contents
  textSize(18);
  fill(255);
  if (primaryCounter != "") 
    text("Primary Class is:\n" + primaryCounter.toUpperCase(), width/2-135, height/3-125);
  if (secondaryCounter != "") {
    text("Secondary Class is:\n"+secondaryCounter.toUpperCase(), width/2-135, height/3-50);
    text("Your Gender is:\n"+gender, width/2-135, height/3+25);
  }

  // gender selection button
  strokeWeight(2);
  noFill();
  stroke(246, 0, 255);
  rect(width/2+297, height-160, 26, 52);
  stroke(0, 214, 255);
  rect(width/2+323, height-160, 26, 52);
  fill(0);
  noStroke();
  rect(width/2+310, height-160, 50, 50, 2);
  textSize(40);
  fill(255);
  text(gender, width/2+292, height - 144);
  genderSwap++;

  // character creation button
  fill(0);
  rect(width/2+310, height-100, 120, 46);
  fill(255);
  textSize(18);
  text("Create\n Next", width/2+265, height-104);

  if (mousePressed && primaryCounter != "" && secondaryCounter != "" && mouseX < width/2 + 310 + 60 && mouseX > width /2 + 310 - 60 && mouseY < height - 100 + 23 && mouseY > height - 100 - 23 && characterCount < 4) {
    String name = primaryCounter+gender.toLowerCase();
    fourThieves[characterCount] = new Thief(name, (characterCount+1)*3.75-1.7, 12);
    fourThieves[characterCount].w = 75;
    fourThieves[characterCount].h = 75;
    if (secondaryCounter == "magic")
      fourThieves[characterCount].maxMana += 5;
    else if (secondaryCounter == "stealth")
      fourThieves[characterCount].maxHP += 3;
    else if (secondaryCounter == "blink")
      fourThieves[characterCount].attackTimer -= 5;
    else if (secondaryCounter == "decoy") 
      fourThieves[characterCount].armor += 3;

    characterCount++;
    primaryCounter="";
    secondaryCounter="";
    gender="M";
  }


  // finish creation button
  fill(0);
  rect(width/2+310, height-45, 120, 46);
  if (characterCount >= 4)
    fill(255);
  else
    fill(169, 169, 169);
  text(" Finish\nCreation", width/2+255, height-49, 8);

  for (int i = 0; i < characterCount; i++) {
    tint(255, 255);
    fourThieves[i].currentFrame = 2;
    fourThieves[i].display();
  }

  if (mousePressed && mouseX < width/2 + 310 + 60 && mouseX > width/2 + 310 - 60 && mouseY < height - 45 + 23 && mouseY > height - 45 - 23 && characterCount >= 4) {
    characterCreation = false;
    for (int i = 0; i < characterCount; i++) {
      fourThieves[i].w = 40;
      fourThieves[i].h = 40;
      fourThieves[i].x = 60;
      fourThieves[i].y = 180;
    }
    setupMaps();
    setupEnemies();

    playGame = true;
    creationMusic.shiftGain(creationMusic.getGain(), -100, 5000);
    dungeonMusic.shiftGain(-100, -10, 5000);
  }
}
// ----------------- CODE INVOLVING CHARACTER CREATION END ------------ \\
// variables for the game and position variables
int selectedThief = 0, tempThief, tempCharCount = 4;
int[] numEnemies = {0, 5, 5, 7, 7, 0, 7, 8, 8, 8, 0, 1};
float[][] startPos = {{0, 0}, {1, 5}, {16, 1}, {6, 6}, {13, 6}, {12, 9}, {5, 9}, {17, 2}, {4, 6}, {16, 9}, {5, 9}, {15, 9}};
float[][] endPos = {{0, 0}, {17, 1}, {4, 6}, {13, 6}, {12, 9}, {6, 10}, {17, 3}, {4, 6}, {15, 9}, {3, 9}, {12, 9}, {18, 10}};
float[][][] enemyPos = {
  {{0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}}, 
  {{11, 3, 3}, {2, 9, 0}, {16, 10, 1}, {7, 7, 2}, {11, 9, 1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}}, 
  {{11, 3, 3}, {7, 6, 0}, {16, 6, 1}, {1, 7, 2}, {10, 8, 1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}}, 
  {{3, 2, 1}, {11, 3, 3}, {17, 3, 2}, {9, 5, 2}, {3, 7, 1}, {17, 9, 0}, {8, 10, 3}, {0, 0, -1}}, 
  {{7, 3, 0}, {18, 3, 1}, {2, 4, 3}, {15, 6, 2}, {8, 7, 0}, {6, 10, 2}, {16, 10, 1}, {0, 0, -1}}, 
  {{0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}}, 
  {{8, 3, 3}, {4, 4, 1}, {13, 4, 1}, {16, 6, 0}, {3, 8, 1}, {9, 9, 3}, {18, 9, 2}, {0, 0, -1}}, 
  {{7, 2, 1}, {10, 3, 3}, {14, 3, 0}, {3, 4, 2}, {6, 8, 3}, {11, 8, 2}, {16, 8, 3}, {6, 10, 1}}, 
  {{3, 2, 2}, {12, 3, 0}, {6, 4, 1}, {15, 4, 0}, {1, 8, 2}, {6, 9, 1}, {11, 8, 3}, {14, 7, 2}}, 
  {{1, 2, 3}, {9, 3, 3}, {13, 3, 1}, {18, 5, 2}, {10, 6, 1}, {6, 7, 0}, {13, 7, 0}, {3, 8, 2}}, 
  {{0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}}, 
  {{10, 5, 4}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}, {0, 0, -1}}, 
};

// variables for the shop and money
int goldCoin = 0;
AnimatedSprite coinSpin;
ArrayList<Enemy> enemies;
ArrayList<Enemy> monsterBook = new ArrayList<Enemy>();
Enemy monsterBookEntry;
int pageNumber = 0;

void playGame() {
  background(0);
  dungeonMusic.play();
  drawMap();
  drawUI();
  drawEnemies();
  drawThieves();
  if (mapNumber == 5 || mapNumber == 10) {
    drawShopItems();
    updateShop();
  }
  if (mapNumber == 11)
    bossDefeat();
  if (!fourThieves[0].alive && !fourThieves[1].alive && !fourThieves[2].alive && !fourThieves[3].alive) {
    playGame = false;
    gameOver = true;
  }
}

void drawUI() {
  // HP bar
  stroke(0);
  strokeWeight(2);
  rectMode(CORNER);
  imageMode(CORNER);
  fill(#F7050D);
  image(heart, 0, height-120, 20, 20);
  rect(21, height-120, 220*fourThieves[selectedThief].currentHP/fourThieves[selectedThief].maxHP, 20);
  // mana bar
  image(mana, -1, height-100, 20, 20);
  fill(#140DFF);
  rect(21, height-100, 220*fourThieves[selectedThief].currentMana/fourThieves[selectedThief].maxMana, 20); 
  // experience bar
  image(exp, 0, height-80, 20, 20);
  fill(255);
  stroke(0);
  rect(1+220*(fourThieves[selectedThief].exp/100f), height-80, 240-240*(fourThieves[selectedThief].exp/100f), 18);
  fill(#AD06B7);
  rect(21, height-80, 220*(fourThieves[selectedThief].exp/100f), 20);
  // character slots
  stroke(255);
  noFill();
  rect(0, height-56, 60, 54);
  rect(60, height-56, 60, 54);
  rect(120, height-56, 60, 54);
  rect(180, height-56, 60, 54);

  for (int i = 0; i < tempCharCount; i++) {
    tempCharCount = 4;
    if (selectedThief == 3) {
      tempCharCount = 3;
    } else if (i == selectedThief)
      i++;
    fourThieves[i].x = 12+60*i;
    fourThieves[i].y = height-48;
    fourThieves[i].display();
  }

  fill(255);
  tint(255, 255);
  // coin
  image(coin, 500, height-120, 40, 40);
  text(goldCoin, 545, height-95);
  // armor
  image(armor, 720, height-120, 40, 40);
  text(fourThieves[selectedThief].armor, 770, height-95);

  // monsterbook
  noFill();
  rect(500, height-80, 150, 80);
  rect(650, height-80, 150, 80);
  drawMonsterBook();
  fill(0, 128, 255);
  stroke(255);
  triangle(width-280, height-50, width-295, height-40, width-280, height-30);
  triangle(width-20, height-50, width-5, height-40, width-20, height-30);
  imageMode(CENTER);
}

void keyPressed() {
  if (playGame) {
    if (!fourThieves[selectedThief].isAttacking) {
      switch(keyCode) {
      case UP:
        fourThieves[selectedThief].moveUp();
        break;
      case RIGHT:
        fourThieves[selectedThief].moveRight();
        break;
      case DOWN:
        fourThieves[selectedThief].moveDown();
        break;
      case LEFT:
        fourThieves[selectedThief].moveLeft();
        break;
      case 81:
        tempThief = selectedThief;
        if (fourThieves[0].alive) {
          selectedThief = 0;
          fourThieves[selectedThief].x = fourThieves[tempThief].x;
          fourThieves[selectedThief].y = fourThieves[tempThief].y;
          fourThieves[selectedThief].currentFrame = fourThieves[tempThief].currentFrame;
        }
        break;
      case 87:
        tempThief = selectedThief;
        if (fourThieves[1].alive) {
          selectedThief = 1;
          fourThieves[selectedThief].x = fourThieves[tempThief].x;
          fourThieves[selectedThief].y = fourThieves[tempThief].y;
          fourThieves[selectedThief].currentFrame = fourThieves[tempThief].currentFrame;
        }
        break;
      case 69:
        tempThief = selectedThief;
        if (fourThieves[2].alive) {
          selectedThief = 2;
          fourThieves[selectedThief].x = fourThieves[tempThief].x;
          fourThieves[selectedThief].y = fourThieves[tempThief].y;
          fourThieves[selectedThief].currentFrame = fourThieves[tempThief].currentFrame;
        }
        break;
      case 82:
        tempThief = selectedThief;
        if (fourThieves[3].alive) {
          selectedThief = 3;
          fourThieves[selectedThief].x = fourThieves[tempThief].x;
          fourThieves[selectedThief].y = fourThieves[tempThief].y;
          fourThieves[selectedThief].currentFrame = fourThieves[tempThief].currentFrame;
        }
        break;
      case 90:
        if (fourThieves[selectedThief].currentMana >= 1)
          fourThieves[selectedThief].isAttacking = true;
        break;
      case 78:
        if (monsterBook.size() > 2 && monsterBook.size() < 5) 
          if (pageNumber > 0) 
            pageNumber--;
        break;
      case 77:
        if (monsterBook.size() > 2 && monsterBook.size() < 5) 
          if (pageNumber +  3 <= monsterBook.size()) 
            pageNumber++;
        break;
      case 32:
        purchasingItem = true;
        break;
      }
    }
  }
}

void setupMaps() {
  mapNumber++;
  for (int j = 0; j < coords[mapNumber].length; j++) {
    for (int k = 0; k < coords[mapNumber][j].length; k++) {
      switch(coords[mapNumber][j][k]) {
      case 0:
        maps[mapNumber][j][k] = waterTexture; 
        break;
      case 1:
        maps[mapNumber][j][k] = grassTexture; 
        break;
      case 2:
        maps[mapNumber][j][k] = stoneTexture1; 
        break;
      case 3:
        maps[mapNumber][j][k] = stoneTexture2;
        break;
      case 4:
        maps[mapNumber][j][k] = stoneTexture3;
        break;
      case 5:
        maps[mapNumber][j][k] = wallTexture1;
        break;
      case 6:
        maps[mapNumber][j][k] = wallTexture2;
        break;
      case 7:
        maps[mapNumber][j][k] = wallTexture3;
        break;
      case 8:
        maps[mapNumber][j][k] = dirtTexture; 
        break;
      case 9:
        maps[mapNumber][j][k] = blueflowerTexture; 
        break;
      case 10:
        maps[mapNumber][j][k] = yellowFlowerTexture; 
        break;
      case 11:
        maps[mapNumber][j][k] = pinkFlowerTexture; 
        break;
      case 12:
        maps[mapNumber][j][k] = shrubTexture; 
        break;
      case 13:
        maps[mapNumber][j][k] = doorTexture; 
        break;
      case 14:
        maps[mapNumber][j][k] = stairTexture1;
        break;
      case 15:
        maps[mapNumber][j][k] = stairTexture2;
        break;
      case 16:
        maps[mapNumber][j][k] = UI;
        break;
      case 17:
        maps[mapNumber][j][k] = shopWalls;
        break;
      case 18:
        maps[mapNumber][j][k] = shopCounter;
        break;
      }
    }
  }
}

void drawMap() {
  tint(255, mapFade);
  for (int j = 0; j < maps[mapNumber].length; j++) {
    for (int k = 0; k < maps[mapNumber][j].length; k++) {
      image(maps[mapNumber][j][k], k*tileSize+20, j*tileSize+20, tileSize, tileSize);
    }
  }
}

void drawThieves() {
  fourThieves[selectedThief].display();
  fourThieves[selectedThief].update();
}

String enemyType;
void setupEnemies() {
  enemies = new ArrayList<Enemy>(numEnemies[mapNumber]);
  for (int i = 0; i < numEnemies[mapNumber]; i++) {
    if (enemyPos[mapNumber][i][0] != 0 && enemyPos[mapNumber][i][1] != 0 && enemyPos[mapNumber][i][2] > -1) {
      if (enemyPos[mapNumber][i][2] == 0)
        enemyType = "goblin";
      else if (enemyPos[mapNumber][i][2] == 1)
        enemyType = "demon";
      else if (enemyPos[mapNumber][i][2] == 2)
        enemyType = "eye";
      else if (enemyPos[mapNumber][i][2] == 3)
        enemyType = "rat";
      else if (enemyPos[mapNumber][i][2] == 4)
        enemyType = "ragumiz";
    }
    enemies.add(new Enemy(enemyType, enemyPos[mapNumber][i][0], enemyPos[mapNumber][i][1]));
  }
}

float deathX, deathY;
boolean addMonster = false;
void drawEnemies() {
  for (int i = 0; i < numEnemies[mapNumber]; i++) { 
    if (enemies.get(i).currentHP <= 0) {
      monsterBookEntry = new Enemy(enemies.get(i).name, 200, 200);
      fourThieves[selectedThief].exp += 20;
      if (monsterBook.size() == 0) 
        monsterBook.add(monsterBookEntry);

      if (monsterBook.size() > 0) {
        for (int j = 0; j < monsterBook.size(); j++) {
          if (enemies.get(i).name.equals(monsterBook.get(j).name)) {
            addMonster = false;
            break;
          } else
            addMonster = true;
        }
        if (addMonster)
          monsterBook.add(monsterBookEntry);
      }

      deathX = enemies.get(i).x;
      deathY = enemies.get(i).y;
      coinSpin = new AnimatedSprite("goldCoin", "png", 0, 11, 6, true);
      coinDrop.trigger();
      if (enemies.get(i).type != "ragumiz")
        enemies.remove(i);
      numEnemies[mapNumber]--;
      i--;
    } else if (enemies.get(i).currentHP > 0) {
      enemies.get(i).display();
      enemies.get(i).movement();
      enemies.get(i).attack();
      enemies.get(i).update();
    }
    coinDrop();
  }
}


void drawMonsterBook() {
  textAlign(CENTER);
  if (monsterBook.size() == 1) {
    monsterBook.get(pageNumber).x = 560;
    monsterBook.get(pageNumber).y = 550;
    monsterBook.get(pageNumber).display();
    text(monsterBook.get(pageNumber).name.toUpperCase(), width/1.38, 540);
  } else if (monsterBook.size() >= 2) {
    monsterBook.get(pageNumber).x = 560;
    monsterBook.get(pageNumber).y = 550;
    monsterBook.get(pageNumber).display();
    text(monsterBook.get(pageNumber).name.toUpperCase(), width/1.38, 540);
    if (pageNumber < 3 && monsterBook.get(pageNumber+1) != null) {
      monsterBook.get(pageNumber+1).x = 710;
      monsterBook.get(pageNumber+1).y = 550;
      monsterBook.get(pageNumber+1).display();
      text(monsterBook.get(pageNumber+1).name.toUpperCase(), width/1.1, 540);
    }
  }
}

void coinDrop() {
  if (coinSpin != null) {
    coinSpin.display(deathX, deathY, 32, 32);
    if (coinSpin.currentFrame == coinSpin.maxFrame - 1) {
      goldCoin += (int) random(1, 4);
      coinSpin = null;
    }
  }
}

void drawShopItems() {
  tint(255, 255);
  for (int i=0; i<shopItems.length; i++) {
    shopItems[i].display(300+i*40, 180, 40, 40);
  }
}

boolean purchasingItem = false;
void updateShop() {
  for (int i=0; i <shopItems.length; i++) {
    if (mouseX > 280 + i*40 && mouseX < 320 + i*40 && mouseY > 160 && mouseY < 200) {
      fill(255);
      text(shopItems[i].t + "\ncosts "+ shopItems[i].p + " coins", width/2.25, height-60);
      if (goldCoin - shopItems[i].p >= 0) {
        if (purchasingItem && i < 6) {
          shopItems[i].increaseStats();
          deductMoney(shopItems[i]);
        }
      }
    }
  }
  purchasingItem = false;
}

void deductMoney(Item p) {
  goldCoin-=p.p;
}

int bossCounter = 0, bossTimer = 300;
boolean endSequence = true;
StaticSprite finalChest;

void bossDefeat() {
  if (enemies.get(0).currentHP <= 0) {
    bossCounter++;
  }
  if (bossCounter >= bossTimer && endSequence) {
    finalChest = new StaticSprite("chest", "png", 0, 2, 0, true);
    for (int i = 0; i < fourThieves.length; i++) {
      fourThieves[selectedThief].x = characterPos[i][0]*tileSize;
      fourThieves[selectedThief].y = characterPos[i][1]*tileSize;
    }
    endSequence = false;
  }
  if (finalChest != null) {
    finalChest.display(width/2, height/2, 100, 100);
    textFont(font, 30);
    textAlign(CENTER);
    background(255);
    textSize(50);
    fill(0);
    text("TO BE CONTINUED...", width/2, height/2);
  }
}

PFont endFont;
void gameOver() {
  tint(255, 255);
  textFont(endFont);
  background(0);
  strokeWeight(3);
  textAlign(CENTER);
  textSize(80);
  fill(#BC0606);
  text("Game Over", width/2, height/4);
  rectMode(CENTER);
  fill(255);
  textSize(20);
  text("The Deathly Hallows Dungeon Has Forsaken You\n Better Luck Next Time", width/2, height/2-50);
  stroke((int)random(255), (int)random(255), (int)random(255));
  fill(0);
  rect(width/2, height*2/3, 400, 150);
  fill(#F3F71B);
  textSize(40);
  text("Start Again", width/2, height*2/3+15);
  textSize(10);
  fill(random(255));
  text("P.S.: You Suck", width-75, height-25);
  rectMode(CORNER);
  if (mouseX<width/2+100&&mouseX>width/2-100&&mouseY<height*2/3+75&&mouseY>height*2/3-75&&mousePressed) {
    titleIntro=true;
    gameOver=false;
    goldCoin = 0;
    monsterBook = new ArrayList<Enemy>();
  }
}
//TODO Add safety feature so that map will regen until troops are not in water
//TODO Make terrain mean something
//TODO Mustard gas
//TODO Make AI work differently if it reaches the other end of the map
//TODO? Procedural map? Campaign? Command unit?

float level=1;

float percentage = 0.5;
float meter = 0.5;

int playerSpawned = 0;
int enemySpawned = 0;

int playerInfantry = 0;
int enemyInfantry = 0;
int leftMargin = 6;
int topMargin = 30;
int screenCounter;


float actionRate = 0.185;
float rateOfFire = 0.09;
float spawnRate = 0.02;
float forwardBias = 0.2;
float mortarRate = 0.000001;

float enemyChargeRate = random(1) * 0.00002;
float playerChargeRate = random(1) * 0.00001;

int enemyChargeLoss = 0;
int playerChargeLoss = 0;

int playerLoss = 0;
int enemyLoss = 0;

float coverDeathChance = 0.04;
boolean isPaused = false;
boolean isThinking = true;
boolean playerCharge = false;
boolean enemyCharge = false;

int boardWidth = 76;
int boardHeight = 52;
int winMeter = 0;
int elevation = 0;

float[][] heightMap = new float[boardWidth][boardHeight];

int startPoint1 = int(random(14,boardWidth - 14)); //enemy
int startPoint2 = int(random(14,boardWidth - 14)); //player
char[][] terrain = new char[boardWidth][boardHeight];
char [][] display = new char[boardWidth][boardHeight];
int[][] terrainColor = new int[boardWidth][boardHeight];
char[][] bullets = new char[boardWidth][boardHeight];
char[][] infantry = new char[boardWidth][boardHeight];
PFont font;
String pauseText = "-----=:|  (P)AUSED  |:=-----";

void setup() {
  background(0x000000);
  size(800,600);
  frameRate(60);
  font = loadFont("CourierNewPS-BoldMT-48.vlw");
  textFont(font,16);
  //terrain gen
  HeightMapGen h = new HeightMapGen();
  h.setSize(boardWidth,boardHeight);
  h.setVariance(random(5,25));
  heightMap = h.generate();
  //populate arrays
  for(int x = 0; x < boardWidth; x++) {
    for(int y = 0; y < boardHeight; y++) {
      bullets[x][y] = ' ';
      terrain[x][y] = 'O';
      infantry[x][y] = ' ';
      setupTerrain(x,y);
      display[x][y] = terrain[x][y];
    }
  }
  //setupStartPos();
}

//TODO minimap
int boardWidth = 228;
int boardHeight = 128;
boolean shrink = false;

int r,g,b;

float [][] heightMap = new float[boardWidth][boardHeight];
float terrain[][] = new float[boardWidth][boardHeight];
float miniMap[][] = new float[boardWidth][boardHeight];

float display[][] = new float[boardWidth][boardHeight];

PFont font;
TerrainGen t = new TerrainGen();

void setup() {
  background(0x000000);
  size(1366,768);
  frameRate(15);
  font = loadFont("Monospaced.bold-48.vlw");
  textFont(font,8);
  //terrain
  t.setSize(boardWidth,boardHeight);
  //2 for space or large joined land, 5 for islands
  t.setVariance(2);
  heightMap = t.generate();
  
  r = int(random(255));
  g = int(random(255));
  b = int(random(255));
  
  for(int x=0; x<boardWidth; x++) {
    for(int y=0; y<boardHeight; y++) {
      setupTerrain(x,y);
      display[x][y] = terrain[x][y];
    }
  }
}


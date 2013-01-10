//TODO add enemys
//TODO add z movement
//TODO add diagonal movement
PFont font;;
int frameWidth = 80;
int frameHeight = 54;

char[][] crosshair = new char[frameWidth][frameHeight];
char[][] enemys = new char[frameWidth][frameHeight];
char[][] viewableSpace = new char[frameWidth][frameHeight];
char[][] behindShip = new char[frameWidth][frameHeight];
char[][] enemyShip = new char[frameWidth][frameHeight];
char[][] buffer = new char[frameWidth][frameHeight];

void setup() {
  background(0x000000);
  size(800,600);
  frameRate(30);
  font = loadFont("CourierNewPSMT-48.vlw");
  textFont(font,16);
  for(int x = 0; x < frameWidth; x++) {
    for(int y = 0; y < frameHeight; y++) {
      generateStars(x,y);
    }
  }
}

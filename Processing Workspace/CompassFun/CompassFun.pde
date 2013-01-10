float mouseAng;
PFont font;

boolean clicked;

int frameWidth = 80;
int frameHeight = 54;

char[][] points = new char[frameWidth][frameHeight];
char[][] drawDisplay = new char[frameWidth][frameHeight];

void setup() {
  background(0x000000);
  size(800,600);
  font = loadFont("CourierNewPS-BoldMT-48.vlw");
  textFont(font,16);
  for(int x = 0; x < frameWidth; x++) {
    for(int y = 0; y < frameHeight; y++) {
      populateDisplay(x,y);
    }
  }
}

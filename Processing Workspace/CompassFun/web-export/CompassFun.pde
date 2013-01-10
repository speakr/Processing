float mouseAng;
PFont font;

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
boolean bounds(int x, int y) {
  if(x >= 0 && x < frameWidth) {
    if(y >= 0 && y < frameHeight) {
      return true;
    }
    else {
      return false;
    }
  }
  else {
    return false;
  }
}
void draw() {
  background(0x000000);
  for(int x = 0; x < frameWidth; x++) {
    for(int y = 0; y < frameHeight; y++) {
      drawDisplay[x][y] = points[x][y];
      switch(drawDisplay[x][y]) {
        default:
          fill(255);
          break;
      }
      text(drawDisplay[x][y],x*10,y*11+11);
    }
  }
}
//So many embedded if statements...I must clean this up when I'm not lazy
void mouseMoved() {
  int mousePosX = int((mouseX)/10);
  int mousePosY = int((mouseY)/11);
  for(int x = 0; x < frameWidth; x++) {
    for(int y = 0; y < frameHeight; y++) {
      if(bounds(mousePosX,mousePosY)) {
        noCursor();
        if(mousePosX > x) {
          if(mousePosY > y) {
            if(!isEmpty(x,y)) {
              points[x][y] = '\\';
            }
          }
          else if(mousePosY == y) {
            if(!isEmpty(x,y)) {
              points[x][y] = '-';
            }
          }
          else {
            if(!isEmpty(x,y)) {
              points[x][y] = '/';
            }
          }
        }
        else if(mousePosX == x) {
          if(mousePosY > y || mousePosY < y) {
            if(!isEmpty(x,y)) {
            points[x][y] = '|';
            }
          }
          else {
            if(!isEmpty(x,y)) {
              points[x][y] = '*';
            }
          }
        }
        else {
          if(mousePosY > y) {
            if(!isEmpty(x,y)) {
              points[x][y] = '/';
            }
          }
          else if(mousePosY < y) {
            if(!isEmpty(x,y)) {
              points[x][y] = '\\';
            }
          }
          else {
            if(!isEmpty(x,y)) {
              points[x][y] = '-';
            }
          }
        }
      }
    }
  }    
}
  
void populateDisplay(int x, int y) {
  //every other column
  if((x+2)%2 == 0) {
    //every other row
    if((y+2)%2 == 0) {
      points[x][y] = '*';
    }
    else {
      points[x][y] = ' ';
    }
  }
  else {
    points[x][y] = ' ';
  }
}

boolean isEmpty(int x, int y) {
  if(points[x][y] == ' ') {
    return true;
  }
  else {
    return false;
  }
}


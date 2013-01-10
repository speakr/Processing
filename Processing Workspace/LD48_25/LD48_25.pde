//Theme: You are the villain
//Hold planets for ransom? Blow them up anyway?
//TODO: Add ship, add planets screen, add AI, make a game...
import java.util.*;

PImage img;

PFont font;
int nebulaWidth = 342;
int nebulaHeight = 192;
boolean nebulaLoop = true;
boolean solarLoop = false;
boolean pause = false;
boolean killStar = false;

String cross = "[ + ]";

color solColor;

int r,g,b;
int[][] starColor = new int[nebulaWidth][nebulaHeight];
int[][] starRadius = new int[nebulaWidth][nebulaHeight];

char[][] crosshair = new char[nebulaWidth][nebulaHeight];

depthGen d = new depthGen();

//nebula
float[][] depthMap = new float[nebulaWidth][nebulaHeight];
float[][] nebula = new float[nebulaWidth][nebulaHeight];
//starscape
float[][] starMap = new float[nebulaWidth][nebulaHeight];
//setup
void setup() {
  background(0x000000);
  size(800,600);
  font = loadFont("Monospaced.bold-48.vlw");
  textFont(font,12);
  d.setSize(nebulaWidth,nebulaHeight);
  d.setVariance(.8);
  depthMap = d.generate();
  
  r = int(random(255));
  g = int(random(255));
  b = int(random(255));
  
  for(int x=0; x<nebulaWidth; x++) {
    for(int y=0; y<nebulaHeight; y++) {
      //nebula
      fill(depthMap[x][y]*r,depthMap[x][y]*g,depthMap[x][y]*b);
      stroke(depthMap[x][y]*r,depthMap[x][y]*g,depthMap[x][y]*b);
      rect(x*4,y*4,4,4);
      //stars
      generateStars(x,y);
      if(starMap[x][y] != 0) {
        fill(starColor[x][y]+random(r,r+50),starColor[x][y]+random(g,g+50),starColor[x][y]+random(b,b+50));
        ellipseMode(RADIUS);
        ellipse(x*4,y*4,starRadius[x][y],starRadius[x][y]);
      }
    }
  }
  save("C:/Users/Finn/Google Drive/Jeff/Processing Workspace/LD48_25/data/background.png");
  img = loadImage("background.png");
}

import java.util.*;
import java.io.*;

PFont font;
PImage img;
int nebulaWidth = 342;
int nebulaHeight = 192;
int r,g,b;
float[][] depthMap = new float[nebulaWidth][nebulaHeight];
int[][] starColor = new int[nebulaWidth][nebulaHeight];
int[][] starRadius = new int[nebulaWidth][nebulaHeight];
int[][] starMap = new int[nebulaWidth][nebulaHeight];
int[][] planetCount = new int[nebulaWidth][nebulaHeight];

Generator gen = new Generator();
String cross = "[ + ]";

void setup() {
  background(0x000000);
  size(800,600);
  gen.setSize(nebulaWidth,nebulaHeight);
  gen.setVariance(1.5);
  depthMap = gen.generate();
  
  font = loadFont("Monospaced.plain-48.vlw");
  textFont(font,12);
  //pull background from save file
  /*File file = sketchFile("data/background.png");
  if(file.exists()) {
    img = loadImage("background.png");
  }
  else {*/
    nebula();
    save("data/background.png");
    img = loadImage("background.png");
    stars();
  //}
}

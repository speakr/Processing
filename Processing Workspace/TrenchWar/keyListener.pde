void keyReleased() {
  if(key == 'p') {
    pauseFunc();
  }
  if (key == 'c') { //make this dependent on a charge meter
    playerCharge = true;
  }
  if(key == 'r') { //make dedicated retreat command
    playerCharge = false;
  }
  if(key == 'm') { //new map and new game
    playerSpawned = 0;
    enemySpawned = 0;
    playerLoss = 0;
    enemyLoss = 0;
    playerChargeLoss = 0;
    enemyChargeLoss = 0;
    startPoint1 = int(random(14,boardWidth - 14));
    startPoint2 = int(random(14,boardWidth - 14));
    HeightMapGen h = new HeightMapGen();
    h.setSize(boardWidth,boardHeight);
    h.setVariance(random(4,5));
    heightMap = h.generate();
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
   if(key == 's') {
     screenCounter++;
     save("screenshot"+screenCounter+".png");
   }
}

void keyPressed() {
}

boolean sketchFullScreen() {
  return true;
}

void setupStartPos() {
  for(int startCorridor = 0; startCorridor < 1; startCorridor++) {
    terrain[startPoint1][startCorridor] = ' ';
    for(int i = startPoint1 - 10; i < startPoint1 + 10; i++) {
      terrain[i][0] = ' ';
      if(random(1) < 0.5) {
        infantry[i][0] = 'l';
        enemySpawned++;
      }
    }
  }
  for(int startCorridor = 0; startCorridor < 1; startCorridor++) {
    terrain[startPoint2][boardHeight-startCorridor-1] = ' ';
    for(int i=startPoint2 - 10; i < startPoint2 + 10; i++) {
      terrain[i][boardHeight-1] = ' ';
      if(random(1) < 0.5) {
        infantry[i][boardHeight-1] = 'I';
        playerSpawned++;
      }
    }
  }
}

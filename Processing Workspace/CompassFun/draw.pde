void draw() {
  background(35,162,35);
  for(int x = 0; x < frameWidth; x++) {
    for(int y = 0; y < frameHeight; y++) {
      drawDisplay[x][y] = points[x][y];
      switch(drawDisplay[x][y]) {
        default:
          fill(255);
          break;
      }
      fill(0,255,0);
      text(drawDisplay[x][y],x*10,y*11+11);
    }
  }
}

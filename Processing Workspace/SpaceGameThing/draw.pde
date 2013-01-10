void draw() {
  background(0,0,0);
  for(int x = 0; x < frameWidth; x++) {
    for(int y = 0; y < frameHeight; y++) {
      switch(viewableSpace[x][y]) {
        case '*':
          fill(150,255,255);
          break;
        case '¤':
          fill(255,255,150);
          break;
        case '×':
          fill(153,51,0);
          break;
        default:
          fill(255);
          break;
      }
      text(viewableSpace[x][y],x*10,y*11+11);
      fill(0,255,0);
      text(crosshair[x][y],x*10,y*11+11);
      cardinalScroll(x,y);
    }
  }
}

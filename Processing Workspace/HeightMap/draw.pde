void draw() {
  background(0);
  for(int x=0; x<boardWidth; x++) {
    for(int y=0; y<boardHeight; y++) {
      //re-render display each cycle
      display[x][y] = terrain[x][y];
      fill(display[x][y]*r,display[x][y]*g,display[x][y]*b);
      stroke(display[x][y]*r,display[x][y]*g,display[x][y]*b);
      rect(x*6,y*6,6,6);
    }
  }
}

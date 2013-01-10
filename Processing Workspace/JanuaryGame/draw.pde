void draw() {
  background(img);
  noCursor();
  //println(frameRate);
  for(int x=0; x < nebulaWidth; x++) {
    for(int y=0; y < nebulaHeight; y++) {
      if(starMap[x][y] == 1) {
        stroke(starColor[x][y]+random(r,r+50),starColor[x][y]+random(g,g+50),starColor[x][y]+random(b,b+50));
        fill(starColor[x][y]+random(r,r+50),starColor[x][y]+random(g,g+50),starColor[x][y]+random(b,b+50));
        ellipseMode(RADIUS);
        ellipse(x*4,y*4,starRadius[x][y],starRadius[x][y]);
        //crosshair detection
        if(rectEllipseIntersect(mouseX-14,mouseY-4,32,10,x*4,y*4,starRadius[x][y])) {

        }
      }
    }
  }
  fill(255);
  text(cross,mouseX-15,mouseY+4);
}

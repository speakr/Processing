void draw() {
  background(img);
  noCursor();
  println(frameRate);
  fill(255);
  text(cross,mouseX-15,mouseY+4);
        
  /*if(nebulaLoop) { 
    for(int x=0; x<nebulaWidth; x++) {
      for(int y=0; y<nebulaHeight; y++) {
        //crosshair
        fill(255);
        text(cross,mouseX-15,mouseY+4);
        //nebula
        fill(depthMap[x][y]*r,depthMap[x][y]*g,depthMap[x][y]*b);
        stroke(depthMap[x][y]*r,depthMap[x][y]*g,depthMap[x][y]*b);
        rect(x*4,y*4,4,4);
        //stars
        if(starMap[x][y] != 0) {
          fill(starColor[x][y]+random(r,r+50),starColor[x][y]+random(g,g+50),starColor[x][y]+random(b,b+50));
          ellipseMode(RADIUS);
          ellipse(x*4,y*4,starRadius[x][y],starRadius[x][y]);
        }
      }
    }
  }
  else if(solarLoop) {
    //zoom into solar system mode
    fill(solColor);
    stroke(solColor);
    ellipseMode(RADIUS);
    ellipse(width-(width/4),height/2,40,40);
    //kill star
  }*/
}

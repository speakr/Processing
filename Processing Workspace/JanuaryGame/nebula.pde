void nebula() { 
  r = int(random(255));
  g = int(random(255));
  b = int(random(255));  
  for(int x = 0; x < nebulaWidth; x++) {
    for(int y = 0; y < nebulaHeight; y++) {
      fill(depthMap[x][y]*r,depthMap[x][y]*g,depthMap[x][y]*b);
      stroke(depthMap[x][y]*r,depthMap[x][y]*g,depthMap[x][y]*b);
      rect(x*4,y*4,4,4);
    }
  }
}

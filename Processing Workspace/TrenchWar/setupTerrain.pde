void setupTerrain(int tx, int ty) {
      if((int)ceil(10*heightMap[tx][ty]) < 0) {
        heightMap[tx][ty] *= -1;
      }
      if((int)ceil(10*heightMap[tx][ty]) > 36) {
        heightMap[tx][ty] /= 3;
      }
      if((int)ceil(10*heightMap[tx][ty]) > 17) {
        terrain[tx][ty] = '¶';
      }
      if((int)ceil(10*heightMap[tx][ty]) <= 17) {
        terrain[tx][ty] = '£';
      }
      if((int)ceil(10*heightMap[tx][ty]) <= 12) {
        terrain[tx][ty] = '€';
      }
      if((int)ceil(10*heightMap[tx][ty]) <= 7) {
        terrain[tx][ty] = '$';
      }
      if((int)ceil(10*heightMap[tx][ty]) <= 3) {
        terrain[tx][ty] = '¥';
      }
      if((int)ceil(10*heightMap[tx][ty]) <= 0) {
        terrain[tx][ty] = '¢';
      }
      
}
//elevation data
int getElevation(int ex, int ey) {
  if(checkBounds(ex,ey)) {
  if((int)ceil(10*heightMap[ex][ey]) >= 0) {
    elevation = (int)ceil(10*heightMap[ex][ey]);
  }
  else {
    elevation = ((int)ceil(10*heightMap[ex][ey]))*-1;
  }
  }
  return elevation;
}

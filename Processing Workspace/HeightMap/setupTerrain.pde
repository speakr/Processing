//to make a space nebula gen, just remove if/else
void setupTerrain(int x, int y) {
  //terrain[x][y] = heightMap[x][y];
  if(heightMap[x][y] >= 0) {
      terrain[x][y] = heightMap[x][y];
  }
  else {
    terrain[x][y] = abs(heightMap[x][y]);
  }
}

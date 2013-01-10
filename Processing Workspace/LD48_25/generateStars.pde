void generateStars(int x, int y) {
  if(x%2==0) {
    if(y%2==0) {
      if((x+int(random(x)))%15 == int(random(0,4))) {
        if((y+int(random(y)))%18 == int(random(0,4))) {
          starMap[x][y] = random(2,3);
          starColor[x][y] = int(random(155));
          starRadius[x][y] = int(random(1,4));
        }
        else {
          starMap[x][y] = 0;
        }
      }
      else {
        starMap[x][y] = 0;
      }
    }
  }
}

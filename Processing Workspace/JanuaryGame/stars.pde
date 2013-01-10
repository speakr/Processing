void stars() {
  for(int x=0; x < nebulaWidth; x++) {
    for(int y=0; y < nebulaHeight; y++) {
      if(x%2==0) {
        if(y%2==0) {
          if((x+int(random(x)))%15 == int(random(0,4))) {
            if((y+int(random(y)))%18 == int(random(0,4))) {
              starMap[x][y] = 1;
              starColor[x][y] = int(random(155));
              starRadius[x][y] = int(random(1,4));
              planetCount[x][y] = int(random(1,5));
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
  }
}

      

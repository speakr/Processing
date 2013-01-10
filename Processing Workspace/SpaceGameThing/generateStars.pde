void generateStars(int x, int y) {
  //initial 180 degrees
  //random x
  if((x+int(random(x)))%9 == int(random(0,3))) {
    //random y
    if((y+int(random(y)))%12 == int(random(0,3))) {
      int type = int(random(0,3));
        switch(type) {
          case 0:
            viewableSpace[x][y] = '*';
            break;
          case 1:
            viewableSpace[x][y] = '¤';
            break;
          case 2:
            viewableSpace[x][y] = '×';
            break;
          default:
            break;
        }
    }
    else {
      viewableSpace[x][y] = ' ';
    }
  }
  else {
    viewableSpace[x][y] = ' ';
  }
  //rear 180
  /*if((x+int(random(x)))%12 == int(random(0,3))) {
    if((y+int(random(y)))%9 == int(random(0,3))) {
      behindShip[x][y] = '*';
    }
    else {
      behindShip[x][y] = ' ';
    }
  }
  else {
    behindShip[x][y] = ' ';
  }*/
}


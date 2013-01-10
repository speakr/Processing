void populateDisplay(int x, int y) {
  //every other column
  if((x+2)%2 == 0) {
    //every other row
    if((y+2)%2 == 0) {
      points[x][y] = '*';
    }
    else {
      points[x][y] = ' ';
    }
  }
  else {
    points[x][y] = ' ';
  }
}

boolean isEmpty(int x, int y) {
  if(points[x][y] == ' ') {
    return true;
  }
  else {
    return false;
  }
}

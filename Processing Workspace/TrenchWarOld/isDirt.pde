boolean isDirt(int xx, int yy) {
  if(checkBounds(xx,yy)) {
    if(terrain[xx][yy] != ' ' && terrain[xx][yy] != '^' && getElevation(xx,yy) != 0) {
      return true;
    }
    else {
      return false;
    }
  }
  else {
    return false;
  }
}

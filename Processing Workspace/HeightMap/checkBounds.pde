boolean checkBounds(int x, int y) {
  if(x >= 0 && x < boardWidth) {
    if(y >= 0 && y < boardHeight) {
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

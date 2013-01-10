boolean checkBounds(int x, int y) {
  if(x >= 0 && x < nebulaWidth) {
    if(y >= 0 && y < nebulaHeight) {
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

boolean bounds(int x, int y) {
  if(x >= 0 && x < frameWidth) {
    if(y >= 0 && y < frameHeight) {
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

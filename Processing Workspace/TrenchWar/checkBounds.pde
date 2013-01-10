boolean checkBounds(int xx, int yy) {
  if(xx >= 0 && xx < boardWidth && yy >= 0 && yy < boardHeight) {
    return true;
  }
  else {
    return false;
  }
}


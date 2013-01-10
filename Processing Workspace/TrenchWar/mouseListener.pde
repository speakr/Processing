void mousePressed() {//dig marker
  int boardMouseX = int((mouseX - leftMargin)/10);
  int boardMouseY = int((mouseY - topMargin)/11) + 1;
  if(mouseButton == LEFT) {
    if(checkBounds(boardMouseX,boardMouseY)) {
      if(terrain[boardMouseX][boardMouseY] != ' ' && terrain[boardMouseX][boardMouseY] != 'I' && terrain[boardMouseX][boardMouseY] != 'l' && terrain[boardMouseX][boardMouseY] != '¢') {
        terrain[boardMouseX][boardMouseY] = 'X';
      }
    }
  }
  //build marker
  if(mouseButton == RIGHT) {
    if(checkBounds(boardMouseX,boardMouseY)) {
      if(terrain[boardMouseX][boardMouseY] == ' ' || getElevation(boardMouseX,boardMouseY) == 0) {
        terrain[boardMouseX][boardMouseY] = '^';
      }
    }
  }
}
void mouseDragged() {
  int boardMouseX = int((mouseX - leftMargin)/10);
  int boardMouseY = int((mouseY - topMargin)/11) + 1;
  if(checkBounds(boardMouseX,boardMouseY)) {
    if(terrain[boardMouseX][boardMouseY] != ' ' && infantry[boardMouseX][boardMouseY] != 'I' && infantry[boardMouseX][boardMouseY] != 'l' && terrain[boardMouseX][boardMouseY] != '¢') {
      if(mouseButton == LEFT) { 
        terrain[boardMouseX][boardMouseY] = 'X';
      }
    }
    if(terrain[boardMouseX][boardMouseY] == ' ') {
      if(mouseButton == RIGHT) {
        terrain[boardMouseX][boardMouseY] = '^';
      }
    }
  }
}

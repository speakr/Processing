void mouseMoved() {
  int mousePosX = int((mouseX)/10);
  int mousePosY = int((mouseY)/11);
  for(int x = 0; x < frameWidth; x++) {
    for(int y = 0; y < frameHeight; y++) {
      if(bounds(mousePosX,mousePosY)) {
        noCursor();
        //create crosshair based on mouse movement
        if(mousePosX > x+1 && mousePosX < x+6) {
          if(mousePosY == y) {
            if(mousePosX == x+2) {
              crosshair[x][y] = '»';
            }
            else {
              crosshair[x][y] = '—';
            }
          }
          else {
            crosshair[x][y] = ' ';
          }
        }
        else if(mousePosX < x-1 && mousePosX > x-6) {
          if(mousePosY == y) {
            if(mousePosX == x-2) {
              crosshair[x][y] = '«';
            }
            else {
              crosshair[x][y] = '—';
            }
          }
          else {
            crosshair[x][y] = ' ';
          }
        }
        else if(mousePosX == x) {
          if(mousePosY > y+1 && mousePosY < y+5 || mousePosY < y-1 && mousePosY > y-5) {
            if(mousePosY == y+2 || mousePosY == y-2) {
              crosshair[x][y] = '‡';
            }
            else {
              crosshair[x][y] = '|';
            }
          }
          else {
              crosshair[x][y] = ' ';
          }
        }
        else {
          crosshair[x][y] = ' ';
        }
      }
    }
  }    
}

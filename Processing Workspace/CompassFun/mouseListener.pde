//So many embedded if statements...I must clean this up when I'm not lazy
void mouseMoved() {
  int mousePosX = int((mouseX)/10);
  int mousePosY = int((mouseY)/11);
  for(int x = 0; x < frameWidth; x++) {
    for(int y = 0; y < frameHeight; y++) {
      if(bounds(mousePosX,mousePosY)) {
        noCursor();
        if(mousePosX > x) {
          if(mousePosY > y) {
            if(!isEmpty(x,y)) {
              points[x][y] = '\\';
            }
          }
          else if(mousePosY == y) {
            if(!isEmpty(x,y)) {
              points[x][y] = '-';
            }
          }
          else {
            if(!isEmpty(x,y)) {
              points[x][y] = '/';
            }
          }
        }
        else if(mousePosX == x) {
          if(mousePosY > y || mousePosY < y) {
            if(!isEmpty(x,y)) {
              points[x][y] = '|';
            }
          }
          else {
            if(!isEmpty(x,y)) {
              points[x][y] = '*';
            }
          }
        }
        else {
          if(mousePosY > y) {
            if(!isEmpty(x,y)) {
              points[x][y] = '/';
            }
          }
          else if(mousePosY < y) {
            if(!isEmpty(x,y)) {
              points[x][y] = '\\';
            }
          }
         else {
            if(!isEmpty(x,y)) {
              points[x][y] = '-';
            }
          }
        }
      }
    }
  }    
}
  

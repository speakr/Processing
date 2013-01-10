void enemyInfantry(int xx, int yy) {
  if(random(1) < actionRate) {
    int dirX = int(random(3)) - 1;
    int dirY = int(random(3)) - 1;
    if(dirY+yy < yy && random(1) < forwardBias) {
      dirY = 1;
    }
    if(checkBounds(xx+dirX,yy+dirY)) {
      if(infantry[xx+dirX][yy+dirY] == 'l') {
        dirX = int(random(3)) - 1;
        dirY = int(random(3)) - 1;
        if(dirY+yy > yy && random(1) < forwardBias) {
          dirY = -1;
        }
      }
    }
    int whatToDo = int(random(1,4));
    if(checkBounds(xx-1,yy) && checkBounds(xx+1,yy)) {
      if(terrain[xx-1][yy] == 'X' || terrain[xx+1][yy] == 'X') {
        dirY = 0;
        whatToDo = 2;
      }
    }
    if(enemyCharge && whatToDo > 1) {
      whatToDo = 1;
    }
    switch(whatToDo) {
      case 1:
        if(enemyCharge) {
          float t = random(1);
          if(checkBounds(xx+dirX,yy+1) && t < actionRate) {
            if(infantry[xx+dirX][yy+1] != 'l' && getElevation(xx,yy) != 0) {
              infantry[xx+dirX][yy+1] = 'l';
              infantry[xx][yy] = ' ';
            }
            else if(infantry[xx+dirX][yy+1] != 'l' && getElevation(xx,yy) == 0) {
              if(random(1) < actionRate/1.5) {
                infantry[xx+dirX][yy+1] = 'l';
                infantry[xx][yy] = ' ';
              }
            }
          }
        }
        else {
          if(checkBounds(xx+dirX,yy+dirY)) {
            if(terrain[xx+dirX][yy+dirY] == ' ' || terrain[xx+dirX][yy+dirY] == '@' && infantry[xx+dirX][yy+dirY] != 'l') {
              infantry[xx+dirX][yy+dirY] = 'l';
              infantry[xx][yy] = ' ';
            }
            if(getElevation(xx + dirX,yy + dirY) == 0 && infantry[xx+dirX][yy+dirY] != 'l' && random(1) < actionRate/3) {
              infantry[xx+dirX][yy+dirY] = 'l';
              infantry[xx][yy] = ' ';
            }
          }
          if(checkBounds(xx+dirX,yy-1)) {
            if(isDirt(xx,yy) && infantry[xx+dirX][yy-1] != 'l') {
              infantry[xx+dirX][yy-1] = 'l';
              infantry[xx][yy] = ' ';
            }
          }
        }
        break;
      case 2:
        if(checkBounds(xx+dirX,yy+dirY)) {
          if(terrain[xx+dirX][yy+dirY] == 'X') {
            if(random(1) < actionRate) {
              terrain[xx+dirX][yy+dirY] = ' ';
              infantry[xx+dirX][yy+dirY] = 'l';
              infantry[xx][yy] = ' ';
            }
          }
        }
        if(checkBounds(xx+dirX,yy+dirY)) {
          if(terrain[xx+dirX][yy+dirY] == '^') {
            terrain[xx+dirX][yy+dirY] = '#';
          }
        }
        break;
      case 3:
        if(checkBounds(xx,yy+1)) {
          if(random(1) < rateOfFire && terrain[xx][yy+1] != ' ' && infantry[xx][yy+1] != 'l') {
            bullets[xx][yy+1] = ',';
          }
        }
        break;
      default:
        break;
    }
  }
}

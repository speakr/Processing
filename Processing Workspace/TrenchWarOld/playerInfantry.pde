void playerInfantry(int xx, int yy) {
  //should I move?
  if(random(1) < actionRate) {
    int dirX = int(random(3)) - 1;
    int dirY = int(random(3)) - 1;
    //which direction?
    if(dirY + yy > yy && random(1) < forwardBias) {
      dirY = -1;
    }
    if(checkBounds(xx + dirX, yy + dirY)) {
      //is someone near me?
      if(infantry[xx+dirX][yy+dirY] == 'I') {
        //try moving again
        dirX = int(random(3)) - 1;
        dirY = int(random(3)) - 1;
        if(dirY+yy < yy && random(1) < forwardBias) {
          dirY = -1;
        }
      }
    }
    int whatToDo = int(random(1,4));
    if(checkBounds(xx-1,yy) && checkBounds(xx+1,yy)) {
      //should I be digging?
      if(terrain[xx-1][yy] == 'X' || terrain[xx+1][yy] == 'X') {
        dirY = 0;
        whatToDo = 2;
      }
    }
    //should I be charging?
    if(playerCharge && whatToDo > 1) {
      whatToDo = 1;
    }
    switch(whatToDo) {
      //move
      case 1:
      //charge move
        if(playerCharge) {
          float t = random(1);
          if(checkBounds(xx+dirX,yy-1) && t < actionRate) {
            //charge
            if(infantry[xx+dirX][yy-1] != 'I' && getElevation(xx,yy) != 0) {
              infantry[xx+dirX][yy-1] = 'I';
              infantry[xx][yy] = ' ';
            }
            else if(infantry[xx+dirX][yy-1] != 'I' && getElevation(xx,yy) == 0) {
              if(random(1) < actionRate/1.5) {
                infantry[xx+dirX][yy-1] = 'I';
                infantry[xx][yy] = ' ';
              }
            }
          }
        }
        //normal move
        else {
          if(checkBounds(xx+dirX,yy+dirY)) {
            //move to empty, unoccupied space
            if(terrain[xx+dirX][yy+dirY] == ' ' || terrain[xx+dirX][yy+dirY] == '@' && infantry[xx+dirX][yy+dirY] != 'I') {
              infantry[xx+dirX][yy+dirY] = 'I';
              infantry[xx][yy] = ' ';
            }
            if(getElevation(xx + dirX,yy + dirY) == 0 && infantry[xx+dirX][yy+dirY] != 'I' && random(1) < actionRate/3) {
              infantry[xx+dirX][yy+dirY] = 'I';
              infantry[xx][yy] = ' ';
            }
          }
          //retreat move
          if(checkBounds(xx+dirX,yy+1)) {
            if(isDirt(xx,yy) && infantry[xx+dirX][yy+1] != 'I') {
              infantry[xx+dirX][yy+1] = 'I';
              infantry[xx][yy] = ' ';
            }
          }
        }
        break;
      case 2:
        //dig command
          if(checkBounds(xx+dirX,yy+dirY)) {
            //if X, then dig
            if(terrain[xx+dirX][yy+dirY] == 'X') {
              if(random(1) < actionRate) {
                terrain[xx+dirX][yy+dirY] = ' ';
                infantry[xx+dirX][yy+dirY] = 'I';
                infantry[xx][yy] = ' ';
              }
            }
          }
          if(checkBounds(xx+dirX,yy+dirY)) {
            //if ^ then build
            if(terrain[xx+dirX][yy+dirY] == '^') {
              terrain[xx+dirX][yy+dirY] = '@';
            }
          }
          break;
        case 3:
            //shoot a bullet
            if(checkBounds(xx,yy-1)) {
              //place bullet 1 space in front of infantry
              if(random(1) < rateOfFire && terrain[xx][yy-1] != ' ' && infantry[xx][yy-1] != 'I') {
                bullets[xx][yy-1] = '.';
              }
            }
          break;
        default:
          break;
    }
  }
}
            
                

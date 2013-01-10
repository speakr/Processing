void AI() {
  int checkX = int(random(0,boardWidth-2));
  int checkY = 0;
  boolean foundSpot = false;
  while(!foundSpot) {
    checkX = int(random(5,boardWidth - 5));
    checkY = int(random(0,8));
    if(infantry[checkX][checkY] == 'l') {
      foundSpot = true;
    }
    else {
      break;
    }
  }
  if(foundSpot) {
    int randDir = int(random(1,4));
      switch(randDir) {
        case 1:
          if(checkY%2 == 0/2) {
            markTrench(checkX - 8, checkY, checkX, checkY);
          }
          break;
        case 2:
           if(isDirt(checkX-1,checkY+1) && isDirt(checkX+1,checkY+1) && isDirt(checkX,checkY+1) && checkY < int(random(0,boardHeight/2)) ){ //
             if (random(1)<actionRate * .3){
               markTrench(checkX, checkY+1,checkX,checkY+1);
               markTrench(checkX-1, checkY+2,checkX-1,checkY+2);
               markTrench(checkX+1, checkY+2,checkX+1,checkY+2);
             }
           }
           break;
         case 3:
           if(checkY%2 == 0/2) {
             markTrench(checkX, checkY, checkX+8, checkY);
           }
           break;
         default:
           break;
      }
  }
}

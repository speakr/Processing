void enemyBullet(int xx, int yy) {
  //move bullet
  if(checkBounds(xx, yy+1)) {
    bullets[xx][yy+1] = ',';
    bullets[xx][yy] = ' ';
    //did we hit someone?
    if(infantry[xx][yy+1] == 'I') {
      //are they in a trench?
      if(terrain[xx][yy] != ' ' && terrain[xx][yy+1] == ' ') {
        //give them a chance to live
        if(random(1) < coverDeathChance) {
          //kill them
          infantry[xx][yy+1] = '*';
          bullets[xx][yy+1] = ' ';
        }
      }
      else {
        infantry[xx][yy+1] = '*';
        bullets[xx][yy+1] = ' ';
      }
    }
  }
  //despawn bullet
  else {
    bullets[xx][yy] = ' ';
  }
}

void keyReleased() {
  if(key == 'p') {
    pauseFunc();
  }
  if (key == 'c') { //make this dependent on a charge meter
    playerCharge = true;
  }
  if(key == 'r') { //make dedicated retreat command
    playerCharge = false;
  }
  if(key == 'm') { //new map and new game
    playerSpawned = 0;
    enemySpawned = 0;
    playerInfantry = 0;
    enemyInfantry = 0;
    setup();
   }
   if(key == 's') {
     screenCounter++;
     save("screenshot"+screenCounter+".png");
   }
}

void keyPressed() {
}

void draw() {
  if(!focused) {
    pauseFunc();
  }
  //build charge meters
  if(!isPaused) {
    playerChargeRate += playerChargeRate*.005;
    if(playerChargeRate > 0.15) { //start charge
      enemyChargeRate = 0.000005;
      playerChargeRate = 0.0000004;
      playerChargeLoss = playerLoss;
      playerCharge = true;
    }
    enemyChargeRate += enemyChargeRate*.005;
    if(enemyChargeRate > 0.15) { //start charge
      playerChargeRate = 0.000005;
      enemyChargeRate = 0.0000004;
      enemyChargeLoss = enemyLoss;
      enemyCharge = true;
    }
    //keep charging?
    if(enemyCharge) {
      if(enemyLoss - enemyChargeLoss > enemyInfantry/1.3) {
        enemyCharge = false;
      }
    }
    if(playerCharge) {
      if(playerLoss - playerChargeLoss > playerInfantry/1.3) {
        playerCharge = false;
      }
    }
    //spawn mortars
    mortarRate += mortarRate*.02;
    if(mortarRate > 0.15) {
      mortarRate = 0.00000051;
    }
    if(random(1) < mortarRate) {
      int TX = int((random(boardWidth*.49) + random(boardWidth*.49)) - boardWidth*.49) + int(boardWidth/2) - 1;
      int TY = int((random(boardHeight*.45) + random(boardHeight*.45)) - boardHeight*.45) + int(boardHeight/2) - 1;
      if(checkBounds(TX,TY) && checkBounds(TX,TY)) {
        terrain[TX][TY] = 'O';
      }
    }
    if(!enemyCharge) {
      AI();
    }
    isThinking = true;
    int trySpawn;
    //player infantry spawn
    if(random(1) < spawnRate) {
    trySpawn = int(random(startPoint2 - 10, startPoint1 - 10));
      if(infantry[trySpawn][boardHeight-1] != 'I' && terrain[trySpawn][boardHeight-1] == ' ') {
        infantry[trySpawn][boardHeight-1] = 'I'; //place infantry
        playerSpawned++;
      }
    }
    //enemy spawn rate
    if(random(1) < spawnRate*(0.9+(level/30))) {
      trySpawn = int(random(startPoint1 - 10, startPoint2 + 10));
      if(infantry[trySpawn][0] != 'l' && terrain[trySpawn][0] == ' ') { //place infantry
      infantry[trySpawn][0] = 'l';
      enemySpawned++;
    }
  }
  //check for changes every tick
  for(int x = 0; x < boardWidth; x++) {
    for(int y = 0; y < boardHeight; y++) {
      //bullets
      if(bullets[x][y]=='.') {
        playerBullet(x,y);
      }
      if(bullets[x][boardHeight-y-1]==',') {
        enemyBullet(x,boardHeight - y - 1);
      }
      //infantry
      switch(infantry[x][y]) {
        case 'I':
          playerInfantry(x,y);
          break;
        case 'l':
          enemyInfantry(x,y);
          break;
        case '*':
          if(random(1) < 0.005) {
            infantry[x][y] = ' ';
          }
          break;
        default:
          break;
      }
      //mortars
      switch(terrain[x][y]) {
        case 'O':
          if(random(1) < actionRate * 0.3) {
            terrain[x][y] = 'o';
          }
          break;
        case 'o':
          if(random(1) < actionRate * 0.3) {
            terrain[x][y] = '+';
          }
          break;
        case '+':
          terrain[x][y] = '§';
          //was someone there?
          if(infantry[x][y] != ' ') {
            //kill them
            infantry[x][y] = '*';
          }
          //splash radius
          for(int i = 0; i < 12; i++) {
            int splashX = int(random(3))-1;
            int splashY = int(random(3))-1;
            if(checkBounds(x+splashX,y+splashY)) {
              //ground zero
              if(terrain[x+splashX][y+splashY] == ' ' && random(1) < 0.97) {
                terrain[x+splashX][y+splashY] = ' ';
                //is there infantry?
                if(infantry[x+splashX][y+splashY] != ' ') {
                  //kill them
                  infantry[x+splashX][y+splashY] = '*';
                }
              }
              //explosion radius
              else {
                terrain[x+splashX][y+splashY] = '§';
                //was someone there?
                if(infantry[x+splashX][y+splashY] != ' ' && random(1) < 0.85 /*chance to survive*/) {
                  infantry[x+splashX][y+splashY] = '*';
                }
              }
            }
          }
          //chance for crater hole
          if(random(1) < 0.5) {
            terrain[x][y] = ' ';
          }
        break;
      case '§': //make crater
        if(random(1) < actionRate && getElevation(x,y) != 0) {
          terrain[x][y] = '½';
        }
        else if(random(1) < actionRate && getElevation(x,y) == 0) {
          terrain[x][y] = '¢';
        }
        break;
      default:
        break;
      }
    }
  }
  //render
  enemyInfantry = 0;
  playerInfantry = 0;
  background(25,20,25);
  
  for(int x = 0; x < boardWidth; x++) {
    for(int y = 0; y < boardHeight; y++) {
      //populate display
      display[x][y] = terrain[x][y];
      if(bullets[x][y] != ' ') {
        display[x][y] = bullets[x][y];
      }
      if(infantry[x][y] != ' ') {
        display[x][y] = infantry[x][y];
      }
      if(getElevation(x,y) != 0 && !isDirt(x,y)) {
                  if(getElevation(x-1,y) == 0 || getElevation(x+1,y) == 0 || getElevation(x,y+1) == 0 || getElevation(x,y-1) == 0 && random(1)*2 < actionRate/2) {
                    terrain[x][y] = '¢';
                    heightMap[x][y] = 0;
                  }
                }
      //colorize water background
      switch(getElevation(x,y)) {
        case 0:
          fill(24,37,50);
          stroke(24,37,50);
          rect(x*10 + leftMargin, y*11 + (topMargin-11), 10, 11);
          break;
        default:
          fill(25,20,25);
          break;
      }
      //building gets rid of water
      switch(terrain[x][y]) {
        case '@':
          heightMap[x][y] = 1;
          break;
        default:
          break;
      }
      //colorize
      switch(display[x][y]) {
        case 'O':
          fill(250,250,250);
          break;
        case 'o':
          fill(240,240,240);
          break;
        case '+':
          fill(230,230,230);
          break;
        case '§':
          fill(250,int(random(130)+100),130);
          break;
        case '½':
          fill(64,64,64);
          break;
        case 'I':
          fill(125,110,45);
          playerInfantry++;
          break;
        case 'l':
          fill(80,115,80);
          enemyInfantry++;
          break;
        case '.':
          fill(250,250,250);
          break;
        case ',':
          fill(250,250,250);
          break;
        case '¤':
          fill(200,50,50);
          break;
        case 'X':
          fill(203,155,106);
          break;
        case '^':
          fill(255,255,255);
          break;
        case '*':
          fill(200,100,50);
          break;
        case '¢':
          fill(117,134,141);
          break;
        case '¥':
          fill(75,68,59);
          break;
        case '$':
          fill(78,78,63);
          break;
        case '€':
          fill(71,85,71);
          break;
        case '£':
          fill(91,111,102);
          break;
        case '¶':
          fill(111,113,115);
          break;
        case '#':
          fill(255);
          break;
        default:
          fill(192,192,192);
          break;
      }
      text(display[x][y], x*10 + leftMargin, y*11 + topMargin);
    }
  }
  //print info
  fill(100);
  text("LMB=trench exp. (P)ause.    Troops/Losses:", leftMargin, 15);
  //print enemy info
  fill(80,100,80);
  text(enemyInfantry + "/" + enemyLoss, 460, 15);
  //print player info
  fill(100,90,50);
  text(playerInfantry + "/" + playerLoss, 550, 15);
  
  //mouse over
  int boardMouseX = int((mouseX - leftMargin)/10);
  int boardMouseY = int((mouseY - topMargin)/11) + 1;
  if(boardMouseX < boardWidth && boardMouseY < boardHeight && boardMouseX >= 0 && boardMouseY >= 0) {
    fill(terrainColor[boardMouseX][boardMouseY] + 50);
    text(display[boardMouseX][boardMouseY], boardMouseX*10 + leftMargin, boardMouseY *11 + topMargin);
  }
  //win meter
  playerLoss = playerSpawned - playerInfantry;
  enemyLoss = enemySpawned - enemyInfantry;
  
  if(enemyLoss > 0 && playerLoss > 0) {
    percentage = float(enemyLoss)/float(enemyLoss+playerLoss);
  }
  else {
    percentage = 0.5;
    meter = 0.5;
  }
  float plAdv = enemyLoss + (float(playerInfantry)*1.3);
  float enemyAdv = playerLoss + (float(enemyInfantry)*1.3);
    if(plAdv - enemyAdv < -10 || plAdv - enemyAdv > 10) {
      meter = meter + ((plAdv - enemyAdv) * 0.000003);
    }
    for(int i = 0; i < boardHeight; i++) {
      if(meter > 1 - float(i)/float(boardHeight)) {
        fill(120,110,70);
      }
      else {
        fill(80,100,80);
      }
      text("#",(boardWidth + 2)*10 + leftMargin, i*11 + topMargin);
    }
    if(meter > 1) {
      pauseText = "-----=:| YOU WIN! |:=-----";
      pauseFunc();
    }
    if(meter < 0) {
      pauseText = "-----=:| YOU LOSE |:=-----";
      pauseFunc();
    }
  }
  else {
    pauseFunc();
  }
}     
        
        
                  
          
    

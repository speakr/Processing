// adjust difficulty - how????

//TODO: Limit where you can place dig markers and where they dig.
//TODO: Win conditions + levels
//TODO: Close Combat blood
float level=1;

float percentage=0.5;
float meter=0.5;
    
int playerSpawned =0 ;
int AISpawned =0 ;

int InfantryCounterCPU=0;
int InfantryCounterPlayer=0;
int lMargin=6;
int tMargin=29;

float actionRate = 0.185;
float rateOfFire = 0.09;
float spawnRate = 0.02;
float forwardBias = 0.2;
float mortarRate = 0.000001;

float AIChargeRate = random(1) * 0.00002;
float playerChargeRate = random(1) * 0.00001;

int AIChargeDeath=0;
int playerChargeDeath=0;

int playerLoss = 0;
int AILoss = 0;

float deathBehindCoverChance = 0.04;
boolean Paused = false;
boolean AIworking = true;
boolean playerCharge = false;
boolean AICharge = false;

int boardWidth = 76;
int boardHeight = 52;//66;
int winMeter=0;

int startPoint1 = int( random ( 14 , boardWidth -14 )); // AI
int startPoint2 = int( random ( 14 , boardWidth -14 )); // player
char[][] terrain = new char[boardWidth][boardHeight];
char[][] display = new char[boardWidth][boardHeight];
int[][] terrainColor = new int[boardWidth][boardHeight];
char[][] bullets = new char[boardWidth][boardHeight];
char[][] infantry = new char[boardWidth][boardHeight];
PFont font;
String pauseText = "-----=:|  (P)AUSED  |:=-----";
      
void setup(){
  background( 0x000000 );
  size( 800, 600 );
  font = loadFont("CourierNewPS-BoldMT-48.vlw");
  textFont(font,16);
  for (int x=0;x<boardWidth;x++){
    for (int y=0;y<boardHeight;y++){
      bullets[x][y] = ' ';
      terrain[x][y] = 'O';
      infantry[x][y] = ' ';
      setupTerrain(x,y);
      
      terrainColor[x][y] = int(random(60,85));
      display[x][y] = terrain[x][y];
    }
  }
  setupStartPos();
}

void draw(){

  if (!focused) {  // If not focused pause game.
    pauseFunc();
  }
  if(!Paused){
    playerChargeRate += playerChargeRate* .005 ;
    if (playerChargeRate > 0.15){
      AIChargeRate = 0.000005;
      playerChargeRate = 0.0000004;
      playerChargeDeath = playerLoss;
      playerCharge=true;
    }
    AIChargeRate += AIChargeRate* .005 ;
    if (AIChargeRate > 0.15){
      playerChargeRate = 0.000005;
      AIChargeRate = 0.0000004;
      AIChargeDeath = AILoss;
      AICharge=true;
    }
    if(AICharge){
      if(AILoss-AIChargeDeath>InfantryCounterCPU/1.3){
        AICharge=false;
      }
    }
    if(playerCharge){
      if(playerLoss-playerChargeDeath>InfantryCounterPlayer/1.3){
        playerCharge=false;
      }
    }  
  
    // Spawn infantry
    mortarRate += mortarRate* .02 ;
    if (mortarRate > 0.15){
      mortarRate = 0.00000051;
    }

    if (random(1)<mortarRate){
      int TX = int((random(boardWidth*.49) + random(boardWidth*.49))-boardWidth*.49) + int(boardWidth/2)-1;
      int TY = int((random(boardHeight*.45) + random(boardHeight*.45))-boardHeight*.45) + int(boardHeight/2)-1;  
      if (checkBounds(TX,TY) && checkBounds(TX,TY)){
        terrain[TX][TY]='O'; //create mortarshell
      }
    }
    if (!AICharge){
      AI();
    }
    AIworking=true;
    int trySpawn;
    if (random(1)<spawnRate){ //Player infantry
      trySpawn = int(random(startPoint2 -10,startPoint1 +10));
      if (infantry[trySpawn][boardHeight-1] != 'I' && terrain[trySpawn][boardHeight-1] == ' ' ){
        infantry[trySpawn][boardHeight-1] = 'I';
        playerSpawned++;
      }
    }
    if (random(1) < spawnRate*(0.9+(level/30))){ //CPU infantry
      trySpawn = int(random(startPoint1 -10,startPoint2 +10));
      if (infantry[trySpawn][0] != 'l' && terrain[trySpawn][0] == ' ' ){
        infantry[trySpawn][0] = 'l';
        AISpawned++;
      }
    }
    // loop entire board and act upon what ever is found.
    for (int x=0;x<boardWidth;x++){
      for (int y=0;y<boardHeight;y++){
        //move bullets
        if (bullets[x][y]=='.'){//move bullets
          playerBullet(x,y);// display[x][y]='.';
        }
        if (bullets[x][boardHeight-y-1]==','){
          CPUBullet(x,boardHeight-y-1);// display[x][y]='.';
        }
        switch (infantry[x][y]){
          case 'I': //player infantry
            playerInfantry(x,y);
            break;
          case 'l': //CPU infantry
            CPUInfantry(x,y);
            break;
          case '*': //CPU blodspatter
            if (random(1)<0.005){
              infantry[x][y]=' ';
            }
            break;
          default: // empty?
            break;
        }
        switch (terrain[x][y]){
          
          case 'O': //mortar1
              if(random(1)<actionRate * .3){
                terrain[x][y]='o';
              }
            break;
          case 'o': //mortar2
            if(random(1)<actionRate * .3){
              terrain[x][y]='+';
            }
            break;
          case '+': //mortar3
             terrain[x][y]='§';
             if (infantry[x][y] !=' '){
               infantry[x][y] ='*';
             }
             for (int i=0;i<12;i++){
               int drX= int(random(3))-1;
               int drY= int(random(3))-1;
               if (checkBounds(x+drX,y+drY)){
                 if ( terrain[x+drX][y+drY]==' ' && random(1)<0.97 ){
                   terrain[x+drX][y+drY]=' ';
                   if (infantry[x+drX][y+drY] !=' '){
                     infantry[x+drX][y+drY] ='*';
                   }
                 }else{
                   terrain[x+drX][y+drY]='§';
                   if (infantry[x+drX][y+drY] !=' '){
                     infantry[x+drX][y+drY] ='*';
                   }
                 }
               }
             }
             if (random(1)<0.5){
               terrain[x][y]=' ';
               //infantry[x][y]='*';
             }
            break;
          case '§': //make crater
            if(random(1)<actionRate){
              terrain[x][y]='½';
            }
            break;
          default: // probably terrain
            break;
        }
      }
    }

    // Render display
    InfantryCounterCPU=0;
    InfantryCounterPlayer=0;
    background(25, 20, 15);
    
    for (int x=0;x<boardWidth;x++){
      for (int y=0;y<boardHeight;y++){
        
        // fill display array with relevant data from terrain and bullets arrays
         display[x][y] = terrain[x][y];
         if (bullets[x][y] != ' '){
           display[x][y] = bullets[x][y];
         }
         if (infantry[x][y] != ' '){
           display[x][y] = infantry[x][y];
         }
         
         
         //markTrench(3,3,boardWidth -3,3);
         
         
       // Colorization haxxx
       switch (display[x][y]){ 
          case 'O': //mortar1
              fill(250,250,250);
            break;
          case 'o': //mortar2
              fill(240,240,240);
            break;
          case '+': //mortar1
              fill(230,230,230);
            break;
          case '§': //mortar1
              fill(250,int(random(130)+100),130);
            break;
          case '½': //mortar1
              fill(terrainColor[x][y]-20);
            break;
          case 'I': //player infantry
            fill(100,90,50);
            InfantryCounterPlayer++;       
            break;
          case 'l': //CPU infantry
            fill(80,100,80);
            InfantryCounterCPU++;
            break;
          case '.': //player bullet 
            fill(250,250,250);
            break;
          case ',': //CPU bullet 
            fill(250,250,250);
            break;
          case '¤': //mortar round
            fill(200,50,50);
            break;
          case 'X': //dig marker
            fill(100);
            break;
          case '^': //build marker
            fill(100);
            break;
          case '*': //blood
            fill(200,100,50);
            break;
          default: // probably terrain
            fill(terrainColor[x][y]);
            break;
        } 

        text(display[x][y], x*10 + lMargin, y*11 + tMargin);
      }
    }
    // print instructions
    fill(100);
    text("LMB=trench exp. (P)ause.     Troops/Losses: ", lMargin, 15);
    // print infantry
    fill(80,100,80);
    text(InfantryCounterCPU + "/" + AILoss, 460, 15);
    //text("They: " + InfantryCounterCPU, 460, 15);
    fill(100,90,50);
    text(InfantryCounterPlayer + "/" + playerLoss, 550, 15);
    //text("You: " + InfantryCounterPlayer, 550, 15);

    // Board mouseover
    int boardMouseX = int((mouseX - lMargin)/10);
    int boardMouseY = int((mouseY - tMargin)/11)+1;
    if (boardMouseX < boardWidth && boardMouseY < boardHeight && boardMouseX >= 0 && boardMouseY >= 0) {
      fill(terrainColor[boardMouseX][boardMouseY] + 50 );
      text(display[boardMouseX][boardMouseY], boardMouseX*10 + lMargin, boardMouseY * 11 + tMargin);
    }
    //Winmeter
    playerLoss = playerSpawned - InfantryCounterPlayer;
    AILoss = AISpawned - InfantryCounterCPU;
    //println(AILoss + " ; " + (AISpawned - InfantryCounterCPU));
    //println(playerLoss + " ; " + (playerSpawned - InfantryCounterPlayer));

    
    
    if(AILoss>0 && playerLoss>0){
      percentage = float(AILoss)/float(AILoss+playerLoss);
      //println(float(AILoss)/float(AILoss+playerLoss));
      println(meter);
    } else {
      percentage=0.5;
      meter=0.5;
      println(meter);
    }/*
    if(percentage<.43){
      meter = meter - 0.00011;
    }
    if(percentage>.57){
      meter = meter - 0.00011;
    }*/
    float plAdv=AILoss + (float(InfantryCounterPlayer)*1.3);
    float AIAdv=playerLoss + (float(InfantryCounterCPU)*1.3);
    
      if ( plAdv - AIAdv < - 10 || plAdv - AIAdv > 10){
        meter = meter + ( (plAdv - AIAdv) * 0.000003);
      }

    
    for (int i=0;i<boardHeight;i++){
      if (meter>1-float(i)/float(boardHeight)){
        fill(120,110,70);
      }else{
        fill(80,100,80);
      }
      text("#", (boardWidth + 2)*10 + lMargin, i*11 + tMargin);
    }
    if (meter>1){
      //pauseText = "-----=:|  (P)AUSED  |:=-----";
      pauseText = "-----=:|  YOU WIN!  |:=-----";
      pauseFunc();
      //Paused=true;
      println("WIN!");
    }
    if (meter<0){
      pauseText = "-----=:|  YOU LOSE  |:=-----";
      pauseFunc();
      //Paused=true;
      println("LOSE!");
    }
  } else {
    // Paused
    pauseFunc();  
  } 
}
void playerBullet(int xx,int yy){
  if (checkBounds(xx,yy-1)){ //move bullet.
    bullets[xx][yy-1] = '.';
    bullets[xx][yy]=' ';
    if (infantry[xx][yy-1] == 'l'){  // if bullet encounter enemy
      if(terrain[xx][yy] != ' ' && terrain[xx][yy-1] == ' '){ // and enemy is behind dirt cover and not on dirt
        if(random(1)<deathBehindCoverChance){
          infantry[xx][yy-1] = '*';// killed
          bullets[xx][yy-1] = ' ';
        }
      } else {
        infantry[xx][yy-1] = '*';// killed
        bullets[xx][yy-1] = ' ';
      }
    }
  } else {
    bullets[xx][yy] = ' ';
  }
}
void CPUBullet(int xx,int yy){
  if (checkBounds(xx,yy+1)){ //move bullet.
    bullets[xx][yy+1] = ',';
    bullets[xx][yy]=' ';
    if (infantry[xx][yy+1] == 'I'){ // if bullet encounter enemy
      if(terrain[xx][yy] != ' ' && terrain[xx][yy+1] == ' '){ // and enemy is behind dirt cover and not on dirt
        if(random(1) < deathBehindCoverChance){
          infantry[xx][yy+1] = '*';// killed
          bullets[xx][yy+1] = ' ';
        }
      } else { // killed
        infantry[xx][yy+1] = '*';
        bullets[xx][yy+1] = ' ';
      }
    }
  } else {
  bullets[xx][yy] = ' ';
  }
}
void playerInfantry(int xx,int yy){
  if (random(1)<actionRate){
    int dirX= int(random(3))-1;
    int dirY= int(random(3))-1;
    if (dirY+yy>yy && random(1)<forwardBias){
      dirY=-1;
    }
    if(checkBounds(xx+dirX,yy+dirY)){
      if (infantry[xx+dirX][yy+dirY]== 'I'){ // decrease chance of crowds
        dirX= int(random(3))-1;
        dirY= int(random(3))-1;
        if (dirY+yy>yy && random(1)<forwardBias){
          dirY=-1;
        }
      }
    }
    int whatToDo =int(random(1,4));
    if(checkBounds(xx-1,yy) && checkBounds(xx+1,yy)){
      if (terrain[xx-1][yy]== 'X' || terrain[xx+1][yy]== 'X'){ // increase chance of digging neighbor dig markers sideways
        dirY=0;
        whatToDo=2;
      }
    }
    if (playerCharge && whatToDo > 1){ // if charge, only move
      whatToDo = 1;
    }
    switch (whatToDo){
      case 1: // Move
        if(playerCharge){
          float t=random(1);
          if (checkBounds(xx+dirX,yy-1) && t < actionRate){
            if (infantry[xx+dirX][yy-1] != 'I'){ //CHARGE!!
              infantry[xx+dirX][yy-1] = 'I';
              infantry[xx][yy] = ' ';
            }            
          }          
        }else{
          if (checkBounds(xx+dirX,yy+dirY)){
            if (terrain[xx+dirX][yy+dirY] == ' ' && infantry[xx+dirX][yy+dirY] != 'I'){ // if found empty space, move there.
                infantry[xx+dirX][yy+dirY] = 'I';
                infantry[xx][yy] = ' ';
            }
          }
          if (checkBounds(xx+dirX,yy+1)){
            if (isDirt(xx,yy) && infantry[xx+dirX][yy+1] != 'I'){ //RETREAT!!
              infantry[xx+dirX][yy+1] = 'I';
              infantry[xx][yy] = ' ';
            }
          }
        }
        break;
      case 2: // Dig
        if (checkBounds(xx+dirX,yy+dirY)){
          if (terrain[xx+dirX][yy+dirY] == 'X'){ // if found dig marker, dig.
            if(random(1)<actionRate){
              terrain[xx+dirX][yy+dirY] = ' ';
              infantry[xx+dirX][yy+dirY] = 'I';
              infantry[xx][yy] = ' ';
            }else{
              //terrainColor[xx+dirX][yy+dirY] = 250; //There should be a blink to mark digging action.
            }
          }
        }
        if (checkBounds(xx+dirX,yy+dirY)){
          if (terrain[xx+dirX][yy+dirY] == '^'){ // if found build marker, build.
            terrain[xx+dirX][yy+dirY] = '#';
            //terrain[xx][yy] = ' ';
          }
        }
        break;
      case 3: // Shoot!
        if (checkBounds(xx,yy-1)){ //place bullet in front of player infantry if behind cover
          if (random(1)<rateOfFire  && terrain[xx][yy-1] != ' ' && infantry[xx][yy-1] != 'I'){
            bullets[xx][yy-1] = '.';
          }
        } 
        break;
      default: // Nothing
        break;
    }
  }
}
void CPUInfantry(int xx,int yy){
  if (random(1)<actionRate){
    int dirX= int(random(3))-1;
    int dirY= int(random(3))-1;
    if (dirY+yy<yy && random(1)<forwardBias){
      dirY=1;
    }
    if(checkBounds(xx+dirX,yy+dirY)){
      if (infantry[xx+dirX][yy+dirY]== 'l'){ // decrease chance of crowds
        dirX= int(random(3))-1;
        dirY= int(random(3))-1;
        if (dirY+yy>yy && random(1)<forwardBias){
          dirY=-1;
        }
      }
    }
    int whatToDo =int(random(1,4));
    if(checkBounds(xx-1,yy) && checkBounds(xx+1,yy)){
      if (terrain[xx-1][yy]== 'X' || terrain[xx+1][yy]== 'X'){ // increase chance of digging neighbor dig markers sideways
        dirY=0;
        whatToDo=2;
      }
    }
    if (AICharge && whatToDo > 1){ // if charge, only move
      whatToDo = 1;
    }
    switch (whatToDo){
      case 1: // Move
        if(AICharge){
          float t=random(1);
          if (checkBounds(xx+dirX,yy+1) && t < actionRate){
            if (infantry[xx+dirX][yy+1] != 'l'){ //CHARGE!!
              infantry[xx+dirX][yy+1] = 'l';
              infantry[xx][yy] = ' ';
            }            
          }          
        }else{
          if (checkBounds(xx+dirX,yy+dirY)){
            if (terrain[xx+dirX][yy+dirY] == ' ' && infantry[xx+dirX][yy+dirY] != 'l'){ // if found empty space, move there.
                infantry[xx+dirX][yy+dirY] = 'l';
                infantry[xx][yy] = ' ';
            }
          }
          if (checkBounds(xx+dirX,yy-1)){
            if (isDirt(xx,yy) && infantry[xx+dirX][yy-1] != 'l'){ //RETREAT!!
              infantry[xx+dirX][yy-1] = 'l';
              infantry[xx][yy] = ' ';
            }
          }
        }
        break;
      case 2: // Dig
        if (checkBounds(xx+dirX,yy+dirY)){
          if (terrain[xx+dirX][yy+dirY] == 'X'){ // if found dig marker, dig.
            if(random(1)<actionRate){
              terrain[xx+dirX][yy+dirY] = ' ';
              infantry[xx+dirX][yy+dirY] = 'l';
              infantry[xx][yy] = ' ';
            }else{
              //terrainColor[xx+dirX][yy+dirY] = 250; //There should be a blink to mark digging action.
            }
          }
        }
        if (checkBounds(xx+dirX,yy+dirY)){
          if (terrain[xx+dirX][yy+dirY] == '^'){ // if found build marker, build.
            terrain[xx+dirX][yy+dirY] = '#';
            //terrain[xx][yy] = ' ';
          }
        }
        break;
      case 3: // Shoot!
          if (checkBounds(xx,yy+1) ){ //place bullet in front of player infantry
          if (random(1)<rateOfFire && terrain[xx][yy+1] != ' ' && infantry[xx][yy+1] != 'l'){
            bullets[xx][yy+1] = ',';
          }
        } 
        break;
      default: // Nothing
        break;
    }
  }
}
void keyReleased() {
  if (key == 'p' || key == 'P') {
    pauseFunc();
  }
  if (key == 'c'){
    AICharge=true;
  }
  if (key == 's'){
    AICharge=false;
  }
    /*if (Paused){
      //println("Start");
      loop();
      Paused = false;
    } else {
      text("(P)AUSED", 18, 15);
      Paused = true;
      noLoop();
    }
  }*/
  /*if (key == 'm' || key == 'M') {
    generateMap();
  }*/
}
boolean checkBounds(int xx,int yy){
  if (xx >= 0 && xx < boardWidth && yy >= 0 && yy < boardHeight){
    return true;
  } else {
    return false;
  }
}
void mousePressed() { //Mark for digging if mouse pressed on soil

  //TODO: Build orders on right mouse button
  int boardMouseX = int((mouseX - lMargin)/10);
  int boardMouseY = int((mouseY - tMargin)/11)+1;
  if (checkBounds( boardMouseX , boardMouseY)) {
    if (terrain[boardMouseX][boardMouseY] != ' ' && terrain[boardMouseX][boardMouseY] != 'I' && terrain[boardMouseX][boardMouseY] != 'l'){
      terrain[boardMouseX][boardMouseY] = 'X';
    }
  }
  if (checkBounds( boardMouseX , boardMouseY)) {
    if (terrain[boardMouseX][boardMouseY] == ' '){
      terrain[boardMouseX][boardMouseY] = '^';
    }
  }/*
  if (checkBounds( boardMouseX , boardMouseY)) {
    if (terrain[boardMouseX][boardMouseY] == 'X' ){
      terrain[boardMouseX][boardMouseY] = getTerrain();
    }
  }*/
}
void mouseDragged() { //Mark for digging if mouse dragged on soil
  int boardMouseX = int((mouseX - lMargin)/10);
  int boardMouseY = int((mouseY - tMargin)/11)+1;
  if (checkBounds( boardMouseX , boardMouseY)) {
    if (terrain[boardMouseX][boardMouseY] != ' ' && infantry[boardMouseX][boardMouseY] != 'I' && infantry[boardMouseX][boardMouseY] != 'l'){
      terrain[boardMouseX][boardMouseY] = 'X';
    }
  }
  if (checkBounds( boardMouseX , boardMouseY)) {
    if (terrain[boardMouseX][boardMouseY] == ' ' ){
      //terrain[boardMouseX][boardMouseY] = '^';
    }
  }/*
  if (checkBounds( boardMouseX , boardMouseY)) {
    if (terrain[boardMouseX][boardMouseY] == 'X' ){
      terrain[boardMouseX][boardMouseY] = getTerrain();
    }
  }*/
}
void setupTerrain(int tx, int ty){
  int randTerrain = int(random ( 1, 5 )) ;
  switch (randTerrain){
    case 1:
      terrain[tx][ty] = '#';
      break;
    case 2:
      terrain[tx][ty] = '&';
      break;
    case 3:
      terrain[tx][ty] = '£';
      break;
    case 4:
      terrain[tx][ty] = '%';
      break;
    default:
      terrain[tx][ty] = ' ';
      break;
  }
}
void setupStartPos(){
  
  for (int startCorridor = 0; startCorridor < 1; startCorridor++){
    terrain[startPoint1][startCorridor] = ' ';
    for(int i=startPoint1 - 10;i<startPoint1 + 10;i++){
      terrain[i][0] = ' ';
      if (random(1) < 0.5){
        infantry[i][0]='l';
        AISpawned++;
      }
    }
    //terrain[startPoint1+1][startCorridor] = ' ';
    //terrain[startPoint1-1][startCorridor] = ' ';
  }
  for (int startCorridor = 0; startCorridor < 1; startCorridor++){
    terrain[startPoint2][boardHeight-startCorridor-1] = ' ';
    for(int i=startPoint2 - 10;i<startPoint2 + 10;i++){
      terrain[i][boardHeight-1] = ' ';
      if (random(1) < 0.5){
        infantry[i][boardHeight-1]='I';
        playerSpawned++;
      }
    }
    //terrain[startPoint2-1][boardHeight-startCorridor-1] = ' ';
    //terrain[startPoint2+1][boardHeight-startCorridor-1] = ' ';
  }
  
  
}
void pauseFunc() { // WOW AMAZING A MOTHERFUCKING PAUSE FUNCTION THAT WORKS
    if (!Paused){
      background(25, 20, 15);
      //textFont(myFont, 10);

      text(pauseText, int(boardWidth/2*10 - 120), int(boardHeight/2*11)); //textOut(pauseText,390,360,10);
      Paused=true;
      noLoop();
    } else {
      Paused=false;
      loop(); 
    }
}
char getTerrain(){
  char returnChar;
    int randTerrain = int(random ( 1, 5 )) ;
  switch (randTerrain){
    case 1:
      returnChar = '#';
      break;
    case 2:
      returnChar = '&';
      break;
    case 3:
      returnChar = '£';
      break;
    case 4:
      returnChar = '%';
      break;
    case 5:
      returnChar = '=';
      break;
    default:
      returnChar = 'X';
      break;
  }
    return returnChar;
}
void AI(){
  int checkX= int(random ( 0, boardWidth -2 ));
  int checkY= 0;
  //int tryHere = int(random ( 1, boardWidth -2 )) ;
  boolean foundSpot=false;
  //checkX=startPoint2;
  while (!foundSpot){ // randomly find AI infantry with supershitty code.
    checkX= int(random ( 5, boardWidth -5 ));
    checkY= int(random ( 0, 8));
    
    if(infantry[checkX][checkY] == 'l'){
      foundSpot=true;
    } else {
      break;
    }

  }
  if (foundSpot){

   int randDir = int(random ( 1, 4 )) ; //Mark dirt next to him for digging in random direction, strong bias horizontally.
    switch (randDir){
    case 1:
    if (checkY%2 == 0/2){
      markTrench(checkX -8, checkY,checkX,checkY);
    }
      break;
    case 2:
    //println(checkX+","+checkY);
      if(isDirt(checkX-1,checkY+1) && isDirt(checkX+1,checkY+1) && isDirt(checkX,checkY+1) && checkY < int(random(0,boardHeight/2)) ){ //
        if (random(1)<actionRate * .3){
          markTrench(checkX, checkY+1,checkX,checkY+1);
          markTrench(checkX-1, checkY+2,checkX-1,checkY+2);
          markTrench(checkX+1, checkY+2,checkX+1,checkY+2);
        }
      }
      break;
    case 3:
    if (checkY%2 == 0/2){
      markTrench(checkX, checkY,checkX + 8,checkY);
    }
      break;
    default:
      
      break;
  }

  }
}
void markTrench(int x1,int y1,int x2,int y2){
  for (int xi=x1;xi<=x2;xi++){
    for (int yi=y1;yi<=y2;yi++){
      if (checkBounds(xi,yi)){
        if (isDirt(xi,yi)){
          terrain[xi][yi] = 'X';
        }
      }
    }
  }
}
boolean isDirt(int xx, int yy){
  if (checkBounds(xx,yy)){
    if (terrain[xx][yy] != ' '){
      
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

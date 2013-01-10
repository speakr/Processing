//TODO Add safety feature so that map will regen until troops are not in water
//TODO Make terrain mean something
//TODO Mustard gas
//TODO Make AI work differently if it reaches the other end of the map
//TODO? Procedural map? Campaign? Command unit?

float level=1;

float percentage = 0.5;
float meter = 0.5;

int playerSpawned = 0;
int enemySpawned = 0;

int playerInfantry = 0;
int enemyInfantry = 0;
int leftMargin = 6;
int topMargin = 30;


float actionRate = 0.185;
float rateOfFire = 0.09;
float spawnRate = 0.02;
float forwardBias = 0.2;
float mortarRate = 0.000001;

float enemyChargeRate = random(1) * 0.00002;
float playerChargeRate = random(1) * 0.00001;

int enemyChargeLoss = 0;
int playerChargeLoss = 0;

int playerLoss = 0;
int enemyLoss = 0;

float coverDeathChance = 0.04;
boolean isPaused = false;
boolean isThinking = true;
boolean playerCharge = false;
boolean enemyCharge = false;

int boardWidth = 76;
int boardHeight = 52;
int winMeter = 0;
int elevation = 0;

float[][] heightMap = new float[boardWidth][boardHeight];

int startPoint1 = int(random(14,boardWidth - 14)); //enemy
int startPoint2 = int(random(14,boardWidth - 14)); //player
char[][] terrain = new char[boardWidth][boardHeight];
char [][] display = new char[boardWidth][boardHeight];
int[][] terrainColor = new int[boardWidth][boardHeight];
char[][] bullets = new char[boardWidth][boardHeight];
char[][] infantry = new char[boardWidth][boardHeight];
PFont font;
String pauseText = "-----=:|  (P)AUSED  |:=-----";

void setup() {
  background(0x000000);
  size(800,600);
  font = loadFont("CourierNewPS-BoldMT-48.vlw");
  textFont(font,16);
  //terrain gen
  HeightMapGen h = new HeightMapGen();
  h.setSize(boardWidth,boardHeight);
  h.setVariance(random(1));
  heightMap = h.generate();
  //populate arrays
  for(int x = 0; x < boardWidth; x++) {
    for(int y = 0; y < boardHeight; y++) {
      bullets[x][y] = ' ';
      terrain[x][y] = 'O';
      infantry[x][y] = ' ';
      setupTerrain(x,y);
      display[x][y] = terrain[x][y];
    }
  }
  setupStartPos();
}
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
//Diamond-Square Step Algorithm
public class HeightMapGen { //SWEET MOTHER OF GOD IT WORKS
    private int mapSize;
    private int wide;
    private int high;
    private float variance;

    public HeightMapGen() {
        mapSize = (int)pow(2,9) + 1;
        wide = mapSize;
        high = mapSize;
        variance = 1;
    }

    public void setSize(int wide, int high) {
        this.wide = wide;
        this.high = high;

        float w = (float)ceil(log(wide)/log(2));
        float h = (float)ceil(log(high)/log(2));

        if(w > h) {
            mapSize = (int)pow(2,w) + 1;
        }
        else {
            mapSize = (int)pow(2,h) + 1;
        }
    }
    public void setmapSize(int n) {
        mapSize = (int)pow(2,n) + 1;
        wide = mapSize;
        high = mapSize;
    }
    public void setVariance(float v) {
        variance = v;
    }
    public float[][] generate() {
        float[][] map = new float[mapSize][mapSize];
        map[0][0] = random(1);
        map[0][map.length - 1] = random(1);
        map[map.length - 1][0] = random(1);
        map[map.length-1][map.length-1] = random(1);

        map = generate(map);

        if(wide < mapSize || high < mapSize) {
            float[][] temp = new float[wide][high];
            for(int i = 0; i < temp.length; i++) {
                temp[i] = Arrays.copyOf(map[i],temp[i].length);
            }
            map = temp;
        }
        
        //console printout of integer matrix representing heightmap
        
       /*for(int i = 0; i < map.length; i++) {
            for(int j = 0; j < map[i].length; j++) {
                System.out.print(" "+ (int)(Math.ceil(10*(map[i][j]))));
            }
            System.out.println("");
        }
        */
        
        return map;
    }
    public float[][] generate(float[][] map) {
        map = map.clone();
        int step = map.length - 1;

        float v = variance;

        while(step > 1) {
            for(int i = 0; i < map.length - 1; i += step) {
                for(int j = 0; j < map[i].length - 1; j += step) {
                    float average = (map[i][j] + map[i + step][j] + map[i][j + step] + map[i+step][j+step])/4;
                    if(map[i + step/2][j + step/2] == 0) {
                        map[i+step/2][j+step/2] = average + randVariance(v);
                    }
                }
            }
                for(int i = 0; i < map.length - 1; i += step) {
                    for(int j = 0; j < map.length - 1; j += step) {
                        if(map[i+step/2][j] == 0) {
                            map[i+step/2][j] = averageDiamond(map, i + step/2, j, step) + randVariance(v);
                        }
                        if(map[i][j + step/2] == 0) {
                            map[i][j + step/2] = averageDiamond(map, i, j+step/2, step) + randVariance(v);
                        }
                        if(map[i + step][j + step/2] == 0) {
                            map[i + step][j + step/2] = averageDiamond(map, i + step, j + step/2, step) + randVariance(v);
                        }
                        if(map[i + step/2][j + step] == 0) {
                            map[i + step/2][j + step] = averageDiamond(map, i + step/2, j + step, step) + randVariance(v);
                        }
                    }
                }
                v /= 2;
                step /= 2;
            }
            return map;
        }
        private float averageDiamond(float[][] map, int x, int y, int step) {
            int count = 0;
            float average = 0;

            if(x - step/2 >= 0) {
                count++;
                average += map[x - step/2][y];
            }
            if(x + step/2 < map.length) {
                count++;
                average += map[x + step/2][y];
            }
            if(y - step/2 >= 0) {
                count++;
                average += map[x][y - step/2];
            }
            if(y + step/2 < map.length) {
                count++;
                average += map[x][y + step/2];
            }
            return average/count;
        }
    private float randVariance(float v) {
        return random(1)*1.9*v - v; //this can end up being negative, resulting in huge sections of negative numbers. Handled in setupTerrain.
    }

}

boolean checkBounds(int xx, int yy) {
  if(xx >= 0 && xx < boardWidth && yy >= 0 && yy < boardHeight) {
    return true;
  }
  else {
    return false;
  }
}

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
      if(infantry[trySpawn][boardHeight-1] != 'I' && terrain[trySpawn][boardHeight-1] == ' ' && terrain[trySpawn][boardHeight-1] != '¢') {
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
      //terrain
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
boolean isDirt(int xx, int yy) {
  if(checkBounds(xx,yy)) {
    if(terrain[xx][yy] != ' ' && terrain[xx][yy] != '^' && getElevation(xx,yy) != 0) {
      return true;
    }
    else {
      return false;
    }
  }
  else {
    return false;
  }
}
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
    playerLoss = 0;
    enemyLoss = 0;
    playerChargeLoss = 0;
    enemyChargeLoss = 0;
    startPoint1 = int(random(14,boardWidth - 14));
    startPoint2 = int(random(14,boardWidth - 14));
    HeightMapGen h = new HeightMapGen();
    h.setSize(boardWidth,boardHeight);
    h.setVariance(random(1));
    heightMap = h.generate();
    for(int x = 0; x < boardWidth; x++) {
      for(int y = 0; y < boardHeight; y++) {
        bullets[x][y] = ' ';
        terrain[x][y] = 'O';
        infantry[x][y] = ' ';
        setupTerrain(x,y);
        display[x][y] = terrain[x][y];
      }
    }
    setupStartPos();
   }
}

void keyPressed() {
}
void markTrench(int x1,int y1, int x2, int y2) {
  for(int xi = x1; xi <= x2; xi++) {
    for(int yi = y1; yi <= y2; yi++) {
      if(checkBounds(xi,yi)) {
        if(isDirt(xi,yi)) {
          terrain[xi][yi] = 'X';
        }
      }
    }
  }
}
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
void pauseFunc() {
  if(!isPaused) {
    background(25,20,15);
    text(pauseText, int(boardWidth/2*10 - 120), int(boardHeight/2*11));
    isPaused = true;
    noLoop();
  }
  else {
    isPaused = false;
    loop();
  }
}
void playerBullet(int xx, int yy) {
  //move bullet
  if(checkBounds(xx,yy-1)) {
    bullets[xx][yy-1] = '.';
    bullets[xx][yy] = ' ';
    //did we hit someone?
    if(infantry[xx][yy-1] == 'l') {
      //were they in a trench?
      if(terrain[xx][yy] != ' ' && terrain[xx][yy-1] == ' ') {
        //give them a chance to live
        if(random(1) < coverDeathChance) {
          infantry[xx][yy-1] = '*';
          bullets[xx][yy-1] = ' ';
        }
      }
      else {
        //kill them
        infantry[xx][yy-1] = '*';
        bullets[xx][yy-1] = ' ';
      }
    }
  }
  else {
    //despawn bullet
    bullets[xx][yy] = ' ';
  }
}
          
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
            
                
void setupStartPos() {
  for(int startCorridor = 0; startCorridor < 1; startCorridor++) {
    terrain[startPoint1][startCorridor] = ' ';
    for(int i = startPoint1 - 10; i < startPoint1 + 10; i++) {
      terrain[i][0] = ' ';
      if(random(1) < 0.5) {
        infantry[i][0] = 'l';
        enemySpawned++;
      }
    }
  }
  for(int startCorridor = 0; startCorridor < 1; startCorridor++) {
    terrain[startPoint2][boardHeight-startCorridor-1] = ' ';
    for(int i=startPoint2 - 10; i < startPoint2 + 10; i++) {
      terrain[i][boardHeight-1] = ' ';
      if(random(1) < 0.5) {
        infantry[i][boardHeight-1] = 'I';
        playerSpawned++;
      }
    }
  }
}
void setupTerrain(int tx, int ty) {
      if((int)ceil(10*heightMap[tx][ty]) > 10) {
        terrain[tx][ty] = '¶';
      }
      if((int)ceil(10*heightMap[tx][ty]) <= 10) {
        terrain[tx][ty] = '£';
      }
      if((int)ceil(10*heightMap[tx][ty]) <= 7) {
        terrain[tx][ty] = '€';
      }
      if((int)ceil(10*heightMap[tx][ty]) <= 5) {
        terrain[tx][ty] = '$';
      }
      if((int)ceil(10*heightMap[tx][ty]) <= 3) {
        terrain[tx][ty] = '¥';
      }
      if((int)ceil(10*heightMap[tx][ty]) == 0) {
        terrain[tx][ty] = '¢';
      }
      //make water less common
      if((int)ceil(10*heightMap[tx][ty]) < 0) {
        heightMap[tx][ty] *= -1;
      }
      
}
//elevation data
int getElevation(int ex, int ey) {
  if(checkBounds(ex,ey)) {
  if((int)ceil(10*heightMap[ex][ey]) >= 0) {
    elevation = (int)ceil(10*heightMap[ex][ey]);
  }
  else {
    elevation = ((int)ceil(10*heightMap[ex][ey]))*-1;
  }
  }
  return elevation;
}


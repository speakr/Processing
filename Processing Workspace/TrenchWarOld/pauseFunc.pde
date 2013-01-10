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

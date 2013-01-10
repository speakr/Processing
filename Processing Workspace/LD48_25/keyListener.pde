void keyReleased() {
  if(key=='m') {
    setup();
  }
  if(key == 't') {
    solarLoop = !solarLoop;
    nebulaLoop = !nebulaLoop;
  }
  if(key=='p') {
    pause = !pause;
    if(pause) {
      noLoop();
    }
    else {
      loop();
    }
  }
  if(key == 'k') {
    killStar = true;
  }
}

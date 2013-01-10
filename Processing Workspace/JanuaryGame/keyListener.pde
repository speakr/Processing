void keyReleased() {
  if(key=='n') {
    depthMap = gen.generate();
    nebula();
    File file = sketchFile("data/background.png");
    if(file.exists()) {
      file.delete();
    }
    save("data/background.png");
    redraw();
    img = loadImage("background.png");
    stars();
  }
  if(key=='t') {
  }
}

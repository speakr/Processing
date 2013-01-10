void keyReleased() {
  if(key == 'm') {
    for(int x = 0; x < frameWidth; x++) {
      for(int y = 0; y < frameHeight; y++) {
        generateStars(x,y);
      }
    }
  }
}

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

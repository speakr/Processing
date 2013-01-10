void cardinalScroll(int x, int y) {
  //placeholder array
  buffer[x][y] = viewableSpace[x][y];
  //x plane
  //shift left
  if(mouseX < width && mouseX > width-width/8) {
    //does the element to the right exist?
    if(bounds(x+1,y)) {
      viewableSpace[x][y] = viewableSpace[x+1][y];
    }
    //wrap the first element over to the last position
    else {
      viewableSpace[x][y] = viewableSpace[0][y];
    }
  }
  if(mouseX > 0 && mouseX < width/8) {
      //HOLY SWEET JESUS IT WORKED
      if(bounds(x-1,y)) {
        char temp = viewableSpace[viewableSpace.length-1][y];
        viewableSpace[x][y] = buffer[x-1][y];
        viewableSpace[0][y] = temp;
      }
  }
  //y plane
  //shift down
  if(mouseY < height && mouseY > height - height/8) {
    if(bounds(x,y+1)) {
      viewableSpace[x][y] = viewableSpace[x][y+1];
    }
    else {
      viewableSpace[x][y] = viewableSpace[x][0];
    }
  }
  if(mouseY > 0 && mouseY < height/8) {
    if(bounds(x,y-1)) {
      char temp = viewableSpace[x][viewableSpace[x].length-1];
      viewableSpace[x][y] = buffer[x][y-1];
      viewableSpace[x][0] = temp;
    }
  }
}

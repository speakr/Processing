boolean rectEllipseIntersect(float rx, float ry, float rw, float rh, float ex, float ey, float er) {
  float ellipseDistanceX = abs(ex - rx - rw/2);
  float ellipseDistanceY = abs(ey - ry - rh/2);
  
  if(ellipseDistanceX > (rw/2 + er)) {
    return false;
  }
  if(ellipseDistanceY > (rh/2 + er)) {
    return false;
  }
  if(ellipseDistanceX <= rw/2) {
    return true;
  }
  if(ellipseDistanceY <= rh/2) {
    return true;
  }
  
  float cornerDistance = pow(ellipseDistanceX - rw/2,2) + pow(ellipseDistanceY - rh/2,2);
  return cornerDistance <= pow(er,2);
}

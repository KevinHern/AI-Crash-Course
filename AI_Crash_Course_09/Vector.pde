static class PVector {
  public float x, y;

  PVector(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  // Self Operations
  float mag() {
    return sqrt(this.x*this.x + this.y*this.y);
  }
  
  static PVector normalize(PVector v) {
    return PVector.div(v, v.mag());
  }
  
  void limit(float n) {
    if(this.mag() > n) {
      
      
      PVector temp = PVector.mult(PVector.normalize(new PVector(this.x, this.y)), n);
      this.x = temp.x;
      this.y = temp.y;
    }
  }
  
  static PVector rotate(PVector v, float angle) {
    return new PVector(
      v.x*cos(angle) - v.y*sin(angle),
      v.x*sin(angle) + v.y*cos  (angle)
    );
  }
  
  // Binary Operations
  static PVector add(PVector v, PVector w) {
    return new PVector(v.x + w.x, v.y + w.y);
  }
  
  static PVector sub(PVector v, PVector w) {
    return new PVector(v.x - w.x, v.y - w.y);
  }
  
  static PVector mult(PVector v, float scalar) {
    return new PVector(v.x * scalar, v.y * scalar);
  }
  
  static PVector div(PVector v, float scalar) {
    return new PVector(v.x / scalar, v.y / scalar);
  }
  
  static float dotProduct(PVector v, PVector w){
    return w.x*v.x + w.y*v.y;
  }
  
  static float angle(PVector v) {
    return atan2(v.y, v.x);
  }
}

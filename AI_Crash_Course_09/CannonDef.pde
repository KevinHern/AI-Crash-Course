class Target {
  PVector location;
  float r1, r2, r3, r4;
  
  Target(float x, float y){
    this.location = new PVector(x, y);
    this.r4 = 100;
    this.r3 = 50;
    this.r2 = 25;
    this.r1 = 10;
  }
  
  void display() {
    // Draws a target of 4 circles
    pushMatrix();
    stroke(0);
    fill(200);
    ellipse(this.location.x, this.location.y, this.r4, this.r4);
    
    stroke(0);
    fill(150);
    ellipse(this.location.x, this.location.y, this.r3, this.r3);
    
    stroke(0);
    fill(100);
    ellipse(this.location.x, this.location.y, this.r2, this.r2);
    
    stroke(0);
    fill(100);
    ellipse(this.location.x, this.location.y, this.r1, this.r1);
    
    popMatrix();
  }
}

class Projectile {
  PVector location, velocity, acceleration;
  float maxSpeed;
  
  Projectile(PVector spawnPoint, float angle, float speed){
    this.location = new PVector(spawnPoint.x, spawnPoint.y);
    this.velocity = new PVector(speed*cos(angle), speed*sin(angle));
    this.maxSpeed = speed;
    this.acceleration = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    this.acceleration = PVector.add(this.acceleration, force);
  }
  
  void update () {
    this.velocity = PVector.add(this.velocity, this.acceleration);
    this.velocity.limit(this.maxSpeed);
    this.location = PVector.add(this.velocity, this.location);
    this.acceleration = PVector.mult(this.acceleration, 0);
  }
  
  void display() {
    // Prevent the balls from sinking
    if(this.location.y > height) {
      this.location.y = height;
      this.velocity = PVector.mult(this.velocity, 0);
    }
    
    // Moving the ball to the new location
    pushMatrix();
    translate(this.location.x, this.location.y);
    ellipse(0, 0, 15, 15);
    popMatrix();
  }
}

class Cannon implements Comparable<Cannon> {
  float angle, projectileSpeed, fitness;
  PVector location;
  Projectile projectile;
  
  Cannon(float angle, float speed, PVector location, float fitness){
    this.angle = angle;
    this.projectileSpeed = speed;
    this.location = location;
    this.fitness = fitness;
    this.projectile = new Projectile(location, this.angle, this.projectileSpeed);
  }
  
  void display() {
    // Placing the cannon at the right angle
    pushMatrix();
    translate(this.location.x, this.location.y);
    pushMatrix();
    rotate(this.angle);
    fill(150);
    rect(-20, -10, 40, 20);
    popMatrix();
    fill(220);
    rect(-10, -10, 15, 30);
    popMatrix();
  }
  
  // Function to meassure the performance of the cannon
  void getFitness (Target target) {
    // Gets the closest distance that the ball had with respect to the target
    float distance = PVector.sub(target.location, this.projectile.location).mag();
    this.fitness = (this.fitness > distance)? distance : this.fitness;
  }
  
  void run(Target target, PVector gravity) {
    // First applies gravity to the projectile
    this.projectile.applyForce(gravity);
    
    // Updates the position of the projectile
    this.projectile.update();
    
    // Displays the projectile in the new position
    this.projectile.display();
    
    // Displays the cannon
    this.display();
    
    // Calculates Fitness of the projectile with respect of the target
    this.getFitness(target);
  }
  
  // This function mutates the angle it fires. Note it isn't the usual mutation function
  void mutate(float mutationRate) {
    this.angle *= random(0.95, 1.05);
  }
  
  // Function used to compare which cannon is the fittest one
  @Override
  public int compareTo(Cannon cannon) {
    return (int)this.fitness - (int)cannon.fitness;
  }
}

// Cannon Genetic Algorithm - Hello World

import java.util.Arrays;
import java.util.Comparator;
import java.util.Random;


PVector spawnPoint, gravity;
Cannon[] cannons;
Target target;
float lifespan = 255, mutationRate = 0.5;
int population = 100, generation = 1;
PFont f;
Random random = new Random();

void settings(){
  size(1500, 1000);

}
 
void setup(){
  this.gravity = new PVector(0, 0.1);
  this.spawnPoint = new PVector(width/16, height*15/16);
  this.target = new Target(width*15/16, random(height));
  this.cannons = new Cannon[this.population];
  for(int i = 0; i < this.population ; i++) {
    this.cannons[i] = new Cannon(-random(0, PI/2), 15, this.spawnPoint, PVector.sub(this.target.location, this.spawnPoint).mag());
  }
    f = createFont("Arial" , 16, true);
}
 
void draw(){
  // Clears screen
  background(255);
  
  // Displays target first
  this.target.display();
  
  // Executes all the population. All cannons start or update the position of their projectiles
  for(int i = 0; i < this.population; i++) this.cannons[i].run(target, gravity);
  
  // Display important information
  textFont(f,16);
  fill(0);
  text("Lifespan: " + this.lifespan 
      + "\nGeneration: " + this.generation
      + "\nPopulation: " + this.population
      + "\nMutation Rate: " + (this.mutationRate * 100) + "%"
  , width/16,height/16);
  
  // Customization: If the user clicks on the canvas, the target's position is modified
  if(mousePressed) this.target = new Target(mouseX, mouseY);
  
  // The episodic task revolves on a timer of 255 cycles
  if(this.lifespan > 0) this.lifespan--;
  else {
    /* Once the lifespan reaches 0, it is time to evaluate the fitness of each cannon, select cannons to breed and then perform crossover */
    
    // Sorting cannons in an ascending fashion according to fitness 
    Arrays.sort(cannons);
    
    println("Best Cannon: " + cannons[0].fitness);
    
    //Selecting Parents: The 50% of the top cannons are selected for mating
    Cannon[] offsprings = new Cannon[this.population];
    for(int i = 0; i < this.population; i++) {
      Cannon parentA = cannons[(int)(random(51))];
      Cannon parentB = cannons[(int)(random(51))];
      
      // This is the crossover. Randomly selects how the crossover is performed
      offsprings[i] = random.nextBoolean()?
        new Cannon(parentA.angle, parentB.projectileSpeed, this.spawnPoint, PVector.sub(this.target.location, this.spawnPoint).mag())
        : new Cannon(parentB.angle, parentA.projectileSpeed, this.spawnPoint, PVector.sub(this.target.location, this.spawnPoint).mag());
        
      // Performing mutations on the cannons
      offsprings[i].mutate(this.mutationRate);
    }
    
    // Reseting parameters so the next generation can begin their evaluation
    this.lifespan = 255;
    this.generation++;
    this.cannons = offsprings;
    
  }
}

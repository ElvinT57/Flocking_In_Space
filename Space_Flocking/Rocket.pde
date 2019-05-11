class Rocket extends Body {
  PVector velocity;
  PVector acceleration;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed


  //flocking variables
  float cohesionRadius;
  float alignRadius;
  float desiredSeparation;

  Rocket(float x, float y, float r) {
    super(x, y, r);
    acceleration = new PVector(0, 0);
    img = loadImage("spaceship.png");
    float angle = 0;
    velocity = new PVector(cos(angle), sin(angle));

    maxspeed = 2;
    maxforce = .02;

    cohesionRadius = 100;
    alignRadius = 50;
    desiredSeparation = 50;
  }

  /*
    Run boid using its fellow rocket mates, and astroids
   */
  void run(ArrayList<Rocket> rockets, ArrayList<Asteroid> asteroids) {
    flock(rockets, asteroids);
    update();
    wrapAround();
    render(debug);
  }

  /*  
   This run method will only consider the other rockets
   */
  void run(ArrayList<Rocket> rockets) {
    flock(rockets, asteroids);
    update();
    wrapAround();
    render(debug);
  }

  void applyForce(PVector force) {
    // Use Newton's A = F / M, but ignore mass. Assume everything is unit 1
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Rocket> rockets, ArrayList<Asteroid> asteroids) {
    //caculate each vector
    PVector sep = separation(rockets);   // Separation
    PVector ast = avoidAsteroid(asteroids);  //asteroid avoidance force 
    PVector ali = align(rockets);      // Alignment
    PVector coh = cohesion(rockets);   // Cohesion

    // weight these forces
    sep.mult(1.5);
    ali.mult(1.5);
    coh.mult(1.0);
    ast.mult(2);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ast);
    applyForce(ali);
    applyForce(coh);
  }

  // Update the rocket's position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  /*
  * Returns the force needed to seek an object using
   * Reynold's steering formula: Steering = Desired - Velocity
   */
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  
    return steer;
  }

  void render(boolean debug) {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);

    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    if (debug) {
      //display each flocking radius and seperation distance
      noFill();
      stroke(0,255,50);
      ellipse(0,0, alignRadius, alignRadius);
      stroke(255,0,50);
      ellipse(0,0, desiredSeparation, desiredSeparation);
      stroke(50,0,255);
      ellipse(0,0, cohesionRadius, cohesionRadius);
      stroke(175);
      fill(175);
      triangle(-5, 5, 0, -5, 5, 5);
    } else {
      //tint it to the its brightest setting to prevent other tints
      tint(255);
      image(img, -r*5, -r*5, r*10, r*10);
    }
    popMatrix();
  }

  /*
  * Returns the force required to maintain desired separation 
   */
  PVector separation(ArrayList<Rocket> others) {
    PVector steer = new PVector(0, 0);
    int count = 0;  //number of neighbors around this rocket
    // For every boid in the system, check if it is a neighbor
    for (Rocket other : others) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredSeparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many neighbors
      }
    }
    // calculate the average
    if (count > 0)
      steer.div((float)count);
    return steeringForce(steer);
  }

  PVector avoidAsteroid(ArrayList<Asteroid> asteroids) {
    PVector steer = new PVector(0, 0);
    int count = 0;  //number of neighbors around this rocket
    // For every boid in the system, check if it is a neighbor
    for (Asteroid asteroid : asteroids) {
      float d = PVector.dist(location, asteroid.location);
      if ((d > 0) && (d < asteroid.r * 4.5)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, asteroid.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many neighboring asteroids
      }
    }
    // calculate the average
    if (count > 0)
      steer.div((float)count);
    return steeringForce(steer);
  }

  //caculcate the steering force of seperation: Steering = Desired - Velocity
  PVector steeringForce(PVector steer) {
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);  
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  void seekJunk(ArrayList<Junk> junk) {
    for (int i = 0; i < junk.size(); i++) {
      float d = PVector.dist(location, junk.get(i).location);
      if ((d > 0) && (d < 100)) {
        PVector dir = PVector.sub(junk.get(i).location, location);
        dir.normalize();
        dir.mult(maxspeed);
        this.applyForce(dir);

        if ((d > 0) && (d <50)) {
          strokeWeight(2);
          stroke(0, 255, 0);
          line(location.x, location.y, junk.get(i).location.x, junk.get(i).location.y);
          junk.remove(i);
        }
      }
    }
  }
  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Rocket> rockets) {
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Rocket other : rockets) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < alignRadius)) {
        sum.add(((Rocket)other).velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  /*
  
   Cohesion rule
   
   Add all the neighbor locations and average them to calculate 
   the average location.
   
   then calculate the steer towards that location.
   
   finally, return cohesion.
   */
  PVector cohesion (ArrayList<Rocket> rockets) {
    PVector total = new PVector(0, 0); 
    int count = 0;
    for (Rocket other : rockets) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < cohesionRadius)) {
        total.add(other.location); // Add location to total
        count++;
      }
    }
    if (count > 0) {
      total.div(count);
      return seek(total);  // Steer towards the location
    } else {
      return new PVector(0, 0);
    }
  }

  void reset() {
    location = new PVector(random(width), random(height));
    acceleration = new PVector(0, 0);
    img = loadImage("spaceship.png");
    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    r = 4;
    maxspeed = 2;
    maxforce = 0.03;
  }
}

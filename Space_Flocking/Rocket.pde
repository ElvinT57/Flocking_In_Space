class Rocket extends Body {
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  float [] rgb = {random(100, 255), random(50), random(100, 255)};


  //flock variables
  float cohesionRadius = 100;
  float alignRadius = 50;
  float desiredseparation = 50;

  Rocket(float x, float y) {
    super(x, y);
    acceleration = new PVector(0, 0);
    img = loadImage("spaceship.png");
    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    r = 4;
    maxspeed = 2;
    maxforce = .02;
  }

  /*
    Run boid using its fellow rocket mates, and astroids
   */
  void run(ArrayList<Rocket> rockets, ArrayList<Asteroid> asteroids) {
    flock(rockets, asteroids);
    update();
    borders();
    render();
  }

  /*  
   This run method will only consider the other rockets
   */
  void run(ArrayList<Rocket> rockets) {
    flock(rockets, asteroids);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Rocket> rockets, ArrayList<Asteroid> asteroids) {
    PVector sep = separate(rockets);   // Separation
    PVector asteroidSep = avoidAsteroid(asteroids);
    PVector ali = align(rockets);      // Alignment
    PVector coh = cohesion(rockets);   // Cohesion

    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.5);
    coh.mult(1.0);
    asteroidSep.mult(2);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(asteroidSep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up

    fill(rgb[0], rgb[1], rgb[2]);
    stroke(rgb[0], rgb[1], rgb[2]);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    //tint it to the its brightest setting to prevent other tints
    tint(255);
    image(img, -r*5, -r*5, r*10, r*10);
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Rocket> rockets) {
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Body other : rockets) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  PVector avoidAsteroid (ArrayList<Asteroid> asteroids) {
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Asteroid other : asteroids) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < other.r*5)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
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
        sum.add(other.velocity);
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

class Junk extends Body {
  PVector speed;
  String dir;
  float tint;
  Junk() {
    super(random(width), random(height), 60);
    dir = "junk" + floor(random(1, 4)) + ".png";
    img = loadImage(dir);
    tint = random(100, 255);
    speed = new PVector(random(-1, 1), random(0.1, 1));
  }
  void display() {
    // Display the asteroid
    tint(tint, tint, tint);
    fill(255);
    image(img, location.x, location.y, r, r);
  }

  void reset() {
    location = new PVector(random(100, 480), 0);
    speed =  new PVector(random(-1, 1), random(0.1, 1));
  }
  // Move the asteroid down
  void move() {
    // Increment by speed
    location.x += speed.x;
    location.y += speed.y;
  }

  // Check if it hits the bottom
  boolean reachedBottom() {
    // If we go a little beyond the bottom
    if (location.y > height) { 
      return true;
    } else {
      return false;
    }
  }
  void bounce() {
    if (location.x >= width - 20) {
      location.x = width - 20;
      speed.x *= -1;
    } else if (location.x < 0) {
      location.x = 0;
      speed.x *= -1;
    }
  }
}

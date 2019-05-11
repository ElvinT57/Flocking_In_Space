import controlP5.*;

ControlP5 cp5;
String textfieldname = "Enter City";
String city = "Glassboro";
PFont font;
JSONObject json;

// An arraylist of astroids
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
// An arraylist of Junk 
ArrayList<Junk> junk = new ArrayList<Junk>();
Satellite sat;



//flock variables
float cohesionRadius = 100;
float alignRadius = 50;
float desiredSeparation = 70;

//fleet system
Fleet fleet;
int numOfRockets = 30;
Stars s;
int numOfAsteroids = 20;
String mode = "r";
boolean inSpace = true;
boolean isJunk = false;
boolean debug = false; 
int numOfJunk = 100;


//Weather API Var
int windSpeed = 0;
int angle = 0;
String name = "";
String weather = "";
PVector windForce;

void setup() {
  sat = new Satellite();
  s = new Stars();
  size(1700, 900);
  background(0);

  font = createFont("arial", 20);

  cp5 = new ControlP5(this);
  fleet = new Fleet();
  //adding the fleet
  for (int i = 0; i < numOfRockets; i++) 
    fleet.addRocket(new Rocket(random(width), random(height), 4));

  //adding the astroids
  for (int i = 0; i < numOfAsteroids; i++) 
    asteroids.add(new Asteroid());

  //adding the junk 
  for (int i = 0; i < numOfJunk; i++) {
    junk.add(new Junk());
  }
  int y = 10; 
  int spacing = 60; 
  cp5.addTextfield(textfieldname).setPosition(20, y)
    .setSize(130, 20)
    .setFont(new ControlFont(font, 10))
    .setFocus(true)
    .setColor(color(175));
  y+=spacing;
  textFont(font);
}

void draw() {
  //Display current environment
  if (inSpace) {
    space();
  } else {
    if (isJunk) {
      junkMode();
    } else {
      atmosphere();
    }
  }
  //UI
  stroke(175, 175, 175, 50);
  fill(175, 175, 175, 30);
  rect(5, height-300, 150, 240);
  //cohension variables display
  fill(255); 
  text("Cohesion: " + cohesionRadius +" m", 10, height-275);
  text("Alignment: " + alignRadius + " m", 10, height-250);
  text("Separation: " + desiredSeparation + " m", 10, height-225);
  //controls
  textSize(15); 
  text("A: Add Asteroid", 10, height-200); 
  text("R: Add Rocket", 10, height-175); 
  text("D: Debug Mode", 10, height-150);
  text("1: Space", 10, height-125); 
  text("2: Atmosphere", 10, height-100); 
  text("3: Seek Junk", 10, height-75);

  //display framerate
  text(frameRate, width-100, height-45);
}

void mousePressed() {
  saveFrame("screenshot.png");
  //checks the current mode
  if (mode.equals("r")) {
    //add new rockets at mouse position
    fleet.addRocket(new Rocket(mouseX, mouseY, 4));
  } else if (mode.equals("a")) {
    asteroids.add(new Asteroid(mouseX, mouseY));
  }
}

void keyPressed() {
  switch(key) {
  case '1':
    if (!inSpace) {
      for (int i = 0; i < numOfAsteroids; i++)
        asteroids.add(new Asteroid());
    }
    //reset the fleet
    fleet.reset(); 
    //in space, let cohesion radius be 100
    for (Rocket r : fleet.getFleet()) 
      r.cohesionRadius = cohesionRadius;
    inSpace = true;
    break;
  case '2':
    //reset the fleet
    fleet.reset(); 
    //in atmosphere, let cohesion radius be 250
    for (Rocket r : fleet.getFleet()) {
      r.cohesionRadius = cohesionRadius;
      r.maxspeed = 2;
      r.maxforce = .5;
    }
    inSpace = false;
    isJunk = false;
    //remove all asteroids and junk
    asteroids.clear();
    junk.clear();
    break;
  case '3':
    //if we are not in junk destroying mode already
    if (!isJunk) {
      for (int i = 0; i < numOfJunk; i++)
        junk.add(new Junk());
    }
    //reset the fleet and then reinitialize the max speed and force
    fleet.reset();
    for (Rocket r : fleet.getFleet()) {
      r.cohesionRadius = cohesionRadius;
      r.maxspeed = 2;
      r.maxforce = .02;
    }
    inSpace = false;
    isJunk = true;
    //clear out asteroids
    asteroids.clear();
    break;
  case 'a':
    mode = "a";
    break;
  case 'r':
    mode = "r";
    break;
  case 'd':
    debug = !debug;
    break;
  case 'i':
    cohesionRadius++;
    updateVariables();
    break;
  case 'j':
    cohesionRadius--;
    updateVariables();
    break;
  case 'o':
    alignRadius++;
    updateVariables();
    break;
  case 'k':
    alignRadius--;
    updateVariables();
    break;
  case 'p':
    desiredSeparation++;
    updateVariables();
    break;
  case 'l':
    desiredSeparation--;
    updateVariables();
    break;
  }
}

void space() {  
  background(0); 
  //stars
  s.display(); 
  //fleet
  fleet.run(asteroids); 

  //astroid updates
  for (Asteroid a : asteroids) {
    a.wrapAround(); 
    a.move(); 
    a.display(); 
    if (a.reachedBottom())
      a.reset();
  }
}

void atmosphere() {
  background(0, 100, 155);

  //String weather = "Raining";
  //int windSpeed = 5;
  //float angle = 80;
  //String name = city;
  //creat wind force with data
  windForce = new PVector(cos(angle), sin(angle));
  windForce.normalize();
  windForce.mult(windSpeed*2);
  //update fleet
  fleet.run();
  fleet.applyForce(windForce);
  //displays
  fill(255);
  textSize(20);
  text("Flying over " + name +", at " + windSpeed + " meters/hour in the direction of " +angle+"°. Current Weather is " + weather, (width/2)-375, 20);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) 
    city = theEvent.getStringValue();
  json = loadJSONObject("https://api.openweathermap.org/data/2.5/weather?q=" + city + ",us&appid=9b9dc8e944471d14f7a8e8dc8148d41a");
  //json = loadJSONObject("https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22");
  windSpeed = json.getJSONObject("wind").getInt("speed");
  angle = json.getJSONObject("wind").getInt("deg");
  name = json.getString("name");
  JSONArray lib = json.getJSONArray("weather");
  weather = lib.getJSONObject(0).getString("main");
}

void junkMode() {
  background(0); 
  //stars
  s.display(); 
  ArrayList<Asteroid> bodies = new ArrayList<Asteroid>();
  bodies.add(sat);
  fleet.run(bodies);

  fleet.seekJunk(junk);
  for (Junk j : junk) {
    j.wrapAround(); 
    j.move(); 
    j.display(); 
    if (j.reachedBottom())
      j.reset();
  }
  sat.wrapAround();
  sat.display();
  sat.move();
}

void updateVariables() {
  for (Rocket r : fleet.getFleet()) {
    r.cohesionRadius =  cohesionRadius;
    r.alignRadius = alignRadius;
    r.desiredSeparation = desiredSeparation;
  }
}

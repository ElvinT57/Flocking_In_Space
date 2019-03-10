class Fleet {
  ArrayList<Rocket> rockets; // An ArrayList for all the Rockets

  Fleet() {
    rockets = new ArrayList<Rocket>(); // Initialize the ArrayList
  }

  void run(ArrayList<Asteroid> asteroids) {
    for (Rocket r : rockets) {
      r.run(rockets, asteroids);  // Passing the entire list of Rockets to each Rocket individually
    }
  }
  void run() {
    for (Rocket r : rockets) {
      r.run(rockets);  // Passing the entire list of Rockets to each Rocket individually
    }
  }

  void addRocket(Rocket b) {
    rockets.add(b);
  }

  void reset() {
    for(Rocket r: rockets)
      r.reset();
  }

  ArrayList<Rocket> getFleet() {
    return rockets;
  }
  
  void applyForce(PVector force){
     for(Rocket r : rockets){
       r.applyForce(force);
     }
  }
  void seekJunk(ArrayList<Junk> junk){
    for(Rocket r : rockets){
      r.seekJunk(junk);
    }
  }
}

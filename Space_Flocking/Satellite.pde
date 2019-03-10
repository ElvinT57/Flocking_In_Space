class Satellite extends Asteroid{
  Satellite() {
    location = new PVector(0, height/2);
    img = loadImage("Satellite.png");
    speed.x = 1;
    speed.y = 0;
  }
  
  void display(){
    image(img, location.x, location.y, 100,100);
  }
}

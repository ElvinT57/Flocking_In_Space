class Body{
   PVector location;
   PImage img;
   float r;
   
   Body(float x, float y, float r){
      location = new PVector(x,y); 
      img = null;
      this.r = r;
   }
   
   void wrapAround() {
    if (location.x > width)
      location.x = 0; 
    else if (location.x < 0)
      location.x = width;
    else if (location.y > height)
      location.y = 0;
    else if (location.y < 0)
      location.y = height;
  }
}

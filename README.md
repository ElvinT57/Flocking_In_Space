# Flocking_In_Space
<p>Exploring Craig Reynolds' 1986 Flocking Simulation(https://en.wikipedia.org/wiki/Boids) in outer space.</p>

<p>Craig Reynolds is a computer graphics expert. He and Ken Perlin worked on the computer graphics of the
1976 movie <i>Tron</i>. Reynolds was fascinated by the natural system of birds flocking and wanted to simulate
it by using computer graphics skills.</p>
<br/>
<p>We created our own interpretation of this model using rockets as the Boids, and asteroids, space junk, and 
 wind forces as obstacles</p>
 <img src="https://github.com/ElvinT57/Flocking_In_Space/blob/master/screenshot.png">
<h2>Flocking Rules</h2>
  <p><b>1. Separation</b>: Steer to avoid crowding local flockmates.</p>
  <img src="https://www.red3d.com/cwr/boids/images/separation.gif">
  <p><b>2. Alignment</b>: Steer towards the average heading of local flockmates.</p>
  <img src="https://www.red3d.com/cwr/boids/images/alignment.gif">
  <p><b>3. Cohesion</b>: Steer to move toward the average position of local flockmates.<p>
  <img src="https://www.red3d.com/cwr/boids/images/cohesion.gif">

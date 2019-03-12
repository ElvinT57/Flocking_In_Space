# Flocking_In_Space
<p>Authors - Elvin Torres, James Vu, Luke LaValva, and Gabriel Angel</p>
<p>Exploring Craig Reynolds' 1986 Flocking Simulation(https://en.wikipedia.org/wiki/Boids) in outer space.</p>

<p>Craig Reynolds is a computer graphics expert. He and Ken Perlin worked on the computer graphics of the
1976 movie, <i>Tron</i>. Reynolds was fascinated by the natural system of birds flocking and wanted to simulate
it by using his computer graphics skills.</p>
<br/>
<p>We created our own interpretation of this model using rockets as the Boids, and asteroids, space junk, and 
 wind forces as obstacles.</p>
 <img src= "https://github.com/ElvinT57/Flocking_In_Space/blob/master/images/screenshot.png">
<h2>Flocking Rules</h2>
  <p><b>1. Separation</b>: Steer to avoid crowding local flockmates.</p>
  <img src="https://www.red3d.com/cwr/boids/images/separation.gif">
  <p><b>2. Alignment</b>: Steer towards the average heading of local flockmates.</p>
  <img src="https://www.red3d.com/cwr/boids/images/alignment.gif">
  <p><b>3. Cohesion</b>: Steer to move toward the average position of local flockmates.<p>
  <img src="https://www.red3d.com/cwr/boids/images/cohesion.gif">
 
 <h2>Download Instructions</h2>
 <p><ol>
 <li>Download Processing IDE to this program. (Processing.org)</li>
 <li>Add the ControlP5 library to Processing.</li>
</ol></p>

<h2>User Controls</h2>
<p><ul>
 <li>Left Click - Add a new object at the given mouse x and y.</li>
 <li>A - Set object type for the add new object method to Asteroid.</li>
 <li>R - Set object type for the add new object method to Rocket.</li>
 <li>1 - Change to asteroid scenario.</li>
 <br/>
 <img width="300px" height ="200px" src ="https://github.com/ElvinT57/Flocking_In_Space/blob/master/images/screenshot.png">
 <br/>
 <li>2 - Change to atmosphere scenario.</li>
 <br/>
 <img width="300px" height ="200px" src ="https://github.com/ElvinT57/Flocking_In_Space/blob/master/images/screenshot2.png">
 <br/>
 <li>3 - Change to space junk scenario.</li>
 <br/>
 <img width="300px" height ="200px" src ="https://github.com/ElvinT57/Flocking_In_Space/blob/master/images/screenshot3.png">
 <br/>
</ul></p>

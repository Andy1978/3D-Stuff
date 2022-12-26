use <rail_stamp.scad>

$fa = 1;
$fs = 0.4;

h_Hexagon_aussen = 59.7;
r_Ha = h_Hexagon_aussen / 2 / cos (30);
r_Hi = 40 / 2 / cos (30);

difference ()
{
linear_extrude (height = 10)
  polygon ([for (phi = [0:60:360]) [r_Ha*cos(phi), r_Ha*sin(phi)]]); 

translate ([0, 0, 1.6])
  linear_extrude (height = 10)
    polygon ([for (phi = [0:60:360]) [r_Hi*cos(phi), r_Hi*sin(phi)]]); 

for (k = [0:5])
  rotate ([0, 0, 60 * k])
    translate ([0, -30, 10])
      rail_stamp ();
}
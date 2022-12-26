use <rail_stamp.scad>
use <hexagon.scad>

$fa = 1;
$fs = 0.4;

h_Hexagon_aussen = 59.7;

difference ()
{
  hexagon (h = 10, s = h_Hexagon_aussen);

translate ([0, 0, 1.6])
  hexagon (h = 10, s = 40); // grob innen

for (k = [0:2])
  rotate ([0, 0, 120 * k])
    translate ([0, -30, 10])
      rail_stamp (40);
}
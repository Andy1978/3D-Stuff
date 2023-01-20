include <marble_game.scad>

$fa = 1;
$fs = 0.3;
//$fn = 100;

t_Boden = 2;   // Dicke des Sockels in der Mitte
d_Zylinder = 35;

difference ()
{
  hexagon (h = 10, s = 60);

  for (k = [0:5])
    rotate ([0, 0, 60 * k])
      translate ([0, -30, 10])
        rotate ([5, 0, 0])
          rail_stamp (rinne_offset = 5);

  translate ([0, 0, t_Boden])
    cylinder(h = 10, d = d_Zylinder);

  base_adapter_inv ();
}

color ("green")
*difference ()
{
  translate ([0, 0, t_Boden])
    cylinder(h = 40, d = d_Zylinder - 1.0);

  translate ([0, 0, t_Boden + 25])
    cylinder(h = 20, d = D_Rinne);

  // Kegel oben
  translate ([0, 0, 30])
    cylinder(h = 20, d2 = 30, d1 = D_Rinne);

  translate([0, -d_Zylinder/2, d_Zylinder/2 + 12.2])
    rotate ([0, 90, 0])
      rotate_extrude(convexity = 10, angle = 90)
        translate([d_Zylinder/2, 0, 0])
          circle(d = D_Rinne);
}


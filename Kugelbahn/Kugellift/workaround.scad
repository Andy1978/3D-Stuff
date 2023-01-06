include <marble_game.scad>

$fa = 1;
$fs = 0.3;

// Kugeleinlauf unten, von -y her kommend
*translate ([0, 20, 12.1])
 rotate ([-4, 0, 0])
  rail_stamp (rinne_offset = 12.0);

difference ()
{
  w = 25;
  h = 13.5;
  translate ([-w/2, -30, 0])
    cube ([w, 49.7, h]);
  //hexagon (h = 10, s = h_Hexagon_aussen);

  rotate ([-4, 0, 0])
    translate ([0, -30, h])
      rail_stamp (rinne_offset = 50);


  // Aussparung für adapter1.FCStd (2mm stark) zur Grundplatte
  translate ([0, 0, -0.01])
  union ()
  {
    difference ()
    {
      hexagon(h = 2, s = h_Hexagon_innen + 0.1);
      translate ([0, 0, -0.01])
        hexagon(h = 2.02, s = h_Hexagon_innen - 2.0 - 0.6);
    }
  for (k = [0:5])
    rotate ([0, 0, 60 * k])
      translate ([r_Hexagon_innen - 0.8, 0, -3])
        cylinder (d = 3, h = 5);
  }
}  

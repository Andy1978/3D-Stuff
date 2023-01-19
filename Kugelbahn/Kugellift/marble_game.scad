/*
  Konstanten und Funktionen, die zu dem Murmelspiel gehören,
  also fix, bzw. durch die Geometrie des Spiels vorgegeben sind.
  Ist gedacht um über include <marble_game.scad> eingebunden zu werden.
*/

D_Kugel   = 12.8; // mm
D_Rinne   = 13.8; // mm
h_Rinne   = 5.9;  // Rinnentiefe in mm

//s_Hexagon = 2 * sqrt(60^2 - 30^2);// = 103.92 Hexagon vertikale Wiederholung
h_Hexagon_innen  = 29.8; // Schlüsselweite
r_Hexagon_innen = h_Hexagon_innen/2 * 2 / sqrt(3); // Umkreisradius

h_Hexagon_aussen = 59.7;
r_Hexagon_aussen = h_Hexagon_aussen/2 * 2 / sqrt(3); // Umkreisradius

module hexagon (h = 10, s = 59.7)
{
  r = s / 2 / cos (30);
  linear_extrude (height = h)
    polygon ([
      for (phi = [0:60:360])
         [r*cos(phi), r*sin(phi)]]);
}

module beveled_hexagon (h = 10, s = 59.7, b = 3)
{
  difference ()
  {
    r = s / 2 / cos (30);
    hexagon (h = h, s = s);
    for (k = [0:5])
    rotate ([0, 0, k * 60])
     translate ([r-b, -s/4, -s/8])
       cube (s/2);
  }
}

module rail_stamp(rinne_offset = 0.01, y_cyl_offset = 2.0)
{
// Design so, dass 0,0,0 die Mitte der Rinne,
// Außenkante Sechseck, Oberfläche ist.
// Mit rinne_offset kann der Zylinder für die Rinne
// über das Minimum hinaus verlängert werden

noff = 1;  // auch ein Offset, allerdings wird der nach hinten freigeschnitten (für moderate Neigungen)

// Die zwei Ausbuchtungen recht und links
D_bogen  = 3.6;   // Oberer Bogen
s_rand   = 1.2;   // Abstand zur Außenkante
h_tasche = 5.1;   // Höhe der Tasche
t_tasche = 9.1;   // Tiefe der Tasche zur Oberfläche
t_rand   = 7.3;   // Tiefe des Absatzes (der s_rand breite Steg) 
x_tasche = 6.5/2; // Abstand Tasche linke Seite zur Symmetrielinie

for (k = [-1:2:1])
{
  translate([k* (x_tasche + D_bogen/2), h_tasche + s_rand, -t_tasche])
    cylinder (t_tasche, d = D_bogen);

  cube_x = k * x_tasche - ((k < 0)? D_bogen : 0);
  translate([cube_x, s_rand, -t_tasche])
    cube([D_bogen, h_tasche, t_tasche]);

  translate([cube_x, +0.01 - noff, -t_rand])
    cube ([D_bogen, s_rand + noff, t_rand]);
}
translate ([0, -noff, D_Rinne/2 - h_Rinne]) // Oberfläche bei z = 0
  rotate ([-90, 0, 0])
    {
      hull ()
      {  
          cylinder (h = 10 + rinne_offset + noff, d = D_Rinne);
          translate ([0, -y_cyl_offset, 0])
            cylinder (h = 10 + rinne_offset + noff, d = D_Rinne);
      }
    }
}

module demo_rail_stamp ()
{
    difference ()
    {
      hexagon (h = 10, s = 60);

    translate ([0, 0, 1.6])
      hexagon (h = 10, s = 40); // grob innen

    for (k = [0:2])
      rotate ([0, 0, 120 * k])
        translate ([0, -30, 10])
          rail_stamp (rinne_offset = 40);
    }    
}

module base_adapter ()
{
    // Adapter zur Grundplatte, 2mm stark
    difference ()
    {
      beveled_hexagon(h = 4, s = h_Hexagon_innen, b = 1.2);
      translate ([0, 0, -0.01])
        beveled_hexagon(h = 4.02, s = h_Hexagon_innen - 2.0, b = 1.2);
      for (k = [0:5])
        rotate ([0, 0, 60 * k])
          translate ([r_Hexagon_innen - 0.6, 0, 2])
            cylinder (d = 5, h = 5);
    }
}

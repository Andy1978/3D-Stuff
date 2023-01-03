/*
  Konstanten und Funktionen, die zu dem Murmelspiel gehören,
  also fix, bzw. durch die Geometrie des Spiels vorgegeben sind.
  Ist gedacht um über include <marble_game.scad> eingebunden zu werden.
*/

D_Kugel   = 12.8; // mm
D_Rinne   = 13.8; // mm
h_Rinne   = 5.9;  // Rinnentiefe in mm

//s_Hexagon = 2 * sqrt(60^2 - 30^2);// = 103.92 Hexagon vertikale Wiederholung
h_Hexagon_innen  = 29.8; // Höhe des Lochs
h_Hexagon_aussen = 59.7;

module hexagon (h = 10, s = 59.7)
{
  r = s / 2 / cos (30);
  linear_extrude (height = h)
    polygon ([for (phi = [0:60:360]) [r*cos(phi), r*sin(phi)]]);
}

module rail_stamp(rinne_offset = 0.01)
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
    cylinder (h = 10 + rinne_offset + noff, d = D_Rinne);
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
    // adapter1.FCStd nachbauen
    // FIXME: ist noch WIP
    difference ()
    {
      hexagon(h = 10, s = 29.8);
      translate ([0, 0, -0.01])
        hexagon(h = 10.02, s = 27.8);
    }
}
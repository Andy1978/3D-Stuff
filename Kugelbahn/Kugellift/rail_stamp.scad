module rail_stamp(rinne_offset = 0.01)
{
// Design so, dass 0,0,0 die Mitte der Rinne,
// Außenkante Sechseck, Oberfläche ist.
// Mit rinne_offset kann der Zylinder für die Rinne
// über das Minimum hinaus verlängert werden

noff = 1;  // auch ein Offset, allerdings wird der nach hinten freigeschnitten (für moderate Neigungen)

// Fix, bzw. durch die Geometrie des Spiels vorgegeben
D_Kugel   = 12.8; // mm
D_Rinne   = 13.8; // mm
h_Rinne   = 5.9;  // Rinnentiefe in mm

// Die zwei Ausbuchtungen recht und links
D_bogen  = 3.6;   // Oberer Bogen
s_rand   = 1.2;   // Abstand zur Außenkante
h_tasche = 5.1;   // Höhe der Tasche
t_tasche = 9.1;   // Tiefe der Tasche zur Oberfläche
t_rand   = 7.3;   // Tiefe des Absatzes (der s_rand breite Steg) 
x_tasche = 6.5/2; // Abstand Tasche linke Seite zur Symmetrielinie

//mirror ([1, 0, 0])
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
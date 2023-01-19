/*
  Versuch eines Kugellifts
  Das innere Teil soll später durch einen kleinen Getriebemotor
  angetrieben werden

  Variante 2 mit Fokus darauf, dass beide Teile stehend
  ohne support gedruckt werden können.

 */
include <marble_game.scad>
use <brick_game.scad>
use <rinne.scad>
$fa = 1;
$fs = 0.3;
rinne_fn = 80;  // finales rendern = 80
eps = 0.005;

debug_vertical_slice   = 0;  // Schnitt fürs debugging
debug_horizontal_slice = 0;  // Schnitt fürs debugging

debug_kugel_einlauf = 0;
debug_kugel_klemmstellung_einlauf = 0;
debug_kugel_klemmstellung_liftarm = 0;
debug_kugel_auslauf = 1;

/*** Parameter ***/

// Steigung der Spirale in mm/Umdrehung. Muss mindestens D_Kugel sein
// aber 15mm lässt oben so wenig Material, dass man oben fast keinen
// Auslauf einbringen kann.
pitch = 23.0;

// Anzahl der Rinnen am Rotor
n_rinnen = 5;

// Mantel
n_rot   = 1;  // Anzahl der Windungen, typ. 1 für debugging, 5 für echten Druck
//h_Hex   = 8.2 + 5 * pitch;  // Höhe äußeres Hexagon
h_Hex   = 12.0 + n_rot * pitch;  // Höhe äußeres Hexagon
t_Boden = 5;   // Dicke des Sockels in der Mitte

// Radius des Zentrums der Kugelrinne am inneren Zyl.
radius_Rinne = 15; // früher D_zyl/2 - 5.9 + D_Rinne/2;
t_rinne      = 6.4;     // Tiefe der Rinne (Höhe des Trapezes in der X-Y plane)
r_trapez     = radius_Rinne + D_Kugel/2 + 0.3;

// Höhe des inneren Zylinders/Rotors (2mm weniger als Maximum)
h_zyl = h_Hex - t_Boden - 2;

// für mein Tevo Tarantula und 0,3mm Layer angepasst
kreuzstange_offset = 0.25;

/******** Ende Parameter **************/

//$t = 0;
sim_rot = debug_kugel_einlauf ? 5:
          debug_kugel_klemmstellung_einlauf? 15:
          debug_kugel_klemmstellung_liftarm? 2.5*60 + 360 * (n_rot - 1):
          debug_kugel_auslauf? 5*60:
          2 * 360 + 90 * $t; // Animation

echo (sim_rot);

difference () { // slice zum debuggen
union() {

// feststehendes Teil
difference ()
{
  union ()
  {
      // Mantel
      hexagon (h = h_Hex, s = h_Hexagon_aussen);

      // Verstärkungen für die Liftarm-Pin-Kreuzlöcher
      rotate ([0, 0, 60])
      {
        for (k = [-4, 4])
          translate ([k * 8, 0, h_Hex])
            rotate ([0, 180, 0])
              {
                cylinder(h = 7, d = 9);
                translate ([0, 0, 7])
                  cylinder(h = 10, d1 = 9, d2 = 2);
               }
        for (k = [-2, 2])
          translate ([k * 8, -4*8, h_Hex])
            rotate ([0, 180, 0])
              {
                hull () {
                    cylinder(h = 7, d = 9);
                    translate ([0, 3, 15])
                      cylinder(h = 1, d = 1);
                }
               }
       }
   }

  // Aussparung für adapter1.FCStd (2mm stark) zur Grundplatte
  translate ([0, 0, -0.01])
    difference ()
    {
      hexagon(h = 2, s = h_Hexagon_innen + 0.1);
      translate ([0, 0, -0.01])
        hexagon(h = 2.02, s = h_Hexagon_innen - 2.0 - 0.6);
    }

  // Führung der Kreuzstange des Rotors
  translate ([0, 0, -0.05])
    cylinder(h = t_Boden + 0.1, d = 4.75);


  // Spindel im Mantel
  // Z ist ausprobiert, bis die Spindel zum Auslauf passt
  h_spring = h_Hex - 14;
  translate ([0, 0, 4.8])
    rotate ([0, 0, 270 - 21])
      rinne (r = r_trapez,
             h = h_spring,
             t = t_rinne,
             pitch = pitch,
             dr = 7.5,
             alpha = 180,
             fn = rinne_fn);

  // zentrale Bohrung, in der später der Rotor läuft
  translate ([0, 0, t_Boden])
    cylinder(h = h_Hex + eps, r = r_trapez - t_rinne + 0.01, $fn = 100);

  // Kugeleinlauf unten, von -y her kommend
  translate ([0, -29.5, 15])
    rotate ([-4, 0, 0])  // 4° schräg
      rail_stamp (rinne_offset = 0.0);

  // "Anlauf" im Kugeleinlauf (neu seit 15.01.2023)
/*
  *translate([0, 0, 11.0])
    rotate ([0, 0, -100])
      rotate_extrude(angle = 60)
        translate([radius_Rinne, 0, 0])
          circle(d = D_Rinne);
*/
   // Kugelauslauf oben
  rotate ([0, 0, -1 * 60])
    translate ([0, -30, h_Hex - 4.9])
       rotate ([5, 0, 0])
         rail_stamp (rinne_offset = 7, y_cyl_offset = 5);

  // 4 Löcher für Kreuzstangen
  rotate ([0, 0, 60])
   {
    for (k = [-4, 4])
      translate ([k * 8, 0, h_Hex + 0.01])
        rotate ([0, 180, 0])
           kreuzstange (9, kreuzstange_offset);

    for (k = [-2, 2])
      translate ([k * 8, -4*8, h_Hex + 0.01])
        rotate ([0, 180, 0])
           kreuzstange (9, kreuzstange_offset);
    }

}

// Durchmesser des inneren Zylinders/Rotors
D_zyl = 2*(r_trapez - t_rinne) - 3.7;

// Rotor mit senkrechten Rinnen
color ("green")
translate ([0, 0, 5.1])
    rotate ([0, 0, 270 + sim_rot + (debug_kugel_klemmstellung_einlauf? 360/(2*n_rinnen):0)])
        difference ()
        {
            cylinder (h = h_zyl, d = D_zyl);
            for (k = [0:(n_rinnen-1)])
                rotate ([0, 0, k * 360/n_rinnen])
                    translate ([radius_Rinne, 0, -eps])
                        cylinder (h = h_zyl + 2*eps, d = D_Rinne);

            // Kreuzstange oben für das Zahnrad
            translate ([0, 0, h_zyl- 9.9])
              kreuzstange (10, kreuzstange_offset);
            // Kreuzstange unten für die Zentrierung
            translate ([0, 0, -0.01])
              kreuzstange (15, kreuzstange_offset);
       }

// Liftarm
if (debug_kugel_klemmstellung_liftarm)
  rotate ([0, 0, 60])
    translate ([-4 * 8, 0, h_Hex + 0.1])
      {
       liftarm (9);
       translate ([0, -3*8, 0])
         liftarm (9);
      }

/*
// Zahnrad auf dem Liftarm
translate ([0, 0, h_hex + 0.1 + 8])
  zahnrad ();
// Schnecke
rotate ([0, 0, -120])
  translate ([0, 16, t_Boden + h_zyl + 0.1 + 12])
    rotate ([0, 90, 0])
    {
      cylinder (h = 15.7, d = 10, center = true);
      cylinder (h = 80, d = 4.75, center = true); // Kreuzstange
    }
*/

// mal eine Kugel einzeichnen
r_Kugel = debug_kugel_klemmstellung_einlauf? 20:
          radius_Rinne - (D_Rinne - D_Kugel)/2;
z_Kugel = debug_kugel_klemmstellung_einlauf? 16.9:
          sim_rot/360 * pitch - (D_Rinne - D_Kugel) + 14.0;
color ("red")
  rotate ([0, 0, 270 + sim_rot])
    translate ([r_Kugel, 0, z_Kugel])
      sphere (d = D_Kugel);

}  // union

    if (debug_vertical_slice)
    {
      hsw = 10;  // half-slice-width
      rotate ([0, 0, 90])
      {
        cs = 120;
        translate ([-cs/2, hsw, -1])
          cube (cs);
        translate ([-cs/2,-cs - hsw,-1])
          cube (cs);
      }
    }
    if (debug_horizontal_slice)
    {
      sh = 16;  // slice height
      translate ([0, 0, sh])
        cylinder (d = 80, h = h_Hex);
    }
} // difference

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
eps = 0.005;

debug_slice = 0;  // Schnitt fürs debugging

//$t = 1;
//sim_rot = 2 * 360;
sim_rot = 0;//2 * 360 + 90 * $t; // Animation
// 875 ist direkt unter dem Liftarm
// 1019 ist ganz oben

/**** Parameter ****/

// Fix, bzw. durch die Geometrie des Spiels vorgegeben
D_Kugel   = 12.8; // mm
D_Rinne   = 13.8; // mm
//s_Hexagon = 2 * sqrt(60^2 - 30^2);// = 103.92 Hexagon vertikale Wiederholung
h_Hexagon_innen  = 29.8; // Höhe des Lochs
h_Hexagon_aussen = 59.7;

// Mantel
h_Hex   = 96;  // Höhe äußeres Hexagon
t_Boden = 5;   // Dicke des Sockels in der Mitte, die 5 sind bisher eher ausprobiert...

// Radius des Zentrums der Kugelrinne am inneren Zyl.
radius_Rinne = 20; // früher D_zyl/2 - 5.9 + D_Rinne/2;
t_rinne      = 5.4;     // Tiefe der Rinne (Höhe des Trapezes)
r_trapez     = radius_Rinne + D_Kugel/2 + 0.3;

h_zyl = h_Hex - t_Boden - 2; // Höhe des inneren Zylinders/Rotors

// Abstand der Gewindegänge muss ja mindestens D_Kugel sein
// aber 15mm lässt oben so wenig Material, dass man oben fast keinen
// Auslauf einbringen kann
pitch = 18;

// für mein Tevo Tarantula und 0,3mm Layer angepasst
kreuzstange_offset = 0.3;

/******** Ende Parameter **************/

difference () { // slice zum debuggen
union() {

// feststehendes Teil
difference ()
{
  union ()
  {
      // Mantel
      hexagon (h = h_Hex, s = h_Hexagon_aussen);

      // Verstärkungen für die Löcher
      rotate ([0, 0, 60])
      {
        for (k = [-4, 4])
          translate ([k * 8, 0, h_Hex])
            rotate ([0, 180, 0])
              {
                cylinder(h = 7, d = 8);
                translate ([0, 0, 7])
                  cylinder(h = 10, d1 = 8, d2 = 2);
               }
        for (k = [-2, 2])
          translate ([k * 8, -4*8, h_Hex])
            rotate ([0, 180, 0])
              {
                hull () {
                    cylinder(h = 7, d = 8);
                    translate ([0, 3, 15])
                      cylinder(h = 1, d = 1);
                }
               }
       }
      // Verlängerung für Kugeleinlauf
      l_tunnel = 10;
      y_tunnel = 13;
      w_tunnel = 20;
      translate ([0, -h_Hexagon_aussen/2 + 0.01, y_tunnel])
        rotate ([90, 0, 0])
          {
            cylinder (d = w_tunnel, h = l_tunnel);
            translate ([-w_tunnel/2, -y_tunnel, 0])
              cube ([w_tunnel, y_tunnel, l_tunnel]);
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
  // die -9 sind ausprobiert, bis die Spindel zum Auslauf passt
  h_spring = h_Hex - 9;

  translate ([0, 0, 2.6])
    rotate ([0, 0, 270 - 0])
      rinne (r = r_trapez,
             h = h_spring,
             t = t_rinne,
             pitch = pitch,
             dr = 3,
             alpha = 45,
             fn = 80);

  // zentrale Bohrung, in der später der Rotor läuft
  translate ([0, 0, t_Boden])
    cylinder(h = h_Hex + eps, r = r_trapez - t_rinne + 0.01, $fn = 100);

  // Kugeleinlauf unten, von -y her kommend
  translate ([0, -40, 12.1])
     rotate ([-4, 0, 0])
      rail_stamp (rinne_offset = 12.0);

   // Kugelauslauf oben
  rotate ([0, 0, -1 * 60])
    translate ([0, -30, h_Hex - 1])
       rotate ([3, 0, 0])
         rail_stamp (1.5);

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

// Rotor mit senkrechten Rinnen

// Durchmesser des inneren Zylinders/Rotors
D_zyl = 2*(r_trapez - t_rinne) - 1.4; // 0.7mm Spalt
echo (D_zyl);
translate ([0, 0, 5.1])
    rotate ([0, 0, sim_rot + 30])
        difference ()
        {
            cylinder (h = h_zyl, d = D_zyl);
            n = 6;
            for (k = [0:(n-1)])
                rotate ([0, 0, k * 360/n])
                    translate ([radius_Rinne, 0, -eps])
                        cylinder (h = h_zyl + 2*eps, d = D_Rinne);

            // Kreuzstange oben für das Zahnrad
            translate ([0, 0, h_zyl- 9.9])
              kreuzstange (10, kreuzstange_offset);
            // Kreuzstange unten für die Zentrierung
            translate ([0, 0, -0.01])
              kreuzstange (15, kreuzstange_offset);
       }

/*
// Liftarm
rotate ([0, 0, 60])
  translate ([-4 * 8, 0, t_Boden + h_zyl + 0.1])
    {
     liftarm (9);
     translate ([0, -3*8, 0])
       liftarm (9);
    }

// Zahnrad auf dem Liftarm
translate ([0, 0, t_Boden + h_zyl + 0.1 + 8])
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
z_Kugel = sim_rot/360 * pitch - (D_Rinne - D_Kugel) + 12.0;
*rotate ([0, 0, 270 + sim_rot])
  translate ([radius_Rinne - (D_Rinne - D_Kugel)/2, 0, z_Kugel])
    sphere (d = D_Kugel);
}  // union

if (debug_slice)
{
hsw = 10;  // half-slice-width
rotate ([0, 0, 90])
{
  translate ([-45, hsw, -1])
    cube (90);
  translate ([-45,-90 - hsw,-1])
    cube (90);
}
}
} // difference

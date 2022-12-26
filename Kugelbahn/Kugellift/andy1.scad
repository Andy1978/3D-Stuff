/*
  Versuch eines Kugellifts
  Das innere Teil soll später durch einen kleinen Getriebemotor
  (vielleicht Fischer-Technik) angetrieben werden
 */
use <spring.scad>
//$fa = 1;
//$fs = 0.4;

D_zyl = 38; // Durchmesser des inneren Zylinders
h_zyl = 40; // Höhe        des inneren Zylinders

eps = 0.005;

D_fil = 1.75; // Filamentdurchmesser

// Fix, bzw. durch die Geometrie des Spiels vorgegeben
D_Kugel   = 12.8; // mm
D_Rinne   = 13.8; // mm
h_Rinne   = 5.9;  // Rinnentiefe in mm
//s_Hexagon = 2 * sqrt(60^2 - 30^2);// = 103.92 Hexagon vertikale Wiederholung
h_Hexagon_innen  = 29.8; // Höhe des Lochs
h_Hexagon_aussen = 59.7;

difference ()
{
union() {

// Radius des Zentrums der Kugelrinne sowohl am inneren Zylinder
// als auch später beim äußeren Hexagon
radius_Rinne = D_zyl/2 - h_Rinne + D_Rinne/2;
difference ()
{
    cylinder (h = h_zyl, d = D_zyl);

    for (k = [0:3])
        rotate ([0, 0, k * 90])
            translate ([radius_Rinne, 0, -eps])
                cylinder (h = h_zyl + 2*eps, d = D_Rinne);
} 

color("green");
pitch = 15;    // muss ja mindestens D_Kugel sein
// ich denke das Filament müsste in 45° unter der Kugel laufen,
// FIXME, das unten ist erst eine grobe Annahme
r_spring = D_zyl / 2 + D_Kugel / 2;
*spring (h = h_zyl, d_coil = 1.75, r_spring = r_spring , pitch = pitch, n = 50);

// mal eine Kugel einzeichnen
translate ([D_zyl/2 - h_Rinne + D_Kugel/2, 0, 14.2])
  sphere (d = D_Kugel);

// äußerer Körper
h_Hex = 40;   // Höhe äußeres Hexagon
s_gap = 1;    // Spalt zwischen innerem Zylinder und mittlerer Bohrung
// Radius, auf dem die Eckpunkte liegen
r_Ha = h_Hexagon_aussen/ 2 / cos (30);
// Polygon außen
p_Ha = [for (phi = [0:60:360]) [r_Ha*cos(phi), r_Ha*sin(phi)]];
    
difference ()
{
  linear_extrude (height = h_Hex)
    polygon (p_Ha); 
  cylinder(h = h_Hex + eps, d = D_zyl + 2 * s_gap);
  spring (h = h_Hex + D_Rinne/2, d_coil = D_Rinne, r_spring = radius_Rinne + 0.1 , pitch = pitch, n = 50);
}
}
translate ([-30,4,-1])
  cube (60);
translate ([-30,-64,-1])
  cube (60);
}
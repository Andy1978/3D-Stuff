/*
  Versuch eines Kugellifts
  Das innere Teil soll später durch einen kleinen Getriebemotor
  (vielleicht Fischer-Technik) angetrieben werden
 */
use <spring.scad>
use <hexagon.scad>
use <rail_stamp.scad>
$fa = 1;
$fs = 0.4;

debug_slice = 0;

//$t = 0;
sim_rot = 2 * 360;
//sim_rot = 2 * 360 + 100 * $t;

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

difference () {
union() {

// Radius des Zentrums der Kugelrinne sowohl am inneren Zylinder
// als auch später beim äußeren Hexagon
radius_Rinne = D_zyl/2 - h_Rinne + D_Rinne/2;
rotate ([0, 0, sim_rot])
    difference ()
    {
        cylinder (h = h_zyl, d = D_zyl);
        n = 7;
        for (k = [0:(n-1)])
            rotate ([0, 0, k * 360/n])
                translate ([radius_Rinne, 0, -eps])
                    cylinder (h = h_zyl + 2*eps, d = D_Rinne);
    } 

// Abstand der Gewindegänge muss ja mindestens D_Kugel sein
// aber 15mm lässt oben so wenig Material, dass man fas keinen Auslauf einbringen kann
pitch = 18;    

// ich denke das Filament müsste in 45° unter der Kugel laufen,
// FIXME, das unten ist erst eine grobe Annahme
r_spring = D_zyl / 2 + D_Kugel / 2;
*spring (h = h_zyl, d_coil = 1.75, r_spring = r_spring , pitch = pitch, n = 50);

// äußerer Körper
h_Hex = 40;   // Höhe äußeres Hexagon
s_gap = 1;    // Spalt zwischen innerem Zylinder und mittlerer Bohrung

difference ()
{
  hexagon (h = h_Hex, s = h_Hexagon_aussen);

  cylinder(h = h_Hex + eps, d = D_zyl + 2 * s_gap);
  h_spring = h_Hex;// + D_Rinne/2;
  spring (h = h_spring, d_coil = D_Rinne,
          r_spring = radius_Rinne + 0.1 , pitch = pitch, n = 70);

  // Kugelauslauf oben
    if (1)
      rotate ([0, 0, 3 * 60])
        translate ([0, -30, h_Hex - 3])
           rotate ([5, 0, 0])
             rail_stamp (1.5);


}

// mal eine Kugel einzeichnen
z_Kugel = sim_rot/360 * pitch - (D_Rinne - D_Kugel);
rotate ([0, 0, sim_rot])
  translate ([D_zyl/2 - h_Rinne + D_Kugel/2, 0, z_Kugel])
    sphere (d = D_Kugel);

}  // union

if (debug_slice)
{
hsw = 3;  // half-slice-width
translate ([-35,hsw,-1])
  cube (70);
translate ([-35,-70 - hsw,-1])
  cube (70);
}
} // difference

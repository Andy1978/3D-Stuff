/*
  Versuch eines Kugellifts
  Das innere Teil soll später durch einen kleinen Getriebemotor
  angetrieben werden
 */
use <spring.scad>
use <hexagon.scad>
use <rail_stamp.scad>
use <zahnrad.scad>
use <liftarm.scad>
use <liftarm_loch.scad>
use <kreuzstange.scad>
$fa = 1;
$fs = 0.4;
eps = 0.005;

debug_slice = 1;  // Schnitt fürs debugging

//$t = 1;
//sim_rot = 2 * 360;
sim_rot = 0;//2 * 360 + 90 * $t; // Animation
// 875 ist direkt unter dem Liftarm

/**** Parameter ****/

D_zyl = 38; // Durchmesser des inneren Zylinders/Rotors
h_zyl = 55; // Höhe        des inneren Zylinders/Rotors

// Fix, bzw. durch die Geometrie des Spiels vorgegeben
D_Kugel   = 12.8; // mm
D_Rinne   = 13.8; // mm
h_Rinne   = 5.9;  // Rinnentiefe in mm
//s_Hexagon = 2 * sqrt(60^2 - 30^2);// = 103.92 Hexagon vertikale Wiederholung
h_Hexagon_innen  = 29.8; // Höhe des Lochs
h_Hexagon_aussen = 59.7;

// Mantel
h_Hex   = 60;  // Höhe äußeres Hexagon
s_gap   = 1;   // Spalt zwischen innerem Zylinder und mittlerer Bohrung
t_Boden = 5;   // Dicke des Sockels in der Mitte, die 5 sind bisher eher ausprobiert...

// Abstand der Gewindegänge muss ja mindestens D_Kugel sein
// aber 15mm lässt oben so wenig Material, dass man oben fast keinen
// Auslauf einbringen kann
pitch = 18;    

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
    for (k = [-4, 4])
      translate ([k * 8, 0, t_Boden + h_zyl])
        rotate ([0, 180, 0])
          {
            cylinder(h = 7, d = 10);
            translate ([0, 0, 7])
              cylinder(h = 15, d1 = 10, d2 = 0);
           }
   }

  // Aussparung für adapter1.FCStd zur Grundplatte
  translate ([0, 0, -0.01])
    difference ()
    {
      hexagon(h = 2, s = 29.8 + 0.1);
      translate ([0, 0, -0.01])
        hexagon(h = 2.02, s = 27.8 - 0.1);
    }

  // zentrale Bohrung, in der später der Rotor läuft
  translate ([0, 0, t_Boden])
    cylinder(h = h_Hex + eps, d = D_zyl + 2 * s_gap);  

  // Führung der Kreuzstange des Rotors
  translate ([0, 0, -0.05])
    cylinder(h = t_Boden + 0.1, d = 4.75);  

  // Spindel im Mantel
  h_spring = h_Hex - 8;
  // die -8 sind ausprobiert, bis die Spindel zum Auslauf passt
  translate ([0, 0, 10])
    rotate ([0, 0, 270 - 8])
      spring (h = h_spring, d_coil = D_Rinne,
              r_spring = radius_Rinne + 0.1,
              pitch = pitch, n = 150);

  // Kugeleinlauf unten, von -y her kommend
  translate ([0, -30, 10])
     rotate ([-3, 0, 0])
      rail_stamp (rinne_offset = 7);

   // Kugelauslauf oben
  rotate ([0, 0, -1 * 60])
    translate ([0, -30, h_Hex - 1])
       rotate ([3, 0, 0])
         rail_stamp (1.5);

  // zwei Löcher in den Verstärkungen
  // das ist bissle unschön doppelter Code mit den Verschiebungen
  // FIXME: Ich muss recherchieren, wie man eine Kette mit Translate + rotate in eine Funktion auslagern kann

  rotate ([0, 0, 60])
   {
    for (k = [-4, 4])
      translate ([k * 8, 0, t_Boden + h_zyl])
        rotate ([0, 180, 0])
           liftarm_loch ();

    for (k = [-2, 2])
      translate ([k * 8, -3*8, t_Boden + h_zyl])
        rotate ([0, 180, 0])
           liftarm_loch ();
    }

}

// Rotor senkrechten Rinnen
// Radius des Zentrums der Kugelrinne am inneren Zyl.
radius_Rinne = D_zyl/2 - h_Rinne + D_Rinne/2; 
*translate ([0, 0, 5.1])
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
              kreuzstange (10);
            // Kreuzstange unten für die Zentrieung
            translate ([0, 0, -0.01])
              kreuzstange (15);
       } 

// Liftarm
*rotate ([0, 0, 60])
  translate ([-4 * 8, 0, t_Boden + h_zyl + 0.1])
    {  
     liftarm (9);
     translate ([0, -3*8, 0])
       liftarm (9);
    }

// Zahnrad auf dem Liftarm
*translate ([0, 0, t_Boden + h_zyl + 0.1 + 8])
  zahnrad ();
// Schnecke
*rotate ([0, 0, -120])
  translate ([0, 16, t_Boden + h_zyl + 0.1 + 12])
    rotate ([0, 90, 0])
    {
      cylinder (h = 15.7, d = 10, center = true);
      cylinder (h = 80, d = 4.75, center = true); // Kreuzstange
    }
        
// mal eine Kugel einzeichnen
z_Kugel = sim_rot/360 * pitch - (D_Rinne - D_Kugel) + 10;
*rotate ([0, 0, 270 + sim_rot])
  translate ([D_zyl/2 - h_Rinne + D_Kugel/2, 0, z_Kugel])
    sphere (d = D_Kugel);

}  // union

if (debug_slice)
{
hsw = 0;  // half-slice-width
rotate ([0, 0, 60])
{
  // Teil2
  translate ([-45, hsw, -1])
    cube (90);
  // Teil1
  //translate ([-45,-90 - hsw,-1])
  //  cube (90);
}
}
} // difference

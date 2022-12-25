/*
  Versuch eines Kugellifts
  Das innere Teil soll später durch einen kleinen Getriebemotor (vielleicht Fischer-Technik) angetrieben werden
 */
use <spring.scad>
$fa = 1;
$fs = 0.4;

D_zyl = 30; // Durchmesser des inneren Zylinders
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

//cube(10);

difference ()
{
    cylinder (h = h_zyl, d = D_zyl);

    for (k = [0:3])
        rotate ([0, 0, k * 90])
            translate ([D_zyl/2 - h_Rinne + D_Rinne/2, 0, -eps])
                cylinder (h = h_zyl + 2*eps, d = D_Rinne);
} 

color("green");
pitch = 15;           // muss ja mindestens D_Kugel sein
r_spring = D_zyl / 2 + D_Kugel / 2; // 
spring (h = h_zyl, d_coil = 1.75, r_spring = r_spring , pitch = pitch, n = 120);

// mal eine Kugel
translate ([D_zyl/2 - h_Rinne + D_Kugel/2, 0, 18.5])
  sphere (d = D_Kugel);
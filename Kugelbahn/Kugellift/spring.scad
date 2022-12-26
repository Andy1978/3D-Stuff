/*
 h        Höhe der Spiralfeder
 d_coil   Durchmesser Draht
 r_spring mittlerer Radius der Feder
 pitch    Steigung
 n        Anzahl Segmente (mehr => genauer aber mehr CPU Last)
*/
module spring(h, d_coil, r_spring, pitch, n = 100)
{
  phi   = h / pitch * 360 / n;        // Winkel um z-Achse pro Schritt  
  step  = 2 * tan (phi/2) * r_spring; // Länge eines Zylindersegments  
  step_off = 1 * d_coil/2 * tan (phi);
    
  alpha = atan2(pitch, 2*r_spring*PI); // Steigungswinkel
  dy    = step * sin (alpha);          // dy pro Schritt
  for (k = [0:(n-1)])
    rotate([0,0,(k + 0.5)*phi])
        {
          //intersection ()
            {
              // pie
              //rotate([0,0,-phi/2])
                //translate([0,0,k*dy - d_coil])
                  //rotate_extrude(angle = phi)
                    //square([r_spring + 3*d_coil, 2*d_coil]);

              translate([r_spring,0,k*dy])
                rotate([90+alpha,0,0])
                 cylinder(h = step + step_off, d = d_coil, center = true);
            }
        }
}
$fa = 3;
$fs = 0.6;
//$fn = 100;

// Abmessungen der Grundplatte
base_s = [20, 10, 2];
base_r = 1; // Radius an den Kanten

// Abmessungen/Profil Arm
arm1_s = [5, 3, 12];
arm1_r  = 2.5; // Radius großer Bogen am Arm

arm2_s = [10, 3, 5];
arm2_r  = 3.0; // Radius am Scharnier

scharnier_ri = 2;  // Scharnier Innendurchmesser

difference ()
{

minkowski ()
{
    union() {

    // Grundplatte
    cube (base_s, center = true);
      
    // auf die Oberseite der Grundplatte verschieben
    translate ([0, 0, base_s[2]/2])
    {
      translate ([-6, 0, 0])
      rotate ([90, 0, 0])
        cylinder (d = 2, h = 8, center = true);
      translate ([6.5, 0, -1.0])
        sphere (d = 5);

      // senkrechter Stück Arm
      translate ([0, 0, arm1_s[2]/2])
        cube (arm1_s, center = true);
   
      translate ([0, 0, arm1_s[2]])
        rotate ([90, 0, 0])
          cylinder (r = arm1_r, h = arm1_s[1], center = true);

      // horizontaler Stück Arm
      translate ([-arm2_s[0], -arm1_s[1]/2, arm1_s[2] - arm2_s[2]/2])
        cube (arm2_s);

      translate ([-arm2_s[0], 0, arm1_s[2] + (arm2_s[2]/2 - arm2_r)])
        rotate ([90, 0, 0])
          cylinder (r = arm2_r, h = arm1_s[1], center = true);
    }
    } // union
    
  sphere (r = base_r);
}

translate ([-arm2_s[0], 0, base_s[2]/2 + arm1_s[2] + (arm2_s[2]/2 - arm2_r)])
  rotate ([90, 0, 0])
    {
      // Scharnierbohrung
      cylinder (r = scharnier_ri, h = 2 * arm1_s[1], center = true);
      // Dreieck
      translate ([-3.2, 0, 0])
        cylinder (r = 2 * scharnier_ri, h = 2 * arm1_s[1], $fn = 3, center = true);
    }

// Grundplatte unten eben schneiden
translate ([0, 0, -2])
  cube (2*base_s, center = true);
}

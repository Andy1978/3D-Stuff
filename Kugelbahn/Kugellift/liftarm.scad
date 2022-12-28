use <liftarm_loch.scad>

module liftarm (n = 9)
{
  t   = 7.85;
  w   = 7.4;
  D   = 4.8;
  D_a = 6.2;
  b   = 8.0;  // Abstand Löcher

  difference()
  {
    hull()
      {
        cylinder(h = t, d = w);    
        translate ([(n-1)*b, 0, 0])
          cylinder(h = t, d = w);
      }
    for (k = [0: (n-1)])
      translate ([k * b, 0, -0.01])
        liftarm_loch ();
  }


}

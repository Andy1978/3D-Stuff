module liftarm_loch ()
{
  t   = 7.85; // Tiefe des Liftarms
  D   = 4.8;  // Durchmesser Loch
  D_a = 6.2;
  t_a = 0.85;

  j = 0.1;   // jiffy 

  cylinder (h = t, d = D);

  translate ([0, 0, -j])
    cylinder (h = t_a + j, d = D_a);

  translate ([0, 0, t - t_a])
    cylinder (h = t_a + j, d = D_a);
}

liftarm_loch ();
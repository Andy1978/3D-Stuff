
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

module kreuzstange (h, offset = 0)
{
  D = 4.75 + offset;
  w = 1.8 + offset;
  difference ()
  {
    cylinder (h = h, d = D);
    for (k = [0:3])
      rotate ([0, 0, k*90])
        translate ([w/2, w/2, -0.1])
          cube ([5, 5, h + 0.2]);
  } 
}

module zahnrad()
{
/* GNU Octave code:
r = [10, 17.7, 26.8 17.7 10, 0]/2;
x = [0, repelem(r,1,2)];
h = [7.7, 6.3, 3.7];
y = repelem ([h/2 fliplr(-h/2)], 1, 2);
y (end + 1) = y(1);

plot (x, y)

printf ("p = [");
for k = 1:numel (x)
  printf ("[%.2f, %.2f]%s", x(k), y(k), merge (k == numel(x), "];\n", ",\n"))
endfor
*/

p = [[0.00, 3.85],
    [5.00, 3.85],
    [5.00, 3.15],
    [8.85, 3.15],
    [8.85, 1.85],
    [13.40, 1.85],
    [13.40, -1.85],
    [8.85, -1.85],
    [8.85, -3.15],
    [5.00, -3.15],
    [5.00, -3.85],
    [0.00, -3.85],
    [0.00, 3.85]];
 translate ([0, 0, 3.85])
   rotate_extrude()
     polygon (p);
}
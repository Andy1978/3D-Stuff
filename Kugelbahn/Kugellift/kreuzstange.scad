module kreuzstange (h)
{
  D = 4.75;
  w = 1.8;
  difference ()
  {
    cylinder (h = h, d = D);
    for (k = [0:3])
      rotate ([0, 0, k*90])
        translate ([w/2, w/2, -0.1])
          cube ([5, 5, h + 0.2]);
  } 
}
//kreuzstange (50);
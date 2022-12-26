module hexagon (h = 10, s = 59.7)
{
  r = s / 2 / cos (30);
  linear_extrude (height = h)
    polygon ([for (phi = [0:60:360]) [r*cos(phi), r*sin(phi)]]);
}
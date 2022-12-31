use <hexagon.scad>

// adapter1.FCStd nachbauen
// FIXME: ist noch WIP
difference ()
{
  hexagon(h = 10, s = 29.8);
  translate ([0, 0, -0.01])
    hexagon(h = 10.02, s = 27.8);
}
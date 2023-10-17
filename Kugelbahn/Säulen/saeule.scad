include <../marble_game.scad>

//$fa = 1;
//$fs = 0.3;
//$fn = 100;

n = 7;
h_Hex = 9.83 * n;
w_cut = 14;

difference ()
{
  hexagon (h = h_Hex, s = 46);
  base_adapter_inv (t = 1.6);
  translate ([0, 0, h_Hex - 3.4])
    hexagon (h = 3.5, s = h_Hexagon_innen);

  for (k = [0:2])
    rotate ([0, 0, k * 60])
      rotate ([90, 0, 0])
      linear_extrude (height = 80, center = true)
        {
          x = w_cut/2;
          ys = 6;
          y = x * sin(60);
          polygon([[0, ys],
                   [x, ys + y],
                   [x, h_Hex - ys - y],
                   [0, h_Hex - ys],
                   [-x, h_Hex - ys - y],
                   [-x, ys + y],
                   [0, ys]]);
        }    
}  


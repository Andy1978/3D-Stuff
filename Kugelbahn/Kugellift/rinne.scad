use <helix_extrude.scad>

module rinne (r, ri, h, t, pitch, fn = 3)
{
  overlap = -0.05;
  r = r - ri;
  p = [[0, 0],
       [0, pitch + overlap],      
       [r-t, pitch + overlap],      
       [r, pitch - tan(60) * t],      
       [r, tan(30) * t],      
       [r-t, 0],      
       [0, 0]];

  helix_extrude (p, ri, pitch, h, fn = fn); 
}


rinne (r = 27, ri = 20, h = 50, t = 5.4, pitch = 18);
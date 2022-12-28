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
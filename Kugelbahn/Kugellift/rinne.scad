/*
  r = Außenradius
*/

module rinne (r, h, t, pitch, dr = 4, alpha = 90, fn = 20)
{
  // dr: Offsett von r am Anfang bis alpha
  space = 0.01;   // Abstand der Bahnen in z (dürfen nicht überlappen)

  ri = r - t;
  points=[
        for(a=[0:360/fn:h/pitch*360])(
         let(ro = (a < alpha)? dr - dr * a/alpha : 0,
             profile = [[0, 0],
                       [0, pitch - space],    
                       [t+ro, pitch - tan(60) * t],      
                       [t+ro, tan(45) * t]])
            for(p=[0:len(profile)-1])(
                [
                    (profile[p][0]+ri)*cos(a),
                    (profile[p][0]+ri)*sin(a),
                     profile[p][1]+a/360*pitch
                ]
            )
        )   
    ];

	n=4;
	p=len(points);
	faces=[
        [for(point=[0:1:n-1])
            point
        ],
        for(point=[0:n:p-n-1])(
            for(side=[0:n-1])(
                let(offset1=point+side,offset2=n)[
                    offset1,
                    offset1+offset2,
                    (side==n-1?
                        offset1+1
                    :
                        offset1+offset2+1
                    ),
                    (side==n-1?
                        offset1-offset2+1
                    :
                        offset1+1
                    )
                ]
                
            )
        ),
        [for(point=[p-1:-1:p-n])
            point,
        ]
    ];

  polyhedron(points,faces,10);
  //cylinder (r = ri + 0.01, h = h + pitch - space);
}


rinne (r = 21.7, h = 50, t = 5.4, pitch = 22.5, dr = 8.0,  alpha = 180, fn = 30);
// Kugel
rotate ([0, 0, 0])
  translate ([28-5.3, 0, 9.8])
    color ("red")
      sphere (d = 12.8);

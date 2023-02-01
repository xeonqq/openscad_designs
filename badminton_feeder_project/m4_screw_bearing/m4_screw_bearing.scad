
module m4_screw(){
screw_r=4/2+0.2;
head_d=7.5+0.3;
head_r=head_d/2;
cylinder(h=20, r1=screw_r, r2=screw_r,$fn=300);
    linear_extrude(height = 2.5, center = false, convexity = 10, twist = 0, scale=3/head_d)

    circle(r=head_r,$fn=300);
}


h=3.5;
diameter=9;
r=diameter/2;
difference(){
    
    cylinder(h=h, r1=r,r2=r);
    m4_screw();

    }

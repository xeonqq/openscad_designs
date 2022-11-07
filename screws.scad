screw_cap_depth=2;
screw_cap_r=5.5/2;

module screw_m3()
{
tolerance=0.2;
    hole_r = (3+tolerance)/2;
    cylinder(h=10, r1=hole_r, r2=hole_r, $fn=30);
    cylinder(h=screw_cap_depth, r1=screw_cap_r, r2=screw_cap_r, $fn=30);
 }


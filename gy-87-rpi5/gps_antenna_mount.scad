include <../roundedcube.scad>;




hh = 11.16;
up_scale=1+0.2/hh;
echo(up_scale);
w=28;
thickness=2.3;
hole_distance=25;
hole_r=1.4/2;

difference(){

translate([7,-8,10])
rotate([0,90,0])
difference(){
translate([4,-2,-w/2+hh/2])
roundedcube([thickness,w,w], radius=thickness/3, center=false);
scale(up_scale)
import("Short_Plain_Supports.stl");
}

cylinder(r=hole_r, h=10);
translate([hole_distance,0,0])
cylinder(r=hole_r, h=10);
}
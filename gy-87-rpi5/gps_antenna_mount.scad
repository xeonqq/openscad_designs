include <../roundedcube.scad>;




hh = 11.16;
up_scale=1+0.4/hh;
echo(up_scale);
w=28;
thickness=2.3;
hole_distance=25;
hole_r=1.6/2;
tongue_w=6+0.3;
antenna_w=24.6+0.3;


difference(){

translate([7,-8,10])
rotate([0,90,0])
//difference(){
translate([4,-2,-w/2+hh/2-2])
roundedcube([thickness,w*0.666,w+4], radius=thickness/3, center=false);
//translate([0,0,4])
//scale(up_scale)
//import("Short_Plain_Supports.stl");
//}

cylinder(r=hole_r, h=10);
translate([hole_distance,0,0])
cylinder(r=hole_r, h=10);


//translate([10+4,-10,0])
//cube([tongue_w, 5, 10]);

translate([0,0.5,0])
roundedcube([antenna_w,antenna_w,10], radius=2, center=false, apply_to="z");

}

translate([20,-5,6.0])
rotate([-90,0,180])
import("USB_dupont_Adapter_repaired.stl");
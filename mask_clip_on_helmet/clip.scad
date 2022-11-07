include <roundedcube.scad>




strap_thickness=1;
strap_width=14.5+2;
thickness=1.5;
height=12.5;
width=strap_width+2*thickness;
depth=strap_thickness+2*thickness;

difference(){
roundedcube([width,depth , height], apply_to="z");
//translate([thickness, thickness, -1])
//roundedcube([strap_width, strap_thickness, height+2]);
    
translate([width/2-strap_thickness-0.5, thickness+strap_thickness-0.2, -1])
cube([strap_thickness*2+1, thickness+0.5, height+2]);

translate([width/2,thickness-0.25,height/2])
rotate([-90,0,0])
cylinder(h = thickness+0.5, r1 =strap_width/2*1.2 , r2 = strap_thickness*2*2.2);
}


translate([width-1, 0,22.05])
rotate([-90,0,0])
difference(){

intersection(){
translate([60,15,0])
import("Surgical_Mask_Strap_Remix.stl");
cube(30);
}

translate([18.1,6.7,-1])
rotate([0,0,-8])
cube(13);

}
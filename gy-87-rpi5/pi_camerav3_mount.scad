include <../roundedcube.scad>;

translate([11, 25, 5.5])
rotate([0,0,-90])
import("Raspberry_Camera_case_back.stl");
hole_r = 2.9/2;
length = 10;
width = 56;
thickness= 1.5;
center = [length/2, width/2];
//roundedcube([length,width,thickness], radius=thickness/2, center=false);
hole_distance=58;
hole_offset = 3.5;
hole_positions = [[hole_offset, hole_offset],[hole_offset, width-hole_offset],[hole_distance+hole_offset, hole_offset],[hole_distance+hole_offset, width-hole_offset]];

screw_offset=6;
screw_position =[[hole_offset, width-hole_offset-screw_offset]];
screw_r = 3/2;
difference()
{   
    roundedcube([length,width,thickness], radius=thickness/2, center=false);

    for (pos = hole_positions) {
        translate([pos[0], pos[1], -1]) 
        cylinder(r=hole_r, h=10, $fn=100);
        
    }
        for (pos = screw_position) {
        translate([pos[0], pos[1], -1]) 
        cylinder(r=screw_r+0.1, h=10, $fn=100);
        
    }
    

    
}
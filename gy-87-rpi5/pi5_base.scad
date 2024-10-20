include <../roundedcube.scad>;

hole_r = 2.9/2;
length = 70;
width = 56;
thickness= 2;
center = [length/2, width/2];
//roundedcube([length,width,thickness], radius=thickness/2, center=false);

hole_distance=58;
hole_offset = 3.5;
hole_positions = [[hole_offset, hole_offset],[hole_offset, width-hole_offset],[hole_distance+hole_offset, hole_offset],[hole_distance+hole_offset, width-hole_offset]];

gps_hole_size_r = 3/2;
gps_module_hole_length = 28 + gps_hole_size_r*2;
gps_module_hole_width = 17.6 + gps_hole_size_r*2;
gps_center = [gps_module_hole_length/2, gps_module_hole_width/2];

gps_hole_positions = [[0, 0],[gps_module_hole_length, 0],[0, gps_module_hole_width],[gps_module_hole_length, gps_module_hole_width]];




difference()
{   
    roundedcube([length,width,thickness], radius=thickness/2, center=false);

    for (pos = hole_positions) {
        translate([pos[0], pos[1], -1]) 
        cylinder(r=hole_r, h=10, $fn=100);
        
    }
    
    translate([center[0]-gps_center[0], center[1]-gps_center[1], 0]){
    translate([gps_hole_size_r*2,-gps_hole_size_r, 0])
        roundedcube([gps_module_hole_length-4*gps_hole_size_r,gps_module_hole_width+2*gps_hole_size_r,thickness], radius=thickness/2, center=false, apply_to="z");
    
        translate([-gps_hole_size_r,2*gps_hole_size_r, 0])
        roundedcube([gps_module_hole_length+2*gps_hole_size_r,gps_module_hole_width-4*gps_hole_size_r,thickness], radius=thickness/2, center=false, apply_to="z");    
        
    for (pos = gps_hole_positions) {
        translate([pos[0], pos[1], -1]) 
        cylinder(r=(gps_hole_size_r+0.05), h=10, $fn=100);
    }
    }

    
}
//GY-87
include <../roundedcube.scad>;
pi_screw_gap=6;
pi_screw_r = 3/2;

margin = 0.2;
raw_length = 21.8;
length = raw_length+margin;
//height = 17.2 + margin;
height = 13 + margin;
total_thickness =2.5;
chip_thickness = 2;
wall_thickness = 1.2;

screw_d = 3;
hole_x_near_offset = 1.23;
r=3.3/2;

hole_x_offset = length-margin/2- (hole_x_near_offset+r);
hole_y_offset = 0.8;
difference(){
roundedcube([length+pi_screw_gap+wall_thickness,height+wall_thickness*2,total_thickness], radius=wall_thickness/3, center=false);
    translate([wall_thickness, wall_thickness, wall_thickness]){

        cube([length,height+5,chip_thickness]);
        
        translate([length+wall_thickness, 5,-2])
        cube([length,height+5,10]);


        {
        translate([hole_x_offset, hole_y_offset+r, -5])
        cylinder(r=r, h=10);
        }
                {
        translate([hole_x_offset+pi_screw_gap, hole_y_offset+r, -5])
        cylinder(r=r, h=10);
        }
    }
}
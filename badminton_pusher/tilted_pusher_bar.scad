include <../screws.scad>;
include <../servo_mount/servo_mount.scad>;
include <../roundedcube.scad>;
include <badminton_holder.scad>;

bar_height=70;
bar_thickness_at_end = 3;
bar_bottom_thick_section_h = 20;
bar_top_thin_section_h =bar_height-bar_bottom_thick_section_h;
narrow_side_w=rack_width/2;
hole_h = bar_top_thin_section_h*0.85;
buffer=0.5;
screw_diameter=3 + buffer;
module bar(){
linear_extrude(bar_bottom_thick_section_h, scale=[1,bar_thickness_at_end/narrow_side_w])
square([rack_width,narrow_side_w], center=true);
roundedcube([rack_width,narrow_side_w+15,2], center=true);

tilt_angle=28+15;
difference(){
translate([-rack_width/2,0.4,bar_bottom_thick_section_h-1])

rotate([tilt_angle,0,0])
difference(){
    translate([0,-3/2,0])
cube([rack_width, 3,bar_top_thin_section_h], center=false);

//cube([screw_diameter,10, hole_h],center=false);
}

//for (offset = [(bar_top_thin_section_h-hole_h)/2, (bar_top_thin_section_h-hole_h)/2+hole_h]){
//    translate([0,10,bar_bottom_thick_section_h+offset])
//rotate([90,0,0])
//cylinder(h=20, r1=screw_diameter/2,r2=screw_diameter/2);
//    }
//    
}
}

difference(){
bar();

translate([0,-7,-4])
screw_m3();
translate([0,7,-4])
screw_m3();
}

//translate([0,18,25])
//holder();

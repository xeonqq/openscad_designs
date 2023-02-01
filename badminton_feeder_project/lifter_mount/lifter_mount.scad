include<../roundedcube.scad>;
include<../servo_mount/servo_mount.scad>;


total_h = 22.5;
thickness= 4;
length=55;
width=50;


length_stage=48;
width_stage=50;
h_stage=total_h-thickness;


//translate([30-2,0,50])
//rotate([0,-90,0])
//mount_with_fitted_gear();
module stage(){
difference(){
    union(){
roundedcube([width,length, thickness], true, 1,"all");

translate([0,0,h_stage/2+thickness/2])
roundedcube([length_stage,width_stage, h_stage], true, 2,"z");
    }

translate([0,0,h_stage/2-thickness/2])
roundedcube([length_stage-15,width_stage-15, h_stage+10], true, 2,"z");

translate([-19,-12,h_stage/2+thickness/2])
roundedcube([length_stage,width_stage, h_stage+1], true, 2,"z");

screw_r=3.2/2;
translate([-17-2,19-1.3,5])
cylinder(h=20,r1=screw_r, r2=screw_r);
    translate([12.5-2,-19.3-1,5])
    cylinder(h=20,r1=screw_r, r2=screw_r);
}
}
screw_m4_r=4.2/2;
screw_m4_outer_r = 7.5/2;
module pad(){
difference(){
    cylinder(h=thickness,r1=screw_m4_outer_r, r2=screw_m4_outer_r);
cylinder(h=thickness+1,r1=screw_m4_r, r2=screw_m4_r);
}
}

for (x = [-width/2+1,width/2-1-5])
{
    for (y = [-length/2-2.2,length/2+2.2])

        translate([x,y,-thickness/2])pad();
 }
 stage();
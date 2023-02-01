include <../screws.scad>;
include <../mg996r.scad>;


module gripper_base(){
difference(){
import("Gripper_base.stl");
translate([0,-50,-115])
cube([80,80,80]);
    translate([-30.5,-40,-75+30])
cube([40,40,40]);

}
}
//gripper_base();


gear_distance=27.4;

    
    
module gripper_base_mg996r(){
    thickness=2.5;
        h=10+thickness;
difference()
    {
union(){
        translate([0,0,28])
cube([servo_w+thickness*2,servo_l+thickness*2,h]);
                extra_l=60;
    offset_y=(extra_l-servo_l)/2;
    translate([0,thickness,0])
{
    translate([0,-offset_y,26.5+2.5])
    cube([servo_w+thickness*2,extra_l,2.5]);
}
    translate([25,13.5,40-3.5])
    cube([12,25,4]);

}
translate([thickness,thickness,0])
        {
       mg996r();

            four_screws();
            
                r=(servo_w)/2;
            translate([r,r+gear_distance,h+24.]){
            screw_m3();
                translate([19,-7,-3])
                            screw_m3();
                   translate([19,-gear_distance+7,-3])
                            screw_m3();
                
            bearing_r=10/2+0.1;
                translate([0,0,1+thickness+0.5-1.3])
            cylinder(h=10, r1=bearing_r, r2=bearing_r, $fn=100);
            }
        }
//
//
//translate([thickness,47+thickness,0])
//
//rotate([90,0,0])
//import("MG996R_Servo_Model.stl");

}
}
gripper_base_mg996r();



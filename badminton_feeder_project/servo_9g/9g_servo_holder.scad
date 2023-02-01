include<9g_servo.scad>
include<../screws.scad>

tube_inner_r = 69.5/2+0.5;
cap_r = 75/2+0.3;
cap_thickness = 2;
cap_h=15;

servo_width=12.5;
servo_length=32;
z_offset=-2.8;

w = servo_width+3+1.5*2;
module servo_mount(){
difference()
{

    //translate([0,cap_r+cap_thickness+servo_width/2-2.6+1.5,2.6-0.5])
    cube([servo_length+5, w, 2], center=true);
    
    translate([0,1,z_offset])
    {
        scale([1.07,1.07,1])
    9g_motor();
    for ( hole = [14,-14] ){
    translate([hole,0,5]) cylinder(r=1.1, h=20, $fn=20, center=true);
    }
    }
//translate([0,cap_r+cap_thickness+servo_width/2+3,z_offset])
//9g_motor();

}
}
h=13;
servo_mount();

translate([0,-w/2+3,-h/2+1-2])
difference(){
translate([0,-3/2,0])
cube([15,3,h], center=true);
    
translate([0,0,3.5]){
rotate([90,0,0])
cylinder(r=(5.75/cos(30))/2, h=2.2, $fn=6);
    rotate([90,0,0])
cylinder(r=3.2/2, h=10, $fn=20); 
}
    
translate([0,0,-3]){
rotate([90,0,0])
cylinder(r=(5.75/cos(30))/2, h=2.2, $fn=6);
    rotate([90,0,0])
cylinder(r=3.2/2, h=10, $fn=20);
}
}
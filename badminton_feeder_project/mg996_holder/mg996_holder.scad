include <../mg996r.scad>;

include<../screws.scad>


module servo_mount(){
difference()
{
    length=servo_extra_l+4;
    extra_w=3.5+2;
    width= servo_w+extra_w;

union(){
    translate([-(length-servo_l)/2,-extra_w,22.5])
    cube([length, width, 3]);



translate([servo_l/2,-0.5-2,31.5])
vertical_bar();
}

translate([servo_l,0,0])
rotate([0,0,90])
{
    mg996r();
four_screws(20, 3.3);
}
}
}
h=13+2;
servo_mount();

module vertical_bar(){
difference(){
translate([0,-3/2,0])
cube([15,3,h], center=true);
    
translate([0,0,3.5]){
rotate([90,0,0])
cylinder(r=(5.95/cos(30))/2, h=2.2, $fn=6);
    rotate([90,0,0])
cylinder(r=3.2/2, h=10, $fn=20); 
}
    
translate([0,0,-3]){
rotate([90,0,0])
cylinder(r=(5.95/cos(30))/2, h=2.2, $fn=6);
    rotate([90,0,0])
cylinder(r=3.2/2, h=10, $fn=20);
}
}
}

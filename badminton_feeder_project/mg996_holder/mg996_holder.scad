include <../mg996r.scad>;

include<../screws.scad>


module servo_mount(){
difference()
{
    length=servo_extra_l+4;
    extra_w=3.5+2;
    width= servo_w+extra_w;

union(){
        cube_h=3;

    translate([-(length-servo_l)/2,-extra_w,22.5])
    cube([length, width, cube_h]);
    

    difference(){
    translate([-(length-servo_l)/2,-extra_w,22.5+5.5+cube_h])
     cube([length, width, cube_h]);
         translate([servo_l/2,-4+3+3+0.2+10.5,31.5])
        cube([45.1,30,h], center=true);
         translate([servo_l/2,-4+3,31.5])
        cube([15,9,h], center=true);
 
        }


          translate([servo_l/2,-0.5-2,31.5])
        vertical_bar(); 
}

translate([servo_l,0,-1])
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

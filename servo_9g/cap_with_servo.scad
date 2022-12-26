include<9g_servo.scad>
include<../screws.scad>

tube_inner_r = 69.5/2+0.5;
cap_r = 75/2+0.3;
cap_thickness = 2;
cap_h=15;

module cap(){
difference()
{
        cylinder(h=cap_h, r1=cap_r+cap_thickness,r2=cap_r+cap_thickness, $fn=30);
    translate([0,0,-1])
    cylinder(h=cap_h, r1=cap_r,r2=cap_r,$fn=300);
        translate([0,0,1])
    cylinder(h=cap_h*2, r1=tube_inner_r,r2=tube_inner_r,$fn=300);
    
    

    }
}

servo_width=12.5;
servo_length=32;
z_offset=-.5;
//cap();


module servo_mount(){
difference()
{

    translate([0,cap_r+cap_thickness+servo_width/2-2.6+1.5,2.6-0.5])
    cube([servo_length+5, servo_width+5+1.5*2, 2], center=true);
    
    translate([0,cap_r+cap_thickness+servo_width/2+1.5,z_offset]){
    9g_motor();
    for ( hole = [14,-14] ){
    translate([hole,0,5]) cylinder(r=1.1, h=20, $fn=20, center=true);
    }
    }
translate([0,cap_r+cap_thickness+servo_width/2+3,z_offset])
9g_motor();

}
}

module cap_with_servo_mount(){
        cap();

difference(){
union(){
//mirror([0,1,0])
//servo_mount();
servo_mount();
}
    translate([0,0,-1])
    cylinder(h=cap_h, r1=cap_r,r2=cap_r,$fn=300);


}
}

module holder(){

translate([0,cap_r+cap_thickness+servo_width/2,-0.5])
difference()
{
translate([0,0,16])
cube([32+5,11.5+4,20], center=true);
9g_motor();
    
for ( hole = [14,-14] ){
			translate([hole,0,10]) cylinder(r=1.1, h=20, $fn=20, center=true);
		}	
        
        translate([0,0,25])
        cube([32+5+1,11.5+5,20], center=true);      

       for ( hole = [17,-17] ){
             translate([hole,0, 18])
             cube([10,11.5+5,20], center=true);
       }
            
}
}
bearing_r=5/2+0.1;
bearing_h=4;
bearing_hole_r=4.8/2;
m3_r=3/2;
x_offset=-1;

module holder_with_bearing(){
difference(){
union(){
holder();
   translate([-8+x_offset,cap_r+cap_thickness+servo_width/2,15-0.5]){


cylinder(h=bearing_h, r1=bearing_hole_r, r2=bearing_hole_r,$fn=200); 
}
}
translate([-8+x_offset,cap_r+cap_thickness+servo_width/2,15-0.5-10]){
cylinder(h=bearing_h+20, r1=m3_r, r2=m3_r,$fn=200);

translate([0,0,+6])
rotate([0,0,30])
cylinder(r=(5.6/cos(30))/2, h=2, $fn=6);
}
}
}


module visually_combined(){
translate([0,1.5,0])
holder_with_bearing();


cap_with_servo_mount();
}

//
//ball_gap = 50;
//translate([0,0,ball_gap])
//visually_combined();

cube_w=20;
cube_thickness=3;


module connection()
{
    thickness=2;
    h=60;
translate([-cube_w/2,0,0]){
cube([cube_w, thickness, h]);
    for ( offset = [cube_w/4,cube_w-cube_w/4-1] ){
            translate([offset,thickness, 0])
        cube([1.2, thickness/2, h]);
    }
}
}

module connection_with_holes(){
difference(){
//translate([0,-3-cap_r-cube_thickness+1])
connection();
    for ( offset = [cap_h/2:5:55] ){
            translate([0, -5, offset])
        rotate([-90,0,0])
        screw_m3();
}
}
}

module cap_with_connection_and_servo(){
difference(){
    union(){
cap_with_servo_mount();


translate([0,-cap_r-cube_thickness/2,cap_h/2])
cube([cube_w,cube_thickness,cap_h],center=true);
    }
translate([0,-cap_r+0.1,cap_h/2])
rotate([90,0,0])
screw_m3();

translate([0,-3-cap_r-cube_thickness+1])
connection();
}
}
holder_with_bearing();
//connection_with_holes();
//cap_with_connection_and_servo();

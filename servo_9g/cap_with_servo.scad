include<9g_servo.scad>
tube_inner_r = 69.5/2+0.5;
cap_r = 75/2+0.5;
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
    
    
//translate([0,0,-50+5.6])
//cube([100,100,100], center=true);
    }
}

servo_width=12.5;
servo_length=32;
z_offset=-.5;
cap();


module servo_mount(){
difference(){

translate([0,cap_r+cap_thickness+servo_width/2-2.6,6.6])
cube([servo_length+5, servo_width+5, 2], center=true);
    
    
translate([0,cap_r+cap_thickness+servo_width/2,z_offset]){
9g_motor();
		for ( hole = [14,-14] ){
			translate([hole,0,5]) cylinder(r=1.1, h=20, $fn=20, center=true);
        }
}
translate([0,cap_r+cap_thickness+servo_width/2-5,z_offset])
9g_motor();

}
}

difference(){
union(){
mirror([0,1,0])
servo_mount();
servo_mount();
}
    translate([0,0,-1])
    cylinder(h=cap_h, r1=cap_r,r2=cap_r,$fn=300);


}

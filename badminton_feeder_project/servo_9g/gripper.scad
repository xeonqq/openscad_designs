include <9g_servo.scad>;
difference()
{
translate([0,0,16])
cube([32+4,11.5,20], center=true);
9g_motor();
    
for ( hole = [14,-14] ){
			translate([hole,0,5]) cylinder(r=2.1, h=10, $fn=20, center=true);
		}	
        
        translate([0,0,25])
        cube([32+4+1,11.5+1,20], center=true);

}


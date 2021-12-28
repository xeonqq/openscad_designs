include <roundedcube.scad>;
include <camera_base_fit.scad>
include <GoPro_Mount.scad>
speaker_wire_diameter=2.5;

module speaker_wire_hole(){

    h=10;
    translate([-14,5,-10])
        rotate([90,0,0])
        cylinder(h = h, r = speaker_wire_diameter/2, $fn=30);

}
//

module pi3_top()
{
    difference(){
        import("Top_Base_SM_Pins.stl");

        speaker_wire_hole();
        translate([-14,-4,-10])

            rotate([0,-47,0])
            cube([10, 5, speaker_wire_diameter/2]);
    }
}

intersection(){
union(){
difference(){
    
pi3_top();

x_buffer=0.4;
y_buffer=0.5;

scale([(26+x_buffer)/26,(27+y_buffer)/27,1])   
translate([13,13,-17.2])
rotate([0,0,180])

camera_base_with_fit(3, false, 0.6, 0.8,trap_a=0.68, trap_b=1.12, horizontal_snap_length=4.15,cylinder_snap_length=3.2);    
    
    //ribbon hole
    translate([-9,32,-20])
roundedcube([18,1.6, 10], false, 0.5,"z");
    
    translate([-15,-10,-12])
cube([50,10,15]);

   }


//translate([3.5,-13.2,-9.7])
//rotate([0,0,90])
//mount2();
   }
   
   translate([-15,-24,-20])
   cube([30,60,20]);
   }
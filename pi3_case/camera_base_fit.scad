include <roundedcube.scad>;

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


//import("Raspberry_Pi_B+_Camera_Gehause.stl");
//import("Raspberry_Pi_B+_Camera_Deckel.stl");
//import("P2_Housing_Front.stl");
//import("camera_front.stl");
module camera_back(){
    color([0,0,0.7])    // notice that there is NO semicolon

        difference(){
            translate([25,72.4+40+0,,0])
                import("camera_back.stl");
            cube(40,40,40);

        }
}
module camera_front(){
    color([1,0,0])    // notice that there is NO semicolon

        translate([13.8,17.4,-16])

        rotate([0,0,180])
        import("camera_front.stl");



} 

module half_base_projection()
{
    translate([0,-(28-27/2),0]){
        difference(){
            hull(){
                difference(){
                    projection(cut = false)
                    {
                        rotate([-90,0,0])
                            translate([-6.3,-14,1.2])
                            camera_back();
                    }
                    translate([0,28,0])
                        square(26);
                }
            }
            translate([0,-27/2,0])
                square(28);
        }
    }
}


module base_projection(){
    union(){
        half_base_projection();
        mirror([0,1,0])
            half_base_projection();
    }
}

module camera_base(pi_case_thickness)
{
    union(){
translate([0,-(28-27/2),0])
rotate([-90,0,0])
translate([-6.3,-14,1.2])
camera_back();

translate([0,0,-26])
linear_extrude(pi_case_thickness)
base_projection();
}
    }

horizontal_snap_length=4;
    
    

module snap(snap_length)
{
trap_a=0.58;
    trap_b=1.02;
    trap_h=0.7;
    rotate([0,180,0])

      rotate([180,0,180])
rotate([0,90,0])
linear_extrude(snap_length)
 
polygon([[0,0],[trap_b,0],[trap_a,trap_h],[0,trap_h]]);  
}

module camera_base_with_fit(pi_case_thickness){
    horizontal_snap_length_2=3;

 union(){    
   

translate([0,0,26])
camera_base(pi_case_thickness);
    
translate([26/4-horizontal_snap_length/2,27/2,pi_case_thickness])
snap(horizontal_snap_length);

translate([26*0.75-horizontal_snap_length/2,27/2,pi_case_thickness])
snap(horizontal_snap_length);
//roundedcube([26,26,28], false, 2.7, "ymin");
     radius=0.5;
translate([26/4*3-horizontal_snap_length_2/2,-27/2,pi_case_thickness-radius-1.1])
rotate([0,90,0])
cylinder(horizontal_snap_length_2,r=radius);

translate([26/4-horizontal_snap_length_2/2,-27/2,pi_case_thickness-radius-1.1])
rotate([0,90,0])
cylinder(horizontal_snap_length_2,r=radius);
//translate([26/2-horizontal_snap_length_2/2,-27/2,pi_case_thickness-1.])
//rotate([0,180,180])
//snap(horizontal_snap_length_2);
     
     

 }


}

module base_with_fit(pi_case_thickness){
    horizontal_snap_length_2=3;

union(){    
linear_extrude(pi_case_thickness)
base_projection();
    
translate([26/4-horizontal_snap_length/2,27/2,pi_case_thickness])
snap(horizontal_snap_length);

translate([26*0.75-horizontal_snap_length/2,27/2,pi_case_thickness])
snap(horizontal_snap_length);
//roundedcube([26,26,28], false, 2.7, "ymin");
//
//translate([26/2-horizontal_snap_length_2/2,-27/2,pi_case_thickness-1])
//rotate([0,180,180])
//snap(horizontal_snap_length_2);
     radius=0.5;
translate([26/4*3-horizontal_snap_length_2/2,-27/2,pi_case_thickness-radius-1.1])
rotate([0,90,0])
cylinder(horizontal_snap_length_2,r=radius);

translate([26/4-horizontal_snap_length_2/2,-27/2,pi_case_thickness-radius-1.1])
rotate([0,90,0])
cylinder(horizontal_snap_length_2,r=radius);    
}
}
camera_base_with_fit(3);
//base_with_fit(3);
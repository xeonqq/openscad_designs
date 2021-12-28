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

module camera_base(pi_case_thickness, with_camera_back_mount=true)
{
    union(){
        if (with_camera_back_mount)
        {
            translate([0,-(28-27/2),0])
                rotate([-90,0,0])
                translate([-6.3,-14,1.2])
                camera_back();
        }

        translate([0,0,-26])
            linear_extrude(pi_case_thickness)
            base_projection();
    }
}




module snap(snap_length, trap_h, trap_a, trap_b)
{
    rotate([0,180,0])

        rotate([180,0,180])
        rotate([0,90,0])
        linear_extrude(snap_length)

        polygon([[0,0],[trap_b,0],[trap_a,trap_h],[0,trap_h]]);  
}

module camera_base_with_fit(pi_case_thickness, with_camera_back_mount=true, cylinder_radius=0.5, snap_height=0.7, trap_a=0.58,trap_b=1.02,horizontal_snap_length=4, cylinder_snap_length=3){

    union(){    


        translate([0,0,26])
            camera_base(pi_case_thickness,with_camera_back_mount);

        translate([26/4-horizontal_snap_length/2,27/2,pi_case_thickness])
            snap(horizontal_snap_length,snap_height,trap_a,trap_b);

        translate([26*0.75-horizontal_snap_length/2,27/2,pi_case_thickness])
            snap(horizontal_snap_length,snap_height,trap_a,trap_b);
        //roundedcube([26,26,28], false, 2.7, "ymin");
        translate([26/4*3-cylinder_snap_length/2,-27/2,pi_case_thickness-cylinder_radius-1.1])
            rotate([0,90,0])
            cylinder(cylinder_snap_length,r=cylinder_radius);

        translate([26/4-cylinder_snap_length/2,-27/2,pi_case_thickness-cylinder_radius-1.1])
            rotate([0,90,0])
            cylinder(cylinder_snap_length,r=cylinder_radius);
        //translate([26/2-horizontal_snap_length_2/2,-27/2,pi_case_thickness-1.])
        //rotate([0,180,180])
        //snap(horizontal_snap_length_2);

    }
}


//camera_base_with_fit(3);
//camera_base_with_fit(3, false, 0.6, 0.8,trap_a=0.68, trap_b=1.12, horizontal_snap_length=4.15,cylinder_snap_length=3.2);

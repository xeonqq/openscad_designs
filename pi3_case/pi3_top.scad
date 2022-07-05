include <roundedcube.scad>;
include <camera_base_fit.scad>
include <GoPro_Mount.scad>
include <speaker_holder.scad>
include <switch_holder.scad>

speaker_wire_diameter=2.5;

module speaker_wire_hole(){

    h=10;
    translate([-13,5,-10])
        rotate([90,0,0])
        cylinder(h = h, r = speaker_wire_diameter/2, $fn=30);

}
//

module pi3_top()
{
    union(){
    difference(){
        import("Top_Base_SM_Pins.stl");

        speaker_wire_hole();
        translate([-13,-4,-10])

            rotate([0,-47,0])
            cube([10, 5, speaker_wire_diameter/2]);
    }
    
    //go pro mount
    translate([3.5,-13.2-extra_depth ,-9.7])
rotate([0,0,90])
mount2();
}
}

module combined(type="all"){

  
    
        if (type=="all"){pi3_top(); rotate([180,0,180])
import("pi3_base.stl");}
    else if (type=="top"){pi3_top(); }
    else if (type=="bottom"){         rotate([180,0,180])
import("pi3_base.stl");}
    }

module holes_for_speaker_wire(i)
{
   translate([-29+(27.5/2-6),2,-6+1.5+i])
   rotate([90,0,0])
   cylinder(r=1.25,h=15);
   
    translate([-29+13,58.7+12.5,-6.+1.5+i])
   rotate([90,0,0])
   cylinder(r=1.25,h=15);
}

//intersection(){
module pi_case(type="all"){
    //type ["all", "top", "bottom"]
union(){
    
translate([-29,-1.7,-6.])
rotate([90,0,0])
    if (type=="all"){speaker_holder();}
    else if (type=="top"){speaker_holder_top();}
    else if (type=="bottom"){speaker_holder_bottom();}

translate([-29+2,58.7-1,-6.])
rotate([90,0,180])
    if (type=="all"){speaker_holder();}
    else if (type=="top"){speaker_holder_top();}
    else if (type=="bottom"){speaker_holder_bottom();}
   
   translate([15,57.7,7.-1.8])
   rotate([-90,0,0])
    if (type=="all"){switch_holder();}
    else if (type=="top"){switch_holder_top();}
    else if (type=="bottom"){switch_holder_bottom();}
    
//     translate([15,57.7,7.-1.8])
//    rotate([-90,0,0])    
//    translate([holder_thickness, holder_thickness,holder_thickness+extra_holder_bottom_thickness])
//    switch(simplify=true);
difference(){
combined(type);
if (type=="top"){    
translate([-29+2,58.7-1,-6.])
rotate([90,0,180])
speaker();
    
    translate([-29,-1.7,-6.])
rotate([90,0,0])
    speaker();
}

x_buffer=0.4;
y_buffer=0.5;

scale([(26+x_buffer)/26,(27+y_buffer)/27,1])   
translate([13,13,-17.2])
rotate([0,0,180])

camera_base_with_fit(3, false, 0.6, 0.8,trap_a=0.68, trap_b=1.12, horizontal_snap_length=4.15,cylinder_snap_length=3.2);    
    
    //ribbon hole
    translate([-9,32,-20])
roundedcube([18,1.6, 10], false, 0.5,"z");
    
//    translate([-15,-10,-12])
//cube([50,10,15]);
   
   //holes for speaker wire
    if (type=="all" || type=="bottom"){        holes_for_speaker_wire(0);}
    else if (type=="top"){   
        for (i = [0:0.1:3]){
        holes_for_speaker_wire(i);
       }
   }}





   }
   }



module mount_stengthener()
{
   fit_body_connector_width=10;
    fit_body_connector_height=2.5;
    fit_body_connector_depth=2.2;
    
       fit_mount_connector_width=3.5;
    fit_mount_connector_height=2.6;
    fit_mount_connector_depth=22;
    
    binding_length=21;
    binding_thickness=2.5;
   
   translate([0,binding_length-fit_body_connector_height,-fit_body_connector_depth])
    cube([fit_body_connector_width,fit_body_connector_height, fit_body_connector_depth]);
    
       cube([fit_body_connector_width,binding_length, binding_thickness]);
    
    cube([fit_body_connector_width,binding_length, binding_thickness]);
    
    translate([fit_body_connector_width/2-fit_mount_connector_width/2,0,-fit_mount_connector_depth])
    cube([fit_mount_connector_width,fit_mount_connector_height, fit_mount_connector_depth]);

}
module case_combined()
{
    pi_case("bottom");
  pi_case("top");
    }
    
difference(){
    case_combined();

    
translate([-7.2,-7.5, 5.2])
mount_stengthener();
}
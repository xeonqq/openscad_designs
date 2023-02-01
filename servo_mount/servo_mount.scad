include <roundedcube.scad>;
include <../screws.scad>;


sub_height=5;
original_rack_height=8;
new_rack_height=original_rack_height-sub_height;
module rack(){
    
difference()
    {
    //union(){
    translate([-89,-22,0])
import("files/Gear_Rack.STL");
//       import("rack_new.stl");

      translate([0,0,sub_height])
cube([99.22,14.95,4]);


    //}
    translate([-1,-1,-1])
cube([120,20,sub_height+1]);
}
}

original_bottom_height=3.7;
new_bottom_height=3;
module mount(){
difference()
    {
union(){
import("files/Motor_Holder.stl");
translate([0,0, sub_height/2+original_bottom_height])
cube([110,40, sub_height], center=true);

}

h=original_bottom_height+sub_height-new_bottom_height;
cube([120,60, h*2], center=true); //hx2 due to center

translate([-62.,0,0])
cube([60,60,1120], center=true);


translate([75,0,0])
cube([60,60,1120], center=true);
//    
//    translate([48.4,-17,-20])
//cylinder(h=50, r1=1.6, r2=1.6);
//    translate([48.4-35,-17,-20])
//cylinder(h=50, r1=1.6, r2=1.6);
//    translate([48.4-70,-17,-20])
//cylinder(h=50, r1=1.6, r2=1.6);
//
//    translate([48.4,15,-20])
//cylinder(h=50, r1=1.6, r2=1.6);
//    translate([48.4-40,15,-20])
//cylinder(h=50, r1=1.6, r2=1.6);
//    translate([48.4-75,15,-20])
//cylinder(h=50, r1=1.6, r2=1.6);

}
}

top_screw_width=6.7;
scale=1.5;


module top_screw_plate()
{
difference(){
    union(){
linear_extrude(4, scale=[1,scale]){
translate([0,-top_screw_width,0])
square([top_screw_width/2,top_screw_width]);
}
translate([0,-top_screw_width*scale,4])
cube([top_screw_width/2, top_screw_width*scale, 5]);
}
translate([-4.5,-4.5,4.5])
rotate([0,90,0])
cylinder(h=15, r1=2, r2=2);


}
}



module mount_with_screw(){
difference(){
union(){
    mount();
translate([-32,23.75,42.7])
top_screw_plate();
    translate([-32+3.35,-23.75,13])

    rotate([0,0,180])
    top_screw_plate();
}
translate([-60,16,4])
cube([120,15,10]);
translate([-60,-34,1])
cube([120,15,10]);
}
}

teeth_interval=7.625;
teeth_width=teeth_interval/2;
teeth_height=2;
teeth_spike_height=1.3;
teeth_spike_width=teeth_width-1.8;

//translate([0,0,5])
//rack(); 

rack_width=15;
rack_height=3;
rack_length=90;

module gear_rack(extra_one_side_w, extra_one_side_thickness)
{
    sliding_buffer_one_side_w=2.5+extra_one_side_w;
    sliding_buffer_one_side_thickness=1+extra_one_side_thickness;
    translate([0,-sliding_buffer_one_side_w, 0])
            cube([rack_length,rack_width+sliding_buffer_one_side_w*2,sliding_buffer_one_side_thickness] );

        cube([rack_length,rack_width,rack_height] );
    //roundedcube([rack_length,rack_width,rack_height], radius=thickness/2, apply_to="y");
    for (dy=[0:1:8]) {
    translate([teeth_interval*dy,0, 0])
        teeth();
    }


}


module teeth()
{
    translate([0,0,rack_height])
    cube([teeth_width,rack_width,teeth_height]);
    translate([teeth_width/2,rack_width/2, rack_height+teeth_height])
    linear_extrude(teeth_spike_height, scale=[teeth_spike_width/teeth_width, (rack_width-1.8)/rack_width])
    square([teeth_width,rack_width], center=true);

}
module gear_rack_with_screw(extra_one_side_w=0, extra_one_side_thickness=0){
difference()
    {
    gear_rack(extra_one_side_w, extra_one_side_thickness);
    
        for (i = [0:1:10]){
    translate([rack_length-15+i,rack_width/2,-1])
    screw_m3();
        }
}
}
//teeth();
//mount();
module mount_with_fitted_gear(){
difference()
{
mount_with_screw();
translate([-33,-9.5,8.8])
gear_rack_with_screw(0.8, 0.4);
}
}

//mount_with_fitted_gear();    
//gear_rack_with_screw();

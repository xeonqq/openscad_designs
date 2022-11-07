include <roundedcube.scad>;


sub_height=5;
original_rack_height=8;
new_rack_height=original_rack_height-sub_height;
module rack(){
    
difference(){
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
difference(){
union(){
import("files/Motor_Holder.stl");
translate([0,0, sub_height/2+original_bottom_height])
cube([110,40, sub_height], center=true);

}

h=original_bottom_height+sub_height-new_bottom_height;
cube([120,60, h*2], center=true); //hx2 due to center

translate([-62.,0,0])
cube([60,60,1120], center=true);

    
    translate([48.4,-17,-20])
cylinder(h=50, r1=1.6, r2=1.6);
    translate([48.4-35,-17,-20])
cylinder(h=50, r1=1.6, r2=1.6);
    translate([48.4-70,-17,-20])
cylinder(h=50, r1=1.6, r2=1.6);

    translate([48.4,15,-20])
cylinder(h=50, r1=1.6, r2=1.6);
    translate([48.4-40,15,-20])
cylinder(h=50, r1=1.6, r2=1.6);
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
square([top_screw_width,top_screw_width]);
}
translate([0,-top_screw_width*scale,4])
cube([top_screw_width, top_screw_width*scale, 4]);
}
translate([-4.5,-4.5,4.5])
rotate([0,90,0])
cylinder(h=15, r1=1.5, r2=1.5);


}
}




//mount();
//translate([-32,23.75,42.7])
//top_screw_plate();

teeth_interval=7.625;
teeth_width=teeth_interval/2;
teeth_height=2;
teeth_spike_height=1.3;
teeth_spike_width=teeth_width-1.8;

//translate([0,0,5])
//rack(); 

rack_width=15;
rack_height=3;
rack_length=100;

module gear_rack()
{
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
    //gear_rack();

//teeth();

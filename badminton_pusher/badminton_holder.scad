include <../screws.scad>;
include <../servo_mount/servo_mount.scad>;


inner_holder_r = 35/2;
thickness = 2;
outer_pusher_r = inner_holder_r+thickness;
pusher_h=8;
holder_height=42;
inner_holder_openning_r = 39;
module holder()
{
    difference(){

    difference(){
        translate([0,0,-thickness])
        linear_extrude(height=(holder_height+thickness), scale=inner_holder_openning_r/inner_holder_r)
    circle(r=inner_holder_r+thickness);

    linear_extrude(height=holder_height+1, scale=inner_holder_openning_r/inner_holder_r)
    circle(r=inner_holder_r);
}


 translate([-1,-50,-5])
    cube([80,100,90]);
}
}

//holder();
//
//difference(){
//pusher();
//
//translate([-inner_pusher_r+0.3,0,pusher_h/2])
//rotate([0,-90,0])
//screw_m3();
//}
//
//difference(){
//
//barrier_extruding_length=6;
//translate([-outer_pusher_r+1,0,0])
//difference(){
//    cube([barrier_extruding_length,rack_width+4,40], center=true);
//
//buffer=0.5;
//cube([barrier_extruding_length+2,rack_width+buffer,40+2], center=true);
//    }
//        translate([0,0,100/2+pusher_h])
//cube([100,100,100], center=true);
//            translate([0,0,-100/2])
//cube([100,100,100], center=true);
//
//}
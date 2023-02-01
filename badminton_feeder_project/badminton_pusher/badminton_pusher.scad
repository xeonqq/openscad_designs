include <../screws.scad>;
include <../servo_mount/servo_mount.scad>;

extra_r = 2;
head_r = 26.5/2;
inner_pusher_r = head_r+extra_r;
outer_pusher_r = inner_pusher_r+3;
pusher_h=8;
module pusher()
{
difference(){
    cylinder(h=pusher_h, r1=outer_pusher_r, r2=outer_pusher_r);
    translate([0,0,-1])
    cylinder(h=pusher_h+2, r1=inner_pusher_r, r2=inner_pusher_r);
    translate([-inner_pusher_r*0.2,-20,-1])
    cube([40,40,40]);
    translate([-outer_pusher_r-40+0.2,-20,-1])
    cube([40,40,40]);
}
}

difference(){
pusher();

translate([-inner_pusher_r+0.3,0,pusher_h/2])
rotate([0,-90,0])
screw_m3();
}

difference(){

barrier_extruding_length=6;
translate([-outer_pusher_r+1,0,0])
difference(){
    cube([barrier_extruding_length,rack_width+4,40], center=true);

buffer=0.5;
cube([barrier_extruding_length+2,rack_width+buffer,40+2], center=true);
    }
        translate([0,0,100/2+pusher_h])
cube([100,100,100], center=true);
            translate([0,0,-100/2])
cube([100,100,100], center=true);

}
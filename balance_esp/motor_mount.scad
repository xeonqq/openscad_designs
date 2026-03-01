include<../roundedcube.scad>;

thickness=4;
length=139.5;
width=41.4;

module base(thickness=thickness)
{
    roundedcube([length, width, thickness], radius=1, center=false);
}


distance_two_holes_y=19.7-3.5;
distance_two_holes_x=14;
module four_mounting_screws()
{
    tolerance=0.2;
    screw_r=3.5/2+tolerance;
    screw_cap_depth=1;
    screw_cap_r=9.2/2;
    for (x=[0,distance_two_holes_x])
    {
        for (y=[0,distance_two_holes_y])
        {
        translate([x, y, 0]){
            cylinder(h=10, r1=screw_r, r2=screw_r, $fn=30);
            translate([0,0,thickness-screw_cap_depth])
            cylinder(h=screw_cap_depth, r1=screw_cap_r+tolerance, r2=screw_cap_r+tolerance);
        }
        }
    }
    translate([distance_two_holes_x/2,distance_two_holes_y/2,0])
    cylinder(h=10, r1=5, r2=5);

}
distance_two_supporting_screws=34.5-3;

module two_supporting_screws(d=3)
{
    tolerance=0.1;
    screw_r=d/2+tolerance;
    screw_cap_depth=1;
    screw_cap_r=5.1/2;
    
    for (y=[0,distance_two_supporting_screws])
    {
        translate([0, y, 0]){
            cylinder(h=10, r1=screw_r, r2=screw_r, $fn=30);
            cylinder(h=screw_cap_depth, r1=screw_cap_r+tolerance, r2=screw_cap_r+tolerance);
           }
    }
}

 bl=57.7;
 bw=43;
 bh=3;
module screw(r, cap_r, cap_thick=1, h=20)
{
        cylinder(r1=r,r2=r,h=h);
        cylinder(h=cap_thick, r1=cap_r, r2=cap_r);
}


module nut_with_screw(r){
cylinder(r=(5.95/cos(30))/2, h=2.2, $fn=6);
cylinder(r=r, h=20, $fn=20); 
}

module esp_motor_driver_board()
{
union(){
translate([0,0,bh/2])

    cube([bl+1,bw+1,bh], center=true);
    
    pin_h=1;
    offset=5;
    translate([-bl/2+offset,0,-pin_h/2])
    cube([3, bw-2, pin_h], center=true);
}
}

module imu_and_pin()
{
    l=19.5;
    w=2.5;
    h=1.;
    offset_to_motor_board_left_side=9.6;
    translate([(bl+1)/2+offset_to_motor_board_left_side,bw/2-l/2,-h/2+thickness]){
    cube([w,l, h], center=true);
        translate([-15/2,0,1.5])
        cube([15,22,2], center=true);
    }

}
module esp_motor_board_screws()
{
        r=3.4/2;
    cap_r=5.2/2;
    dist_edge=3.14-0.5;
    
    translate([bl/2-dist_edge,bw/2-2.6,1.2])
    nut_with_screw(r);
    
    translate([bl/2-dist_edge,bw/2-16.6,1.2])
    nut_with_screw(r);
    
    translate([bl/2-16.3,bw/2-18.5,0])
    nut_with_screw(r);
    
    translate([bl/2-46.1,bw/2-2.6,0])
    nut_with_screw(r);
    
    translate([bl/2-46.1,bw/2-30,0])
    nut_with_screw(r);
}


supporting_screw_distance_to_side_edge=14;
distance_to_side_edge=8;

module base_with_screw_holes(){
difference()
{
    base();
    translate([distance_to_side_edge,(width-distance_two_holes_y)/2,0])
four_mounting_screws();

translate([length-distance_to_side_edge-distance_two_holes_x,(width-distance_two_holes_y)/2,0])
four_mounting_screws();
    
    //supporting 4 screws
    translate([supporting_screw_distance_to_side_edge,(width-distance_two_supporting_screws)/2,0])
two_supporting_screws();

translate([length-supporting_screw_distance_to_side_edge,(width-distance_two_supporting_screws)/2,0])
two_supporting_screws();
}
}

    extended_width=6;
        extended_h=thickness+1.5;
module base_extended(){


union(){
translate([-length/2,-width/2,0])
base_with_screw_holes();

translate([0,0,(extended_h)/2])
roundedcube([bl+extended_width,bw+extended_width,extended_h], r=1,center=true);
}
}

module motor_mount(){
difference()
{
   base_extended();
       translate([0,0,extended_h-bh])
esp_motor_driver_board();
    imu_and_pin();
translate([0,0,-1.2])
esp_motor_board_screws();
}
}

module battery_mount_base()
{
difference()
{
    base(thickness=3);
        //supporting 4 screws
    translate([supporting_screw_distance_to_side_edge,(width-distance_two_supporting_screws)/2,0])
two_supporting_screws(d=3.4);

translate([length-supporting_screw_distance_to_side_edge,(width-distance_two_supporting_screws)/2,0])
two_supporting_screws(d=3.4);
}
}
module battery()
{
    l = 108.5;
    w=26;
    h=50;
    translate([0,0,h/2])
    cube([l, w, h],center=true);
}

module battery_strap_holes()
{
    
    l = 22;
    w=32;
    h=20;
    difference(){
    translate([0,0,h/2])
    cube([l, w, h],center=true);
        battery();
    }
}

module battery_support()
{
    
    l = 65;
    w=24;
    h=2;
        translate([0,0,h/2])

    difference(){
    cube([l, w, h],center=true);
    cube([l-4, w+1, h],center=true);

    }
}
module battery_mount()
{
    union(){
    difference(){
translate([-length/2,-width/2,0])
battery_mount_base();

translate([0,0,-3])
battery_strap_holes();

}
translate([0,0,2.9])
battery_support();
}
}

battery_mount();
//motor_mount();
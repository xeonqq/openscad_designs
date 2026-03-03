include<../roundedcube.scad>;

wheel_diameter = 66.5; // mm
wheel_width=26;
wheel_body_gap=9;
wheelbase_factor = 2.75;
wheel_base=wheel_diameter*wheelbase_factor;
width =  wheel_base-wheel_width-2*wheel_body_gap;
thickness=4;
distance_two_holes_y=19.7-3.5;
distance_two_holes_x=14;
// y
// |
// ---->x
caster_hole_diameter = 4.5;
caster_hole_spacing_x = 35;//27.5;
caster_hole_spacing_y = 27.5;
caster_edge_margin = 5;
caster_distance_to_rear_axis = wheel_base*0.4;

control_board_hole_spacing_x = 72;
control_board_hole_spacing_y = 48;
control_board_hole_diameter = 3.2; // M3 clearance
control_board_edge_margin = 4;
control_board_mount_rotated = true;

control_board_pattern_x = control_board_mount_rotated ? control_board_hole_spacing_y : control_board_hole_spacing_x;
control_board_pattern_y = control_board_mount_rotated ? control_board_hole_spacing_x : control_board_hole_spacing_y;

aux_board_hole_spacing_x = 58;
aux_board_hole_spacing_y = 42;
aux_board_hole_diameter = 3.0; // M2.8 clearance
aux_board_mount_rotated = true;
aux_board_pattern_x = aux_board_mount_rotated ? aux_board_hole_spacing_y : aux_board_hole_spacing_x;
aux_board_pattern_y = aux_board_mount_rotated ? aux_board_hole_spacing_x : aux_board_hole_spacing_y;
aux_board_back_offset = 6;

rear_bar_motor_margin = 5;
rear_bar_rear_margin = 5;
rear_bar_depth = distance_two_holes_y + 2*rear_bar_motor_margin;
// Rear axis passes through the motor-hole pattern center.
rear_axis_y = rear_bar_rear_margin + distance_two_holes_y/2;
motor_mount_origin_y = rear_axis_y - distance_two_holes_y/2;

stem_width = max(
    caster_hole_spacing_x + 2*caster_edge_margin,
    control_board_pattern_x + 2*control_board_edge_margin
);
stem_origin_x = (width - stem_width)/2;
caster_center_x = width/2;
caster_center_y = rear_axis_y + caster_distance_to_rear_axis;
control_board_center_x = width/2;
control_board_center_y = rear_bar_depth/2 + control_board_pattern_y/2;
aux_board_center_x = width/2;
aux_board_center_y = rear_bar_depth/2 + aux_board_pattern_y/2 - aux_board_back_offset;
length = max(
    caster_center_y + caster_hole_spacing_y/2 + caster_edge_margin,
    control_board_center_y + control_board_pattern_y/2 + control_board_edge_margin,
    aux_board_center_y + aux_board_pattern_y/2 + control_board_edge_margin
);

assert(stem_width <= width, "Stem width exceeds base width.");

assert(length > rear_bar_depth, "Computed length must be larger than rear bar depth.");
assert(control_board_center_y - control_board_pattern_y/2 >= 0, "Control board holes exceed rear edge.");
assert(control_board_center_y + control_board_pattern_y/2 <= length, "Control board holes exceed front edge.");
assert(aux_board_center_y - aux_board_pattern_y/2 >= 0, "Aux board holes exceed rear edge.");
assert(aux_board_center_y + aux_board_pattern_y/2 <= length, "Aux board holes exceed front edge.");

echo("wheel base:",wheel_base);
echo("base width:",width);
echo("base length:",length);
echo("rear axis y:",rear_axis_y);
echo("caster center:", [caster_center_x, caster_center_y]);
echo("control board center:", [control_board_center_x, control_board_center_y]);
echo("aux board center:", [aux_board_center_x, aux_board_center_y]);
assert(width > 65*2, "Computed length must be larger than 2 motor body lengths.");
module base(thickness=thickness)
{
    union()
    {
        // Horizontal bar for the motor mounts (rear axle section).
        roundedcube([width, rear_bar_depth, thickness], radius=1, center=false);

        // Forward stem ending at the caster tip.
        extra_length_to_cover_edge=2;
        translate([stem_origin_x, rear_bar_depth-extra_length_to_cover_edge, 0])
        roundedcube([stem_width, length+extra_length_to_cover_edge-rear_bar_depth, thickness], radius=1, center=false);
    }
}
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

module imu_module(
    board_x=15.596,
    board_y=20.394,
    board_z=1.6,
    hole_d=3.2,
    hole_x_from_left=13.048,
    hole_y_spacing=15.24,
    side_pin_bar_x=2.54,
    side_pin_bar_y=19.5,
    side_pin_bar_z=1.5
)
{
    hole_center_x = -board_x/2 + hole_x_from_left;
    translate([0,0,-side_pin_bar_z/2])
    union()
    {
        // Side header represented as a single soldered-pin bar for subtraction clearance.
        translate([-board_x/2+side_pin_bar_x/2, 0, 0])
        cube([side_pin_bar_x, side_pin_bar_y, side_pin_bar_z], center=true);

        translate([0, 0, side_pin_bar_z/2 + board_z/2])
        union()
        {
            cube([board_x, board_y, board_z], center=true);

            // Hole center X is measured from the left PCB edge.
            translate([hole_center_x, hole_y_spacing/2, -board_z/2-thickness])
            //cylinder(h=10 + 0.2, r=hole_d/2, center=true, $fn=40);
            nut_with_screw(r=hole_d/2);

            translate([hole_center_x, -hole_y_spacing/2, -board_z/2-thickness])
            //cylinder(h=10 + 0.2, r=hole_d/2, center=true, $fn=40);
            nut_with_screw(r=hole_d/2);
        }
    }
}

module imu_and_pin()
{
    //offset_to_motor_board_left_side=9.6;
    //translate([(bl+1)/2+offset_to_motor_board_left_side,bw/2-20.394/2,thickness-1.2/2])
    imu_module();
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

module caster_mount_holes()
{
    caster_hole_r = caster_hole_diameter/2;

    translate([caster_center_x - caster_hole_spacing_x/2, caster_center_y - caster_hole_spacing_y/2, 0])
    for (x=[0, caster_hole_spacing_x])
    {
        for (y=[0, caster_hole_spacing_y])
        {
            translate([x, y, 0])
            cylinder(h=10, r=caster_hole_r, $fn=30);
        }
    }
}

module control_board_mount_holes()
{
    board_hole_r = control_board_hole_diameter/2;

    translate([
        control_board_center_x - control_board_pattern_x/2,
        control_board_center_y - control_board_pattern_y/2,
        0
    ])
    for (x=[0, control_board_pattern_x])
    {
        for (y=[0, control_board_pattern_y])
        {
            translate([x, y, 0])
            cylinder(h=10, r=board_hole_r, $fn=30);
        }
    }
}

module aux_board_mount_holes()
{
    board_hole_r = aux_board_hole_diameter/2;

    translate([
        aux_board_center_x - aux_board_pattern_x/2,
        aux_board_center_y - aux_board_pattern_y/2,
        0
    ])
    for (x=[0, aux_board_pattern_x])
    {
        for (y=[0, aux_board_pattern_y])
        {
            translate([x, y, 0])
            cylinder(h=10, r=board_hole_r, $fn=30);
        }
    }
}

module base_with_screw_holes(){
difference()
{
    base();
    translate([distance_to_side_edge,motor_mount_origin_y,0])
four_mounting_screws();

translate([width-distance_to_side_edge-distance_two_holes_x,motor_mount_origin_y,0])
four_mounting_screws();

control_board_mount_holes();
//aux_board_mount_holes();
caster_mount_holes();
    
//    //supporting 4 screws
//    translate([supporting_screw_distance_to_side_edge,(length-distance_two_supporting_screws)/2,0])
//two_supporting_screws();
//
//translate([width-supporting_screw_distance_to_side_edge,(length-distance_two_supporting_screws)/2,0])
//two_supporting_screws();
}
}

    extended_width=6;
        extended_h=thickness+1.5;
module base_extended(){


union(){
translate([-width/2,-length/2,0])
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
    translate([supporting_screw_distance_to_side_edge,(length-distance_two_supporting_screws)/2,0])
two_supporting_screws(d=3.4);

translate([width-supporting_screw_distance_to_side_edge,(length-distance_two_supporting_screws)/2,0])
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

    w=23;
    l=2.2;
    battery_w=35;
    translate([-battery_w/2, 0, 0])
    roundedcube([l, w, 2* thickness], center=true);
    translate([battery_w/2, 0, 0])
    roundedcube([l, w, 2* thickness], center=true);
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
translate([-width/2,-length/2,0])
battery_mount_base();

translate([0,0,-3])
battery_strap_holes();

}
translate([0,0,2.9])
battery_support();
}

}
//module battery_strap_holes()
//{
//    
//    l = 22;
//    w=32;
//    h=20;
//    difference(){
//    translate([0,0,h/2])
//    cube([l, w, h],center=true);
//        battery();
//    }
//}

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
translate([-width/2,-length/2,0])
battery_mount_base();

translate([0,0,-3])
battery_strap_holes();

}
translate([0,0,2.9])
battery_support();
}
}

//battery_mount();
difference()
{
base_with_screw_holes();
translate([width/2, length/2-5, 1])
battery_strap_holes();

translate([width/4-0.2,rear_axis_y,thickness])
imu_and_pin();
}
    

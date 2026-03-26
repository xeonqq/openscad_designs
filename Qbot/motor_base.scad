include<../roundedcube.scad>;
include<../badminton_feeder_project/servo_9g/9g_servo_holder.scad>;

wheel_diameter = 66.5; // mm
wheel_width=26;
wheel_body_gap=9;
wheelbase_factor = 2.75;
wheel_base=wheel_diameter*wheelbase_factor;
width =  wheel_base-wheel_width-2*wheel_body_gap;
thickness=4;
trailer_hitch_length = 9;
trailer_hitch_root_width = 16;
trailer_hitch_tip_width = 7;
trailer_hitch_hole_diameter = 3.2; // M3 clearance
trailer_hitch_hole_tip_offset = 5;
distance_two_holes_y=19.7-3.5;
distance_two_holes_x=14;
// y
// |
// ---->x
caster_hole_diameter = 4.5;
caster_center_hole_diameter = 8;
caster_hole_spacing_x = 35;//27.5;
caster_hole_spacing_y = 27.5;
caster_edge_margin = 5;
caster_distance_to_rear_axis = wheel_base*0.5;
servo_caster_gap = 20;         // extra Y gap between caster holes and servo

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
    caster_center_y + caster_hole_spacing_y/2 + caster_edge_margin + servo_caster_gap,
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

        // Rear trailer hitch tab (trapezoid) extending from the tail.
        translate([0,1,0])
        linear_extrude(height=thickness)
        polygon([
            [width/2 - trailer_hitch_root_width/2, 0],
            [width/2 + trailer_hitch_root_width/2, 0],
            [width/2 + trailer_hitch_tip_width/2, -trailer_hitch_length],
            [width/2 - trailer_hitch_tip_width/2, -trailer_hitch_length]
        ]);
    }
}

module trailer_hitch_hole(h=10)
{
    translate([width/2, -trailer_hitch_length + trailer_hitch_hole_tip_offset, 0])
    nut_with_screw(r=trailer_hitch_hole_diameter/2, nut_z_offset=thickness/2);
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

module encoder_clearance_cutout(left_side=true)
{
    // Built from sketch dimensions, referenced to the 4-hole pattern.
    // Local frame is identical to four_mounting_screws():
    // (0,0)=bottom-left hole, (distance_two_holes_x, distance_two_holes_y)=top-right hole.
    top_cube_w = 5;
    top_cube_h = 14;
    bottom_cube_w = 12.3;
    bottom_cube_h = 6.3;

    // Measured offsets from the top-right motor hole on the LEFT side sketch.
    ref_to_top_left_x = 29;
    bottom_left_from_top_left_x = 5.2;

    ref_x = distance_two_holes_x;
    ref_y = distance_two_holes_y;
    cut_h = thickness + 2;

    module left_pattern()
    {
        // Left side requirement: top cube sits left of bottom cube.
        top_left_x = ref_x + ref_to_top_left_x;
        bottom_left_x = top_left_x + bottom_left_from_top_left_x;
        // Keep X from sketch, align cube center in Y with big motor-hole center.
        joint_y = ref_y/2 - top_cube_h/2;

        translate([top_left_x, joint_y, -1])
        cube([top_cube_w, top_cube_h, cut_h], center=false);

        //translate([bottom_left_x, joint_y - bottom_cube_h, -1])
        //cube([bottom_cube_w, bottom_cube_h, cut_h], center=false);
    }

    if (left_side)
    {
        left_pattern();
    }
    else
    {
        // Right side is the left sketch rotated 180 deg around hole-pattern center.
        translate([distance_two_holes_x/2, distance_two_holes_y/2, 0])
        rotate([0, 0, 180])
        translate([-distance_two_holes_x/2, -distance_two_holes_y/2, 0])
        left_pattern();
    }
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


module nut_with_screw(r, nut_z_offset=0){
translate([0,0,nut_z_offset])
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
    caster_center_hole_r = caster_center_hole_diameter/2;

    translate([caster_center_x - caster_hole_spacing_x/2, caster_center_y - caster_hole_spacing_y/2, 0])
    for (x=[0, caster_hole_spacing_x])
    {
        for (y=[0, caster_hole_spacing_y])
        {
            translate([x, y, 0])
            cylinder(h=10, r=caster_hole_r, $fn=30);
        }
    }

    translate([caster_center_x, caster_center_y, 0])
    cylinder(h=10, r=caster_center_hole_r, $fn=40);
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
    translate([distance_to_side_edge,motor_mount_origin_y,0])
encoder_clearance_cutout(left_side=true);

translate([width-distance_to_side_edge-distance_two_holes_x,motor_mount_origin_y,0])
four_mounting_screws();
translate([width-distance_to_side_edge-distance_two_holes_x,motor_mount_origin_y,0])
encoder_clearance_cutout(left_side=false);

control_board_mount_holes();
//aux_board_mount_holes();
caster_mount_holes();
trailer_hitch_hole();
    
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
    trailer_hitch_hole();
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
    battery_strap_center_triangle_side = 10;
    battery_strap_center_triangle_r = battery_strap_center_triangle_side/sqrt(3);
    translate([-battery_w/2, 0, 0])
    roundedcube([l, w, 2* thickness], center=true);
    translate([battery_w/2, 0, 0])
    roundedcube([l, w, 2* thickness], center=true);
    cylinder(h=2*thickness, r=battery_strap_center_triangle_r, $fn=3, center=true);
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

// ─── Front Wing (detachable bumper with bearing M3 holes) ────
// Mini-4WD style front wing with side-bypass arms that go around
// the servo 9g and bolt onto the base front edge with M3 screws.

wing_arm_length      = 40;        // how far each swept arm extends sideways
wing_arm_width       = 8;         // swept arm cross-section width
wing_thickness       = thickness; // same thickness as base
wing_attach_h        = 6;         // attach tab height (sits ON TOP of base)
wing_attach_pad_r    = 7;         // attach pad radius (bigger = stronger)
wing_center_w        = 30;        // center bar width
wing_center_d        = 8;         // center bar depth (Y)
wing_bearing_hole_d  = 3.2;       // M3 clearance for bearing screw
wing_bearing_standoff_r = 5;      // pad radius around bearing hole
wing_sweep_angle     = 45;        // arm sweep angle from X axis

// Servo clearance
servo_mount_w        = servo_length + 5 + 2;  // servo holder X width + clearance
servo_center_y       = length + w/2 - 1.5;    // servo center Y
servo_front_y        = servo_center_y + w/2;  // servo front edge Y

// Wing front bar sits just past the servo
wing_gap_from_servo  = 2;
wing_bar_y           = servo_front_y + wing_gap_from_servo;

// Side bypass arms: run alongside the servo, from base front to wing bar
wing_side_arm_w      = 8;         // width of each side bypass arm
wing_side_arm_gap    = 2;         // gap between servo and side arm

// X positions of the side arms (outside the servo)
wing_side_arm_left_x  = width/2 - servo_mount_w/2 - wing_side_arm_gap - wing_side_arm_w;
wing_side_arm_right_x = width/2 + servo_mount_w/2 + wing_side_arm_gap;

// Attach holes on the base: at the rear end of the side arms
wing_attach_hole_d   = 3.2;       // M3 clearance
wing_attach_y        = length - 5; // M3 hole Y on the base (near front edge)

// Attach tab X centers
wing_attach_left_cx  = wing_side_arm_left_x + wing_side_arm_w/2;
wing_attach_right_cx = wing_side_arm_right_x + wing_side_arm_w/2;

// ─── Wing attach holes (go through base + wing attach tab) ──
module wing_attach_hole_pattern()
{
    r = wing_attach_hole_d / 2;
    full_h = thickness + wing_attach_h+2;
    translate([wing_attach_left_cx, wing_attach_y, -1])
        cylinder(h = full_h, r = r, $fn = 30);
    translate([wing_attach_right_cx, wing_attach_y, -1])
        cylinder(h = full_h, r = r, $fn = 30);
}

// ─── Attach pads on the BASE ────────────────────────────────
module base_wing_attach_pads()
{
    // Slightly larger pads on the base for the screw head to sit on
    for (cx = [wing_attach_left_cx, wing_attach_right_cx])
        translate([cx, wing_attach_y, 0])
            cylinder(h = thickness, r = wing_attach_pad_r, $fn = 60);
}

// ─── Front wing (separate detachable part) ───────────────────
module front_wing()
{
    // Side bypass arms: sit on top of base (Z = thickness)
    // and run alongside the servo from attach point to wing bar
    for (sx = [wing_side_arm_left_x, wing_side_arm_right_x])
    {
        translate([sx, wing_attach_y - wing_attach_pad_r+2, thickness])
            roundedcube([wing_side_arm_w,
                         wing_bar_y - (wing_attach_y - wing_attach_pad_r) + wing_center_d/2,
                         wing_thickness],
                        radius = 1, center = false);
    }

    // Thick attach tabs at the rear of each side arm
    // These sit ON TOP of the base (Z = thickness), tall enough for the screw
    for (cx = [wing_attach_left_cx, wing_attach_right_cx])
    {
        translate([cx, wing_attach_y, thickness])
            cylinder(h = thickness, r = wing_attach_pad_r, $fn = 60);
    }

    // Center front bar connecting the two side arms
    translate([wing_side_arm_left_x, wing_bar_y, thickness])
        roundedcube([wing_side_arm_right_x + wing_side_arm_w - wing_side_arm_left_x,
                     wing_center_d, wing_thickness],
                    radius = 1, center = false);

    // Left and right swept arms + bearing pads
    for (side = [-1, 1])
    {
        arm_start_x = width/2 + side * (wing_center_w/2);
        arm_start_y = wing_bar_y + wing_center_d/2;

        arm_end_x = arm_start_x + side * wing_arm_length * cos(wing_sweep_angle);
        arm_end_y = arm_start_y + wing_arm_length * sin(wing_sweep_angle);

        hull()
        {
            translate([arm_start_x, arm_start_y, thickness])
                cylinder(h = wing_thickness, r = wing_arm_width/2, $fn = 60);
            translate([arm_end_x, arm_end_y, thickness])
                cylinder(h = wing_thickness, r = wing_arm_width/2, $fn = 60);
        }

        // Bearing pad at tip
        translate([arm_end_x, arm_end_y, thickness])
            cylinder(h = wing_thickness, r = wing_bearing_standoff_r, $fn = 60);
    }
}

module front_wing_holes()
{
    r = wing_bearing_hole_d / 2;

    for (side = [-1, 1])
    {
        arm_start_x = width/2 + side * (wing_center_w/2);
        arm_start_y = wing_bar_y + wing_center_d/2;
        arm_end_x = arm_start_x + side * wing_arm_length * cos(wing_sweep_angle);
        arm_end_y = arm_start_y + wing_arm_length * sin(wing_sweep_angle);

        translate([arm_end_x, arm_end_y, thickness - 1])
            cylinder(h = wing_thickness + 2, r = r, $fn = 30);
    }
}

module front_wing_part()
{
    difference()
    {
        front_wing();
        front_wing_holes();
        wing_attach_hole_pattern();
    }
}

//battery_mount();

// ─── Base plate (with wing attach pads & holes) ─────────────
difference()
{
    union()
    {
        base_with_screw_holes();
        base_wing_attach_pads();
    }
    wing_attach_hole_pattern();

    translate([width/2, length/2-5, 1])
    battery_strap_holes();

    translate([width/4-0.2,rear_axis_y,thickness])
    imu_and_pin();
}

// Servo 9g
translate([width/2, length+w/2-1.5,1.5])
scale([1, 1, 1.5])
servo_mount();

// Front wing (shown assembled — comment out to print separately)
//front_wing_part();

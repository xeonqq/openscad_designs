// --- Dimensions ---
include<../roundedcube.scad>;

total_length = 117;   // 11.7cm from the vertical sketch
total_width = 23;     // 2.4cm from the right sketch
inner_width = 10;     // 1.5cm from the top-left sketch
flange_height = 7.5;  // 7.5mm from the right sketch
bottom_thick = 2;   // 1.7mm from the bottom-right sketch

// Calculated dimensions
wall_thick = 2;// // Equals 4.5mm
distance_to_side=(total_width - inner_width-wall_thick*2) / 2;
echo(distance_to_side);
// --- Rendering Options ---
$fn = 60; // Smooth out curves
corner_r       = 0.5;            // rounded-corner radius

module uchannel()
 {

    // 1. The Bottom Base Plate


    roundedcube([total_length, total_width, bottom_thick], radius = corner_r, center = false);


    // 2. The Left Side Wall
    translate([0,distance_to_side , bottom_thick-corner_r])
        roundedcube([total_length, wall_thick, flange_height], radius = corner_r, center = false);

    // 3. The Right Side Wall
    translate([0, total_width - distance_to_side-wall_thick, bottom_thick-corner_r])
        roundedcube([total_length, wall_thick, flange_height], radius = corner_r, center = false);

}
module uchannel_without_mid(){
difference()
{
substract_w=inner_width-4;
uchannel();
translate([-1,(total_width-inner_width)/2,-1])
cube([total_length+2, inner_width, bottom_thick*2]);
}
}
offset_to_center=2;
module clip(){


intersection() {
    // Big cylinder - small cylinder
    difference() {
        cylinder(h = total_length, r = inner_width/2+bottom_thick);
        cylinder(h = total_length, r = inner_width/2);
    }

    // Keep only top half
    translate([offset_to_center, -25, -1])
        cube([52, 50, total_length+10]);
}

}
//translate([0,total_width/2,bottom_thick+offset_to_center])
//rotate([0,90,0])
//clip();
//uchannel_without_mid();
uchannel();
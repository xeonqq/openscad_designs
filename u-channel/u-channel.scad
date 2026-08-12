// --- Dimensions ---
total_length = 117;   // 11.7cm from the vertical sketch
total_width = 26; //extended    // 2.4cm from the right sketch
inner_width = 15;     // 1.5cm from the top-left sketch
flange_height = 7.5;  // 7.5mm from the right sketch
bottom_thick = 2;   // 1.7mm from the bottom-right sketch

// Calculated dimensions
wall_thick = 2;// // Equals 4.5mm
distance_to_side=(total_width - inner_width-wall_thick*2) / 2;
echo(distance_to_side);
// --- Rendering Options ---
$fn = 60; // Smooth out curves
color("white") {

    // 1. The Bottom Base Plate
    cube([total_length, total_width, bottom_thick]);

    // 2. The Left Side Wall
    translate([0,distance_to_side , bottom_thick])
        cube([total_length, wall_thick, flange_height]);

    // 3. The Right Side Wall
    translate([0, total_width - distance_to_side-wall_thick, bottom_thick])
        cube([total_length, wall_thick, flange_height]);

}
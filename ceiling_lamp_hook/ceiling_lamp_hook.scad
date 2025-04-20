// IKEA Ceiling Lamp Hook
// Designed for 4mm screw (4.5mm hole for tolerance)

// Base Plate
fixture_d=30;
fixture_h=2.5;
difference() {
    cylinder(h=fixture_h, d=fixture_d, $fn=50);      // Base platform
    translate([0,0,-1])
        cylinder(h=5, d=4.5, $fn=30); // Screw hole (4.5mm diameter)
}

// Vertical Support
hook_h=15;
translate([-fixture_d/3,0,fixture_h]) 
    cylinder(h=hook_h, d1=6*1.5,d2=6, $fn=50);      // Main support column

// Curved Hook
offset=fixture_d/3-10;
translate([-offset,0,hook_h+fixture_h])                   // Top of vertical support (3+25=28)
rotate([90,0,0])                      // Orient hook downward
rotate_extrude(angle=180, $fn=50)
    translate([10,0])                 // Hook radius (12mm from center)
    circle(d=6, $fn=30);              // Hook thickness
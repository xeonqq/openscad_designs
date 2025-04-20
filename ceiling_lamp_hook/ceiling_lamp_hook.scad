// IKEA Ceiling Lamp Hook
// Designed for 4mm screw (4.5mm hole for tolerance)

// Base Plate
difference() {
    cylinder(h=3, d=20, $fn=50);      // Base platform
    translate([0,0,-1])
        cylinder(h=5, d=4.5, $fn=30); // Screw hole (4.5mm diameter)
}

// Vertical Support
translate([0,0,3]) 
    cylinder(h=25, d=8, $fn=50);      // Main support column

// Curved Hook
translate([0,0,28])                   // Top of vertical support (3+25=28)
rotate([90,0,0])                      // Orient hook downward
rotate_extrude(angle=180, $fn=50)
    translate([12,0])                 // Hook radius (12mm from center)
    circle(d=6, $fn=30);              // Hook thickness
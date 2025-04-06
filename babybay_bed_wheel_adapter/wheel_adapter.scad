$fn = 100;

// Dimensions
outer_diameter = 12.6;
inner_diameter = 10.35;
length = 16;
pad_diameter = 20;
pad_thickness = 2;

// Main body
difference() {
    union() {
        // Cylinder for the body
        cylinder(h = length, d = outer_diameter, center = false);
        
        // Pad at the bottom
        translate([0, 0, 1])
            cylinder(h = pad_thickness, d = pad_diameter, center = false);
    }
    
    // Hollow inner part
    translate([0, 0, 0])
        cylinder(h = length + pad_thickness, d = inner_diameter, center = false);
}

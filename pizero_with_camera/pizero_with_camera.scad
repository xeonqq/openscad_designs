module camera_front(){
difference(){
    
    import("camera_front_box_v003.stl");
translate([0,-28-15,0])
cube([30,30*2,30], center=true);
}
}


// Adjustable camera support
// Two identical bars, 35 mm apart
// 3 mm screw hole centered in semicircular end

$fn = 64;

// Parameters
bar_length = 30;      // total length of bar
bar_width  = 12;       // width of straight section
thickness   = 4;       // thickness
end_radius = bar_width / 2;

hole_d     = 3.2;      // screw clearance hole
spacing    = 35;       // distance between the two bars
// Recess for male side
recess_d = 6.5;
recess_depth = 1;
// ----------------------------------------------------
// Single bar
// ----------------------------------------------------
module camera_bar() {
    rotate([90,0,-90])

    difference() {
        union() {
            // Straight rectangular section
            translate([0, -bar_width/2, 0])
                cube([
                    bar_length - end_radius,
                    bar_width,
                    thickness
                ]);

            // Semicircular end
            translate([bar_length - end_radius, 0, 0])
                cylinder(
                    r = end_radius,
                    h = thickness
                );
        }

        // 3 mm screw hole at center of semicircle
        translate([
            bar_length - end_radius,
            0,
            -1
        ])
            cylinder(
                d = hole_d,
                h = thickness + 2
            );
                // 6.5 mm x 1 mm recess
        // Recess is on the TOP surface
        translate([
            bar_length - end_radius,
            0,
            thickness - recess_depth
        ])
            cylinder(
                d = recess_d,
                h = recess_depth + 0.01
            );
    }
}

camera_front();

// ----------------------------------------------------
// Two bars, 35 mm apart
// ----------------------------------------------------
translate([-(spacing/2+thickness),0,bar_width/2])
union(){
rotate([0,180,0])
camera_bar();

translate([spacing+thickness*2, 0,0])
    camera_bar();
}

difference(){
translate([0,-5, thickness/2])
cube([
                    spacing+thickness*2,
                    10,
                    thickness
                ], center=true);
 translate([0,-5, thickness/2])
cube([
                    spacing-7,
                    10+1,
                    thickness+1
                ], center=true);   
    
}
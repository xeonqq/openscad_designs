// Parameters
short_edge = 11;              // legs of the right triangle
prism_height = 19.4;          // extrusion height
cyl_d = 3.2;
cyl_r = cyl_d / 2;

// Module to create the right triangle in 2D
module right_triangle_2d() {
    polygon(points=[
        [0, 0],
        [short_edge, 0],
        [0, short_edge]
    ]);
}

// Module for the triangle prism
module triangle_prism() {
    linear_extrude(height=prism_height)
        right_triangle_2d();
}

// Calculate the center point of the hypotenuse
hypotenuse_center = [short_edge/2, short_edge/2, prism_height/2];

// Correct rotation:
// - First rotate around Z by 45° to align with hypotenuse
// - Then rotate around the new X-axis by 90° to go perpendicular into the face
module hypotenuse_cylinder() {
   translate(hypotenuse_center)
        rotate([0, 90, 45])  // Z=45 to align with hypotenuse, Y=-45 to tilt perpendicular
            cylinder(h=90, r=cyl_r, $fn=100, center=true); // Long enough to cut through
}

// Final shape: triangle prism minus cylinder
difference() {
    triangle_prism();
    hypotenuse_cylinder();
}

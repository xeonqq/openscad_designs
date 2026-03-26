include<../roundedcube.scad>;

// ============================================================
// Coral Camera Mount  –  L-bracket with camera housing
//
// Bolts onto the front extension of coral_mini_board_mount
// with 2 × M3 screws.  Camera faces forward (+Y).
//
// Housing encloses the camera PCB with:
//   - lens aperture on front face
//   - open back for PCB insertion
//   - 4 × screw-through standoffs from the front
//   - ribbon-cable slot at the bottom
//   - proper side gussets for rigidity
// ============================================================

// ─── Camera module (from datasheet) ──────────────────────────
cam_board_size      = 25;       // 25 × 25 mm square PCB
cam_board_thick     = 1.6;      // PCB thickness
cam_hole_spacing    = 20;       // 20 × 20 mm hole pattern
cam_hole_d          = 2.4;      // ⌀2.40 mm
cam_protrusion      = 6.98;     // lens barrel protrusion from PCB front
cam_lens_d          = 10;       // lens barrel diameter (approx)

// ─── Ribbon cable ────────────────────────────────────────────
ribbon_w            = 16;       // ribbon cable width
ribbon_h            = 1.5;      // slot height (thickness clearance)

// ─── Attachment to coral_mini_mount (must match) ─────────────
cam_attach_spacing_x = 20;     // matches coral_mini_board_mount
cam_attach_hole_d    = 3.2;    // M3 clearance

// ─── Bracket / housing geometry ─────────────────────────────
wall          = 2.5;            // housing wall thickness
foot_thick    = 3;              // horizontal foot plate thickness
foot_depth    = 17;             // foot extent in Y
corner_r      = 0.5;
gusset_thick  = 2.5;           // gusset plate thickness
gusset_h      = 15;            // how far up the housing the gusset reaches

// Housing internal dimensions
housing_clearance = 0.5;        // gap around the PCB
housing_inner_w   = cam_board_size + 2 * housing_clearance;   // ~26
housing_inner_h   = cam_board_size + 2 * housing_clearance;   // ~26
housing_inner_d   = cam_protrusion + cam_board_thick + 2;     // ~11 depth

// Housing outer dimensions
housing_w = housing_inner_w + 2 * wall;     // ~31
housing_total_h = foot_thick + housing_inner_h + wall;  // bottom=foot_thick, top=wall
housing_d = housing_inner_d + wall;         // front wall included

// Foot width matches housing width
bracket_w = housing_w;
bcx = bracket_w / 2;

// Standoffs inside – PCB rests against these from the back
standoff_h_cam  = 1.5;
standoff_r_cam  = 2.5;

// Lens aperture
lens_aperture_d = cam_lens_d + 1;

// ─── Derived positions ──────────────────────────────────────
// Everything starts at Z=0 (flat bottom for 3D printing)
housing_oy = foot_depth - wall;

// Centre of camera hole pattern on the wall
cam_center_z = foot_thick + housing_inner_h / 2;

// Front wall inner face Y
front_inner_y = housing_oy + housing_d - wall;

echo("Housing outer:", housing_w, "×", housing_total_h, "×", housing_d);
echo("Bracket foot:", bracket_w, "×", foot_depth, "×", foot_thick);

// ─── Modules ─────────────────────────────────────────────────

// Horizontal foot
module bracket_foot()
{
    roundedcube([bracket_w, foot_depth, foot_thick],
                radius = corner_r, center = false);
}

// Housing box – starts at Z=0 same as foot (no step)
module housing_shell()
{
    translate([0, housing_oy, 0])
    {
        difference()
        {
            // Outer box – same Z=0 base as foot
            roundedcube([housing_w, housing_d, housing_total_h],
                        radius = corner_r, center = false);

            // Inner cavity (open at the back, Y=0 side)
            // Floor at Z=foot_thick (flush with foot top)
            translate([wall, -1, foot_thick])
                cube([housing_inner_w, housing_inner_d + 1, housing_inner_h]);

            // Lens aperture through the front wall
            translate([housing_w/2, housing_d - wall - 1, cam_center_z])
                rotate([-90, 0, 0])
                    cylinder(h = wall + 2, r = lens_aperture_d/2, $fn = 50);

            // Ribbon cable slot through the bottom wall
            translate([housing_w/2 - ribbon_w/2, -1, 0])
                cube([ribbon_w, housing_d + 2, foot_thick + ribbon_h]);
        }
    }
}

// 4 standoff bosses on the inner front wall
module housing_standoffs()
{
    hx = housing_w / 2;

    for (dx = [-cam_hole_spacing/2, cam_hole_spacing/2])
        for (dz = [-cam_hole_spacing/2, cam_hole_spacing/2])
            translate([hx + dx, front_inner_y, cam_center_z + dz])
                rotate([90, 0, 0])
                    cylinder(h = standoff_h_cam, r = standoff_r_cam, $fn = 20);
}

// 4 screw holes through the front wall + standoffs
module housing_cam_holes()
{
    r = (cam_hole_d + 0.2) / 2;
    hx = housing_w / 2;
    front_outer_y = housing_oy + housing_d;
    drill_len = wall + standoff_h_cam + 2;

    for (dx = [-cam_hole_spacing/2, cam_hole_spacing/2])
        for (dz = [-cam_hole_spacing/2, cam_hole_spacing/2])
            translate([hx + dx, front_outer_y + 1, cam_center_z + dz])
                rotate([90, 0, 0])
                    cylinder(h = drill_len, r = r, $fn = 30);
}

// Side gussets – triangular plates in the YZ plane on each side
module bracket_gussets()
{
    gy_start = housing_oy+0.5;

    for (x_off = [0, bracket_w - gusset_thick])
    {
        translate([x_off, gy_start, foot_thick])
            rotate([90, 0, 90])
                linear_extrude(height = gusset_thick)
                    polygon([
                        [0, 0],
                        [-(foot_depth - wall), 0],
                        [0, gusset_h]
                    ]);
    }
}

// 2 × M3 holes through the foot
module foot_holes()
{
    r = cam_attach_hole_d / 2;
    fy = foot_depth / 2;
    for (x = [-cam_attach_spacing_x/2, cam_attach_spacing_x/2])
        translate([bcx + x, fy, -1])
            cylinder(h = foot_thick + 2, r = r, $fn = 30);
}

// ─── Final part ──────────────────────────────────────────────

module coral_camera_mount()
{
    difference()
    {
        union()
        {
            bracket_foot();
            housing_shell();
            housing_standoffs();
            bracket_gussets();
        }
        foot_holes();
        housing_cam_holes();
    }
}

// Rotate so the front wall lies flat on the print bed
coral_camera_mount();

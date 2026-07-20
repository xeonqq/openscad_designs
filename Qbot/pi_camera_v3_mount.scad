include<../roundedcube.scad>;

// ============================================================
// Raspberry Pi Camera Module 3 (v3) Mount – L-bracket + housing
//
// Bolts onto the front extension of coral_mini_board_mount
// with 2 × M3 screws.  Camera faces forward (+Y).
//
// Housing encloses the Pi Camera v3 PCB with:
//   - round lens aperture on front face (clears the wide FoV)
//   - open back for PCB insertion
//   - 4 × screw-through standoffs from the front
//   - ribbon-cable slot at the bottom
//   - proper side gussets for rigidity
// ============================================================

// ─── Pi Camera Module 3 (from RPi mechanical drawing) ────────
// Board / hole positions are identical to Camera Module 2.
cam_board_w         = 25;       // PCB width  (X)  25 mm
cam_board_h         = 24;       // PCB height (Z)  23.862 mm (nominal 24)
cam_board_thick     = 1.4;      // PCB thickness
cam_hole_spacing_x  = 21;       // mounting-hole pitch in X  21 mm (2 mm from each edge)
cam_hole_spacing_z  = 12.5;     // mounting-hole pitch in Z  12.5 mm
cam_hole_from_bottom = 2.0;     // bottom holes 2.0 mm from the bottom (ribbon) edge
cam_hole_d          = 2.2;      // ⌀2.20 mm mounting holes
cam_protrusion      = 6.0;      // v3 lens/housing protrusion from PCB front
cam_lens_sq         = 11;       // v3 lens holder is an 11 mm square

// Optical axis is NOT centred on the 4 mounting holes: it sits high on the
// board (level with the top hole row), 6.25 mm above the hole-pattern centre.
cam_optical_from_bottom = 14.5; // lens optical axis height above the bottom edge

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
housing_inner_w   = cam_board_w + 2 * housing_clearance;      // ~26
housing_inner_h   = cam_board_h + 2 * housing_clearance;      // ~25
housing_inner_d   = cam_protrusion + cam_board_thick + 2;     // lens depth

// Housing outer dimensions
housing_w = housing_inner_w + 2 * wall;     // ~32
housing_total_h = foot_thick + housing_inner_h + wall;  // bottom=foot_thick, top=wall
housing_d = housing_inner_d + wall;         // front wall included

// Foot width matches housing width
bracket_w = housing_w;
bcx = bracket_w / 2;

// Standoffs inside – PCB rests against these from the back
standoff_h_cam  = 1.5;
standoff_r_cam  = 2.5;

// Lens aperture
lens_aperture_sq = cam_lens_sq + 0.7;

// ─── Derived positions ──────────────────────────────────────
// Everything starts at Z=0 (flat bottom for 3D printing)
housing_oy = foot_depth - wall;

// The PCB sits centred in the housing cavity; its geometric centre is here.
pcb_center_z = foot_thick + housing_inner_h / 2;

// Mounting-hole pattern centre and lens optical axis, measured relative to the
// PCB centre (positive = toward the top of the board, away from the ribbon).
hole_center_z = pcb_center_z
    + (cam_hole_from_bottom + cam_hole_spacing_z / 2) - cam_board_h / 2;
lens_center_z = pcb_center_z
    + cam_optical_from_bottom - cam_board_h / 2;

// Front wall inner face Y
front_inner_y = housing_oy + housing_d - wall;

echo("Housing outer:", housing_w, "×", housing_total_h, "×", housing_d);
echo("Bracket foot:", bracket_w, "×", foot_depth, "×", foot_thick);
echo("Lens above hole centre:", lens_center_z - hole_center_z, "mm");

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

            // Lens aperture through the front wall (11 mm square v3 lens),
            // offset up to the true optical axis.
            translate([housing_w/2 - lens_aperture_sq/2, housing_d - wall - 1, lens_center_z - lens_aperture_sq/2])
                cube([lens_aperture_sq, wall + 2, lens_aperture_sq]);

            // Ribbon cable slot through the bottom wall
            translate([housing_w/2 - ribbon_w/2, -1, 0])
                cube([ribbon_w, housing_d + 2, foot_thick + ribbon_h]);

            // Ribbon cable slot through the top wall (route cable upward)
            translate([housing_w/2 - ribbon_w/2, -1, housing_total_h - wall - ribbon_h])
                cube([ribbon_w, housing_d + 2, wall + ribbon_h + 1]);
        }
    }
}

// 4 standoff bosses on the inner front wall
module housing_standoffs()
{
    hx = housing_w / 2;

    for (dx = [-cam_hole_spacing_x/2, cam_hole_spacing_x/2])
        for (dz = [-cam_hole_spacing_z/2, cam_hole_spacing_z/2])
            translate([hx + dx, front_inner_y, hole_center_z + dz])
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

    for (dx = [-cam_hole_spacing_x/2, cam_hole_spacing_x/2])
        for (dz = [-cam_hole_spacing_z/2, cam_hole_spacing_z/2])
            translate([hx + dx, front_outer_y + 1, hole_center_z + dz])
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

module pi_camera_v3_mount()
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

pi_camera_v3_mount();

include<../roundedcube.scad>;

// ============================================================
// Raspberry Pi 5 Mount
// A plate that bolts onto the control board (4 × M3 holes)
// and provides 4 standoffs + holes for the Raspberry Pi 5.
// ============================================================

// ─── Control board mount holes (bottom – attach plate to control board) ───
// Hole-to-hole spacing on the control board PCB
ctrl_hole_spacing_x = 72;       // mm
ctrl_hole_spacing_y = 48;       // mm
ctrl_hole_d         = 3.2;      // M3 clearance
ctrl_rotated        = true;     // board is mounted rotated 90°
ctrl_pat_x = ctrl_rotated ? ctrl_hole_spacing_y : ctrl_hole_spacing_x;  // 48
ctrl_pat_y = ctrl_rotated ? ctrl_hole_spacing_x : ctrl_hole_spacing_y;  // 72

// ─── Raspberry Pi 5 board holes (top – mount Pi 5 onto plate) ───
// From mechanical drawing: board 85 × 56 mm, 4 × ⌀2.70 M2.5 holes at 58 × 49 mm
rpi5_board_l        = 85;       // mm
rpi5_board_w        = 56;       // mm
rpi5_hole_spacing_x = 58;      // mm  (center-to-center, along length)
rpi5_hole_spacing_y = 49;      // mm  (center-to-center, along width)
rpi5_hole_d         = 2.7;     // mm  (M2.5 clearance)
rpi5_rotated        = true;    // rotate 90° to align with control board
rpi5_pat_x = rpi5_rotated ? rpi5_hole_spacing_y : rpi5_hole_spacing_x;  // 49
rpi5_pat_y = rpi5_rotated ? rpi5_hole_spacing_x : rpi5_hole_spacing_y;  // 58

// ─── Camera-bracket attach holes (M3, on front extension) ───
cam_attach_spacing_x = 20;     // horizontal spacing of 2 × M3 holes
cam_attach_hole_d    = 3.2;    // M3 clearance

// ─── Plate geometry ───
edge_margin    = 5;            // mm around outermost holes
plate_thick    = 3;            // mm
corner_r       = 2;            // rounded-corner radius
standoff_h     = 8;            // height of Coral-board standoffs
standoff_r     = 3.5;          // outer radius of each standoff

cam_extension  = 18;           // extra length at front for camera bracket

plate_w     = max(ctrl_pat_x, rpi5_pat_x) + 2 * edge_margin;
plate_l_base = max(ctrl_pat_y, rpi5_pat_y) + 2 * edge_margin;
plate_l     = plate_l_base + cam_extension;

cx = plate_w / 2;              // plate centre X
cy = plate_l_base / 2;         // board-area centre Y (not counting extension)

// Camera-attach holes centred in the extension zone
cam_attach_cy = plate_l_base + cam_extension / 2;

echo("Plate size:", plate_w, "×", plate_l, "×", plate_thick);
echo("Control-board pattern (on plate):", ctrl_pat_x, "×", ctrl_pat_y);
echo("RPi5 pattern (on plate):", rpi5_pat_x, "×", rpi5_pat_y);
echo("Camera-attach holes Y:", cam_attach_cy);

// ─── Modules ─────────────────────────────────────────────────

module plate()
{
    roundedcube([plate_w, plate_l, plate_thick], radius = corner_r, center = false);
}

// 4 pass-through holes for M3 screws (control board pattern)
module ctrl_holes()
{
    r = ctrl_hole_d / 2;
    ox = cx - ctrl_pat_x / 2;
    oy = cy - ctrl_pat_y / 2;

    for (x = [0, ctrl_pat_x])
        for (y = [0, ctrl_pat_y])
            translate([ox + x, oy + y, -1])
                cylinder(h = plate_thick + standoff_h + 2, r = r, $fn = 30);
}

// 4 standoff cylinders on top of the plate for the Pi 5 board
module rpi5_standoffs()
{
    ox = cx - rpi5_pat_x / 2;
    oy = cy - rpi5_pat_y / 2;

    for (x = [0, rpi5_pat_x])
        for (y = [0, rpi5_pat_y])
            translate([ox + x, oy + y, plate_thick])
                cylinder(h = standoff_h, r = standoff_r, $fn = 30);
}

// Holes drilled through the standoffs for Pi 5 board screws
module rpi5_holes()
{
    r = (rpi5_hole_d + 0.2) / 2;   // +0.2 mm clearance
    ox = cx - rpi5_pat_x / 2;
    oy = cy - rpi5_pat_y / 2;

    for (x = [0, rpi5_pat_x])
        for (y = [0, rpi5_pat_y])
            translate([ox + x, oy + y, -1])
                cylinder(h = plate_thick + standoff_h + 2, r = r, $fn = 30);
}

// 2 M3 holes in the front extension for the camera bracket
module cam_attach_holes()
{
    r = cam_attach_hole_d / 2;
    for (x = [-cam_attach_spacing_x/2, cam_attach_spacing_x/2])
        translate([cx + x, cam_attach_cy, -1])
            cylinder(h = plate_thick + 2, r = r, $fn = 30);
}

// ─── Final assembly ──────────────────────────────────────────

module rpi5_mount()
{
    difference()
    {
        union()
        {
            plate();
            //rpi5_standoffs();
        }
        ctrl_holes();
        rpi5_holes();
        cam_attach_holes();
    }
}

rpi5_mount();
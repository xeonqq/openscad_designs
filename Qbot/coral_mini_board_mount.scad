include<../roundedcube.scad>;

// ============================================================
// Coral Mini Board Mount
// A plate that bolts onto the control board (4 × M3 holes)
// and provides 4 standoffs + holes for the Coral Mini board.
// ============================================================

// ─── Control board mount holes (bottom – attach plate to control board) ───
// Hole-to-hole spacing on the control board PCB
ctrl_hole_spacing_x = 72;       // mm
ctrl_hole_spacing_y = 48;       // mm
ctrl_hole_d         = 3.2;      // M3 clearance
ctrl_rotated        = true;     // board is mounted rotated 90°
ctrl_pat_x = ctrl_rotated ? ctrl_hole_spacing_y : ctrl_hole_spacing_x;  // 48
ctrl_pat_y = ctrl_rotated ? ctrl_hole_spacing_x : ctrl_hole_spacing_y;  // 72

// ─── Coral Mini board holes (top – mount Coral board onto plate) ───
// From datasheet: board 64 × 48 mm, 4 × ⌀2.80 holes at 58 × 42 mm
coral_board_w       = 48;       // mm
coral_board_l       = 64;       // mm
coral_hole_spacing_x = 58;     // mm  (center-to-center)
coral_hole_spacing_y = 42;     // mm
coral_hole_d        = 2.8;     // mm  (nominal)
coral_rotated       = true;    // rotate 90° to align with control board
coral_pat_x = coral_rotated ? coral_hole_spacing_y : coral_hole_spacing_x;  // 42
coral_pat_y = coral_rotated ? coral_hole_spacing_x : coral_hole_spacing_y;  // 58

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

plate_w     = max(ctrl_pat_x, coral_pat_x) + 2 * edge_margin;
plate_l_base = max(ctrl_pat_y, coral_pat_y) + 2 * edge_margin;
plate_l     = plate_l_base + cam_extension;

cx = plate_w / 2;              // plate centre X
cy = plate_l_base / 2;         // board-area centre Y (not counting extension)

// Camera-attach holes centred in the extension zone
cam_attach_cy = plate_l_base + cam_extension / 2;

echo("Plate size:", plate_w, "×", plate_l, "×", plate_thick);
echo("Control-board pattern (on plate):", ctrl_pat_x, "×", ctrl_pat_y);
echo("Coral pattern (on plate):", coral_pat_x, "×", coral_pat_y);
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

// 4 standoff cylinders on top of the plate for the Coral board
module coral_standoffs()
{
    ox = cx - coral_pat_x / 2;
    oy = cy - coral_pat_y / 2;

    for (x = [0, coral_pat_x])
        for (y = [0, coral_pat_y])
            translate([ox + x, oy + y, plate_thick])
                cylinder(h = standoff_h, r = standoff_r, $fn = 30);
}

// Holes drilled through the standoffs for Coral board screws
module coral_holes()
{
    r = (coral_hole_d + 0.2) / 2;   // +0.2 mm clearance
    ox = cx - coral_pat_x / 2;
    oy = cy - coral_pat_y / 2;

    for (x = [0, coral_pat_x])
        for (y = [0, coral_pat_y])
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

module coral_mini_mount()
{
    difference()
    {
        union()
        {
            plate();
            coral_standoffs();
        }
        ctrl_holes();
        coral_holes();
        cam_attach_holes();
    }
}

coral_mini_mount();
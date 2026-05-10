// ESP8266 with 0.96" OLED Case - Base and Cover
// Snap-fit two-part enclosure

/* [Board Dimensions] */
board_w = 62.3;         // X - total board width
board_h = 27.2;         // Y - total board height
board_thickness = 6;    // Z - total height with all components
pcb_thickness = 1.6;    // PCB thickness alone

/* [Case Parameters] */
wall = 1.8;             // wall thickness
floor_t = 1.5;          // base floor thickness
roof_t = 1.5;           // cover roof thickness
clearance = 0.3;        // gap around board edges
post_height = 1.5;      // mounting posts lift PCB off floor

/* [Mounting Holes - distance from board edges to hole center] */
hole_dia = 2.0;         // M2 PCB mounting holes
post_dia = 4.5;         // outer diameter of support posts
pin_dia = 1.8;          // pin that goes into PCB hole
pin_h = 2.5;            // pin height above post
hole_from_left = 2.5;
hole_from_right = 2.5;
hole_from_top = 2.5;
hole_from_bottom = 2.5;

/* [OLED Display Window] */
oled_from_left = 8;             // display window X start from board left
oled_w = 27;                    // display window width
oled_h = 19;                    // display window height
oled_y = (board_h - oled_h) / 2; // centered vertically on board

/* [Button - hangs below board bottom edge, pressed from top] */
button_right_edge_from_right = 29.5; // right side of button connector to board right edge
button_body_w = 18;              // button body width in X direction
button_protrusion = 8.5;          // how far button hangs below board bottom edge (Y)
button_body_h = 6.8;              // button body height (Z, for clearance)
button_x_right = board_w - button_right_edge_from_right; // right edge X on board
button_x_center = button_x_right - button_body_w / 2;   // center X on board
button_hole_dia = 6;              // round hole in cover roof for pressing from top
button_extra_front = button_protrusion + 1; // extra case space at front for button

/* [USB Port - left wall cutout] */
usb_w = 8.5;            // micro-USB width
usb_h = 4;              // micro-USB height

/* [Snap Fit Parameters] */
snap_w = 8;             // length of each snap tab
snap_protrusion = 0.5;  // how far the tab sticks out
snap_thickness = 1.0;   // tab thickness in Z
lip_height = 2.0;       // inner lip on base for cover alignment

/* [LED Hole] */
led_hole_dia = 3.0;     // LED viewing hole diameter
led_from_corner = 6.5;  // distance from board bottom-right corner

/* [Zip Tie Holes] */
zip_hole_dia = 3.5;     // diameter of zip tie hole
zip_corner_inset = 8.0; // how far hole center is from outer corner

/* [Rendering] */
$fn = 50;
explode = 0;            // set > 0 to separate parts for viewing

// === Derived Dimensions ===
case_inner_w = board_w + clearance * 2;
case_inner_h = board_h + clearance * 2 + button_extra_front; // extra front space for button
case_outer_w = case_inner_w + wall * 2;
case_outer_h = case_inner_h + wall * 2;

// Z split: base holds board on posts, cover clears top of components
// Base interior height: post + full board thickness + small gap
base_interior_z = post_height + board_thickness + 0.5;
// Cover drops down with a lip that fits inside base walls
cover_lip_z = lip_height;

base_total_z = floor_t + base_interior_z;
cover_total_z = roof_t + cover_lip_z;

// Board origin offset inside the case (from inner bottom-left corner)
board_ox = wall + clearance;
board_oy = wall + clearance + button_extra_front; // board shifted back to make room for button
board_oz = floor_t + post_height;

// Button center position in case coordinates (for cover hole)
// button_x_center is already the true center of the button assembly
button_case_x = board_ox + button_x_center;
button_case_y = wall + clearance + button_extra_front / 2; // centered in button area

// === MODULES ===

module mounting_post() {
    // Cylindrical post with pin on top
    cylinder(h = post_height, d = post_dia);
    translate([0, 0, post_height])
        cylinder(h = pin_h, d = pin_dia);
}

module base() {
    difference() {
        union() {
            // Main box
            difference() {
                cube([case_outer_w, case_outer_h, base_total_z]);
                translate([wall, wall, floor_t])
                    cube([case_inner_w, case_inner_h, base_total_z]);
            }

            // Inner lip for cover alignment (thin wall inside, at top)
            lip_wall = 1.0;
            translate([wall + clearance/2, wall + clearance/2, base_total_z - lip_height])
                difference() {
                    cube([case_inner_w - clearance, case_inner_h - clearance, lip_height]);
                    translate([lip_wall, lip_wall, -0.1])
                        cube([case_inner_w - clearance - lip_wall*2,
                              case_inner_h - clearance - lip_wall*2,
                              lip_height + 0.2]);
                }

            // 4 mounting posts
            translate([board_ox, board_oy, floor_t]) {
                translate([hole_from_left, hole_from_bottom, 0]) mounting_post();
                translate([hole_from_left, board_h - hole_from_top, 0]) mounting_post();
                translate([board_w - hole_from_right, hole_from_bottom, 0]) mounting_post();
                translate([board_w - hole_from_right, board_h - hole_from_top, 0]) mounting_post();
            }

            // Snap tabs on long walls (outside, near top)
            snap_z = base_total_z - snap_thickness - 0.5;
            // Front wall (Y=0 side)
            translate([case_outer_w/2 - snap_w/2, -snap_protrusion, snap_z])
                cube([snap_w, snap_protrusion, snap_thickness]);
            // Back wall (Y=max side)
            translate([case_outer_w/2 - snap_w/2, case_outer_h, snap_z])
                cube([snap_w, snap_protrusion, snap_thickness]);
            // Right wall (X=max side)
            translate([case_outer_w, case_outer_h/2 - snap_w/2, snap_z])
                cube([snap_protrusion, snap_w, snap_thickness]);

            // Button holding bars (two rails on either side of button body)
            // Aligned with button_case_x (center), rails go full height to top of base walls
            btn_bar_w = 1.2;    // bar thickness in X
            btn_bar_h = base_interior_z/2;  // full internal height (flush with base walls)
            btn_bar_y_start = wall + clearance + 0.5;
            btn_bar_y_len = button_extra_front - 1;
            // Left bar (left edge of button body = button_x_center - button_body_w/2)
            translate([board_ox + button_x_center - button_body_w/2 - btn_bar_w - 0.3, btn_bar_y_start, floor_t])
                cube([btn_bar_w, btn_bar_y_len, btn_bar_h]);
            // Right bar (right edge of button body = button_x_center + button_body_w/2)
            translate([board_ox + button_x_center + button_body_w/2 + 0.3, btn_bar_y_start, floor_t])
                cube([btn_bar_w, btn_bar_y_len, btn_bar_h]);
        }

        // USB port cutout (left wall, centered vertically on board)
        usb_z = board_oz + pcb_thickness/2 - usb_h/2;
        translate([-0.1, board_oy + board_h/2 - usb_w/2, usb_z])
            cube([wall + 0.2, usb_w, usb_h]);

        // Zip tie holes - one near each corner
        for (cx = [zip_corner_inset, case_outer_w - zip_corner_inset])
            for (cy = [zip_corner_inset, case_outer_h - zip_corner_inset])
                translate([cx, cy, -0.1])
                    cylinder(h = floor_t + 0.2, d = zip_hole_dia);
    }
}

module cover() {
    // Cover wraps OVER the base walls. 
    // Inner cavity must be slightly larger than base outer dimensions.
    cover_gap = 0.2;  // clearance between cover inner and base outer
    cover_inner_w = case_outer_w + cover_gap * 2;
    cover_inner_h = case_outer_h + cover_gap * 2;
    cover_outer_w = cover_inner_w + wall * 2;
    cover_outer_h = cover_inner_h + wall * 2;
    skirt_h = lip_height + 1;  // how far skirt drops down over base walls

    // Cover origin offset from base origin
    ox = (cover_outer_w - case_outer_w) / 2;
    oy = (cover_outer_h - case_outer_h) / 2;

    translate([-ox, -oy, base_total_z - skirt_h + explode]) {
        difference() {
            union() {
                // Skirt walls
                difference() {
                    cube([cover_outer_w, cover_outer_h, skirt_h]);
                    translate([wall, wall, -0.1])
                        cube([cover_inner_w, cover_inner_h, skirt_h + 0.2]);
                }
                // Roof plate on top
                translate([0, 0, skirt_h])
                    cube([cover_outer_w, cover_outer_h, roof_t]);
            }

            // OLED window cutout through roof
            oled_abs_x = ox + board_ox + oled_from_left;
            oled_abs_y = oy + board_oy + oled_y;
            roof_z = skirt_h;
            translate([oled_abs_x, oled_abs_y, roof_z - 0.1])
                cube([oled_w, oled_h, roof_t + 0.2]);

            // Button press hole through cover roof (top-down access)
            btn_cover_x = ox + button_case_x;
            btn_cover_y = oy + button_case_y;
            translate([btn_cover_x, btn_cover_y, roof_z - 0.1])
                cylinder(h = roof_t + 0.2, d = button_hole_dia);

            // Snap grooves on inner skirt walls to catch base tabs
            groove_z = skirt_h - snap_thickness - 0.5;
            // Front groove (Y=0 inner wall)
            translate([cover_outer_w/2 - snap_w/2 - 0.1, wall - 0.1, groove_z])
                cube([snap_w + 0.2, snap_protrusion + 0.3, snap_thickness + 0.3]);
            // Back groove (Y=max inner wall)
            translate([cover_outer_w/2 - snap_w/2 - 0.1, cover_outer_h - wall - snap_protrusion - 0.1, groove_z])
                cube([snap_w + 0.2, snap_protrusion + 0.3, snap_thickness + 0.3]);
            // Right groove (X=max inner wall)
            translate([cover_outer_w - wall - snap_protrusion - 0.1, cover_outer_h/2 - snap_w/2 - 0.1, groove_z])
                cube([snap_protrusion + 0.3, snap_w + 0.2, snap_thickness + 0.3]);

            // LED hole through cover roof (bottom-right of board)
            led_cover_x = ox + board_ox + board_w - led_from_corner;
            led_cover_y = oy + board_oy + led_from_corner;
            translate([led_cover_x, led_cover_y, roof_z - 0.1])
                cylinder(h = roof_t + 0.2, d = led_hole_dia);

            // USB clearance in cover skirt (left side)
            translate([-0.1, oy + board_oy + board_h/2 - usb_w/2 - 0.5, -0.1])
                cube([wall + 0.2, usb_w + 1, skirt_h + roof_t + 0.2]);
        }
    }
}

// === ASSEMBLY ===
// Both parts shown together (use explode > 0 to separate)
color("SteelBlue", 0.85) base();
color("Orange", 0.7) cover();

// === FOR 3D PRINTING ===
// Uncomment ONE of these and comment out the assembly above:

// Print base (as-is, open side up):
//base();

// Print cover (flipped, roof on print bed):
// translate([0, case_outer_h + 10, cover_total_z + lip_height])
//     rotate([180, 0, 0]) cover();

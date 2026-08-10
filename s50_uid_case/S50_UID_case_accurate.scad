/*
 S50 UID key-fob case — dimensioned from the supplied product image

 TAG nominal dimensions:
   overall plastic: 32.0 W × 41.0 H × 4.0 T mm
   main lower body: ~32 mm diameter
   top key-ring slot: ~6.3 × 3.4 mm

 This version uses a much closer S50 silhouette:
   - true 32 mm circular lower body
   - curved/tapered shoulders
   - rounded top tab
   - correctly positioned rounded key-ring slot
   - separate back + snap-on front cover

 Print:
   back  : flat, cavity facing upward
   front : flat, outside face on the build plate

 Set PART to "back", "front", or "both".
*/

$fn = 96;

// ===================== USER PARAMETERS =====================

PART = "both";       // "back", "front", "both"

// Measured tag
TAG_W = 32.0;
TAG_H = 41.0;
TAG_T = 4.0;

// Fit
CLEARANCE = 0.30;    // FDM: 0.25–0.40, resin: 0.15–0.25

// Case construction
BACK_WALL = 1.20;
SIDE_WALL = 1.35;
FRONT_WALL = 1.20;

// Front cover overlap
LID_OVERLAP = 1.00;

// Front face opening.
// The original S50 has a large circular face; this leaves a protective
// rim around that area.
FACE_OPENING_D = 27.2;
FACE_OPENING_Y = 24.0;

// Key-ring slot from the reference image
SLOT_W = 6.3;
SLOT_H = 3.4;
SLOT_Y = 4.0;

// Decorative holes are included in the lid as shallow openings.
// Set false if you don't want them.
KEEP_DECORATIVE_SLOTS = true;

// Snap-fit settings
SNAP_DEPTH = 1.0;
SNAP_HEIGHT = 1.5;
SNAP_CLEARANCE = 0.18;

// ===================== S50 SILHOUETTE =====================

// Coordinate system:
//   x = left/right, center = 0
//   y = top = 0, bottom = 41
//
// The lower section is a genuine 32 mm circle centered at y=25.
// The upper section is formed with sampled cubic curves to closely
// reproduce the tapered S50 shoulder visible in the reference.

function bezier(p0,p1,p2,p3,t) =
    let(u=1-t)
    [
        u*u*u*p0[0] + 3*u*u*t*p1[0] + 3*u*t*t*p2[0] + t*t*t*p3[0],
        u*u*u*p0[1] + 3*u*u*t*p1[1] + 3*u*t*t*p2[1] + t*t*t*p3[1]
    ];

// Left shoulder, top -> side of circular body
function left_curve(n=14) =
    [
        for (i=[0:n])
            bezier(
                [0,0],
                [-7.0,0.0],
                [-9.5,6.0],
                [-13.5,14.0],
                i/n
            ),
        for (i=[1:n])
            bezier(
                [-13.5,14.0],
                [-15.0,17.0],
                [-16.0,20.5],
                [-16.0,25.0],
                i/n
            )
    ];

// Mirror the left side
function right_curve(n=14) =
    [
        for (i=[0:n])
            let(p=bezier(
                [0,0],
                [-7.0,0.0],
                [-9.5,6.0],
                [-13.5,14.0],
                i/n))
            [-p[0],p[1]],
        for (i=[1:n])
            let(p=bezier(
                [-13.5,14.0],
                [-15.0,17.0],
                [-16.0,20.5],
                [-16.0,25.0],
                i/n))
            [-p[0],p[1]]
    ];

// Make the upper profile plus the circular lower body.
// The circular body is deliberately 32 mm diameter.
module s50_outline_2d(extra=0) {
    // extra is an outward offset approximation.
    // offset() gives a true uniform offset around the complete shape.
    offset(delta=extra)
        union() {
            // Main 32 mm circular body.
            translate([0,25])
                circle(d=TAG_W);

            // Upper tapered tab.
            polygon(
                concat(
                    left_curve(),
                    // right side is traversed from body back to top
                    [for (i=[len(right_curve())-1:-1:0]) right_curve()[i]],
                    [[0,0]]
                )
            );
        }
}

// Rounded slot
module rounded_slot(w,h,r,z0=-1,hz=10) {
    linear_extrude(height=hz)
        offset(r=r)
            square([w-2*r,h-2*r], center=true);
}

// ===================== DECORATIVE SLOTS =====================

// Positions estimated from the supplied image.
module decorative_slots(z0=-1,hz=10) {
    // left
    translate([-10.0,9.5,z0])
        rotate(18)
            rounded_slot(2.2,5.5,1.0,z0,hz);

    // right
    translate([10.0,9.5,z0])
        rotate(-18)
            rounded_slot(2.2,5.5,1.0,z0,hz);
}

// ===================== BACK SHELL =====================

module back_shell() {
    outer_extra = SIDE_WALL + CLEARANCE;
    cavity_extra = CLEARANCE;

    difference() {
        // Outer shell
        linear_extrude(height=BACK_WALL + TAG_T + 0.35)
            s50_outline_2d(outer_extra);

        // Tag cavity
        translate([0,0,BACK_WALL])
            linear_extrude(height=TAG_T + 0.6)
                s50_outline_2d(cavity_extra);

        // Key-ring slot
        translate([0,SLOT_Y, -0.2])
            rounded_slot(SLOT_W,SLOT_H,SLOT_H/2,-0.2,3.0);
    }

    // Snap receiver groove around the perimeter.
    // A continuous shallow ledge is easier to print than tiny clips.
    difference() {
        translate([0,0,BACK_WALL + TAG_T + 0.10])
            linear_extrude(height=0.9)
                s50_outline_2d(SIDE_WALL + CLEARANCE + 0.35);

        translate([0,0,BACK_WALL + TAG_T - 0.05])
            linear_extrude(height=1.2)
                s50_outline_2d(SIDE_WALL + CLEARANCE - 0.25);
    }
}

// ===================== FRONT LID =====================
module front_lid() {
    outer_extra = SIDE_WALL + CLEARANCE;

    // 乐高凸粒参数
    LEGO_STUD_DIAMETER = 4.8;
    LEGO_STUD_HEIGHT = 1.8;
    LEGO_STUD_PITCH = 8.0;

    // Overall lid plate
    difference() {
        linear_extrude(height=FRONT_WALL)
            s50_outline_2d(outer_extra);

        // Key-ring slot
        translate([0,SLOT_Y,-0.2])
            rounded_slot(SLOT_W,SLOT_H,SLOT_H/2,-0.2,2.0);

        // Optional decorative openings
        if (KEEP_DECORATIVE_SLOTS)
            decorative_slots(-0.2,2.0);
    }

    // 两个乐高凸粒
    translate([-LEGO_STUD_PITCH/2, TAG_H/2, FRONT_WALL])
        cylinder(d=LEGO_STUD_DIAMETER, h=LEGO_STUD_HEIGHT, $fn=48);
    translate([LEGO_STUD_PITCH/2, TAG_H/2, FRONT_WALL])
        cylinder(d=LEGO_STUD_DIAMETER, h=LEGO_STUD_HEIGHT, $fn=48);

    // Rear locating lip
    difference() {
        translate([0,0,-SNAP_HEIGHT])
            linear_extrude(height=SNAP_HEIGHT)
                s50_outline_2d(SIDE_WALL + CLEARANCE - SNAP_CLEARANCE);

        translate([0,0,-SNAP_HEIGHT-0.1])
            linear_extrude(height=SNAP_HEIGHT+0.2)
                s50_outline_2d(SIDE_WALL + CLEARANCE - SNAP_CLEARANCE - 1.1);

        translate([0,SLOT_Y,0])
            rounded_slot(SLOT_W+2.0,SLOT_H+1.0,SLOT_H/2,-SNAP_HEIGHT-0.2,SNAP_HEIGHT+0.5);
    }
}

// ===================== OUTPUT =====================

if (PART == "back") {
    back_shell();
}
else if (PART == "front") {
    front_lid();
}
else {
    // Side-by-side printable arrangement
    translate([-24,0,0])
        back_shell();

    translate([24,0,FRONT_WALL])
        rotate([180,0,0])
            front_lid();
}

// ===================== NOTES =====================
//
// Approximate finished external dimensions:
//   ~34.7 mm wide
//   ~43.7 mm high
//   ~6.7 mm total thickness
//
// The reference photo is perspective-distorted, so the exact original
// CAD contour cannot be recovered from the photograph alone. The 32 mm
// width, 41 mm height and 4 mm thickness are retained exactly; the
// circular lower body, shoulder curvature and key-ring slot are fitted
// to the proportions visible in the supplied image.
//
// If your actual S50 measures slightly differently, change only:
//   TAG_W, TAG_H, TAG_T, SLOT_W, SLOT_H, SLOT_Y
//

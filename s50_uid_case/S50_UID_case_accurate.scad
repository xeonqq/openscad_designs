/*
 S50 UID key-fob case
 --------------------

 PART:
   "back"      = back shell only
   "front"     = front cover only
   "both"      = assembled visualization
   "exploded"  = exploded visualization

 The front cover has a down-turned skirt that wraps around the
 OUTSIDE of the back shell's wall (bottle-cap style) and snaps
 onto a ridge molded into that wall.

 Coordinate system:
   X = left/right
   Y = top -> bottom
   Z = thickness

 Tag:
   32 x 41 x 4 mm
*/

$fn = 96;


// ============================================================
// USER PARAMETERS
// ============================================================

PART = "front";

// Original tag dimensions
TAG_W = 32.0;
TAG_H = 41.0;
TAG_T = 4.0;

// FDM clearance
CLEARANCE = 0.30;

// Shell
BACK_WALL  = 1.20;
SIDE_WALL  = 1.35;
FRONT_WALL = 1.20;

// ------------------------------------------------------------
// SNAP FIT (bottle-cap style: skirt wraps OVER the back wall)
// ------------------------------------------------------------
// The front cover no longer tries to insert INSIDE the tag
// cavity (that space is only CLEARANCE wide and already fully
// occupied by the back shell's own SIDE_WALL). Instead, like
// esp8266_with_oled_case.scad, the front has a down-turned
// skirt that wraps around the OUTSIDE of the back shell's
// outer wall, with a snap ridge/groove to hold it on.

// Radial clearance between the skirt's inner bore and the back wall's outer face
SKIRT_CLEARANCE = 0.25;

// Wall thickness of the front cover's down-turned skirt
SKIRT_WALL = 1.0;

// How far the skirt drops down over the back shell's outer wall
SKIRT_HEIGHT = 3.0;

// Continuous snap ridge molded onto the back shell's outer wall
RIDGE_BUMP = 0.40;     // how far the ridge sticks out radially
RIDGE_HEIGHT = 1.20;   // height (Z) of the ridge band
RIDGE_FROM_TOP = 1.40; // distance down from the top of the back wall to the ridge

// Extra clearance in the mating groove so the ridge can seat without a tight press
GROOVE_CLEARANCE = 0.15;


// ============================================================
// FRONT FEATURES
// ============================================================

FACE_OPENING_D = 27.2;
FACE_OPENING_Y = 24.0;

SLOT_W = 6.3;
SLOT_H = 3.4;
SLOT_Y = 4.0;

KEEP_DECORATIVE_SLOTS = true;


// ============================================================
// LEGO STUDS
// ============================================================

LEGO_STUD_DIAMETER = 4.8;
LEGO_STUD_HEIGHT   = 1.8;
LEGO_STUD_PITCH    = 8.0;


// ============================================================
// BEZIER
// ============================================================

function bezier(p0,p1,p2,p3,t) =
    let(u = 1-t)
    [
        u*u*u*p0[0] +
        3*u*u*t*p1[0] +
        3*u*t*t*p2[0] +
        t*t*t*p3[0],

        u*u*u*p0[1] +
        3*u*u*t*p1[1] +
        3*u*t*t*p2[1] +
        t*t*t*p3[1]
    ];


// ============================================================
// S50 OUTLINE
// ============================================================

function left_curve(n=16) =
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


function right_curve(n=16) =
[
    for (i=[0:n])
        let(
            p = bezier(
                [0,0],
                [-7.0,0.0],
                [-9.5,6.0],
                [-13.5,14.0],
                i/n
            )
        )
        [-p[0],p[1]],

    for (i=[1:n])
        let(
            p = bezier(
                [-13.5,14.0],
                [-15.0,17.0],
                [-16.0,20.5],
                [-16.0,25.0],
                i/n
            )
        )
        [-p[0],p[1]]
];


// ============================================================
// MAIN S50 SHAPE
// ============================================================

module s50_outline_2d(extra=0)
{
    offset(delta=extra)
    union()
    {
        // Genuine 32 mm circular lower body
        translate([0,25])
            circle(d=TAG_W);

        // Upper tab / shoulder
        polygon(
            concat(
                left_curve(),
                [
                    for (
                        i=[len(right_curve())-1:-1:0]
                    )
                        right_curve()[i]
                ],
                [[0,0]]
            )
        );
    }
}


// ============================================================
// ROUNDED SLOT
// ============================================================

module rounded_slot(w,h,r)
{
    hull()
    {
        translate([
            -w/2+r,
            -h/2+r
        ])
            circle(r=r);

        translate([
            w/2-r,
            -h/2+r
        ])
            circle(r=r);

        translate([
            -w/2+r,
            h/2-r
        ])
            circle(r=r);

        translate([
            w/2-r,
            h/2-r
        ])
            circle(r=r);
    }
}


// ============================================================
// DECORATIVE SLOTS
// ============================================================

module decorative_slots()
{
    translate([-10.0,9.5])
        rotate(18)
            rounded_slot(2.2,5.5,1.0);

    translate([10.0,9.5])
        rotate(-18)
            rounded_slot(2.2,5.5,1.0);
}


// ============================================================
// BACK SHELL
// ============================================================

module back_shell()
{
    /*
       Outer dimensions:

       TAG_W + 2*(SIDE_WALL+CLEARANCE)

       = 32 + 2*(1.35+0.30)
       = 35.3 mm

       This is the actual outside shell.
    */

    OUTER_EXTRA =
        SIDE_WALL + CLEARANCE;

    CAVITY_EXTRA =
        CLEARANCE;


    difference()
    {
        // ----------------------------------------------------
        // Main outer shell
        // ----------------------------------------------------

        linear_extrude(
            height=BACK_WALL + TAG_T + 0.35
        )
            s50_outline_2d(OUTER_EXTRA);


        // ----------------------------------------------------
        // Tag cavity
        // ----------------------------------------------------

        translate([0,0,BACK_WALL])
            linear_extrude(
                height=TAG_T + 0.8
            )
                s50_outline_2d(CAVITY_EXTRA);


        // ----------------------------------------------------
        // Key ring opening
        // ----------------------------------------------------

        translate([0,SLOT_Y,-0.5])
            linear_extrude(height=3.0)
                rounded_slot(
                    SLOT_W,
                    SLOT_H,
                    SLOT_H/2
                );
    }


    // ========================================================
    // OUTER SNAP RIDGE
    // ========================================================

    /*
       A thin ridge running around the OUTSIDE of the back wall,
       near its top edge. The front cover's skirt wraps over the
       wall and its inner groove catches on this ridge, the same
       way a bottle cap snaps onto a bottle.
    */

    back_total_h = BACK_WALL + TAG_T + 0.35;

    difference()
    {
        translate([
            0,
            0,
            back_total_h - RIDGE_FROM_TOP - RIDGE_HEIGHT
        ])
            linear_extrude(height=RIDGE_HEIGHT)
                s50_outline_2d(OUTER_EXTRA + RIDGE_BUMP);

        translate([
            0,
            0,
            back_total_h - RIDGE_FROM_TOP - RIDGE_HEIGHT - 0.1
        ])
            linear_extrude(height=RIDGE_HEIGHT + 0.2)
                s50_outline_2d(OUTER_EXTRA);


        // Keep key-ring opening clear
        translate([0,SLOT_Y,-0.2])
            linear_extrude(height=back_total_h + 0.5)
                rounded_slot(
                    SLOT_W + 2.0,
                    SLOT_H + 1.0,
                    SLOT_H/2
                );
    }
}


// ============================================================
// FRONT COVER
// ============================================================

module front_lid()
{
    /*
       Same OUTER_EXTRA as back_shell()'s own outer wall, so the
       skirt below tracks the back wall exactly.
    */
    OUTER_EXTRA = SIDE_WALL + CLEARANCE;

    // Outer edge of the lid, flush with the outside of the skirt
    PLATE_EXTRA = OUTER_EXTRA + SKIRT_CLEARANCE + SKIRT_WALL;


    // ========================================================
    // TOP PLATE
    // ========================================================

    difference()
    {
        linear_extrude(height=FRONT_WALL)
            s50_outline_2d(PLATE_EXTRA);


        // Key-ring hole
        translate([0,SLOT_Y,-0.5])
            linear_extrude(height=FRONT_WALL+1.0)
                rounded_slot(
                    SLOT_W,
                    SLOT_H,
                    SLOT_H/2
                );


        // Decorative holes
        if (KEEP_DECORATIVE_SLOTS)
        {
            translate([0,0,-0.5])
                linear_extrude(height=FRONT_WALL+1.0)
                    decorative_slots();
        }
    }


    // ========================================================
    // DOWN-TURNED SKIRT (bottle-cap style, wraps the OUTSIDE
    // of the back shell's wall instead of inserting inside it)
    // ========================================================

    difference()
    {
        translate([0,0,-SKIRT_HEIGHT])
            linear_extrude(height=SKIRT_HEIGHT)
                s50_outline_2d(PLATE_EXTRA);

        // Hollow out the skirt down to the clearance gap around the back wall
        translate([0,0,-SKIRT_HEIGHT-0.1])
            linear_extrude(height=SKIRT_HEIGHT+0.2)
                s50_outline_2d(OUTER_EXTRA + SKIRT_CLEARANCE);

        // Snap groove: locally widen the bore so the back wall's
        // ridge can pop in and seat (skirt must flex slightly to
        // get past the ridge on the way down)
        translate([
            0,
            0,
            -RIDGE_FROM_TOP - RIDGE_HEIGHT - GROOVE_CLEARANCE
        ])
            linear_extrude(height=RIDGE_HEIGHT + 2*GROOVE_CLEARANCE)
                s50_outline_2d(OUTER_EXTRA + RIDGE_BUMP + GROOVE_CLEARANCE);

        // Don't block key-ring slot
        translate([
            0,
            SLOT_Y,
            -SKIRT_HEIGHT-0.2
        ])
            linear_extrude(
                height=SKIRT_HEIGHT+0.5
            )
                rounded_slot(
                    SLOT_W + 2.0,
                    SLOT_H + 1.0,
                    SLOT_H/2
                );
    }


    // ========================================================
    // LEGO STUDS
    // ========================================================

    /*
       Outside face of the front cover.

       Studs are at Y = 20.5 mm, which puts them around the
       center of the 41 mm tag rather than at Y=41.
    */

    translate([
        -LEGO_STUD_PITCH/2,
        TAG_H/2,
        FRONT_WALL
    ])
        cylinder(
            d=LEGO_STUD_DIAMETER,
            h=LEGO_STUD_HEIGHT,
            $fn=48
        );


    translate([
        LEGO_STUD_PITCH/2,
        TAG_H/2,
        FRONT_WALL
    ])
        cylinder(
            d=LEGO_STUD_DIAMETER,
            h=LEGO_STUD_HEIGHT,
            $fn=48
        );
}


// ============================================================
// ASSEMBLED MODEL
// ============================================================

module assembled()
{
    /*
       Back is placed at Z=0, total height BACK_WALL+TAG_T+0.35.

       Front cover sits on top of the back wall's top edge, its
       skirt dropping down by SKIRT_HEIGHT to wrap over the wall
       and snap onto the ridge.
    */

    back_shell();

    translate([
        0,
        0,
        BACK_WALL + TAG_T + 0.35
    ])
        front_lid();
}


// ============================================================
// EXPLODED VIEW
// ============================================================

module exploded()
{
    back_shell();

    translate([
        45,
        0,
        3
    ])
        front_lid();
}


// ============================================================
// OUTPUT
// ============================================================

if (PART == "back")
{
    back_shell();
}
else if (PART == "front")
{
    front_lid();
}
else if (PART == "both")
{
    assembled();
}
else if (PART == "exploded")
{
    exploded();
}
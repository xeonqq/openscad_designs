/*
 S50 UID key-fob case
 --------------------

 PART:
   "back"      = back shell only
   "front"     = front cover only
   "both"      = assembled visualization
   "exploded"  = exploded visualization

 The front cover is intentionally slightly larger than the back shell.
 The snap ring is sized to enter the inside of the back shell.

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
// SNAP FIT
// ------------------------------------------------------------

// Radial clearance between male snap and female receiver
SNAP_CLEARANCE = 0.25;

// Height of male snap ring
SNAP_HEIGHT = 1.50;

// Width of male snap ring
SNAP_RING_WIDTH = 0.80;

// Width of female receiver ledge
RECEIVER_WIDTH = 0.80;

// Extra overlap of front cover over back shell
FRONT_OVERHANG = 0.30;


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
    // FEMALE SNAP RECEIVER
    // ========================================================

    /*
       The receiver is an inward-facing annular ledge.

       The important change compared with your old design is
       that the receiver is defined relative to the INNER
       cavity boundary instead of trying to make a groove from
       two arbitrary offsets.
    */

    receiver_outer =
        SIDE_WALL + CLEARANCE - SNAP_CLEARANCE;

    receiver_inner =
        receiver_outer - RECEIVER_WIDTH;


    difference()
    {
        translate([
            0,
            0,
            BACK_WALL + TAG_T - 0.05
        ])
            linear_extrude(height=0.75)
                s50_outline_2d(receiver_outer);

        translate([
            0,
            0,
            BACK_WALL + TAG_T - 0.10
        ])
            linear_extrude(height=1.0)
                s50_outline_2d(receiver_inner);


        // Keep key-ring opening clear
        translate([0,SLOT_Y,-0.2])
            linear_extrude(height=1.5)
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
       The front plate is deliberately slightly larger than
       the back shell.

       This prevents the front from looking recessed and also
       gives a small external overlap.
    */

    FRONT_EXTRA =
        SIDE_WALL +
        CLEARANCE +
        FRONT_OVERHANG;


    // ========================================================
    // MAIN COVER
    // ========================================================

    difference()
    {
        linear_extrude(height=FRONT_WALL)
            s50_outline_2d(FRONT_EXTRA);


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
    // MALE SNAP RING
    // ========================================================

    /*
       This is the critical part.

       It is located on the INNER side of the front cover.

       The ring enters the inside of the back shell and catches
       under the receiver ledge.
    */

    MALE_OUTER =
        SIDE_WALL +
        CLEARANCE -
        SNAP_CLEARANCE;

    MALE_INNER =
        MALE_OUTER -
        SNAP_RING_WIDTH;


    difference()
    {
        translate([
            0,
            0,
            -SNAP_HEIGHT
        ])
            linear_extrude(height=SNAP_HEIGHT)
                s50_outline_2d(MALE_OUTER);

        translate([
            0,
            0,
            -SNAP_HEIGHT-0.1
        ])
            linear_extrude(height=SNAP_HEIGHT+0.2)
                s50_outline_2d(MALE_INNER);


        // Don't block key-ring slot
        translate([
            0,
            SLOT_Y,
            -SNAP_HEIGHT-0.2
        ])
            linear_extrude(
                height=SNAP_HEIGHT+0.5
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
       Back is placed at Z=0.

       Back shell total height:
         1.2 + 4.0 + 0.35 = 5.55 mm

       Front cover is positioned so that its male snap ring
       enters the back shell.

       The outside face remains visible.
    */

    back_shell();

    translate([
        0,
        0,
        BACK_WALL + TAG_T + 0.10
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
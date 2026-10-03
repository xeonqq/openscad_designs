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
// SNAP FIT (discrete tabs, same idea as esp8266_with_oled_case.scad)
// ------------------------------------------------------------
// The front cover no longer tries to insert INSIDE the tag
// cavity (that space is only CLEARANCE wide and already fully
// occupied by the back shell's own SIDE_WALL). Instead, like
// esp8266_with_oled_case.scad, the front has a down-turned
// skirt that wraps around the OUTSIDE of the back shell's
// outer wall, and a few discrete snap tabs click the two
// halves together (rather than one continuous ring, which
// would need the whole skirt to flex at once).

// Radial clearance between the skirt's inner bore and the back wall's outer face
SKIRT_CLEARANCE = 0.25;

// Wall thickness of the front cover's down-turned skirt
SKIRT_WALL = 1.0;

// How far the skirt drops down over the back shell's outer wall
SKIRT_HEIGHT = 3.0;

// Tabs are placed around the circular body (0=right, 90=top, 180=left),
// away from the key-ring slot near the bottom of the tag
TAB_ANGLES = [0, 90, 180];

TAB_WIDTH     = 8.0;  // tangential width of each tab
TAB_BUMP      = 0.40; // how far each tab sticks out radially
TAB_HEIGHT    = 1.60; // Z height of each tab
TAB_FROM_TOP  = 0.60; // distance down from the top of the back wall to the tabs
TAB_CLEARANCE = 0.12; // extra clearance in the matching groove
RELIEF_SLIT_W = 0.7;  // width of the flex slits cut beside each tab in the skirt
RELIEF_SLIT_HEIGHT = 2.0; // vertical height of each flex slit


// ============================================================
// FRONT FEATURES
// ============================================================

FACE_OPENING_D = 27.2;
FACE_OPENING_Y = 24.0;

SLOT_W = 6.3;
SLOT_H = 3.4;
SLOT_Y = 4.0;

KEEP_DECORATIVE_SLOTS = false;


// ============================================================
// LEGO STUDS
// ============================================================

LEGO_STUD_DIAMETER = 4.9;
LEGO_STUD_HEIGHT   = 1.8;
LEGO_STUD_PITCH    = 8.0;

// Hollow cylinder alternative
CENTER_FEATURE = "cylinder";  // "lego" or "cylinder"

CYLINDER_D      = 18.5;
CYLINDER_WALL   = 1.2;
CYLINDER_HEIGHT = 2.0;


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
// SNAP TAB (male bump on the back wall / female groove in the skirt)
// ============================================================

/*
   theta places the tab around the circular body (which is a
   true circle of radius TAG_W/2+SIDE_WALL+CLEARANCE, centered
   at [0,25]), z is the bottom of the tab band, and clearance=0
   builds the male bump while clearance=TAB_CLEARANCE builds the
   matching oversized female groove.
*/
module snap_tab(theta, z, clearance=0)
{
    R = TAG_W/2 + SIDE_WALL + CLEARANCE;

    x0  = R - 0.4 - clearance;
    len = TAB_BUMP + 0.4 + 2*clearance;
    tw  = TAB_WIDTH + 2*clearance;
    th  = TAB_HEIGHT + 2*clearance;

    translate([0,25,0])
        rotate([0,0,theta])
            translate([x0, -tw/2, z-clearance])
                cube([len, tw, th]);
}


/*
    Two thin slits flanking a tab, cut through part of the
   front skirt only. This turns the skirt into independent
   cantilever fingers at each tab so a finger can flex over its
   own bump without needing the whole closed ring to stretch.
*/
module skirt_relief_cuts(theta)
{
    R = TAG_W/2 + SIDE_WALL + CLEARANCE;
    half_gap = TAB_WIDTH/2 + 0.8;
    len = SKIRT_CLEARANCE + SKIRT_WALL + 1.0;

    translate([0,25,0])
        rotate([0,0,theta])
            for (s = [-1,1])
                translate([R-0.5, s*half_gap - RELIEF_SLIT_W/2, -RELIEF_SLIT_HEIGHT-0.1])
                    cube([len, RELIEF_SLIT_W, RELIEF_SLIT_HEIGHT+0.1]);
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
        if (KEEP_DECORATIVE_SLOTS){
        translate([0,SLOT_Y,-0.5])
            linear_extrude(height=3.0)
                rounded_slot(
                    SLOT_W,
                    SLOT_H,
                    SLOT_H/2
                );
        }
    }


    // ========================================================
    // SNAP TABS (esp8266-style discrete tabs, not a full ring)
    // ========================================================

    /*
       A handful of small tabs on the OUTSIDE of the back wall,
       near its top edge. The front cover's skirt wraps over the
       wall and its matching grooves click onto these tabs.
    */

    back_total_h = BACK_WALL + TAG_T + 0.35;
    tab_z = back_total_h - TAB_FROM_TOP - TAB_HEIGHT;

    for (theta = TAB_ANGLES)
        snap_tab(theta, tab_z);
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
        if (KEEP_DECORATIVE_SLOTS){
        translate([0,SLOT_Y,-0.5])
            linear_extrude(height=FRONT_WALL+1.0)
                rounded_slot(
                    SLOT_W,
                    SLOT_H,
                    SLOT_H/2
                );
        }


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

        // Snap grooves: match the back wall's tabs so the skirt
        // must flex slightly to click over each one
        for (theta = TAB_ANGLES)
            snap_tab(theta, -TAB_FROM_TOP - TAB_HEIGHT, TAB_CLEARANCE);

        // Relief slits: isolate each tab into its own flexible
        // finger instead of requiring the whole closed skirt to stretch
        for (theta = TAB_ANGLES)
            skirt_relief_cuts(theta);

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

       Studs form a 2x2 grid centered at Y = 20.5 mm, which puts
       them around the center of the 41 mm tag rather than at Y=41.
    */

    if (CENTER_FEATURE == "lego")
    {
        for (dx = [-LEGO_STUD_PITCH/2, LEGO_STUD_PITCH/2])
            for (dy = [-LEGO_STUD_PITCH/2, LEGO_STUD_PITCH/2])
                translate([
                    dx,
                    TAG_H/2 + dy,
                    FRONT_WALL
                ])
                    cylinder(
                        d=LEGO_STUD_DIAMETER,
                        h=LEGO_STUD_HEIGHT,
                        $fn=48
                    );
    }
    else if (CENTER_FEATURE == "cylinder")
    {
        difference()
        {
            translate([
                0,
                TAG_H/2,
                FRONT_WALL
            ])
                cylinder(
                    d=CYLINDER_D,
                    h=CYLINDER_HEIGHT,
                    $fn=96
                );

            translate([
                0,
                TAG_H/2,
                FRONT_WALL - 0.1
            ])
                cylinder(
                    d=CYLINDER_D - 2*CYLINDER_WALL,
                    h=CYLINDER_HEIGHT + 0.2,
                    $fn=96
                );
        }
    }
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
color("Orange", 0.7) 
    back_shell();

    translate([
        0,
        0,
        BACK_WALL + TAG_T + 0.35
    ])
    color("SteelBlue", 0.7) 
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
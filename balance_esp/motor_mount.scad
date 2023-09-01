include<../roundedcube.scad>;

thickness=4;
length=139.5;
width=41.4;

module base()
{
    roundedcube([length, width, thickness], radius=1, center=false);
}


distance_two_holes=19.7-3.5;
module four_mounting_screws()
{
    tolerance=0.1;
    screw_r=3.5/2+tolerance;
    screw_cap_depth=1;
    screw_cap_r=9.2/2;
    for (x=[0,distance_two_holes])
    {
        for (y=[0,distance_two_holes])
        {
        translate([x, y, 0]){
            cylinder(h=10, r1=screw_r, r2=screw_r, $fn=30);
            translate([0,0,thickness-screw_cap_depth])
            cylinder(h=screw_cap_depth, r1=screw_cap_r+tolerance, r2=screw_cap_r+tolerance);
        }
        }
    }
    translate([distance_two_holes/2,distance_two_holes/2,0])
    cylinder(h=10, r1=5, r2=5);

}
distance_two_supporting_screws=34.5-3;

module two_supporting_screws()
{
    tolerance=0.1;
    screw_r=3/2+tolerance;
    screw_cap_depth=1;
    screw_cap_r=5.1/2;
    
    for (y=[0,distance_two_supporting_screws])
    {
        translate([0, y, 0]){
            cylinder(h=10, r1=screw_r, r2=screw_r, $fn=30);
            cylinder(h=screw_cap_depth, r1=screw_cap_r+tolerance, r2=screw_cap_r+tolerance);
           }
    }
}

 bl=57.7;
 bw=43;
 bh=3;
module screw(r, cap_r, cap_thick=1, h=20)
{
        cylinder(r1=r,r2=r,h=h);
        cylinder(h=cap_thick, r1=cap_r, r2=cap_r);
}
module esp_motor_driver_board()
{

translate([0,0,bh/2])

    cube([bl+1,bw+1,bh], center=true);

}
module esp_motor_board_screws()
{
        r=3.25/2;
    cap_r=5.2/2;
    dist_edge=3.14;
    translate([bl/2-dist_edge,bw/2-3.1,0])
    screw(r, cap_r);
    translate([bl/2-dist_edge,bw/2-16.6,0])
    screw(r, cap_r);
    
    translate([bl/2-16.3,bw/2-18.5,0])
    screw(r, cap_r);
    
        translate([bl/2-46.8,bw/2-3.1,0])
    screw(r, cap_r);
    
            translate([bl/2-46.8,bw/2-31,0])
    screw(r, cap_r);
}


supporting_screw_distance_to_side_edge=14;
distance_to_side_edge=8;

module base_with_screw_holes(){
difference()
{
    base();
    translate([distance_to_side_edge,(width-distance_two_holes)/2,0])
four_mounting_screws();

translate([length-distance_to_side_edge-distance_two_holes,(width-distance_two_holes)/2,0])
four_mounting_screws();
    
    //supporting 4 screws
    translate([supporting_screw_distance_to_side_edge,(width-distance_two_supporting_screws)/2,0])
two_supporting_screws();

translate([length-supporting_screw_distance_to_side_edge,(width-distance_two_supporting_screws)/2,0])
two_supporting_screws();
}
}

    extended_width=6;
        extended_h=thickness+1.5;
module base_extended(){


union(){
translate([-length/2,-width/2,0])
base_with_screw_holes();

translate([0,0,(extended_h)/2])
roundedcube([bl+extended_width,bw+extended_width,extended_h], r=1,center=true);
}
}


difference()
{
    base_extended();
        translate([0,0,extended_h-bh])
esp_motor_driver_board();
esp_motor_board_screws();
}

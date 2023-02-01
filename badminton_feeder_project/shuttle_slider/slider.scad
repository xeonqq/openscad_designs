include <../screws.scad>;
include <../roundedcube.scad>;
        
        head_d = 28;
        head_height=25;
module shuttle_head()
{
        translate([0,0,head_d/2])
{
        sphere(d=head_d);
    cube_h=head_height-head_d/2;
        cylinder(h=cube_h, r1=head_d/2, r2=head_d/2);
}   
}

    cube_w=60;
slider_angle=50;
    back_thickness=22;

module base()
{
 // w=cube_w*sqrt(2);  
   // translate([-back_thickness,0,0])
        //    cube([back_thickness,cube_w,cube_w]);
    translate([0,cube_w/2,cube_w/2])
rotate([0,-90,0])
linear_extrude(height = back_thickness, center = false, convexity = 10, twist = 0, scale=[1,0.5])
translate([-cube_w/2,-cube_w/2,0])
square([cube_w, cube_w]);
    
translate([0,cube_w/2,0])
mirror([1,0,0]){
rotate([0,-90, 0])
linear_extrude(height = cube_w*cos(slider_angle), center = false, convexity = 10, twist = 0, scale=[0,0])
translate([0,-cube_w/2,0])
square([cube_w, cube_w]);
}
//difference()
//    {
//        cube([cube_w,cube_w,cube_w]);
//    translate([0,-1, cube_w])
//rotate([0,slider_angle,0]) 
//            cube([w,w,w]);
//}
    
}
r=64/2;
shuttle_head_cut_depth=r/2.5;

tolerance=0.2;
    hole_r = (3+tolerance)/2;
screw_z_offset=6;
module slider(){
    rotate([0,slider_angle,0])
    
difference()
{
rotate([0,-slider_angle,0])
base();

translate([40,cube_w/2,cube_w/2+cube_w*cos(slider_angle)-shuttle_head_cut_depth])
rotate([0,-90,0])
cylinder(h = 200, r1=r, r2=r, $fn=360);
    

}
}

//base();
module slider_with_m3_hole()
{
    difference()
    {
        
            slider();

   translate([-back_thickness-1,cube_w/2,screw_z_offset])
rotate([0,90,0])
    cylinder(h=20, r1=hole_r, r2=hole_r, $fn=30); 
        
           translate([-back_thickness-1,cube_w/2,screw_z_offset+10])
rotate([0,90,0])
    cylinder(h=20, r1=hole_r, r2=hole_r, $fn=30); 
        


    insider_hole();
side_slimer();
    }
}

module insider_hole()
{
            h=cube_w/4.5;
    h0=20;
    r=14;
    x_offset=2;
            translate([-x_offset,cube_w/2,h/2+h0]){
linear_extrude(height = h, center = true, convexity = 10, twist = 0, scale=0)
circle(r = r);
            }
                            translate([-x_offset,cube_w/2,h0/2]){

    linear_extrude(height = h0, center = true, convexity = 10, twist = 0, scale=1)
circle(r = r);
    }
}

module side_slimer()
{
    translate([-cube_w/2,cube_w/2-6,0])
    rotate([25+90,0,0])
    cube([cube_w*2, cube_w, 30]);
    
        translate([-cube_w/2,cube_w-cube_w/2+6,0])
    mirror([0,1,0])
        rotate([25+90,0,0])
    cube([cube_w*2, cube_w, 30]);
    }
slider_with_m3_hole();

                 //side_slimer();
       
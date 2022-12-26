include<roundedcube.scad>;
    distance_two_holes = 32/2*sqrt(2);
screw_cap_depth=2;
screw_cap_r=5.5/2;
keep_screw_cylinder=false; //change me

 tilt_support_thickness=4;
   tilt_angle=15;


    length=130;
    width = 45;
 thickness=4;
 
module motor_mounting_holes()
{
tolerance=0.2;
    hole_r = (3+tolerance)/2;
    translate([distance_two_holes/2, distance_two_holes/2])
   cylinder(h=10, r1=5.5, r2=5.5, $fn=30);

    for (x=[0,distance_two_holes])
    {
        for (y=[0,distance_two_holes])
        {
        translate([x, y, 0]){
            cylinder(h=10, r1=hole_r, r2=hole_r, $fn=30);
            cylinder(h=screw_cap_depth, r1=screw_cap_r, r2=screw_cap_r);
        }
        }
    }

 }

module shooter_mount()
{
    roundedcube([length,width, thickness], false, 1,"all");
}


motors_distance=77-1;
offset_from_edge=(length-motors_distance-distance_two_holes)/2;
module shooter_mount_with_holes(){

    difference() // comment out if keep_screw_cylinder is true
{
    shooter_mount();
    offset_from_bar = (width-distance_two_holes)/2;
     z_offset=keep_screw_cylinder?-tilt_support_thickness:0;

    for (i=[0,motors_distance]){
           translate([offset_from_edge+i, offset_from_bar, z_offset])
    motor_mounting_holes(); 
        }
    }
}

box_screw_r = 3/2;
    pad_r = 5;

pad_length = length-pad_r/2;
pad_width = width-pad_r/2;
module box_pad_holes()
{
        for (x=[pad_r/2,pad_length])
    {
        for (y=[pad_r/2,pad_width])
        {
              translate([x, y, 0]){
 
                    cylinder(h=thickness+1, r1=box_screw_r, r2=box_screw_r);

                 if (keep_screw_cylinder){
                  translate([0,0,-10])
                  cylinder(h=20, r1=box_screw_r, r2=box_screw_r);
                     translate([0,0,-tilt_support_thickness])
                  cylinder(h=screw_cap_depth, r1=screw_cap_r, r2=screw_cap_r);

                 }
               }
        }
       }
    
    }

module shooter_mount_with_holes_and_box_pad(){
    for (x=[pad_r/2,pad_length])
    {
        for (y=[pad_r/2,pad_width])
        {
              translate([x, y, 0]){
                  difference()
                  {
                    cylinder(h=thickness, r1=pad_r, r2=pad_r);
                      translate([0,0,-0.1])
                    cylinder(h=thickness+1, r1=box_screw_r, r2=box_screw_r);
                  }
                 if (keep_screw_cylinder){
                  translate([0,0,-10])
                  cylinder(h=20, r1=box_screw_r, r2=box_screw_r);
                     translate([0,0,-tilt_support_thickness])
                  cylinder(h=screw_cap_depth, r1=screw_cap_r, r2=screw_cap_r);

                 }
               }
        }
       }
shooter_mount_with_holes();
   }
   
module pad_on_box_screw_holes()
{
          for (x=[pad_r/2,pad_length])
    {
        for (y=[pad_r/2,pad_width])
        {
              translate([x, y, -0.1]){
                    cylinder(h=thickness+1, r1=box_screw_r, r2=box_screw_r);
                  
                    }
        }
       }
 }
module shooter_mount_final(){
  
   difference(){
   shooter_mount_with_holes_and_box_pad();
    
   
    pad_on_box_screw_holes();
      
       translate([length/2, width/2, 0])
       cylinder(h=10, r1=11, r2=11);
   }
   }
   
shooter_mount_final();
   
   
   
tilt_width=pad_r*1.6+offset_from_edge;
         tilt_support_w = width+pad_r*2;

 module tilt_support(){  

   //rotate([tilt_angle,0,0])
     
 translate([-pad_r/2,-pad_r,-thickness])
roundedcube([tilt_width,tilt_support_w, tilt_support_thickness], false, 1,"all");



 }

screw_on_tilt_support_r=3.5/2;

module tilted_support(){
 union(){
      rotate([tilt_angle,0,0])

 difference()
 {
 
 union(){    
 tilt_support();

 }

     box_pad_holes();
                  
  shooter_mount_final();
     }
 
     difference(){
         union(){
         virtical_support();
     horizontal_support();
         }
          bottom_screw_holes();
     }

 } 
 }
//tilted_support();
     
 support_y_offset=-pad_r/2+tilt_support_w*cos(tilt_angle)-tilt_support_thickness;

 module virtical_support()
 {    
translate([-pad_r/2,support_y_offset ,-3.5])
   roundedcube([tilt_width, tilt_support_thickness,tilt_support_w*sin(tilt_angle)+tilt_support_thickness/2], false, 1,"all");
 }   
   
module horizontal_support(){ 
difference(){
translate([-pad_r/2,-13 ,-5])
   roundedcube([tilt_width,support_y_offset+27, tilt_support_thickness], false, 1,"all");

 translate([-10,-3,-10])
 cube([40,49.6,20]);
} 
}

module bottom_screw_holes(){
          translate([-pad_r/2+tilt_width/2, -7.8, -10])
     cylinder(20, r1=screw_on_tilt_support_r, r2=screw_on_tilt_support_r);
               translate([-pad_r/2+tilt_width/2, 55, -10])
     cylinder(20, r1=screw_on_tilt_support_r, r2=screw_on_tilt_support_r);
}
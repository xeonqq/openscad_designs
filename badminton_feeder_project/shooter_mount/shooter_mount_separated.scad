include<roundedcube.scad>;
    distance_two_holes = 32/2*sqrt(2);
screw_cap_depth=2;
screw_cap_r=5.5/2;
keep_screw_cylinder=false; //change me

 tilt_support_thickness=4;
   tilt_angle=15;

offset_from_edge=16;

    length0=distance_two_holes+offset_from_edge*2;

    length=length0+5;
    width = 45;
 thickness=4;
 
module motor_mounting_holes()
{
tolerance=0.4;
    hole_r = (3+tolerance)/2;
    translate([distance_two_holes/2, distance_two_holes/2])
   cylinder(h=10, r1=5.5+tolerance, r2=5.5+tolerance, $fn=30);

    for (x=[0,distance_two_holes])
    {
        for (y=[0,distance_two_holes])
        {
        translate([x, y, 0]){
            cylinder(h=10, r1=hole_r, r2=hole_r, $fn=30);
            cylinder(h=screw_cap_depth, r1=screw_cap_r+tolerance, r2=screw_cap_r+tolerance);
        }
        }
    }

 }

module shooter_mount()
{
    roundedcube([length,width, thickness], false, 1,"all");
}

motors_distance=77-1.5+50;
module shooter_mount_with_holes(){

    difference() // comment out if keep_screw_cylinder is true
{
    shooter_mount();
    offset_from_bar = (width-distance_two_holes)/2;
     z_offset=keep_screw_cylinder?-tilt_support_thickness:0;
    for (x_offset=[-2:1:2]){
               translate([offset_from_edge+x_offset, offset_from_bar, z_offset])
        motor_mounting_holes(); 
            
        }
    }
}
box_screw_r = 4.2/2;
    pad_r = 6;

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
//      for(i = [-25:1:25])
//       translate([length/2+i, width/2, 0])
//       cylinder(h=10, r1=11, r2=11);
   }
   }

difference()
   {
union(){
shooter_mount_final();
//translate([length0+motors_distance,0,0])
//mirror([1,0,0])   
//shooter_mount_final();
}
connection();
}
h_tolerance = 0.4; //set it to 0 when generating mounts
connection_h = screw_cap_depth+1-h_tolerance;
connection_length=motors_distance-offset_from_edge*2-10;
   echo(connection_length);
connection_w=distance_two_holes*0.7;//+0.8;
module connection(){
translate([distance_two_holes/2+offset_from_edge+motors_distance/2,width/2,connection_h/2])
roundedcube([connection_length, connection_w, connection_h],  true, 1,"all");
       connection_mounting_holes();

}
  module connection_with_holes() {
difference(){
translate([distance_two_holes/2+offset_from_edge+motors_distance/2,width/2,connection_h/2])
roundedcube([connection_length, connection_w, connection_h],  true, 1,"all");
       connection_mounting_holes();
}
}


      l = connection_length+10;
  module connection_with_slider(keep_screw=false) {


difference(){
tolerance=0.1;
    screw_cap_tolerance=0.2;
    hole_r = (3+tolerance)/2;
    echo(connection_h);
    union(){
roundedcube([l, connection_w, connection_h+1.2],  false, 1,"all");
      translate([l-connection_w*0.3,0,0])
      roundedcube([connection_w, connection_w, connection_h/2],  false, 0.2,"all");   
    }
    for (x=[7+10:1:l-15])
    {
        
        translate([x, connection_w/2, 0]){
            cylinder(h=10, r1=hole_r, r2=hole_r, $fn=30);
            cylinder(h=screw_cap_depth, r1=screw_cap_r+screw_cap_tolerance, r2=screw_cap_r+screw_cap_tolerance);
        
        }
    }
  translate([7, connection_w/2, -2])
    cylinder(h=thickness+10, r1=box_screw_r, r2=box_screw_r);
      
        translate([l+connection_w*0.7/2, connection_w/2, -2]){

                      cylinder(h=thickness+10, r1=box_screw_r, r2=box_screw_r);

    }
}

if (keep_screw)
{
       translate([l+connection_w*0.7/2, connection_w/2, -5])

                      cylinder(h=thickness*2, r1=box_screw_r, r2=box_screw_r);
    
}
}

module connection_mounting_holes()
{
tolerance=0.4;
    hole_r = (3+tolerance)/2;
    distance=connection_length-12;
     translate([distance_two_holes/2+offset_from_edge+motors_distance/2,width/2,0])
{
    for (x=[-distance/2,distance/2])
    {
        
        translate([x, 0, 0]){
            cylinder(h=10, r1=hole_r, r2=hole_r, $fn=30);
            cylinder(h=screw_cap_depth, r1=screw_cap_r+tolerance, r2=screw_cap_r+tolerance);
        
        }
    }
}
 }
 
   module connection_with_holes_for_slider_connection() {
       
       translate([l+connection_w/2,0,connection_h/2])
       rotate([0,0,90])
difference()
       {
roundedcube([connection_length, connection_w, connection_h],  true, 1,"all");
    tolerance=0.4;
    hole_r = (3+tolerance)/2;
    distance=connection_length-12;
{
    for (x=[-distance/2,distance/2])
    {
        
        translate([x, 0, -connection_h/2]){
            cylinder(h=10, r1=hole_r, r2=hole_r, $fn=30);
            cylinder(h=screw_cap_depth, r1=screw_cap_r+tolerance, r2=screw_cap_r+tolerance);
        
        }
    }
}
}
}
//difference()
//{ connection_with_holes_for_slider_connection();
//
//translate([0,-connection_w/2,0])
// connection_with_slider(true);
//}

//connection_with_slider();
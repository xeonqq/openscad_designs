include <../screws.scad>;
//include <../servo_mount/servo_mount.scad>;
include <../roundedcube.scad>;
        
        head_d = 28;
        head_height=25;

rack_width=10;
bar_thickness_at_end = 30;
shuttle_lifted_height=42-6;
botton_pad_h = 2;
push_part_h=head_height*0.7;
bar_bottom_thick_section_h= shuttle_lifted_height-botton_pad_h/2 +push_part_h;
narrow_side_w=rack_width/2;
buffer=0.5;
screw_diameter=3 + buffer;

bar_botton_w=10;
module bar(){
linear_extrude(bar_bottom_thick_section_h, scale=[(rack_width+2)/bar_botton_w,bar_thickness_at_end/narrow_side_w])
square([bar_botton_w, rack_width], center=true);
//translate([0,0,1])
roundedcube([15,rack_width,botton_pad_h], center=true);
}

module tray_pusher(){
difference(){
bar();
translate([0,0,-4])
screw_m3();

screw_m3();
    for (i = [5:1:40]){
    translate([0,i,shuttle_lifted_height])
        rotate([15,0,0])
shuttle_head();
    }
    translate([0,-35,shuttle_lifted_height])
    cube([40,40,40], center=true);
        translate([0,37,shuttle_lifted_height-5])
    cube([40,40,40], center=true);
    
    //material_saving_hole();
}
}
module shuttle_head()
{
        translate([0,0,head_d/2])
{
        sphere(d=head_d);
    cube_h=head_height-head_d/2;
        cylinder(h=cube_h, r1=head_d/2, r2=head_d/2);
}   
}

module material_saving_hole(){
hole_r=bar_thickness_at_end/4;
for (i = [0:1:14]){
translate([-20,0,shuttle_lifted_height*0.4+i])
rotate([0,90,0])
cylinder(h=40, r1=hole_r, r2=hole_r);
}
}

    spring_h=21.2;
    spring_d=4.5;
    schrinked_h=11.5;
spring_z_lift=10;
spring_push_cylinder_h=spring_h-schrinked_h;
spring_push_cylinder_d=spring_d+1;
module spring()
{
    cylinder(h=spring_h, r1=spring_d/2, r2=spring_d/2);

}

module mask_cube()
{
    cube_size=40;
        translate([0,0,spring_h-cube_size/2+spring_z_lift])
    cube([cube_size,cube_size,cube_size], center=true);}
    
    
module upper_part(to_substract=false){
difference(){
tray_pusher();
mask_cube();
}
translate([0,0,schrinked_h+spring_z_lift])
    if (to_substract)
    {
cylinder(h=spring_push_cylinder_h, r1=spring_push_cylinder_d/2, r2=spring_push_cylinder_d/2);
    }
        else{
            cylinder(h=spring_push_cylinder_h, r1=spring_d/2, r2=spring_d/2);
            }
for (y=[-9,9]){
    translate([0,y,spring_z_lift])
    if (to_substract)
    {
            translate([0,0,-10])

        cylinder(h=spring_h+10, r1=spring_push_cylinder_d/2, r2=spring_push_cylinder_d/2);

    }else{
spring();
        }
}
}

module lower_part(){
difference(){
intersection()
{
    tray_pusher();
    mask_cube();
    }
    upper_part(true);
    translate([0,0,spring_z_lift])
    cylinder(h=spring_h, r1=(spring_push_cylinder_d)/2, r2=(spring_push_cylinder_d)/2);

translate([0,-20,-10])
rotate([-45,0,0])
cylinder(h=30,r1=1,r2=1);
}
}
//lower_part();

module upper_part_with_hole(){
difference(){
upper_part();
translate([0,0,20])
cylinder(h=30,r1=1,r2=1);
translate([0,0,shuttle_lifted_height-2])
cylinder(h=2,r1=2, r2=2);
}
}
//translate([0,0,10])
upper_part_with_hole();

module hook(){
difference(){
 cylinder(h=1.8,r1=1.5, r2=1.5);
translate([0,0,1.8-0.5])
cylinder(h=0.5, r1=0.5, r2=0.5);
    cylinder(h=0.5, r1=0.5, r2=0.5);
    
    translate([0,0.7,-1])
cylinder(h=10,r1=0.3, r2=0.3);
translate([0,-0.7,-1])
cylinder(h=10,r1=0.3, r2=0.3);

}
}
//hook();

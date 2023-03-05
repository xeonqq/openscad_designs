tolerance=0.5;
shell_d = 69.5-tolerance;
shell_h=12;
fn=180;
module shell()
{

cylinder(r=shell_d/2, h=shell_h, center=true, $fn=fn);  
 }
 
 module cap_extend()
{
extended=1.5;
    thickness=1.5;
        translate([0,0,thickness/2])
cylinder(r=shell_d/2+extended, h=thickness, center=true, $fn=fn);  
 }

wall_thickness=1.2;
module inter_cylinder()
{
    badminton_diameter=64;
cylinder(r=(badminton_diameter)/2, h=shell_h, center=true, $fn=fn);  
 }

module cylinder_open()
{
    opening_d=60;
cylinder(r=opening_d/2, h=shell_h*2, center=true, $fn=fn);  
}

difference()
{
    translate([0,0,-shell_h/2])
        cap_extend();
        translate([0,0,-0.1])
        shell();

}
difference(){
    
    shell();
    
   // translate([0,0,wall_thickness])
    inter_cylinder();
    cylinder_open(); 
}

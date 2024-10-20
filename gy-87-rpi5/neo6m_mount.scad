include <../roundedcube.scad>;
gps_hole_size_r = 3/2;
gps_module_hole_length = 28 + gps_hole_size_r*2;
gps_module_hole_width = 17.6 + gps_hole_size_r*2;
gps_center = [gps_module_hole_length/2, gps_module_hole_width/2];
gps_module_width=25.9;
gps_module_length=36;

thickness= 2.5;
rpi_hole_r = 2.7/2;
hole_offset = 3.5;
holes_gap = 5.7;

gps_hole_positions = [[0, 0],[gps_module_hole_length, 0],[0, gps_module_hole_width],[gps_module_hole_length, gps_module_hole_width]];
rpi_holes = [[0, gps_module_hole_width+holes_gap]];

mount_w=10;
mount_length = 34;

difference()
{
        roundedcube([mount_w,mount_length,thickness], radius=thickness/3, center=false);
        
y_offset=mount_length-rpi_holes[0][1]-3.5;
translate([mount_w/3*2,y_offset,0])
    {
    for (pos = gps_hole_positions) {
        translate([pos[0], pos[1], -1]) 
        cylinder(r=(gps_hole_size_r+0.05), h=10, $fn=100);
    }
    translate([-1.1-gps_hole_size_r-gps_module_hole_length,-0.8-gps_hole_size_r,thickness-0.8])
    //translate([-1.1-gps_hole_size_r,-0.8-gps_hole_size_r,thickness-0.8])
    cube([gps_module_length,gps_module_width,  0.8]);

     for (pos = rpi_holes) {
        translate([pos[0], pos[1], -1]) 
        cylinder(r=(rpi_hole_r+0.05), h=10, $fn=100);
    }
}
cutoff_w = 12;
translate([mount_w*0.6,mount_length/2-cutoff_w/2-2.5,0])
    roundedcube([20,cutoff_w,thickness], radius=thickness/3, center=false,apply_to="z");
}
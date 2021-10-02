$fn=50;
total_height=39;
//total_height=20;
printer_tolerance = 0.2;
wall_thickness = 4;
rodel_end_inside_length = 35;
wheel_base_and_rodel_end_overlap_length = 20;
//rodel_end_inside_length = 20;
//wheel_base_and_rodel_end_overlap_length = 1;
wheel_base_width = 42;
//wheel_base_width = 38;

assert(rodel_end_inside_length>wheel_base_and_rodel_end_overlap_length);
assert(rodel_end_inside_length<total_height);
rodel_end_width = 14.6;
rodel_end_length = 30.2;
rodel_end_radius = 25;
corner_radius = 4;

wheel_base_height = total_height-rodel_end_inside_length+wheel_base_and_rodel_end_overlap_length;
echo(wheel_base_height);

module cylinder_hat(cylinder_h, radius){
	cylinder_h = 1;
	translate([0,0,0.5*cylinder_h - (cylinder_h+radius)/2]){
			cylinder(r=radius, h=cylinder_h, center=true);
			translate([0,0,cylinder_h/2])
			half_sphere(radius=radius);
	}
}

module base_rounded(corner_r, l, w, h)
{
	minkowski() {
		cyl_h = 1;
		cylinder_hat(cylinder_h=cyl_h, radius=corner_r);
		hat_h = cyl_h + corner_r;
		//cylinder(r=corner_r, h=cyl_h, center=true);
		cube([l-2*corner_r,w-2*corner_r,h-hat_h], true);
		}

}

module base(corner_r, l, w, h)
{
	minkowski() {
                       cyl_h = 1;
                       cylinder(r=corner_r, h=cyl_h, center=true);
            	       cube([l-2*corner_r,w-2*corner_r,h-cyl_h], true);
}
}

//translate([40,0,0])
//base();

module half_sphere(radius)
{
 difference() {
  sphere(r=radius);
  translate([0,0, -radius]) cube(2*radius, center=true);
}
}

module tougue_shape(radius, l, w, h)
{
intersection() {
        cube([l, w, h], true);
        sphere(radius);
        }
}

//base_rounded(corner_radius);

//cylinder_hat(cylinder_h=1, radius=4);

difference(){
    union(){
        translate([0,0, wheel_base_height/2]) {
		base_rounded(corner_radius, wheel_base_width, wheel_base_width, wheel_base_height);
		//base(corner_radius,wheel_base_width, wheel_base_width, wheel_base_height);
        }
        translate([0,0, total_height/2]) {
	    base_rounded(3, rodel_end_length+wall_thickness+printer_tolerance,rodel_end_width+wall_thickness+printer_tolerance, total_height);
            //cube([rodel_end_length+wall_thickness+printer_tolerance, rodel_end_width+wall_thickness+printer_tolerance, total_height], true);
        }
    }

    translate([0,0,total_height-(rodel_end_inside_length-rodel_end_radius)]) {
        //intersection() {
        //cube([rodel_end_length+printer_tolerance, rodel_end_width+printer_tolerance, 100], true);
        //sphere(rodel_end_radius);
        //}
	tougue_shape(rodel_end_radius, (rodel_end_length+printer_tolerance), (rodel_end_width+printer_tolerance), 100);
    }
}

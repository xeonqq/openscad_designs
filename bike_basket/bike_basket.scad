// Higher definition curves
$fs = 0.1;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	module build_point(type = "sphere", rotate = [0, 0, 0]) {
		if (type == "sphere") {
			sphere(r = radius);
		} else if (type == "cylinder") {
			rotate(a = rotate)
			cylinder(h = diameter, r = radius, center = true);
		}
	}

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							build_point("sphere");
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							build_point("cylinder", rotate);
						}
					}
				}
			}
		}
	}
}

thin_side = 3;
thick_side = 11;
wall_thickness = 2.5;
height = 40;
corner_radius = 1.5;
thin_side_length = 60;
thick_side_length = 60;

thin_side_width = thin_side + 2 * wall_thickness;
thick_side_width = thick_side+2*wall_thickness;
roof_thickness = wall_thickness;
module basket_corner_holder(){

difference(){
    union(){
    //thin side
    roundedcube([thin_side_length, thin_side_width ,height], center = false, radius = corner_radius);

    //thick side


    roundedcube([thick_side_width, thick_side_length, height], center = false, radius = corner_radius);
    }
    
translate([wall_thickness, wall_thickness, 0])
cube([thin_side_length+20, thin_side ,height-roof_thickness]);
translate([wall_thickness, wall_thickness, 0])
cube([thick_side, thick_side_length+20, height-roof_thickness]);
}
friction_cylinder_d = 1.5;
friction_cylinder_r = friction_cylinder_d/2;
distance_between_friction_cylinders = friction_cylinder_d * 2.5;
num_friction_cylinder_thick_side = (height)/distance_between_friction_cylinders-1;

//thick side
thick_side_cylinder_height =  thick_side_length - thin_side_width;
for (i=[0:num_friction_cylinder_thick_side]){
    translate([wall_thickness,thick_side_length,distance_between_friction_cylinders*i+distance_between_friction_cylinders/2])
    rotate([90,0,0])
    cylinder(thick_side_cylinder_height, d=friction_cylinder_d);
}

for (i=[0:num_friction_cylinder_thick_side]){
    translate([thick_side_width-wall_thickness,thick_side_length,distance_between_friction_cylinders*i+distance_between_friction_cylinders/2])
    rotate([90,0,0])
    cylinder(thick_side_cylinder_height, d=friction_cylinder_d);
}
//
//thin side
friction_cylinder_thin_d = 1;
friction_cylinder_thin_r = friction_cylinder_thin_d/2;
distance_between_friction_thin_cylinders = friction_cylinder_thin_d*2.5;
num_friction_cylinder_thin_side = (height)/distance_between_friction_thin_cylinders-1;
thin_side_cylinder_height =  thin_side_length - thick_side_width;
for (i=[0:num_friction_cylinder_thin_side]){
    translate([thin_side_length,wall_thickness , distance_between_friction_thin_cylinders*i + distance_between_friction_thin_cylinders/2])
    rotate([0,-90,0])
    cylinder(thin_side_cylinder_height, d=friction_cylinder_thin_d);
}

for (i=[0:num_friction_cylinder_thin_side]){
    translate([thin_side_length,thin_side_width-wall_thickness , distance_between_friction_thin_cylinders*i + distance_between_friction_thin_cylinders/2])
    rotate([0,-90,0])
    cylinder(thin_side_cylinder_height, d=friction_cylinder_thin_d);
}
}
module ziptie_hole(ziptie_width = 5.5) {
translate([0,0,height/5])
rotate([-90,0,0])
cylinder(50, d=ziptie_width);

translate([0,0,height+roof_thickness/3])
rotate([-90,0,0])
cylinder(50, d=ziptie_width);
    
    }
difference(){
    
basket_corner_holder();
translate([thick_side_width+(thin_side_length-thick_side_width)/2,-1,height/2])
rotate([-90,0,0])
cylinder(50, d=height*0.45);
translate([-1, thin_side_width+(thick_side_length-thin_side_width)/2, height/2])
rotate([0,90,0])
cylinder(50, d=height*0.45);
    translate([thin_side_length-10,-1, 0])
ziptie_hole();
translate([20,-1, 0])
ziptie_hole();
    
    translate([-1,20, 0])
rotate([0,0,-90])
ziptie_hole();

translate([-1,50, 0])
rotate([0,0,-90])
ziptie_hole(4.5);
}



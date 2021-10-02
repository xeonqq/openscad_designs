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


// parameters depending on the monitor
screen_edge_height = 10;
screen_thickness = 23;

// parameters for phone, the default should be fine
phone_holder_height = 52;
holder_thickness = 4.5;
holder_width = 40;
phone_stand_width = 28;
phone_stand_diameter = 22.5;

// parameters for screw
screw_diameter = 6;
thickness_top = 12;



corner_radius = 2;
module screen_hook(){
difference(){
    
union(){
    translate([0,0,phone_holder_height-(screen_edge_height+thickness_top)])    
    roundedcube([holder_width, screen_thickness+2*holder_thickness ,screen_edge_height+thickness_top], center = false, radius = corner_radius);
    
    translate ([0,screen_thickness, 0])
    roundedcube([holder_width, holder_thickness*2,phone_holder_height], center = false, radius = corner_radius);
    }
    
translate ([-0.5,holder_thickness, -thickness_top])
roundedcube([holder_width+1, screen_thickness ,phone_holder_height], center = false, radius = corner_radius);
}
}

adapted_phone_stand_thickness = (thickness_top - screw_diameter)/2;
phone_stand_cube_height=thickness_top/2+phone_holder_height-thickness_top-phone_stand_diameter/2;

module phone_stand(new_phone_stand_thickness, cube_height=phone_stand_cube_height, hinge_outer_diameter=thickness_top, margin=0){
    union(){
rotate([0,90,0])
difference(){
cylinder(phone_stand_width+margin, d=hinge_outer_diameter);
translate ([0,0,-0.5])
cylinder(phone_stand_width+margin+1, d=screw_diameter);
   }
   
translate([phone_stand_width/2,screw_diameter/2+(thickness_top-screw_diameter)/4,-cube_height/2])
cube([phone_stand_width+margin,new_phone_stand_thickness, cube_height], true);


phone_stand_inner_diameter=phone_stand_diameter-2*new_phone_stand_thickness;

translate([phone_stand_width,phone_stand_inner_diameter/2+screw_diameter/2+new_phone_stand_thickness,-cube_height])
rotate([0,-90,0])
difference(){
cylinder(phone_stand_width+margin, d=phone_stand_diameter);
translate ([0,0,-0.5])
cylinder(phone_stand_width+margin+1, d=phone_stand_inner_diameter);
   translate([0, -(phone_stand_width+margin)/2,-1])
   cube(phone_stand_width+margin+2);
   }
}

}
margin=0.7;

module phone_stand_hinge(hinge_outer_diameter){
    union(){
rotate([0,90,0])
difference(){
cylinder(phone_stand_width+margin, d=hinge_outer_diameter);
translate ([0,0,-0.5])
cylinder(phone_stand_width+margin+1, d=screw_diameter);
   }

}
}




module screen_hook_finish(){
difference(){
    screen_hook();
   
    translate([0,screen_thickness+holder_thickness*2-adapted_phone_stand_thickness-screw_diameter/2,phone_holder_height-thickness_top/2])
    rotate([0,90,0])
    translate ([0,0,-0.5])
    cylinder(holder_width+1, d=screw_diameter+0.1);

translate([(holder_width-phone_stand_width)/2,screen_thickness+holder_thickness*2-adapted_phone_stand_thickness-screw_diameter/2,phone_holder_height-thickness_top/2])
    phone_stand(adapted_phone_stand_thickness);

 translate([(holder_width-phone_stand_width)/2-margin/2,screen_thickness+holder_thickness*2-adapted_phone_stand_thickness-screw_diameter/2,phone_holder_height-thickness_top/2])
    phone_stand_hinge(thickness_top+1.5);


translate([(holder_width-phone_stand_width)/2,screen_thickness+holder_thickness-margin, phone_stand_diameter/2-margin/2])

cube([phone_stand_width, holder_thickness+margin, phone_holder_height-phone_stand_diameter/2+margin]);

}
}

// part 1
screen_hook_finish();

//translate([(holder_width-phone_stand_width)/2,screen_thickness+holder_thickness*2-adapted_phone_stand_thickness-screw_diameter/2,phone_holder_height-thickness_top/2])
// part 2
//phone_stand(adapted_phone_stand_thickness);

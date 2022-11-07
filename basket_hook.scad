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
wall_thickness = 2.5;
height = 40;
corner_radius = 2;
thin_side_length = 35;


thin_side_width = thin_side + 2 * wall_thickness;

roof_thickness = wall_thickness;
module basket_corner_holder(){

difference(){

    //thin side
    roundedcube([thin_side_length, thin_side_width ,height], center = false, radius = corner_radius);

    
translate([-1, wall_thickness, 0])
cube([thin_side_length+20, thin_side ,height-roof_thickness]);

}



//thin side
friction_cylinder_thin_d = 1;
friction_cylinder_thin_r = friction_cylinder_thin_d/2;
distance_between_friction_thin_cylinders = friction_cylinder_thin_d*2.5;
num_friction_cylinder_thin_side = (height-roof_thickness)/distance_between_friction_thin_cylinders-2;
thin_side_cylinder_height =  thin_side_length;
for (i=[0:num_friction_cylinder_thin_side]){
    translate([thin_side_length,wall_thickness , distance_between_friction_thin_cylinders*i + distance_between_friction_thin_cylinders])
    rotate([0,-90,0])
    cylinder(thin_side_cylinder_height, d=friction_cylinder_thin_d);
}

for (i=[0:num_friction_cylinder_thin_side]){
    translate([thin_side_length,thin_side_width-wall_thickness , distance_between_friction_thin_cylinders*i + distance_between_friction_thin_cylinders])
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
    
module rounded_square( width, radius_corner ) {
	translate( [ radius_corner, radius_corner, 0 ] )
		minkowski() {
			square( width - 2 * radius_corner );
			circle( radius_corner );
		}
}

module hook_twist(hook_width, twist_radius, corner_radius)
{
    rotate_extrude(angle=-45, convexity=10)
    translate([-twist_radius-hook_width/2.0,0])
    rounded_square(hook_width, corner_radius);

    x_offset = 2*twist_radius*cos(45) - twist_radius;
    y_offset = 2*twist_radius*sin(45) ;
    translate([-x_offset,y_offset,0,])
    translate([-twist_radius,0,0])
    rotate_extrude(angle=-45, convexity=10)
    translate([twist_radius-hook_width/2.0,0])
    rounded_square(hook_width, corner_radius);
    echo("twist span: ", twist_radius - x_offset);
    echo("twist height: ", y_offset);
}

hook_width=12;
twist_radius = 25;
hook_radius = 32.5;
offset_into_clip=17.5;
offset_y_away = 3;
module hook_and_twist(hook_width, twist_radius, hook_radius, corner_radius)
{

hook_twist(hook_width, twist_radius, corner_radius);

x_offset = 2*twist_radius*cos(45) - twist_radius;
y_offset = 2*twist_radius*sin(45);

translate([hook_radius-x_offset,y_offset, 0])
rotate_extrude(angle=-180-50, convexity=10)
    translate([-hook_radius-hook_width/2.0,0])
    rounded_square(hook_width, corner_radius);
//basket_corner_holder();
 echo("box top to hook top must be not larger than 35, currently: ", y_offset+hook_radius-hook_width/2-roof_thickness-offset_into_clip);
echo("box inner side to hook outerside larger than 86.3, currently: ", twist_radius-x_offset+2*hook_radius+hook_width/2-offset_y_away);
}

module hook_in_position(){
    translate([thin_side_length,thin_side_width/2+offset_y_away,height-roof_thickness-offset_into_clip])
rotate([0,0,-90])    
translate([twist_radius,0,0])
rotate([90,0,0])
hook_and_twist(hook_width, twist_radius, hook_radius, corner_radius);
    }


difference(){
union(){
difference(){
hook_in_position();
roundedcube([thin_side_length, thin_side_width ,height], center = false, radius =corner_radius);
translate([0,thin_side_width-corner_radius, 0])
    cube([thin_side_length, thin_side_width ,height], center = false);
    
}   
    basket_corner_holder() ;
}

ziptie_width = 5;

translate([thin_side_length*0.2,-1, 0])
ziptie_hole(ziptie_width);
   
translate([thin_side_length*0.7,-1,height/5])
rotate([-90,0,0])
cylinder(50, d=ziptie_width);

translate([thin_side_length*0.5,-1,height/2])
rotate([-90,0,0])
cylinder(50, d=ziptie_width*2);
}

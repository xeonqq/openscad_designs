use <rodel_wheel_adapter.scad>;

$fn=50;


support_height = 82;
//holder_height = 18.5;
holder_height = 30;
total_height = support_height+holder_height;
rodel_end_height = 18.5;
rodel_round_head_height = 5;

wood_foot_width = 56.9;
wood_foot_height_without_tyre = 30.66;
tyre_height = 34.86-30.66;
rodel_end_radius = 33;

wall_thickness = 3;

difference()
{
	translate([0,0,-holder_height/2])
	union(){
	base_rounded(corner_r=4,l=(wood_foot_width+2*wall_thickness), w=(wood_foot_height_without_tyre + tyre_height+2*wall_thickness),h=holder_height);
	//cube([wood_foot_width+2*wall_thickness, wood_foot_height_without_tyre + tyre_height+2*wall_thickness,holder_height]);


	translate([0,0,-0.5*(holder_height+support_height)])
	{
	difference()
	{
			base(corner_r=4,l=(wood_foot_width+2*wall_thickness), w=(wood_foot_height_without_tyre + tyre_height+2*wall_thickness), h=support_height,center=true);
			translate([0,74, -35])
			{sphere(90);}
		}
	}
	}
	translate([0,0,-0.5*(holder_height-rodel_round_head_height)]) tougue();

}

module tougue()
{
union() {
	h = holder_height - rodel_round_head_height;
	translate([0,0,h*0.5])
        cube([wood_foot_width, wood_foot_height_without_tyre+tyre_height, h+0.1], true);
	translate([0,0,rodel_end_radius-rodel_round_head_height])
	difference(){
		translate([-wood_foot_width/2,0,0]){
			rotate([0,90,0]){
				cylinder(r=rodel_end_radius, wood_foot_width);
			}
		}
		translate([0,0,rodel_round_head_height]){
		cube([wood_foot_width+2,wood_foot_width,rodel_end_radius*2], true);}
		offset = wood_foot_height_without_tyre+tyre_height;
		translate([0,(offset*0.5+wood_foot_width*0.5),0]){
		cube([wood_foot_width+2,wood_foot_width,rodel_end_radius*2], true);}
		translate([0,-(offset*0.5+wood_foot_width*0.5),0]){
		cube([wood_foot_width+2,wood_foot_width,rodel_end_radius*2], true);}

	}
}
}

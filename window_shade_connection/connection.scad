
$fa = 2;
$fs = 0.25;

hexgon_outer_height=13;
outer_length=10;
outer_width=outer_length/sqrt(3);

inner_length=7.15;
inner_width=inner_length/sqrt(3);
module nut_hole()
{
	//rotate([0, 90, 0]) // (Un)comment to rotate nut hole
	//rotate([90, 0, 0])
		for(i = [0:(360 / 3):359])
		{
			rotate([0, 0, i])
			cube([outer_width, outer_length, hexgon_outer_height], center = true);
		}
}

module nut_hole_inner()
{
	//rotate([0, 90, 0]) // (Un)comment to rotate nut hole
	//rotate([90, 0, 0])
		for(i = [0:(360 / 3):359])
		{
			rotate([0, 0, i])
			cube([inner_width, inner_length, hexgon_outer_height], center = true);
		}
}
module hexgon_base(){
difference(){
    
    nut_hole();
    translate([0,0,-2])
    nut_hole_inner();

}
}

h=8;
diameter=3.0;
hook_diameter=3;
translate([-diameter/2-hook_diameter/2,0,h+hexgon_outer_height/2])

rotate([90,0,0])
rotate_extrude(angle=230,convexity = 20){
translate([diameter/2+hook_diameter/2,0,0])
circle(r=diameter/2);
}

union(){
translate([0,0,hexgon_outer_height/2])
linear_extrude(h, scale=diameter/outer_length)
projection(cut=false)
hexgon_base();
}

hexgon_base();
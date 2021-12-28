
coral_holes_diameter=3.1;
coral_holes_distance_height=58;
coral_holes_distance_vertical=23;

module coral_holes(){
    h=10;
    cylinder(h = h, r = coral_holes_diameter/2, $fn=30);
    translate([coral_holes_distance_height,0,0])
    cylinder(h = h, r = coral_holes_diameter/2, $fn=30);
    translate([coral_holes_distance_height,coral_holes_distance_vertical,0])
    cylinder(h = h, r = coral_holes_diameter/2, $fn=30);
     translate([0,coral_holes_distance_vertical,0])
    cylinder(h = h, r = coral_holes_diameter/2, $fn=30);
//cylinder(h = h, r = coral_holes_diameter/2);
}

difference(){
import("Bottom_Base_SM.stl");

translate([-coral_holes_distance_height/2,28-coral_holes_distance_vertical/2,-8])
coral_holes();
}
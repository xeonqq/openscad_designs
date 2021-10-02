include <roundedcube.scad>

cam_width=25;
cam_height=24.12;    

built_in_screw_diameter=3.2;

pcb_plus_rippon_connector_thickness=3.5;

built_in_screws_h_distance=18.42;

screw_tolerance=0.1;
cam_tolerance=0.5;


screw_holes_h_distance=20.6;
screw_holes_v_distance=13.84;
screw_hole_diameter=2+screw_tolerance;

vertical_distance_low_holes = 3.1;
vertical_distance_built_in_screws = 9.32;

gopro_screw_diameter=5+screw_tolerance;

container_depth=18;
container_thickness=1.5;
container_outer_width=cam_width+container_thickness*2;
container_outer_height=cam_height+container_thickness*2;
container_outer_depth = container_depth+container_thickness;


module container(){
    difference(){
        roundedcube([container_outer_width+cam_tolerance*2,container_outer_depth,   container_outer_height+cam_tolerance*2], radius=2);
        translate([container_thickness,0,container_thickness])
        cube([cam_width+cam_tolerance*2,container_depth,cam_height+cam_tolerance*2]);
}
}





module built_in_screw_cylinder(){
translate([(cam_width-built_in_screws_h_distance)/2,0,vertical_distance_built_in_screws])
rotate([-90,0,0])
cylinder(h = 10, r = built_in_screw_diameter/2);
}

module built_in_screw_cylinders(){
built_in_screw_cylinder();
   translate([built_in_screws_h_distance,0,0])
built_in_screw_cylinder(); 
}

module screw_cylinder(){
translate([(cam_width-screw_holes_h_distance)/2,0,vertical_distance_low_holes])
rotate([-90,0,0])
cylinder(h = 10, r = screw_hole_diameter/2);
}

module screw_cylinders(){
    screw_cylinder();
translate([screw_holes_h_distance,0,0])
screw_cylinder();

translate([screw_holes_h_distance,0,screw_holes_v_distance])
screw_cylinder();

translate([0,0,screw_holes_v_distance])
screw_cylinder();
    }


module ribbon_connector(){
thickness=pcb_plus_rippon_connector_thickness+cam_tolerance*4;
translate([-cam_tolerance,container_depth-pcb_plus_rippon_connector_thickness-cam_tolerance ,-cam_tolerance+24])
        cube([cam_width+cam_tolerance*2,thickness,cam_height+cam_tolerance*2]);
    }

    module gopro_screw(){
              translate([cam_width/2,container_depth/2-1,-5])

cylinder(h = 10, r = gopro_screw_diameter/2);
        }
        
        
difference(){
            translate([-container_thickness-cam_tolerance,0,-container_thickness-cam_tolerance])
            container();
            
            translate([0,container_depth-2,0])
            screw_cylinders();
        translate([0,container_depth-2,0])
    built_in_screw_cylinders();
    
    
        ribbon_connector();
    
    gopro_screw();
    }


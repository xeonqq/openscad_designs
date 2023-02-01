servo_w=20;
servo_l=40;
servo_h=40;
servo_extra_l=54;

module mg996r(extra_buffer=0)
{
    
    r=(servo_w+extra_buffer)/2;
    h= servo_h-2.5;
    cube([servo_w+extra_buffer,servo_l+extra_buffer,h]);
    translate([r,r,h])
    cylinder(h=6, r1=r,r2=r);
    
    offset_y=(servo_extra_l-servo_l)/2;
    translate([0,-offset_y,26.5])
    cube([servo_w,servo_extra_l,2.5]);
    
        translate([servo_w/2-1,-offset_y-5,28])
    cube([2,servo_extra_l+10,2.5]);


}

module four_screws(h=10, d=3.1)
{
    z_offset=h*0.2;
                        translate([4.5,-5,servo_h*0.6-z_offset])
            cylinder(h, r1=d/2, r2=d/2, $fn=100);
                                translate([5+9.5,-5,servo_h*0.6-z_offset])
            cylinder(h, r1=d/2, r2=d/2, $fn=100);
            offset=49.5;
                   translate([4.5,-4+offset,servo_h*0.6-z_offset])
            cylinder(h, r1=d/2, r2=d/2, $fn=100);
                                translate([5+9.5,-4+offset,servo_h*0.6-z_offset])
            cylinder(h, r1=d/2, r2=d/2, $fn=100);
    }

//four_screws();
//mg996r();


module kai()
{
    difference()
{
    import("kai_statue.stl");
        union(){
//            translate([0,0,110])
 //           sphere(r=20);
      translate([0,10,0])

    cylinder(h=80, r1=25, r2=0);
    translate([0,0,-50+20])
    cube([200,200,100],center=true);
            
            translate([0,20,140])
rotate([90,0,90])
ring();
        }
}
}


module ring(outer_r=8, inner_r=4, h=4) {
    difference() {
        cylinder(h=h, r=outer_r);
        translate([0,0,-1])
            cylinder(h=h+2, r=inner_r);
    }
}


kai();

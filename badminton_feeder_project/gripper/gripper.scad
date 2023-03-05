module gripper_base(){
difference(){
import("Gripper_base.stl");
translate([0,-50,-115])
cube([80,80,80]);
    translate([-30.5,-40,-75+30])
cube([40,40,40]);

}
}

module gear1(){
translate([10,0,0])
intersection(){
    translate([15,-10,-10])
cube([10,20,20]);
    import("gear1.stl");

    }

translate([10,0,0])
intersection(){
    translate([5,-10,-10])
cube([10,20,20]);
    import("gear1.stl");

    }
    import("gear1.stl");
}

bearing_r=10/2+0.1+1



;
bearing_h=4;
bearing_hole_r=4.8/2;
m3_r=3/2+0.1;
m3_nut_h = 2.2;
module bearing(){

difference(){
cylinder(h=bearing_h, r1=bearing_r, r2=bearing_r,$fn=200); 

translate([0,0,-0.5])
cylinder(h=bearing_h+1, r1=bearing_hole_r, r2=bearing_hole_r,$fn=200); 
}
}

module gear1_with_bearing(){
offset = bearing_h-m3_nut_h;//-1.8+1; //0.8mm higher than before
difference()
{
gear1();
       translate([-10,offset,0])
    rotate([90,0,0])
    bearing();
    
}
 translate([31,4,0])
hole_fitter();
}
module hole_fitter()
{       
            rotate([90,0,0])
            difference(){
            cylinder(h=4, r1=5/2,r2=5/2, $fn=100);
            cylinder(h=11, r1=3.2/2,r2=3.2/2, $fn=100);
            }
    }

module gear2(){
translate([-10,0,0])
intersection(){
    translate([-45,-10,-10])
cube([10,20,20]);
    rotate([0,-7.5,0])
   import("gear2.stl");

    }
    translate([-10,0,0])
    intersection(){
    translate([-35,-10,-10])
cube([10,20,20]);
    rotate([0,-7.5,0])
   import("gear2.stl");
}
    rotate([0,-7.5,0])

   import("gear2.stl");
translate([-51,4,-1.2])
hole_fitter();
}

module gear2_with_gear_ring()
{
    r_small_screw=1.7/2+0.2;
    r=20.6/2+0.1;
    h=2.3+1.3;
    difference()
    {
        union(){
            translate([-10,4+0.01-h,-1.])
            rotate([90,0,0]){
                difference(){
            cylinder(h=1, r1=r+1.5,r2=r+1.5, $fn=100);
            cylinder(h=1, r1=r-5.5,r2=r-5.5, $fn=100);
                }
            }
            gear2();

        }

    translate([-10,4+0.01,-1.])
    rotate([90,0,0]){
            
            cylinder(h=h, r1=r,r2=r, $fn=100);
            translate([0, -15.2/2,-5])
            cylinder(h=10, r1=r_small_screw,r2=r_small_screw, $fn=100);
            translate([0,15.2/2,-5])
            cylinder(h=10, r1=r_small_screw,r2=r_small_screw, $fn=100);
    }
    }
}
//gear1();

//gear2();
module grip_link()
{
    translate([10,0,0])
        intersection(){

        translate([25,-10,-10])
    cube([10,20,20]);
    import("grip_link_1.stl");
        }
            translate([10,0,0])
        intersection(){

        translate([15,-10,-10])
    cube([10,20,20]);
    import("grip_link_1.stl");
        }
        difference(){
    import("grip_link_1.stl");

        translate([25,-10,-10])
    cube([10,20,20]);
        }
}

module grip_link_enhanced(){
grip_link();
translate([41,0,0])
rotate([90,0,0])
difference(){
    r=4;
    cylinder(h=m3_nut_h,r1=r,r2=r,$fn=200);
r_i=1.7;
cylinder(h=m3_nut_h,r1=r_i,r2=r_i,$fn=200);
}
}
//mirror([0,0,1])
//gear1_with_bearing();

gear2_with_gear_ring();

//grip_link_enhanced();
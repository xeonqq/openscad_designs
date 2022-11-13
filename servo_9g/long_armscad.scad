
translate([-0,-0,0])
import("servo_arm.stl");


tube_inner_r = 69.5/2;
cap_r = 75/2;
cap_thickness = 5;
cap_h=2;
difference(){
    translate([-10,(cap_r+cap_thickness/2),0])
rotate([0,0,180])
linear_extrude(height=2)
cap();





}

module cap(){
difference()
{
    
    pie_slice(r=cap_r+cap_thickness,a=70);
    pie_slice(r=cap_r,a=90);

    
    
//translate([0,0,-50+5.6])
//cube([100,100,100], center=true);
    }
}

module pie_slice(r=3.0,a=30) {
  $fn=64;
  intersection() {
    circle(r=r);
    square(r);
    rotate(90-a) square(r);
  }
}


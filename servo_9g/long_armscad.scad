


tube_inner_r = 69.5/2;
cap_r = 75/2;
cap_thickness = 5;
cap_h=2;


//translate([0,20,0])
//long_arm();

bearing_r=10/2+0.1;
bearing_h=4;
bearing_hole_r=4.8/2;
m3_r=3/2;

original_hole_offset=11.75;
module long_arm_fitted_with_bearing()
{
difference(){

union(){
mirror([0,1,0])
long_arm();
//fill the original hole
translate([original_hole_offset,0,0])
cylinder(h=1.2, r1=6/2, r2=6/2,$fn=200);
}
translate([original_hole_offset,0,1.2]){


cylinder(h=bearing_h, r1=bearing_r, r2=bearing_r,$fn=200); 
    translate([0,0,-10])

cylinder(h=bearing_h+20, r1=m3_r, r2=m3_r,$fn=200);
}
}
}

module long_arm(){
    import("servo_arm.stl");
difference(){
    union(){
difference(){
   translate([-10,(cap_r+cap_thickness/2),0])
rotate([0,0,180])
linear_extrude(height=2)
cap();
}
//fill the original hole
translate([original_hole_offset,0,0])
cylinder(h=1.2, r1=6/2, r2=6/2,$fn=200);
}
translate([original_hole_offset,0,-1])
cylinder(h=bearing_h+20, r1=1.1, r2=1.1,$fn=200);

}

}

module cap(){
difference()
{
    
    pie_slice(r=cap_r+cap_thickness,a=90);
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
circle_r=13/2;
perimeter=2*3.1415926*circle_r;
n= floor(perimeter/1/2);
d_angle=360/n;

teeth_width=perimeter/(n*2)-0.15;
echo(teeth_width);
rack_width=4.65;
teeth_height=1.2;
teeth_spike_height=0.6;
module teeth()
{
    rotate([90,0,90]){
    cube([teeth_width,rack_width,teeth_height],center=true);
    translate([0,0,teeth_height/2]){
    linear_extrude(teeth_spike_height, scale=[0.7, 0.7])
    square([teeth_width,rack_width], center=true);
    }
}
}

echo(perimeter);
echo(n);
module gears(){
for (i=[0:n-1])
{
    angle=d_angle*i;
    angle_thres=125;
   if ((angle<angle_thres)||(angle>(360-angle_thres)))
    
    {
    x=cos(angle)*circle_r;
    y =sin(angle)*circle_r;
    translate([x, y, 0])
    rotate([0,0,i*d_angle])
    teeth();
    }
}
}


//long_arm_fitted_with_bearing();
translate([original_hole_offset,0,2.35])
gears();

long_arm();
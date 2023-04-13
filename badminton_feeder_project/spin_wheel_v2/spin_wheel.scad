wheel_diameter=50*2;
wheel_r = wheel_diameter/2;
shaft_d=3+1-0.74;
shaft_h=11;


bullet_head_h=5;
bullet_head_diameter=5+0.4;

wheel_h=9*2;
thickness=3.5;
shaft_adapter_d=11;
top_thickness=3;
module spin_wheel()
{
    difference(){
    cylinder(h=wheel_h, r1=wheel_r, r2=wheel_r, $fn=360);
            cylinder(h=wheel_h-top_thickness, r1=wheel_r-thickness, r2=wheel_r-thickness,$fn=360);

    }

 
translate([0,0,wheel_h-bullet_head_h])
difference()
{
       cylinder(h=bullet_head_h, r1=shaft_adapter_d/2, r2=shaft_adapter_d/2,$fn=360);
}


}


difference(){
spin_wheel();


  
    for (i=[0:60:360])
    {
        r=wheel_r/2+2;
        y = r*sin(i);
        x=r*cos(i);
        translate([x, y, 0])
        cylinder(h=40, r1=wheel_r/7, r2=wheel_r/7, $fn=360);
    }  
            cylinder(h=30, r1=bullet_head_diameter/2, r2=bullet_head_diameter/2,$fn=360);


}





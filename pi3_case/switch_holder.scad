include <roundedcube.scad>;
buffer=0.5;
switch_w=21.5;
switch_h=23.3;
switch_thickness=1.8;
module switch(simplify=false){
w=switch_w+buffer;
h=switch_h+buffer;
thickness=switch_thickness+buffer;
roundedcube([w, h, thickness], radius=thickness/2, apply_to="z");

button_thickness=5.8+buffer;
button_w=13+buffer;
button_h=6+buffer;
y_offset=2.5;
z_offset=1;
translate([w/2-button_w/2,-y_offset,-z_offset])
cube([button_w,button_h,button_thickness]);


//big block to simplify diff
if(simplify){
translate([w/2-button_w/2,-y_offset,-z_offset])
cube([button_w,40,button_thickness]);
}

translate([w/2-8/2,h-4,-1])
cube([8,6,10]);
}
holder_thickness=1.4;
extra_holder_bottom_thickness=0.8;
module switch_holder(){
difference(){
w=switch_w+holder_thickness*2;
h=switch_h+holder_thickness*2;
 
roundedcube([w, h, holder_thickness*2+switch_thickness+extra_holder_bottom_thickness], radius=2, apply_to="z");

translate([holder_thickness, holder_thickness,holder_thickness+extra_holder_bottom_thickness])
switch(true);
    
    //cut the separation
    gap=0.9;
    case_thickness_diff=1.5;
translate([-1,h/2-gap/2-case_thickness_diff-1.7,-1 ])
cube([50+1,gap,40]);    
    
    //cut the top
translate([-1,22.4,-1])
cube([50+1,20,40]); 
    
 //cut bottom   
    //translate([-1,-1,-40+0.5])
//cube([50+1,50,40]);    
}


}
module switch_holder_bottom()
{
    intersection(){
    translate([0,-30+10,0])
    cube(30,30,10);
    switch_holder();
    }
}

module switch_holder_top()
{
    intersection(){
    translate([0,10,0])
    cube(30,30,10);
    switch_holder();
        }

    }
//switch_holder_top();
//switch_holder();
//switch_holder();
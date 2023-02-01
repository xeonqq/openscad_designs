include<../screws.scad>

tube_inner_r = 69.5/2+0.5;
cap_r = 75/2+0.3;
cap_thickness = 2;
cap_h=15;

l=(cap_r+cap_thickness)*2+22;
w=9;
gap=4;

module tube_fixer(){

difference()
{
    union(){
            difference(){
translate([0,0,1])
cube([l+10,cap_h, 2], center=true);
        screw2();
mirror([1,0,0])
screw2();
    }
    
      additional_support();
    mirror([0,1.0])
   additional_support();

        cylinder(h=cap_h, r1=cap_r+cap_thickness,r2=cap_r+cap_thickness, $fn=30);
    
       // translate([0,0,1])
    //cylinder(h=cap_h*2, r1=tube_inner_r,r2=tube_inner_r,$fn=300);
    

translate([0,0,cap_h/2])
cube([w, l, cap_h], center=true);


}
translate([0,0,cap_h/2])
cube([gap, l, cap_h], center=true);
    cylinder(h=cap_h, r1=cap_r,r2=cap_r,$fn=300);
screw();
mirror([0,1,0])
screw();

    }
}



module screw(){
screw_r=4/2+0.2;
translate([-10,l/2-6,cap_h/2])
rotate([0,90,0])
cylinder(h=20, r1=screw_r, r2=screw_r,$fn=300);
}

module screw2(offset=0){
screw_r=4/2+0.2;
translate([(l+10)/2-6.5+offset,0,-1])
cylinder(h=20, r1=screw_r, r2=screw_r,$fn=300);
}

intersection(){
translate([0,-100,0])
cube([100,200,100]);
tube_fixer();
}


module additional_support(){
    screw_offset=5;
 rotate([0,0,30])
translate([0,0,1])
                difference(){
                    cube([l+20,cap_h, 2], center=true);
                            screw2(screw_offset);
                    mirror([1,0,0])
                    screw2(screw_offset);
                }

            }
            

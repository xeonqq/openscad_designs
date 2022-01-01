    half_case_cover_thickness=2/2+0.5;
    case_thickness=22.4;
    outer_diameter=29.7;
cover_diameter=25.8;
    
speaker_diameter=27.5;
speaker_thickness=3.5;
cover_thinkness=1.;
fn=100;

module speaker_holder()
{

    
       cut_h=(outer_diameter-case_thickness)/2;
h=40;
difference()
{
 cylinder(r=outer_diameter/2, h=speaker_thickness+cover_thinkness*2+half_case_cover_thickness,$fn=fn);
translate([0,0,-1])
cylinder(r=cover_diameter/2, h=(speaker_thickness+cover_thinkness*2+2+half_case_cover_thickness),$fn=fn);   
   
     translate([0,0,cover_thinkness+half_case_cover_thickness])
 cylinder(r=speaker_diameter/2, h=(speaker_thickness),$fn=fn); 
    
    //make it smaller
    translate([0,h/2+outer_diameter/2-cut_h,0])
cube(h, center=true);
        translate([0,-h/2-outer_diameter/2+cut_h,0])
cube(h, center=true);
   
    gap=0.9;
    case_thickness_diff=1.5;
translate([0,case_thickness_diff,40/2-1])
cube([outer_diameter+1,gap,40], center=true);
    }
 



    
}
module speaker()
{
    diameter=24;
    extra_thickness=-1.6;
    translate([0,0,-1-extra_thickness/2])
cylinder(r=diameter/2, h=(speaker_thickness+cover_thinkness*2+2+half_case_cover_thickness+extra_thickness),$fn=fn);   
    
    }
module speaker_holder_top()
{
    intersection(){
        
    speaker_holder();
        h=40;
        translate([0,-h/2+1.2,0])
cube(h, center=true);
}
}

module speaker_holder_bottom()
{
    intersection(){
        
    speaker_holder();
        h=40;
                translate([0,h/2+1.8,0])
cube(h, center=true);

}        


}
//speaker_holder_bottom();
//speaker_holder_top();
//speaker_holder();
//speaker();
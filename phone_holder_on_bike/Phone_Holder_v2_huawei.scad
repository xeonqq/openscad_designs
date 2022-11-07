// Depending on your printer, you should add an extra 1 to 2 mm.
Phone_Length=140.5+1;
// Depending on your printer, you should add an extra 1 to 2 mm.
Phone_Width=70+1;
// Depending on your printer, you should add an extra 1 to 2 mm.
Phone_Thickness = 10.1+1;
// Offset the phone vertically. This is useful if your phone have side buttons at the middle that is blocked by the side grip. A positive value will shift the phone upwards, while a negative value shifts it downwards.
Vertical_Offset = 10;//Phone_Length/2-65;
// Allow you to attach two vertical pieces instead of one. This can be useful if you want to charge your phone while it's in the holder.
Dual_Vertical = 0; // [8:True, 0:False]
// Trade off between improved grip and ease of insertion/removal. Increasing this number will increase height of the top catch, improving grip but making it harder to remove the phone. The default should be fine for most cases.
Grip = 0;

// Diameter of the bar where the holder is to be mounted.
//Handle_Bar_Diameter = 27.66+1;
Handle_Bar_Diameter = 22.5+1; //my bike
// Distance from the handle bar to the back of the phone. A smaller number will give a lower profile.
Holder_Height = 17; // [11:20]

Handle_Bar_Lengh = 26;

zip_tie_width = 4.5;
/* [Hidden] */
$fs = 0.5;
$fa = 6;

module copy_mirror(vec=[0,1,0]) {
 union() {
  children();
  mirror(vec) children();
 }
};

module rounded_corner(vec=[0,0,0],rot=0) {
 translate(vec) rotate([0,0,rot]) difference(){
  intersection(){
   cylinder(r=6.5,h=5);
   translate([-6.5,0,0]) cube([6.5,6.5,5]);
  };
  cylinder(r=1.5,h=5);
 };
};



translate([3.4,Vertical_Offset,0])
rotate([0,0,-90])
union() {
  //rounded_corner([Phone_Width/2-1.5,18.5,0],180);
  translate([Phone_Length/2,18.5,0]) cube([5,Phone_Thickness-3,5]);
  rounded_corner([Phone_Length/2-1.5,17+Phone_Thickness-1.5,0],-90);
  translate([Phone_Length/2-1.5,17+Phone_Thickness+1.5,0]) cylinder(r=1.5,h=5);
  translate([Phone_Length/2-1.5,17+Phone_Thickness+5-1.5,0]) cylinder(r=1.5,h=5);
  translate([Phone_Length/2-3,17+Phone_Thickness+1.5,0]) cube([1.5,2,5]);
};


Height_Extension = 5;
arc_offset = -7;
// Vertical Piece
//translate([2.5,0,0]) rotate([0,-90,0]) difference(){
difference(){
 union() {
  translate ([0,Vertical_Offset,0]) union(){
   translate([18.5+Height_Extension,Phone_Length/2,0]) cube([Phone_Thickness/2+Grip,5,5]);
   translate([18.5+Height_Extension+Phone_Thickness/2+Grip,Phone_Length/2+2.5,0]) cylinder(r=2.5,h=5);
   copy_mirror([0,1,0]) rounded_corner([18.5+Height_Extension,Phone_Length/2-1.5,0]);
  

      
   translate([12+Height_Extension,-Phone_Length/2+1.5,0]) cube([5,Phone_Length-3,5]);
   translate([18.5+Height_Extension,-Phone_Length/2-5,0]) cube([Phone_Thickness/2+1,5,5]);
   //translate([19.5+Height_Extension+Phone_Thickness/2,-Phone_Length/2-2.5,0]) cylinder(r=2.5,h=5);
//   translate([18.5,-Phone_Length/2-5,0]) cube([Phone_Thickness-1.5,5,5]);
//   translate([17+Phone_Thickness,-Phone_Length/2-2.5,0]) cylinder(r=2.5,h=5);
  };
  linear_extrude(height=5) polygon([[12+5,-39],[12+5,39],[10+5.3923,33],[0,Handle_Bar_Lengh/2],[0,-Handle_Bar_Lengh/2],[10+5.3923,-33]]);
 };
 copy_mirror([0,1,0]) translate([0,39,0]) cylinder(r=12,h=5);
  translate([arc_offset,0,-5]) cylinder(r=Handle_Bar_Diameter/2,h=20);
 
 translate([-Holder_Height/4-0.1-1+17.5,-5.5/2,-10]) cube([Holder_Height/2+0.2+2,5.5,20]);
 //translate([-Holder_Height,-30,0]) cube([17,60,5]);
};


//comment the rest out if you want to print part by part

offset = 2.8;
// Horizontal Piece
//translate([0,2.5,0]) rotate([90,0,0]) copy_mirror([1,0,0]) difference(){
translate([-30,0,0]) rotate([0,0,-90]) copy_mirror([1,0,0]) difference(){
 union(){
//  linear_extrude(height=5) polygon([[0,-3],[10,-3],[14.6768,10.0145],[17.5,12],[Phone_Width/2-1.5,12],[Phone_Width/2-1.5,17],[0,17]]);
  linear_extrude(height=5) polygon([[0,-3+offset],[10,-3+offset],[18.84,10.4],[21.5,12],[Phone_Width/2-1.5,12],[Phone_Width/2-1.5,17],[0,17]]);
  rounded_corner([Phone_Width/2-1.5,18.5,0],180);
  translate([Phone_Width/2,18.5,0]) cube([5,Phone_Thickness-3,5]);
  rounded_corner([Phone_Width/2-1.5,17+Phone_Thickness-1.5,0],-90);
  translate([Phone_Width/2-1.5,17+Phone_Thickness+1.5,0]) cylinder(r=1.5,h=5);
  translate([Phone_Width/2-1.5,17+Phone_Thickness+5-1.5,0]) cylinder(r=1.5,h=5);
  translate([Phone_Width/2-3,17+Phone_Thickness+1.5,0]) cube([1.5,2,5]);
//  translate([5.5/2,17,5/2]) rotate([90,0,0]) linear_extrude(height=20) polygon([[0,0],[5,0],[0,5]]);
 };
 translate([21.5,9,0]) cylinder(r=3,h=5);
 //translate([0,-Handle_Bar_Diameter/2-Holder_Height+17,0]) cylinder(r=Handle_Bar_Diameter/2,h=10);
 translate([-5.5/2,5.5+offset-(Holder_Height/2+0.2),0]) cube([5.5,Holder_Height/2+0.2,5]); // The poorly named Dual_Vertical contains the horizontal offset for the slot.
 copy_mirror([0,1,0]) translate([8,Handle_Bar_Lengh/2-4,0]) cube([zip_tie_width,zip_tie_width-1.5,5]);
};



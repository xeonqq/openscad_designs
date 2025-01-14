include <../pi3_case/GoPro_Mount.scad>
union(){
    

import("Short_Plain_Supports.stl");

translate([-22.5-0.1,-2.5,-1])
    rotate([90,0,0])

mount2();
}
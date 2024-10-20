include <../pi3_case/GoPro_Mount.scad>
union(){
    
translate([-8,5,12])
rotate([90,90,-0])
import("USB_dupont_Adapter_repaired.stl");

translate([-22.5,-2.5,-1])
    rotate([90,0,0])

mount2();
}
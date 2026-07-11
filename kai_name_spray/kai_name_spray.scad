name = "KAI";
font = "FreeSerif:style=Italic";
size = 50;
thickness = 2;


difference() {
    // Stencil sheet
    linear_extrude(thickness)
        square([130,60], center=true);

    // Subtract the text, but leave a bridge
    translate([-3,0,-1])
    linear_extrude(thickness + 2)
    difference() {
         //spaced_text(name, 40, size, font);
        text(name,
             size=size,
             font=font,
             halign="center",
             valign="center");

        // Bridge across the hole in the A
        rotate([0,0,-28])
        translate([7.5, -6])
            square([3, 12], center=true);
    }
}
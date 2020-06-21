/* Author:
 *  Github: rojasneva
 *  Twitter: @rojasneva
*/

include <MCAD/regular_shapes.scad>
use <MCAD/fonts.scad>

fonts = 8bit_polyfont();
// Font style
font_style = fonts[2];
// Font size in mm
font_size=12;

// Plate dimensions
// eg. California:  ‎12 in × 6 in
plate_x_len = 304.8;
plate_y_len = 152.4;
plate_z_len = 1;

border_width = 10;

msg_frame_x_len = 200;
msg_frame_y_len = 30;
msg_frame_z_len = 2;

// Top left hole center coords
screw_x_center = 65;
screw_y_center = plate_y_len - 15;

// delta
delta = 0.001;

// Text on the top
text_top="3D Printing";

// Text on the bottom
text_bottom="@rojasneva";

// Total length frame. Assummes there is 50% overlap
frame_x_len_total = plate_x_len + border_width;
frame_y_len_total = plate_y_len + border_width;

module border_horizontal(text_str, has_flap=false, invert_text=false) {
    // Small beams length
    beam_len = (frame_x_len_total - msg_frame_x_len) / 2;
    // Left beam
    translate([border_width + delta, 0, 0])
        cube([beam_len - border_width, border_width, plate_z_len]);
    // Right beam
    translate([(frame_x_len_total / 2) + (msg_frame_x_len / 2) - delta, 0, 0])
        cube([beam_len - border_width, border_width, plate_z_len]);
    // Message Frame on Bottom
    linear_extrude(height=msg_frame_z_len)
        translate([beam_len, 0, 0])
            difference() {
                // Message Frame
                polygon(
                    points=[
                        [0, 0],
                        [0, border_width],
                        [border_width, msg_frame_y_len],
                        [msg_frame_x_len - border_width, msg_frame_y_len],
                        [msg_frame_x_len, border_width],
                        [msg_frame_x_len, 0]
                    ]
                );
                // Frame Text
                translate([msg_frame_x_len / 2, msg_frame_y_len / 2, 0])
                    rotate([0, 0, invert_text ? 180 : 0])
                        text(
                            text=text_str,
                            font=font_style,
                            size=font_size,
                            halign="center",
                            valign="center",
                            spacing=1.4
                        );
            }  
}

module border_vertical() {
    cube([border_width + delta, plate_y_len + border_width, plate_z_len]);
}

module hole() {
    mirror([0, 0, 1])
        union() {
            // Thread
            cylinder(h=msg_frame_z_len * 2, d=5);
            // Head
            cylinder(h=msg_frame_z_len * 0.4, d=9);   
        }
}

// Top border
difference() {
    translate([plate_x_len + border_width - delta, plate_y_len + border_width, 0])
        rotate([0, 0, 180])
            border_horizontal(text_top, invert_text=true);
    // Top left hole
    translate(
        [
            screw_x_center + border_width / 2,
            screw_y_center + border_width / 2,
            msg_frame_z_len + delta
        ]
    ) hole();
    // Top right hole
    translate(
        [
            plate_x_len - screw_x_center + border_width / 2,
            screw_y_center + border_width / 2,
            msg_frame_z_len + delta
        ]
    ) hole();
}
// Bottom border
border_horizontal(text_bottom, invert_text=false);
// Left border
border_vertical();
// Right border
translate([frame_x_len_total - delta, 0, 0])
    mirror([1, 0, 0])
    border_vertical();






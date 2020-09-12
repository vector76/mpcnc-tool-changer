use <tool_changer.scad>
use <mpcnc_shared.scad>


difference() {
  union() {
    rotate([0, 180, 0])
    tool_plate(1);
    
    // bar on the end
    translate([-30, -22.5+120-3, 0])
    cube([60, 12.5+3, 15]);
    
    for (y=[-22.5+3.2/2, -9, 10, 16.5, 23, 36]) {
      translate([-30, y-3.2/2, 0])
      cube([60, 3.2, 15]);
      
      translate([-30, 120-45-(y+3.2/2), 0])
      cube([60, 3.2, 15]);
    }
    
    for (i=[0,1]) mirror([i, 0, 0]) {
      translate([13, -22.5, 0])
      rotate([0, 15, 0])
      translate([0, 0, 8])
      cube([12, 120 + 12.5, 10]);

      translate([9.5+4, -22.5, 0])
      cube([8, 120 + 12.5, 8]);
      
      translate([20, -22.5+12, 0])
      cube([8, 96, 8]);
    }
  }
  
  translate([0, -22.5, 15])
  rotate([-90, -90, 0])
  classic_negative(-12.5);

}
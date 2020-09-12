use <tool_changer.scad>

eps = 0.1;

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


// Carve away to leave an interface that matches the interface given by the standard universal tool mount
module classic_negative(negz_offs = 0) {
  bigr = 35;
  span = 37;
  hang = asin(span/2/bigr);
  cutht = 150;
  
  translate([bigr*cos(hang), 0, -eps/2])
  cylinder(r=bigr, h=cutht+eps, $fn=120);
  
  for (i=[0, 1]) mirror([0, i, 0])
  translate([0, bigr*sin(hang), 0])
  rotate([0, 0, 15])
  translate([0, -1, -eps/2])
  cube([20, 20, cutht+eps]);
  
  for (i=[0, 1]) mirror([0, i, 0])
  for (z=[10, 35, 60, 85, 110])
  translate([0, bigr*sin(hang), 0])
  rotate([0, 0, 15])
  translate([0, 4, z - negz_offs])
  rotate([0, -90, 0])
  translate([0, 0, -eps]) {
    cylinder(d=4, h=25*.75-3, $fn=24);  // assume at least 3mm of 'meat' in the attaching part
    translate([0, 0, 7])  // standard mount has 7 mm of meat on the back side for the nut
    rotate([0, 0, 30])
    cylinder(d=9.55, h=25, $fn=6);
  }
}

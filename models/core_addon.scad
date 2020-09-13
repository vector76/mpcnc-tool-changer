short = 0;
core_addon(short);


module core_addon(short = 0) {
  height = short ? 20 : 110;
  
  difference() {
    union() {
      // large upper part
      linear_extrude(height=height)
      union() {
        import("core_addon_top.dxf");
        for (i=[0,1]) mirror([i, 0, 0])
        translate([0, -14.2325, 0])
        rotate([0, 0, -75])
        translate([0, -6, 0])
        square([23, 20]);
      }
      
      if (!short) {
        // builtin washers for middle bearings
        for (xi=[0,1]) mirror([xi, 0, 0])
        translate([-35.73, 0, height-15])
        rotate([0, 0, -15])
        translate([25.4/2+11, 0, 0])
        rotate([-90, 0, 0])
        translate([0, 0, -4.5])
        builtin_washer();
      }
      
      // bottom plate
      linear_extrude(height=5)
      import("core_addon_bottom.dxf");
      
      // flanges for screw support
      for (i=[0, 1]) mirror([i, 0, 0])
      translate([-35.73, 0, 0])
      rotate([0, 0, -45])
      for (j=[0, 1]) mirror([j, 0, 0])
      translate([18.25, -34.5, 0])
      cylinder(d=12, h=5, $fn=30);
    }
    
    if (!short) {
      for (xi=[0,1]) mirror([xi, 0, 0]) {
        // holes for bolts nearest the middle
        translate([-35.73, 0, height-15])
        rotate([0, 0, -15])
        translate([25.4/2+11, 0, 0])
        rotate([90, 0, 0])
        {
          cylinder(d=8.108, h=50, $fn=60);
          translate([0, 0, 24])
          cylinder(d=20, h=40, $fn=30);
        }
        
        // bolt hole and pocket for baring
        translate([-35.73, 0, height-15])
        rotate([0, 0, -135])
        translate([25.4/2+11, 0, 0])
        rotate([90, 0, 0]) {
          // bolt
          cylinder(d=8.108, h=27.4, $fn=60, center=true);
          
          // pocket for bearing
          hull() {
            cylinder(d=24, h=9, $fn=60, center=true);
            translate([-23, 0, 0])
            cylinder(d=24, h=9, $fn=60, center=true);      
          }
          
          // space for heads and socket
          for (j=[0,1]) mirror([0, 0, j])
          translate([0, 0, 27.301/2])
          cylinder(d=20, h=40, $fn=30);
          
          // hole to allow removing bearing
          rotate([0, 90, 0])
          cylinder(d=4.7, h=40, $fn=6);
        }
        
        // holes for bolts farthest from the middle
        translate([-35.73, -0.3, height-15])
        rotate([0, 0, 105])
        translate([25.4/2+11, 0, 0])
        rotate([-90, 0, 0]) {
          cylinder(d=8.308, h=27.4, $fn=60);
          translate([0, 0, 24])
          cylinder(d=20, h=40, $fn=30);
        }
      }
    }
    
    // holes in flange, oversize for fine adjustment
    for (i=[0, 1]) mirror([i, 0, 0])
    translate([-35.73, 0, 0])
    rotate([0, 0, -45])
    {
      for (j=[0, 1]) mirror([j, 0, 0])
      translate([18.25, -34.5, 0]) {
        translate([0, 0, -0.5])
        cylinder(d=5.2 + 1.2, h=6, $fn=30);
        translate([0, 0, 5])
        cylinder(d1=12, d2=9.5, h=35, $fn=30);
      }
    }
    
    // hole for lead screw and part of lead screw nut (10mm in size)
    translate([0, -93.797 + 69.6224, -1])
    cylinder(d=10.5, h=height+10, $fn=60);
    
    // hole for lead screw nut
    translate([0, -93.797 + 69.6224, height-6.5])
    cylinder(d=23, h=20, $fn=60);
    
    // holes for nut screws
    for (a=[0:3])
    translate([0, -93.797 + 69.6224, height-20])
    rotate([0, 0, 45+90*a])
    translate([8, 0, 0])
    cylinder(d=3, h=20, $fn=30);
  }

  if (!short) {
    // builtin washers for pocket bearings
    for (i=[0, 1]) mirror([i, 0, 0])
    translate([-35.73, 0, height-15])
    rotate([0, 0, -135])
    translate([25.4/2+11, 0, 0])
    rotate([90, 0, 0])
    for (zi=[0,1]) mirror([0, 0, zi])
    translate([0, 0, -4.5])
    builtin_washer(8.108);
  }
}


module builtin_washer(holesize=0) {
  // d1=12.5, d2 = 10.5
  difference() {
    //cylinder(d1=12.5, d2=10.5, h=1, $fn=36);
  
    translate([0, 0, -1]) cylinder(d1=14.5, d2=10.5, h=2, $fn=36);
    if (holesize) {
      translate([0, 0, -1.5])
      cylinder(d=holesize, h=3, $fn=36);
    }
  }
}

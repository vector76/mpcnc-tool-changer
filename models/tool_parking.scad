pin_d = 5;
pin_len = 20;
stance_w = 55;
stance_h = 90;
plate_th = 5;

strut_th = 3.2;
strut_len = 80;

yzlist = [[-stance_w/2, 0], [stance_w/2, 0], [0, stance_h]];

part = "";

if (part == "parking") {
  parking_hooks();
}

if (part == "hanger") {
  rotate([0, 90, 0]) pin_hangers();
}

if (part == "dw660_hanger") {
  dw660_hanger();
}

if (part == "") {
  %parking_hooks();
  dw660_hanger();
}



module dw660_hanger() {
  pin_hangers();
  
  translate([65, 0, -10])
  rotate([0, 0, -90])
  dw660_assembly();
  
  for (i=[0,1]) mirror([0, i, 0])
  hull() {
    translate([46, 25, 2])
    sphere(d=3, $fn=12);

    translate([46, 25, -8])
    sphere(d=3, $fn=12);
    
    translate([24, 25, 16])
    sphere(d=3, $fn=12);
    
    translate([15, 25, 6])
    sphere(d=3, $fn=12);
  }
  
  for (i=[0,1]) mirror([0, i, 0])
  translate([23, 15, 47.5])
  rotate([10, 0, 0])
  cube([10, 3.2, 80]);
  
  for (i=[0,1]) mirror([0, i, 0])
  translate([13, 15, 20])
  cube([10, 3.2, 40]);
  
  translate([34, 0, 0])
  rotate([0, -42, 0])
  translate([0, -15, 0])
  cube([3.2, 30, 20]);
  
  translate([4, -15, 126])
  cube([30, 30, 2]);
}


module dw660_assembly() {
  translate([0, 0, 25*4]) {
    translate([0, 0, 3-14])
    translate([-102.5, -102.6, 0])
    import("../imported/MPCNC DW660 Mount/660_Upper_Lock_V1.STL");

    %translate([0, 0, 3])
    rotate([0, 180, 0])
    translate([-102.5, -102.5, 0])
    import("../imported/MPCNC DW660 Mount/660_Upper_Mount_V1.STL");
  }

  %rotate([0, 180, 0])
  translate([-102.5, -102.5, -14])
  import("../imported/MPCNC DW660 Mount/660_Low_Mount_V1.STL");

  rotate([0, 180, 0])
  translate([-102.5, -134.423, -14])
  import("../imported/MPCNC DW660 Mount/660_Low_Lock_V1.STL");
}



module hideif(x) {
  if (x) {
    %children();
  }
  else {
    children();
  }
}


module pin_hangers() {
  for (i=[0:2])
  translate([0, yzlist[i][0], yzlist[i][1]])
  pin_hanger();
  
  hull()
  for (i=[0:2])
  translate([0, yzlist[i][0], yzlist[i][1]])
  pin_hanger_plate(3);
  
}


module pin_hanger_plate(th=2) {
  extra_len = 3;  // extra room lengthwise
  extra_d = 4;  // extra depth up/out
  
  rotate([0, 45, 0]) 
  intersection() {
    translate([0, 0, pin_d/2+pin_len/2])
    translate([-5-extra_d, -5, 0])
    cube([11+extra_d, 10, pin_len/2+extra_len+30]);
    
    translate([10, 0, -10])
    translate([5, -25, pin_d/2+pin_len+extra_len])
    rotate([0, -45, 0])
    cube([th, 50, 50]);    
  }
}


module pin_hanger() {
  extra_len = 3;  // extra room lengthwise
  extra_d = 4;  // extra depth up/out
  hanger_pin_d = 6;
  
  rotate([0, 45, 0])
  difference() {
    translate([0, 0, pin_d/2+pin_len/2])
    translate([-5-extra_d, -5, 0])
    cube([11+extra_d, 10, pin_len/2+extra_len+30]);
    
    translate([hanger_pin_d/2-pin_d/2, 0, 0])
    cylinder(d=hanger_pin_d, h=50, $fn=24);
    
    translate([10, 0, -10])
    translate([5, -25, pin_d/2+pin_len+extra_len])
    rotate([0, -45, 0])
    cube([50, 50, 50]);
  }
}


module parking_hooks() {
  // holes for pins
  for (i=[0:2])
  translate([0, yzlist[i][0], yzlist[i][1]])
  pin_anchor(i!=2);

  // front plate
  hull()
  for (i=[0:2])
  translate([0, yzlist[i][0], yzlist[i][1]])
  pin_anchor_plate(plate_th);

  // supporting strut
  hull() {
    translate([-plate_th, -strut_th/2, 0])
    cube([1, strut_th, 107]);

    translate([-plate_th-strut_len, -strut_th/2, 0])
    cube([strut_len+1, strut_th, 1]);
  }

  // support middle joint a bit
  translate([-15-plate_th+0.1, -15, 0])
  cube([15, 30, 2]);

  // screws
  for (i=[0, 1]) mirror([0, i, 0])
  translate([-strut_len+7-plate_th, strut_th/2, 0])
  rotate([0, 0, 90])
  screwdown_foot();
  
  for (i=[0, 1]) mirror([0, i, 0])
  translate([-plate_th, 27, 0])
  rotate([0, 0, 180])
  screwdown_foot();
}


module screwdown_foot() {
  difference() {
    translate([-1, -5, 0])
    cube([11, 10, 4]);
    translate([5, 0, -0.5])
    cylinder(d=3.6, h=5, $fn=12);
  }
}


module pin_anchor_plate(th=1) {
  translate([-th, -pin_d, 0])
  cube([th, 2*pin_d, sqrt(2)*(pin_len/2+pin_d/2)]);
}


module pin_anchor(cutbase = 1) {
  bonus = 10;
  rotate([0, 45, 0])
  translate([0, 0, pin_d/2])
  %cylinder(d=pin_d, h=pin_len, $fn=24);
  
  // surround for pin
  rotate([0, 45, 0])
  translate([0, 0, pin_d/2])
  difference() {
    union() {
      hull() {
        // basic cylindrical surround
        translate([0, 0, -pin_d/2-bonus])
        cylinder(d=2*pin_d, h=pin_len/2+pin_d/2+bonus);
        
        // extend to plane
        translate([-pin_len/2-pin_d/2, 0, -pin_d/2])
        cylinder(d=2*pin_d, h=pin_len/2+pin_d/2);
      }
    }
    
    // carve out pin
    translate([0, 0, 0.1])  // extra 0.1 to avoid manifold issues
    cylinder(d=pin_d, h=pin_len/2+1, $fn=24);
    
    translate([0, 0, -pin_d/2])
    rotate([0, -45, 0]) {
      if (cutbase) {
        // remove floor
        translate([0, 0, -100])
        cylinder(d=100, h=100, $fn=4);
      }
      
      // remove back wall
      translate([-50.1, -25, -25])
      cube([50, 50, 50]);
    }
  }
  
}
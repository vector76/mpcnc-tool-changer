// Supposed to be 5mm and 3mm pins but could 1/4" (6.35 mm) and 1/8" (3.175) fit?
shaft_d = 5; // 25.4/4;  // 5; // shaft diameter is 5mm (goes into a hole that's 7mm across)
pin_d = 3; // 25.4/8; // 3;  // shaft pin is 3mm wide (goes into a slot that's 4.5mm wide)
pin_len = 12;  // shaft pin is 12mm long (goes into a slot that's 15mm long)
e3d_draw_length = 1;  // about 1.0 mm of clamping
jubilee_draw_length = 1.6;  // for 'default' jubilee, but we can customize
closed_gap = 2;  // in E3D locked position, distance from cleat surface to blank surface
open_gap = closed_gap + e3d_draw_length;
front_plate_th = 2;  // thickness of cleat front plate
shaft_len = 26;
shaft_end_unlocked = 8.9;  // In unlocked position, tip is about 8.9 mm from blank outer surface
draw_length = jubilee_draw_length;
shaft_end_locked = shaft_end_unlocked + draw_length;
locking_surface = shaft_end_locked - 4 - 1.5;
unlocked_surface = shaft_end_unlocked - 4 - 1.5;
J_rail_center_dist = 2*35.73;
rail_offset_dist = 25;
axis_edge_dist = 22.5;
bearing_od = 22;
// slot gap, bar_w, bar_thickness, num_slices, ring_wall_th
spring_params = [ .3, 1.2, 1, 5, 2.4 ];
tube_ht = 16.5;

double_cleat = 0;

screw_size = "num6";   // num6 or M5

// "" or "all" or:
// plate_a, plate_b, tool_plate, tool_plate_quick, drill_guide, pulley, servo_bracket, back_plate
part = "servo_bracket";  

quickrender = ((part == "tool_plate") ? 0 : 1);

// #########################################
// Batch processing

if (part == "plate_b" || part == "all") {
  translate([-105, -45, -2+5])
  plate_b(1);
}
if (part == "plate_a" || part == "all") {
  translate(part == "all" ? [35, -45, 4+5] : [0, 0, 0])
  rotate([0, 180, 0])
  plate_a(1);
}
if (part == "tool_plate" || part == "tool_plate_quick" || part == "all") {
  translate([-35, -45, 0+5]) {
    rotate([0, 180, 0])
    tool_plate(1);
  }
}
if (part == "drill_guide" || part == "all") {
  translate([35, 80, 5])
  drill_guide2();
}
if (part == "pulley" || part == "all") {
  translate(part == "all" ? [-15, 70, 0] : [0, 0, 0])
  translate([0, 0, 11.5 + 5])
  rotate([180, 0, 0])
  shaft_collar();
}
if (part == "servo_bracket" || part == "all") {
  translate(part == "all" ? [-75, 100, 5] : [0, 0, 0])
  servo_bracket();
}
if (part == "wire_string_link" || part == "all") {
  translate(part == "all" ? [15, 110, 5] : [0, 0, 0])
  wire_string_link();
  
  translate(part == "all" ? [5, 100, 5] : [0, -10, 0])
  wire_string_cap() ;
}
if (part == "back_plate" || part == "all") {
  translate(part == "all" ? [75, 100, -closed_gap-14+5]: [0, 0, -closed_gap-14])
  back_plate();
}
if (part == "") {
  // #########################################
  // Balls
  %balls(double_cleat);

  // #########################################
  // Blank tool plate
  *tool_plate(double_cleat);

  translate([0, 0, 2])
  back_plate();

  // #########################################
  // Cleat plates
  shaft_assembly(complete=1, engaged=0);

  *translate([0, 0, e3d_draw_length])
  plate_a(double_cleat);

  translate([0, 0, e3d_draw_length+front_plate_th+0.0])
  plate_b(double_cleat);

  // #########################################
  // J rail visualization
  *rail_visualize(50);

  // #########################################
  // Servo mount (up is up)

  *translate([0, -axis_edge_dist-5, rail_offset_dist])
  rotate([90, 0, 0])
  union() {
    %for (i=[0, 1]) mirror([i, 0, 0])
    translate([J_rail_center_dist/2, 0, 0])
    cylinder(d=25.4, h=50, $fn=60);
    
    servo_bracket();
    
    rotate([-90, 0, 0])
    translate([0, -17, -32])
    rotate([0, 0, -90]) {
      %servo_model();
      *servo_model(1);
    }
  }
}

// #########################################
// Modules



module back_plate() {
  plate_w = 19.6;
  plate_th = 3;
  extra_len = 12;
  rib_w = 5;
  rib_h = 8;
  
  //%translate([0, 0, plate_th-1])
  difference() {
    union() {
      // main plate
      translate([-plate_w/2, -22.5-extra_len/2, closed_gap+14])
      cube([plate_w, 120+extra_len, plate_th]);
      
      translate([-rib_w/2, -22.5, closed_gap+14+plate_th])
      cube([rib_w, 120, rib_h]);
    }
    
    for (i=[0,1]) translate([0, i*75, 0]) rotate([0, 0, 180*i]) {
      translate([0, -22.5-1.6, closed_gap+14-1])
      cylinder(d=3.2, h=12, $fn=12);
      

      translate([0, -22.5-1.6, closed_gap+14+plate_th])
      cylinder(d=7, h=12, $fn=24);

      translate([6, 29, closed_gap+14-1])
      cylinder(d=3.2, h=12, $fn=12);
      
      translate([0, 0, closed_gap+14-1])
      cylinder(d=2.8, h=15, $fn=12);      
      
      translate([0, 0, closed_gap+14+plate_th+3])
      cylinder(d=7, h=12, $fn=24);
      
    }
  }
}


module wire_string_cap() {
  wire_diam = 0.047 * 25.4;  // about 1.19 mm
  wall = 1.6;
  block_h = 5;
  block_w = 10;
  margin = .1;
  
  difference() {
    // main cap block
    cube([block_w + 2*wall+2*margin, block_h+2*wall+2*margin, 5+wall]);
    
    // cavity for block
    translate([wall, wall, wall])
    cube([block_w+2*margin, block_h+2*margin, 5+0.1]);
    
    // internal recesses for securing
    for (x=[wall, wall+2*margin+block_w])
    translate([x, wall, wall+1+.1])
    rotate([-90, 0, 0])
    cylinder(d=2.2, h=block_h+2*margin, $fn=12);
    
    // hole for wire to go through
    translate([block_w/2+wall-1.5-wire_diam/2, block_h/2+wall-wire_diam/2, -0.5])
    cube([3+wire_diam+2*margin, wire_diam+2*margin, wall+1]);
    
    // bevel an edge so it's less likely to catch
    translate([wall, -1, 5+wall])
    rotate([0, -90-55, 0])
    cube([5, 10, 5]);
  }
}


module wire_string_link() {
  wire_diam = 0.047 * 25.4;  // about 1.19 mm
  hook_w = 3;  // effective width of hook as far as centering
  block_h = 5;
  block_w = 10;
  block_len = 30;
  hook_len = 5;
  extra_len = 7;  // length in x direction of string guide block
  rib_w = 1.6;
  
  // visualize the hook
  translate([0, block_w/2-hook_w/2, block_h/2]) {
    rotate([0, 90, 0])
    %cylinder(d=wire_diam, h=50, $fn=24);
       
    rotate([-90, 0, 0])
    %cylinder(d=wire_diam, h=10, $fn=12);
  }
  
  difference() {
    union() {
      // main block
      cube([block_len, block_w, block_h]);
      
      // ribs
      difference() {
        for (i=[0,1])
        translate([-hook_len-extra_len, 10*i, 0]) mirror([0, i, 0])
        cube([hook_len+extra_len+0.1, rib_w, block_h]);
        
        translate([-hook_len, -0.5, block_h/2])
        rotate([-90, 0, 0])
        cylinder(d=3, h=block_w+1, $fn=6);
      }
      
      // extension for string
      translate([-hook_len-extra_len, 0, 0]) {
        cube([extra_len, block_w, block_h]);
        cube([hook_len+extra_len+0.1, block_w, block_h/2-wire_diam/sqrt(2)]);
      }
      
      // nub for spring clip
      translate([block_len-1, block_w, 0])
      cylinder(d=2, h=block_h, $fn=12);
      
      // nub on opposite side too
      translate([block_len-1, 0, 0])
      cylinder(d=2, h=block_h, $fn=12);
      
    }

    // slot for clip springy
    translate([block_len/3, block_w-2-1.6, -0.5])
    cube([block_len*2/3+1, 2, block_h+1]);
    

    // chunk out of middle
    translate([block_len/3, block_w/2-hook_w/2-wire_diam-0.1, block_h/2-+wire_diam/sqrt(2)])
    cube([block_len/2, 2*wire_diam+0.2, block_h/2+wire_diam/sqrt(2)+0.1]);
    
    // cutout relative to the vertex of the hook
    translate([0, block_w/2-hook_w/2, block_h/2]) {
      // horizontal slot for the wire
      for (i=[0,1]) translate([i*2*block_len/3, i*wire_diam/2, 0]) {
        hull() {
          // main channel
          rotate([0, 90, 0])
          cylinder(d=wire_diam*sqrt(2), h=block_len/3+0.1, $fn=4);
          
          // offset channel so it can settle into main channel
          translate([-0.1, -wire_diam/2, 0])
          rotate([0, 90, 0])
          cylinder(d=wire_diam*sqrt(2), h=block_len/3+0.1, $fn=4);
        }
        
        // slot for inserting vertically
        hull() {
          for (z=[0,10])
          translate([-0.1, -(1-i)*wire_diam/2, z])
          rotate([0, 90, 0])
          cylinder(d=wire_diam+0.2, h=block_len/3+0.2, $fn=24);
        }
      }
      
      // recess for base of hook and offset
      hull() {
        for (x=[0, -wire_diam/sqrt(2)])
        rotate([-90, 0, 0])
        translate([x, 0, -wire_diam/2])
        cylinder(d=wire_diam*sqrt(2), h=10, $fn=4);        
      }
      
    }
    // now carve out space so it can be inserted at an angle
    hull() {
      for (a=[0, 30])
      translate([-wire_diam/sqrt(2), block_w-rib_w/2, block_h/2])
      rotate([-90-a, 0, 0])
      cylinder(d=wire_diam*sqrt(2), rib_w*2, $fn=4);
    }
    hull() {
      for (a=[0, 30])
      translate([-wire_diam/sqrt(2), block_w-rib_w/2, block_h/2])
      rotate([-270-a, 0, 0])
      cylinder(d=wire_diam*sqrt(2), rib_w*2, $fn=4);
    }
    
    // hole for string
    for (y=[3, 7])
    translate([-hook_len-extra_len, 0, 0])
    translate([-0.5, y, block_h/2])
    rotate([0, 90, 0])
    cylinder(d=2.5, h=extra_len+1, $fn=4);
    
    // slant so it's less likely to catch
    translate([-hook_len-extra_len+4.5, -1, -1])
    rotate([0, 0, 180-30])
    cube([10, 10, 10]);
  }
    
  // cleats for tying off string
  for (i=[0,1])  translate([20*i, 0, 0])
  translate([-hook_len-extra_len/2, 0, 0])
  translate([0, block_w-0.1, 0])
  rotate([0, 0, 90])
  {
    translate([0, -6, 0])
    cube([2, 12, 2]);
    
    for (i=[0,1]) mirror([0, i, 0])
    translate([1.8, 0, 0])
    rotate([0, 0, -8])
    cube([2, 6, 2]);
    
    for (i=[0,1]) mirror([0, i, 0])
    translate([3.6, 0, 0])
    rotate([0, 0, -16])
    cube([2, 6, 2]);
  }
}


module drill_guide2() {
  translate([0, 0, 5])
  difference() {
    translate([0, 0, -5])
    cylinder(d=50, h=5+2.5);
    rotate([0, 90, 0])
    translate([0, 0, -22]) {
      // visualize where pin goes
      %cylinder(d=5, h=26, $fn=30);
      
      // ejection pin
      translate([0, 0, -10])
      cylinder(d=2, h=50, $fn=4);
      
      hull() {
        // main bore
        cylinder(d=5, h=50, $fn=30);
        
        // generate sloped sides
        for (a=[-20, 20]) rotate([0, 0, 180+a])
        translate([0, -2.5, 0])
        cube([10, 5, 50]);
      }
    }
    
    // locating hole
    translate([0, 0, -6])
    cylinder(d=3, h=10, $fn=24);
  }
}


module nut_hole(head_ht = 15) {
  if (screw_size == "num6") {
    num6_nut_hole(head_ht);
  }
  else if (screw_size == "M5") {
    m5_nut_hole(head_ht);
  }
  //
}


module num6_nut_hole(head_ht = 15) {
  cylinder(d=4.05, h=30, $fn=60);
  cylinder(d1=9.56, d2=9.34, h=5.25, $fn=6);
  translate([0, 0, head_ht])
  cylinder(d=6.2, h=30-head_ht, $fn=60);  
}


module m5_nut_hole(head_ht = 15) {
  cylinder(d=5.2, h=30, $fn=60);
  cylinder(d1=9.63, d2=9.24, h=5.25, $fn=6);
  translate([0, 0, head_ht])
  cylinder(d=10.5, h=30-head_ht, $fn=60);
}


module servo_bracket() {
  for (i=[0, 1]) mirror([i, 0, 0]) {
    translate([J_rail_center_dist/2, 0, 0])
    difference() {
      union() {
        // main body tube
        cylinder(d=25.4+10, h=tube_ht, $fn=60);
        
        // blocks for M5 screw engagement
        for (i=[0,1]) mirror([i, 0, 0])
        translate([25.4/2, -5.1, 0])
        cube([16, 15, tube_ht]);
        
        // extra to connect two sides together
        translate([-J_rail_center_dist/2-0.1, -5.1, 0])
        cube([10, 5.1, tube_ht]);
      }
      
      // inner bore for rail
      translate([0, 0, -0.5])
      cylinder(d=25.4, h=tube_ht+1, $fn=60);
      
      // slice for clamping
      translate([-50, -1.5, -0.5])
      cube([100, 3, tube_ht+1]);
      
      // nut hole
      for (i=[0,1]) mirror([i, 0, 0])
      translate([25.4/2+7, 10, tube_ht/2])
      rotate([90, 0, 0])
      rotate([0, 0, 90])
      nut_hole();  // m5 or number 6
      
    }
  }
  
  // bracket to actually hold servo
  difference() {
    union() {
      // big block to hold servo
      translate([-20, -32-10, 0])
      cube([30, 10, 56]);
      
      // floor
      translate([-J_rail_center_dist/2-5, -40, 0])
      cube([J_rail_center_dist+10, 25, 5]);
      
      // web to connect servo holder so it won't flex
      hull() {
        translate([-J_rail_center_dist/2, -25.4/2-5+2.4/2, 0])
        cylinder(d=2.4, h=tube_ht, $fn=36);
      
        translate([-20+2.4/2, -32-2.4/2, 0])
        cylinder(d=2.4, h=56, $fn=36);
      }
    }
    // cut out servo
    rotate([-90, 0, 0])
    translate([0, -17, -32])
    rotate([0, 0, -90])
    servo_model(1);
    
    // cutout extra material to clear servo mounting holes
    translate([-21/2, -32, -1])
    cube([21, 30, 7]);
    
    // punch hole so screw is accessible
    translate([-J_rail_center_dist/2+25.4/2+7, -10, tube_ht/2])
    rotate([90, 0, 0])
    cylinder(d=7.5, h=50, $fn=30);
    
    // carve out clearance for Z brackets
    translate([-J_rail_center_dist/2, 0, tube_ht])
    cylinder(d=25.4+16, h=50, $fn=30);
  }
  
  // approximate size and location of coupler if mounted at same height as coupler
  translate([0, 25.4/2+1.75+19/2, 0])
  %cylinder(d=19, h=15, $fn=60);
}


module servo_model(cutout=0) {
  e = cutout ? 0.4 : 0;
  translate([0, 0, 42-28+5])
  cylinder(d=36.5, h=2.6, $fn=36);
  
  translate([-9-e, -10-e, -28])
  cube([40+2*e, 20+2*e, 42]);
  
  translate([-9-(55-40)/2, -10-e, 0])
  cube([55, 20+2*e, 3.1]);
  
  if (cutout) {
    for (x=[-9-7.5+5.5/2, -9+47.5-5.5/2])
    for (y=[-9.9/2, 9.9/2])
    translate([x, y, -11])
    cylinder(d=2.9, h=12, $fn=12);
  }
}


module wire_holes() {  // wire holes factored out so it can be subtracted later
  wire_hole_d = 2;
  extra_len = 6;  // evenly divided on both sides
  bar_th = spring_params[2];
  // space for spring wires
  for (a=[0:2]) rotate([0, 0, a*120]) {
    for (altaz=[[-0.7,0], [.7, 180]]) // , [3, 6], [3, 6+180], [1.5, -6], [1.5, -6+180]])
    translate([0, -22/2-3.4, closed_gap+bar_th+4])
    rotate([0, 90-altaz[0]-3, -altaz[1]])
    translate([0, 0, 5]) 
    {
      hull() {
        cylinder(d=wire_hole_d, h=40, $fn=4);
        translate([-2, 0, 0])
        cylinder(d=wire_hole_d, h=40, $fn=4);
      }
    }
    
    translate([0, -22/2-3.4, closed_gap+bar_th+4])
    rotate([0, 90, 0])
    cylinder(d=wire_hole_d, h=10, $fn=4, center=true);
  }
}


module tube_and_screw_holes() {
  bolt_d = (screw_size == "M5") ? 5.2 : 4.05;
  bolt_head_d = (screw_size == "M5") ? 10 : 7;  // 6.2 is enough for num6 but give extra room
  
  for (i=[0, 1]) mirror([i, 0, 0])
  translate([J_rail_center_dist/2, -axis_edge_dist, rail_offset_dist-e3d_draw_length-front_plate_th]) {
    // tubes (shifted slightly to clip both ends
    translate([0, -0.5, 0])
    rotate([-90, 0, 0])
    cylinder(d=25.4, h=61, $fn=120);
    
    // holes for M5 bolts
    rotate([-90, 0, 0])
    for (z=[22.5, 120-22.5])
    translate([0, 0, z])
    rotate([0, 90, 135]) {
      // main bolt
      cylinder(d=bolt_d, h=25.4/2+8.1, $fn=24);
      translate([0, 0, 25.4/2+8.05])
      // larger hole for head
      cylinder(d=bolt_head_d, h=5+10, $fn=24);
    }
  }
}


module triple_cleat_plate_b_combined(junction=0) {
  rail_shift = 0;
  
  difference() {
    union() {
      // basic plate b
      triple_cleat_plate_b(junction);

      // add bars for Z rails to ride on
      for (i=[0, 1]) mirror([i, 0, 0]) {
        translate([32-10, -axis_edge_dist+rail_shift, closed_gap])
        cube([10, 60.1-rail_shift, 9]);  // slighly oversize so a pair will not leave a gap
        
        translate([J_rail_center_dist/2, rail_shift, rail_offset_dist-e3d_draw_length-front_plate_th])
        rotate([0, 45, 0])
        translate([-5, -axis_edge_dist, -25.4/2-8])
        cube([10, 60.1-rail_shift, 10]);
      }
      
      // add ribs to stiffen against bending
      for (y=[-axis_edge_dist, 30-2.4/2])
      translate([-32, y, closed_gap])
      cube([64, 2.4, 14]);
      
      // spot for M3 screws to attach back plate
      translate([0, -22.5-1.6, closed_gap])
      cylinder(d=8, h=14, $fn=24);
      
      translate([6, 29, closed_gap])
      cylinder(d=8, h=14, $fn=24);
      
    }
    
    // punch holes for wires
    wire_holes();
    *%wire_holes();
    
    // carve out tubes
    tube_and_screw_holes();
    
    // round corners
    for (i=[0, 1]) mirror([i, 0, 0])
    translate([-32, -axis_edge_dist, 0])
    corner_rounder();
    
    // slots for cables/wires
    // narrow part of pulley is 24
    for (i=[0, 1]) mirror([i, 0, 0])
    for (y=[-axis_edge_dist, 30-2.4/2])
    translate([12-4/2+1.2, y-1, closed_gap+front_plate_th+2])
    cube([3, 7, 8]);
    
    // holes for M3 screws to attach back plate
    translate([0, -22.5-1.6, closed_gap+2.1]) {
      cylinder(d=2.8, h=12, $fn=12);
      translate([0, 0, 9])
      cylinder(d=3.1, h=3, $fn=12);
    }
    
    translate([6, 29, closed_gap+2.1]) {
      cylinder(d=2.8, h=12, $fn=12);
      translate([0, 0, 9])
      cylinder(d=3.1, h=3, $fn=12);
    }
    
    // carve out chunk for plate
    plate_w = 20;
    plate_th = 3;
    extra_len = 12;
    translate([-plate_w/2, -22.5-extra_len/2, closed_gap+14-1])
    cube([plate_w, 120+extra_len, plate_th+1]);
    
  }
}


module shaft_assembly(complete=0, engaged=0) {
  rotate([0, 0, 130 * (engaged ? 1 : 0)])
  translate([0, 0, -shaft_end_unlocked + spring_params[2]-draw_length*(engaged ? 1 : 0)]) {
    shaft();
    if (complete) {
      translate([0, 0, 9.9+closed_gap+front_plate_th]) {
        shaft_collar();
        %shaft_bearing();
      }
    }
  }
}


module rail_visualize(extralong=0) {
  for (xi=[0, 1]) mirror([xi, 0, 0])
  translate([J_rail_center_dist/2, -axis_edge_dist, rail_offset_dist])
  rotate([-90, 0, 0]) {
    translate([0, 0, -extralong])
    %cylinder(d=25.4, h=120+extralong);

    for (a=[-45, -45+105, -45+240]) rotate([0, 0, a]) {
      %translate([25.4/2, -7/2, 0])
      cube([22, 7, 120]);

      if (a != -45) {
        //for (i=[0, 1]) mirror([0, i, 0])
        mirror([0, (a == -45+240) ? 1 : 0, 0])
        %translate([25.4/2+11-15/2, 7/2, 0])
        cube([15, 6, 120]);
      }
    }
    
    %for (z=[22.5, 120-22.5])
    translate([0, 0, z])
    rotate([0, 90, 135])
    cylinder(d=5, h=33, $fn=24);
  }
}


module tool_plate(double=0) {
  if (!double) {
    tool_blank_plate();
  }
  else {
    tool_blank_plate(1);
    rotate([0, 0, 180])
    translate([0, 2*axis_edge_dist-120, 0])
    tool_blank_plate(1);
  }
}


module tool_blank_plate(junction=0) {
  rotate([180, 0, 0]) {
    jubilee_wedge();
    simplified_blank(junction);
  }
}



module plate_b(double = 0) {
  if (!double) {
    triple_cleat_plate_b_combined();
  }
  else {
    triple_cleat_plate_b_combined(1);
    rotate([0, 0, 180])
    translate([0, 2*axis_edge_dist-120, 0])
    triple_cleat_plate_b_combined(1);
  }
}


module plate_a(double=0) {
  if (!double) {
    triple_cleat_plate_a();
  }
  else {
    triple_cleat_plate_a(1);
    rotate([0, 0, 180])
    translate([0, 2*axis_edge_dist-120, 0])
    triple_cleat_plate_a(1);
  }
}

module drill_guide_half() {
  block_d = 15;
  difference() {
    cube([20, block_d, block_d/2]);
    
    translate([-0.5, block_d/2, block_d/2])
    rotate([0, 90, 0])
    cylinder(d=5, h=21, $fn=60);
    
    translate([4, block_d/2, -0.5])
    cylinder(d=3, h=block_d+1, $fn=24);
  }
}
module pill(d, ex) {
  translate([0, 0, -ex/2])
  cylinder(d=d, h=ex, $fn=60);
  for (z=[ex/2, -ex/2])
  translate([0, 0, z])
  sphere(d=d, $fn=60);
}


module ball_socket_kinematic2() {
  // sphere(d=8, $fn=36);

  difference() {
    translate([0, 0, -e3d_draw_length+0.5])
    cylinder(d=12, h=3+e3d_draw_length);
    
    translate([0, 0, -e3d_draw_length-1])
    rotate([-90, 0, 0])
    rotate([0, 0, 45])
    intersection() {
      translate([1, 0, 0])
      pill(10, 4);
      translate([0, 1, 0])
      pill(10, 4);
    }
  }
}


module simplified_blank(junction=0) {
  ball_sm_ang = asin(3.1/4);
  // echo("ball_sm_ang: ", ball_sm_ang);
  ball_sm_d = cos(ball_sm_ang)*4*2;
  
  difference() {
    union() {
      translate([-32, -60+axis_edge_dist-(junction?1:0), 0])
      cube([64, 60+(junction?1:0), 2]);
      
      for (a=[0:2]) rotate([0, 0, 120*a])
      translate([0, -30, 0])
      cylinder(d=12, h=4.1+2);
      
      for (a=[0:2]) rotate([0, 0, 120*a])
      hull() {
        for (a2=[0, 120]) rotate([0, 0, a2])
        translate([0, -30, 0])
        cylinder(d=2.4, h=4.1+2, $fn=24);
      }
      
      for (a=[0:2]) rotate([0, 0, 120*a])
      hull() {
        for (yy=[-10, -30])
        translate([0, yy, 0])
        cylinder(d=2.4, h=4.1+2, $fn=24);
      }
      
      if (junction) {
        for (i=[0, 1]) mirror([i, 0, 0])
        hull() {
          for (yy=[0, -60]) translate([0, yy, 0])
          rotate([0, 0, 120])
          translate([0, -30, 0])
          cylinder(d=2.4, h=4.1+2, $fn=24);
        }
        hull() {
          for (yy=[-30, -40]) translate([0, yy, 0])
          cylinder(d=2.4, h=4.1+2, $fn=24);
        }
      }
    }
    
    for (j=[junction?1:0, 1]) translate([0, -j*(60-2*axis_edge_dist), 0]) mirror([0, j, 0])
    for (i=[0, 1]) mirror([i, 0, 0])
    translate([-32, -60+axis_edge_dist, -10])
    corner_rounder();
    
    wedge_punchout();
    
    rotate([180, 0, 0])
    balls(1);
    
    // balls cut out total height of 4.1
    for (a=[0:2]) rotate([0, 0, 120*a])
    translate([0, -30, 0])
    cylinder(d=ball_sm_d, h=6.2, $fn=36);
  }
}

module wedge_punchout(plate_th = 5) {
  translate([0, 0, -0.5])
  hull()
  for (a=[0, 120, 240]) rotate([0, 0, a])
  translate([0, -12])
  cylinder(d=7, h=plate_th, $fn=36);
}


module jubilee_ramp(ht_start = 1.5, ht_end = 3.6, ang_end = 120) {
  astep = quickrender ? 10 : 2;
  for (i=[0, 180]) rotate([0, 0, i])
  for (a=[0:astep:ang_end]) {
    hull() {
      rotate([0, 0, -a])
      translate([0, 0, 1.5+ht_start+(ht_end-ht_start)*a/ang_end])
      rotate([0, -90, 0])
      cylinder(d=3, h=7.6, $fn=36);

      rotate([0, 0, -(a+astep)])
      translate([0, 0, 1.5+ht_start+(ht_end-ht_start)*(a+astep)/ang_end])
      rotate([0, -90, 0])
      cylinder(d=3, h=7.6, $fn=36);
    }
  }
}



module jubilee_wedge(draw_length = draw_length) {
  lock_th = shaft_end_unlocked + draw_length - 4 - 1.5;  
  plate_th = lock_th;
  
  difference() {
    union() {
      hull()
      for (a=[0, 120, 240]) rotate([0, 0, a])
      translate([0, -12])
      cylinder(d=8, h=plate_th, $fn=36);
    }
    // ramp
    intersection() {
      translate([0, 0, -0.5])
      cylinder(d=15, h=plate_th+1, $fn=72);
      
      union() {
        jubilee_ramp(unlocked_surface, lock_th, 120);
        jubilee_ramp(unlocked_surface-1, lock_th, 60);
      }
    }
    
    // central hole and chamfer
    union() {
      translate([0, 0, -0.5])
      cylinder(d=6.2, h=plate_th+1, $fn=36);
      
      // chamfer on central hole
      translate([0, 0, -0.01])
      cylinder(d1=7.2, d2=6.2, h=.71, $fn=36);
    }
    
    // slot (intersection of cylinder and box)
    intersection() {
      union() {
        translate([0, 0, -0.5])
        cylinder(d=15, h=plate_th+1, $fn=72);
        
        // chamfer on ends of slot
        translate([0, 0, -0.01])
        cylinder(d1=16, d2=15, h=.71, $fn=72);
      }
      
      union() {
        translate([-18/2, -3.8/2, -0.5])
        cube([18, 3.8, plate_th+1]);
        
        // chamfer on sides of slot
        translate([0, 0, -0.01])
        linear_extrude(height=0.71, scale=[1, 3.8/4.8])
        translate([-18/2, -4.8/2, 0])
        square([18, 4.8]);
      }
    }
  }
}




module triple_cleat_plate_b(junction=0) {
  slot_gap = spring_params[0];
  bar_w = spring_params[1];
  bar_th = spring_params[2];
  num_slices = spring_params[3];
  ring_wall_th = spring_params[4];
  wing_thickness = 5;
  
  outer_perf_od = bearing_od+2*ring_wall_th+2*(num_slices*slot_gap+(num_slices-1)*bar_w);
  
  difference() {
    union() {
      translate([-32, -axis_edge_dist, closed_gap])
      cube([64, 60+(junction?1:0), front_plate_th]);
    }
    
    for (j=[0, junction?0:1]) translate([0, j*(60-2*axis_edge_dist), 0]) mirror([0, j, 0])
    for (i=[0, 1]) mirror([i, 0, 0])
    translate([-32, -axis_edge_dist, 0])
    corner_rounder();
    
    // hole for inner bearing race and shaft
    cylinder(d=15, h=10, $fn=32);
    
    // perforations
    rotate([0, 0, 360/16])
    for (i=[0:num_slices-1]) {
      for (a=[0:3]) rotate([0, 0, 90*a+5 + (i%2)*45])
      rotate_extrude(angle=80, $fn=60)
      translate([11+i*(slot_gap+bar_w)+ring_wall_th, 0, 0])
      square([slot_gap, 10]);
    }
    
    // punch a hole so the screw can reach through
    for (a=[0, 180])
    rotate([0, 0, a+-360/24])
    rotate_extrude(angle=360/12)
    translate([11+ring_wall_th, 0])
    square([outer_perf_od/2 - (11+ring_wall_th), 10]);
    
    // make it thinner
    translate([0, 0, closed_gap+bar_th])
    cylinder(d=outer_perf_od+0.2, h=5, $fn=60);
  }
  
  // bearing holder and spring wire posts
  difference() {
    union() {
      // outer wall to hold bearing
      translate([0, 0, closed_gap+bar_th-0.1])
      cylinder(d=22+2*ring_wall_th, h=7.1, $fn=60);
      
      // posts for spring wires
      for (a=[0:2]) rotate([0, 0, a*120])
      translate([0, 30, closed_gap+bar_th])
      cylinder(d=12, h=6);
      
      // ears for spring to pull up
      for (a=[0:2]) rotate([0, 0, 30+a*120])
      translate([11+ring_wall_th-0.3, 0, closed_gap+bar_th])
      rotate([90, 0, 0])
      translate([0, 0, -wing_thickness/2])
      linear_extrude(height=wing_thickness)
      polygon([[0, 0], [4, 3], [4, 7], [0, 7]]);
    }
    
    // perforations in cylinder so bearing fits more easily
    for (a=[-30, -150, -270]) rotate([0, 0, a])
    translate([0, -0.5, closed_gap+bar_th])
    cube([11+ring_wall_th+1, 1, 7.1]);
    
    // hole for bearing
    translate([0, 0, closed_gap+bar_th])
    cylinder(d=22, h=7.1, $fn=60);

    // slighly larger at bottom
    translate([0, 0, closed_gap+bar_th])
    cylinder(d1=22.3, d2=21.7, h=4, $fn=60);
    
    // hole for inner race and shaft
    cylinder(d=15, h=10, $fn=32);
    
  }
}


module corner_rounder() {
  translate([-0.1, -0.1, 0])
  difference() {
    translate([-1, -1, 0])
    cube([5, 5, 20]);
    
    translate([4, 4, -0.5])
    cylinder(d=8, h=21, $fn=24);
  }
}


module triple_cleat_plate_a(junction=0) {
  // three layers:
  // base layer "A" has ball receptacles and hole in center
  // spring layer "B" has slotted flexure, receptacle for bearing, and posts for spring wire
  // capture layer "C" has features to prevent bearing from rising from preload
  slot_gap = spring_params[0];
  bar_w = spring_params[1];
  num_slices = spring_params[3];
  ring_wall_th = spring_params[4];
  ring_sup_od = bearing_od+2*ring_wall_th+2*(num_slices*slot_gap+(num_slices-1)*bar_w)+2*ring_wall_th;
  
  difference() {
    union() {
      difference() {
        translate([-32, -axis_edge_dist, closed_gap])
        cube([64, 60+(junction?1:0), front_plate_th]);
        
        for (a=[0:2]) rotate([0, 0, a*120])
        translate([0, 30, closed_gap-0.1])
        cylinder(d=10, h=1);
      }
      
      // receptacle for balls
      for (a=[0:2]) rotate([0, 0, a*120])
      translate([0, 30, 0])
      ball_socket_kinematic2();
      
      // ring around the hole for stiffness/support
      translate([0, 0, -e3d_draw_length+0.5])
      cylinder(d=ring_sup_od, h=2+e3d_draw_length-0.5+0.1, $fn=60);
    }
    
    for (j=[0, junction ? 0 : 1]) translate([0, j*(60-2*axis_edge_dist), 0]) mirror([0, j, 0])
    for (i=[0, 1]) mirror([i, 0, 0])
    translate([-32, -axis_edge_dist, 0])
    corner_rounder();
    
    translate([0, 0, front_plate_th])
    tube_and_screw_holes();
    
    // cutout interior of supporting ring
    translate([0, 0, -e3d_draw_length+0.5-0.1])
    cylinder(d=ring_sup_od-2*ring_wall_th+0.2, h=20, $fn=60);
    
    // extra clearance for E3D screw positions (if we use pan-head instead of countersunk screws)
    for (x=[-15, 15])
    for (y=[-10, -10+22.5, -10+45])
    translate([x, y, -0.6])
    cylinder(d=7, h=2.1, $fn=24);
    
    // clearance for PCB
    for (i=[0,1]) translate([0, 75*i, 0]) rotate([0, 0, i*180])
    translate([18, -22.5+60, 0])
    translate([-10, -12.5, 0.7])
    {
      translate([-1, -1, 0])
      cube([20+2, 25+2, 1.5]);
      translate([0, -3, 0])
      cube([20, 7, 4]);
    }
  }
}


module shaft_bearing() {
  difference() {
    cylinder(d=22, h=7, $fn=60);
    translate([0, 0, -0.5])
    cylinder(d=8, h=8, $fn=30);
  }
}


module shaft_collar() {
  // joins shaft onto bearing for axial tension and also adds the pulleys
  difference() {
    union() {
      translate([0, 0, 7])
      cylinder(d=13, h=0.5);  // just thick enough that pulley doesn't rub outer race
      cylinder(d=8, h=7.1, $fn=24);
      
      translate([0, 0, 7.5])
      cylinder(d1=28, d2=24, h=2, $fn=48);
      translate([0, 0, 9.5])
      cylinder(d1=24, d2=28, h=2, $fn=48);
    }
    
    // central hole for metal shaft
    translate([0, 0, -0.5])
    cylinder(d=5, h=20, $fn=24);
    
    // slots for adding glue
    for (a=[0, 90]) rotate([0, 0, a])
    translate([-3.2, -0.5, -0.5])
    cube([6.4, 1, 20]);
    
    // holes for thread
    for (a=[0, 180]) rotate([0, 0, a]) {
      translate([12, 0, 9.5])
      rotate([0, -55, 0])
      translate([0, 0, -1])
      cylinder(d=2, h=10, $fn=4);
      
      for (y=[-1.5,1.5])
      translate([7, y, 6.5])
      cylinder(d=2, h=10, $fn=4);
    }
  }
}


module shaft() {
  // according to the Jubilee version "E3D compatible"
  // There's a bevel on the end at 30 degree taper angle and 1.5 mm length
  // And center of cross pin hole is 4mm from the end  (from E3D I had estimated 11-6.75 = 4.25)

  clip_d = shaft_d+2;

  %union() {
    // tapered portion
    cylinder(r1=shaft_d/2-1.5*tan(30), d2=shaft_d, h=1.5, $fn=24);
    
    // main portion
    translate([0, 0, 1.5])
    cylinder(d=shaft_d, h=shaft_len-1.5, $fn=24);
    
    // cross peg
    translate([0, 0, 4])
    rotate([0, 90, 0])
    cylinder(d=pin_d, h=pin_len, center=true, $fn=24);
  }
}


module balls(double = 0) {
  // locating spheres on a 60mm diameter circle
  for (a=[0, 120, 240]) rotate([0, 0, a])
  translate([0, 30, -1]) {
  sphere(d=8, $fn=36);
  }
  
  if (double) {
    translate([0, 120-2*axis_edge_dist, 0]) rotate([0, 0, 180])
    balls();
  }
}



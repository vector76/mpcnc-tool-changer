tube_d = 25.4;
hole_z_offset = 14;
tube_len = 130;  // how much extension above wheel surface
plate_thickness = 12;
bearing_od = 22;
bearing_w = 7;
spool_motor_dist = 80.0556;  // mm from center of wheel to center of motor gears
motor_ang = 15;
part = "carousel_plate";

if (part == "corner_post") {
  corner_post();
}
if (part == "") {
  rotate([0, 0, -90])
  translate([0, 0, -41 - 2])
  rotate([-90, 0, 0])
  translate([0, 0, -30])
  import("carousel_corner_post.stl");
  
  % cylinder(d=25.4, h=tube_len);
  
  %carousel_plate();
  cap_bearing_holder();
  
  for (a=[0, 120, 240])
  rotate([0, 0, -15+a])
  translate([-(25.4+22)/2, 0, plate_thickness])
  rotate([0, 0, 45]) {
    base_roller();
    translate([0, 0, 5+7])
    base_roller_cap(1);
  }
  motor_rigid_mount();
}
if (part == "cap_bearing_struts" || part == "") {
  cap_bearing_struts();
}
if (part == "cap_bearing_holder") {
  translate([0, 0, -tube_len])
  cap_bearing_holder();
}
if (part == "base_roller") {
  base_roller();
}
if (part == "base_roller_cap") {
  base_roller_cap();
}
if (part == "motor_rigid_mount") {
  motor_rigid_mount();
}
if (part == "carousel_plate") {
  projection()
  carousel_plate();
}

module motor_rigid_mount() {
  motor_size = 42;
  motor_len = 38;
  strap_th = 3.2;
  strap_w = 12;
  plate_w = 13;
  
  rotate([0, 0, motor_ang])
  translate([spool_motor_dist, 0, plate_thickness])
  rotate([0, 0, -motor_ang]) {
    // motor visual
    translate([-motor_size/2, -motor_size/2, -plate_thickness])
    %cube([motor_size, motor_size, motor_len]);
    
    difference() {
      union() {
        // motor strap
        translate([-motor_size/2-strap_th, -motor_size/2-strap_th, 0])
        cube([motor_size+2*strap_th, motor_size+2*strap_th, strap_w]);
        
        // plate for attachment
        translate([-plate_w-strap_th-motor_size/2, -motor_size/2-strap_th, 0])
        cube([plate_w+1, motor_size+2*strap_th, 3]);
        
        // small side plate
        translate([motor_size/2-10, -motor_size/2-strap_th-10, 0])
        cube([12, 11, 3]);
        
        // block for screw
        translate([motor_size/2+strap_th-1, -5, 0])
        cube([11, 12, strap_w]);
        
        // floor for screw block for better stiffness/clamping
        translate([motor_size/2+strap_th-1, -15, 0])
        cube([11, 30, 2]);
      }
      
      // motor cutout
      translate([-motor_size/2, -motor_size/2, -1])
      cube([motor_size, motor_size, motor_len]);
      
      // slot for clamp
      translate([0, -1.5, -0.5])
      cube([100, 3, strap_w+1]);
      
      // holes for screw clamping
      translate([motor_size/2+strap_th+4, 0, strap_w/2])
      rotate([90, 0, 0]) {
        cylinder(d=3.6, h=10, $fn=12);
        translate([0, 0, -10])
        cylinder(d=2.9, h=10, $fn=12);
      }
      
      // holes for attachment plate
      for (y=[motor_size*.35, -motor_size*.35])
      hull()
      for (x=[-1,1])
      translate([-motor_size/2-strap_th-plate_w/2+x, y, -1])
      cylinder(d=3.6, h=5, $fn=12);
      
      // hole in side plate
      hull()
      for (x=[0,2])
      translate([motor_size/2-5+x, -motor_size/2-strap_th-5, -1])
      cylinder(d=3.6, h=5, $fn=12);
      
    }
  }
}


module base_roller_cap(flip=0) {
  doflip = flip ? 1 : 0;
  
  translate([0, 0, 4*doflip])
  rotate([0, 180*doflip, 0])
  difference() {
    union() {
      cylinder(d=15, h=4, $fn=24);
      translate([0, -7.5, 0])
      cube([13, 15, 1]);
    }
    translate([0, 0, -0.5])
    cylinder(d=3.6, h=5, $fn=12);
  }
}


module base_roller() {
  translate([0, 0, 2+3])
  %cylinder(d=22, h=7, $fn=24);
  difference() {
    union() {
      // primary hub
      cylinder(d=8, h=6+2+3, $fn=24);
      
      // for inner race to ride on
      cylinder(d=15, h=2+3, $fn=24);
      
      // underlying plate
      hull() {
        cylinder(d=15, h=3, $fn=24);
        
        translate([-7.5, -11, 0])
        cube([1, 22, 3]);
        
        translate([-30+7.5, -11, 0])
        cube([1, 22, 3]);
      }
    }
    
    // hole in middle
    translate([0, 0, -0.1])
    cylinder(d=2.9, h=20, $fn=12);
    
    // slots in plate
    for (y=[6, -6])
    hull() {
    for (x=[-15, -18])
    translate([x, y, -0.1])
    cylinder(d=3.6, h=4, $fn=12);
    }
  }
}

module cap_bearing_holder() {
  h1 = 7;
  h2 = 2.5;
  h3 = 3;
  h4 = 5;
  
  translate([0, 0, tube_len+h2+h3-0.1])
  cylinder(d=8, h=h1+0.1, $fn=32);
  
  translate([0, 0, tube_len+h3-0.1])
  cylinder(d=15, h=h2+0.1, $fn=32);
  
  translate([0, 0, tube_len])
  cylinder(d=tube_d+4, h=h3, $fn=32);
  
  translate([0, 0, tube_len-h4])
  difference() {
    cylinder(d=tube_d+4, h=h4+0.1, $fn=32);
    translate([0, 0, -0.05])
    cylinder(d1=tube_d, d2=tube_d+0.6, h=h4+0.1+0.1, $fn=32);
    
    for (a=[0:4]) rotate([0, 0, a*360/5])
    translate([0, -0.5, -0.1])
    cube([20, 1, h4+0.1]);
  }
}

module cap_bearing_struts() {
  tube_inner_radius = 16;
  tube_start_height = plate_thickness;
  bearing_offs = 5.5;
  tt = tube_len + bearing_offs;
  strut_w = 2.4;
  arm_len = 83;
  
  // bearing sitting at top
  %translate([0, 0, tube_len+bearing_offs])
  cylinder(d=bearing_od, h=bearing_w);

  difference() {
    // rotate([90, 0, 0])
    rotate_extrude()
    polygon([[tube_inner_radius, tube_start_height], [tube_inner_radius, tt-3], 
      [bearing_od/2+1, tt+2], 
      [bearing_od/2-1, tt+2*bearing_w-2], 
      [bearing_od/2-1 + 4, tt+2*bearing_w-2], 
      [bearing_od/2+1 + 4, tt+2], 
      [tube_inner_radius+2, tt-3],   
      [tube_inner_radius+2, tube_start_height]]);
    
    for (a=[0, 120, 240]) rotate([0, 0, a]) {
      // poke holes for rollers to roll on the tubes
      rotate([0, 0, 45])
      translate([0, -10, plate_thickness-0.5])
      cube([20, 20, 15]);
      
      translate([0, 0, plate_thickness-0.5+15])
      rotate([0, 90, 45])
      cylinder(d=20, h=20, $fn=4);
    }
  }
  
  for (a=[0, 120, 240]) rotate([0, 0, a-15])
  translate([tube_inner_radius, -strut_w/2, plate_thickness]) {
    hull() {
      cube([arm_len-tube_inner_radius, strut_w, 1]);
      cube([1, strut_w, tube_len*0.8 ]);
    }
    
    for (x=[arm_len-10, 20])
    translate([x-tube_inner_radius, 0, 0])
    difference() {
      cube([10, 10+strut_w, 4]);
      translate([5, 5+strut_w, -0.1])
      cylinder(d=3.6, h=5, $fn=12);
    }
  }
  
}


module carousel_plate() {
  plate_r = 200;
  motor_size = 44;
  
  // spool size is radius of 74.2333
  
  difference() {
    linear_extrude(height=plate_thickness)
    union() {
      // outer pac-man shape
      difference() {
        circle(r=plate_r, $fn=120);
        
        circle(d=30);
        
        *rotate([0, 0, 45])
        translate([0, -15])
        square([100, 30]);
        
        square([plate_r+10, plate_r+10]);
      }
      
      // now inner disc with hole
      difference() {
        circle(r=75, $fn=60);
        circle(d=30);
      }
    }
    
    rotate([0, 0, motor_ang])
    translate([spool_motor_dist, 0, 0])
    rotate([0, 0, -motor_ang])
    translate([-motor_size/2-3, -motor_size/2, -0.5])
    cube([motor_size+3, motor_size, plate_thickness+1]);
  }
}

module corner_post() {
  tube_wall = 4;
  gusset_th = 4;
  
  difference() {
    translate([-93.25, -89, 0])
    import("../imported/MPCNC Primo 25.4/Primo Top Mirror Reduced.STL");

    translate([0, 10, 30])
    rotate([90, 0, 0])
    //cylinder(d=tube_d, h=70, $fn=60);
    teardrop(d=tube_d, h=70, a=90);
  }

  difference() {
    union() {
      translate([0, -1, 30])
      rotate([90, 0, 0]) {
        // outer part of tube
        teardrop(d=tube_d+2*tube_wall, h=40, a=90);
        
        // radial support gussets
        ang_offs = [[-117, -5, 40], [-100, -5, 40], [-47, 0, 44], [135, -14, 35], [45, 0, 35]];
        for (i=[0:len(ang_offs)-1]) rotate([0, 0, ang_offs[i][0]])
        translate([0, -gusset_th/2, ang_offs[i][1]])
        difference() {
          cube([ang_offs[i][2], gusset_th, 40-ang_offs[i][1]]);
          
          // screw holes next layer might use to secure gear for example
          if (i >= 2)
          translate([25, -0.5, 40-ang_offs[i][1]-hole_z_offset])
          rotate([-90, 0, 0])
          cylinder(d=2.9, h=gusset_th+1, $fn=12);
        }
      }
      
      // extension of tube but only one side so it doesn't interfere with belt tension slot
      intersection() {
        translate([0, 2.3, 30])
        rotate([90, 0, 0])
        teardrop(d=tube_d+2*tube_wall, h=40, a=90);
        
        translate([-100, -50, 0])
        cube([100, 100, 100]);
      }
      
      // flat floor so it can be printed with bridging
      translate([-8, -41, 12.25+5-tube_wall])
      cube([22, 40, 3.6]);
    }
    
    // inner hole for tube
    translate([0, 10, 30])
    rotate([90, 0, 0])
    teardrop(d=tube_d, h=70, a=90);
    
    // sloped at top so it's easier to force in a tube
    translate([0, 10-42, 30])
    rotate([90, 0, 0])
    cylinder(d1=tube_d-1, d2=tube_d+2, h=10, $fn=32);
    
    // cut away anything that would interfere with side rail
    translate([0, 11.5, -1])
    cylinder(d=tube_d+3, h=80, $fn=30);
    
    // slot for tightening
    translate([-8.7, -41.5, 5])
    rotate([0, 14, 0])
    cube([2, 40, 20]);
    
    // chop everything (radial gussets) below Z=0
    translate([-50, -50, -100])
    cube([100, 100, 100]);
    
    // dual cylinders for screw
    translate([-5.5, -33, 12])
    rotate([0, -73, 0]) {
      cylinder(d=3.2, h=12, $fn=12);
      translate([0, 0, -11])
      cylinder(d=2.9, h=12, $fn=12);
    }
  }

  translate([0, 0, 30])
  rotate([90, 0, 0])
  *cylinder(d=25.4, h=50, $fn=60);
}

module teardrop(d, h, a=0) {
  cylinder(d=d, h=h, $fn=32);
  rotate([0, 0, a])
  difference() {
    rotate([0, 0, -45])
    cube([d/2, d/2, h]);
    
    translate([d/2+1, -d/2, -0.5])
    cube([d, d, h+1]);
  }
}
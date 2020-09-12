// "Parameters"
num6_d1 = 2.9; // diameter of 'tight' threads intended for engagement
num6_d2 = 3.6; // diameter of thread OD intended not for engagement with threads
num6_head_room = 8;  // generous space for screw head (clearance or support)
eps = 0.1;
// Specifically tuned based on test print and test-fit
Spool_shield_t = 1;   // thickness of shield
Shaft_tuned_d = 5.4;
Motor_gear_screw_loosening = 0.1;  // fine-tune so motor gear screw are not too tight

// "Gear parameters"
Circular_pitch = 262;
Motor_teeth = 10;
Gear_height = 21.4;
Motor_pitch                      = (Motor_teeth*Circular_pitch/360);
Motor_pitch_diametrial           = Motor_teeth/(2*Motor_pitch);
Motor_outer_radius               = Motor_pitch + 1/Motor_pitch_diametrial;
Spool_teeth = 100;
Spool_r = 50;
Spool_height = 8;
Spool_pitch                      = (Spool_teeth*Circular_pitch/360);
Spool_pitch_diametrial           = Spool_teeth/(2*Spool_pitch);
Spool_outer_radius               = Spool_pitch + 1/Spool_pitch_diametrial;

//echo("Spool_outer_radius", Spool_outer_radius);
//echo("Spool plus motor radii", Spool_pitch + Motor_pitch);

hole_z_offset = 14;

part = "";

if (part == "wheel" || part == "") {
  wheel();
}

if (part == "motor" || part == "") {
  rotate([0, 0, 45])
  translate([Spool_outer_radius+Motor_outer_radius+1, 0, 0])
  motor_gear();
}


module radial_support_gussets() {
  gusset_th = 4;
  
  // radial support gussets
  ang_offs = [[-117, -5, 40], [-100, -5, 40], [-47, 0, 44], [135, -14, 35], [45, 0, 35]];
  
  translate([0, 0, -40])
  difference() {
    union() {
      for (i=[0:len(ang_offs)-1]) rotate([0, 0, ang_offs[i][0]])
      translate([0, -gusset_th/2, ang_offs[i][1]])
      difference() {
        cube([ang_offs[i][2], gusset_th, 40-ang_offs[i][1]]);
        
        // screw holes next layer might use to secure gear for example
        if (i >= 2)
        translate([25, -0.5, 40-ang_offs[i][1]-hole_z_offset])
        rotate([-90, 0, 0]) {
          cylinder(d=2.9, h=gusset_th+1, $fn=12);
          %cylinder(d=2.9, h=gusset_th+1, $fn=12);
        }
      }
      
      cylinder(d=25.4+7, h=40);
    }
    
    translate([-50, -100-30, -20])
    cube([100, 100, 100]);
    
    translate([-50, -50, -100+40-Gear_height])
    cube([100, 100, 100]);
  }
}

module wheel() {
  inner_clearance_r = 44;
  floor_th = 2;
  rib_w = 2;
  ring_w = 3.2;
  attach_w = 3.2;  // thickness of wall that attaches to post
  gusset_th = 4;  // thickness of gussets on post
  
  translate([0, 0, floor_th])
  rotate([180, 0, 0])
  %radial_support_gussets();
  
  ang_side = [[-47, -1], [45, 1], [135, -1]];
  
  // ribs to attach to post
  difference() {
    for (i=[0:2]) rotate([0, 0, -ang_side[i][0]])
    translate([0, ang_side[i][1]*(gusset_th/2+attach_w/2)-attach_w/2, 0])
    difference() {
      cube([inner_clearance_r+1, attach_w, Gear_height]);
      // punch hole 5.5 mm away from top of floor
      translate([25, -0.5, hole_z_offset+floor_th])
      rotate([-90, 0, 0])
      cylinder(d=3.6, h=attach_w+1, $fn=12);
    }
    
    // clear out interior
    translate([0, 0, -0.1])
    cylinder(d=25.4+10, h=Gear_height+1);
  }
  
  difference() {
    herringbone();
    translate([0, 0, -0.5])
    
    cylinder(r=Spool_outer_radius-7, h=Gear_height+1, $fn=60);
    
    for (z=[-0.3, Gear_height+0.3]) translate([0, 0, z])
    rotate_extrude(angle=360, convexity=5, $fn=60)
    translate([Spool_pitch-2.3,0])
    rotate([0,0,-45])
    square([10, 10]);
  }
  
  difference() {
    union() {
      // floor
      cylinder(r=Spool_outer_radius-6.5, h=floor_th, $fn=60);
      
      // inside clearance ring and ribs
      difference() {
        union() {
          cylinder(r=inner_clearance_r+ring_w, h=Gear_height, $fn=60);
          // ribs between clearance ring and outer gear
          for (a=[0:5]) rotate([0, 0, a*60])
          translate([0, -rib_w/2, 0])
          cube([Spool_outer_radius-6.5, rib_w, Gear_height]);
        }
        
        // clear out inside ring
        translate([0, 0, -0.5])
        cylinder(r=inner_clearance_r, h=Gear_height+1, $fn=60);
      }
    }
    
    // hole for metal tube
    translate([0, 0, -0.5])
    cylinder(d=30, h=floor_th+1);
    
    
  }
  
}


module herringbone() {
  module half() {
    my_gear(Spool_teeth, Gear_height/2, Circular_pitch, slices = floor(Gear_height/2));
  }

  translate([0, 0, Gear_height/2])
  for (i=[0:1]) {
    mirror([0, 0, i])
    half();
  }
}



Foot_height = Spool_height + Spool_shield_t; // 9;
Foot_bulge = 1.5;
slot_w = 1;

module motor_gear() {
  module half(){
    my_gear(Motor_teeth, Gear_height/2, Circular_pitch, fac=-1, slices = 2*Gear_height);
  }

  mirror([1, 0, 0])
  difference() {
    union() {
      translate([0,0,Gear_height/2]){
        half();
        mirror([0,0,1])
          half();
      }
      
      translate([0,0,Gear_height])
      cylinder(r1=Motor_outer_radius, r2=Motor_outer_radius+Foot_bulge, h=Foot_height/2);
      translate([0,0,Gear_height+Foot_height/2])
      cylinder(r1=Motor_outer_radius+Foot_bulge, r2=Motor_outer_radius, h=Foot_height/2);
    }
    
    translate([0, 0, -eps/2])
    cylinder(d=Shaft_tuned_d, h=Gear_height+Foot_height+eps, $fn=20);
    
    translate([-Motor_outer_radius-1-Foot_bulge, -slot_w/2, Gear_height+1])
    cube([Motor_outer_radius*2+2*Foot_bulge+2, slot_w, Foot_height-1+eps]);
    
    for (a=[0, 180])
      rotate([0, 0, a])
      translate([Motor_outer_radius/2+Shaft_tuned_d/4, slot_w/2, Gear_height + Foot_height/2])
      rotate([90, 0, 0])
      screw_set();
    
    translate([0,0,-0.3])
    rotate_extrude(angle=360, convexity=5)
      translate([Motor_pitch-2.3,0])
      rotate([0,0,-45])
      square([10, 10]);
  }
}


module screw_set() {
  translate([0, 0, -eps])
  cylinder(d=num6_d1+Motor_gear_screw_loosening, h=20, $fn=12);
  translate([0, 0, -20])
  cylinder(d=num6_d2+Motor_gear_screw_loosening, h=20, $fn=12);
  translate([0, 0, -20-4])
  cylinder(d=num6_head_room, h=20, $fn=12);
}



//######################## Functions ########################
function mirror_point(coord) =
[
	coord[0],
	-coord[1]
];

function rotate_point(rotate, coord) =
[
	cos(rotate)*coord[0] + sin(rotate)*coord[1],
	cos(rotate)*coord[1] - sin(rotate)*coord[0]
];

function involute(base_radius, involute_angle) =
[
	base_radius*(cos(involute_angle) + involute_angle*PI/180*sin(involute_angle)),
	base_radius*(sin(involute_angle) - involute_angle*PI/180*cos(involute_angle)),
];

function rotated_involute(rotate, base_radius, involute_angle) =
[
	cos(rotate)*involute(base_radius, involute_angle)[0] + 
    sin(rotate)*involute(base_radius, involute_angle)[1],
	cos(rotate)*involute(base_radius, involute_angle)[1] - 
    sin(rotate)*involute(base_radius, involute_angle)[0]
];

function involute_intersect_angle(base_radius, radius) = 
    sqrt(pow(radius/base_radius, 2) - 1)*180/PI;


//######################## Modules ########################
module involute_gear_tooth(pitch_radius, root_radius, base_radius, outer_radius, 
                           half_thick_angle, involute_facets) {
  min_radius   = max(base_radius,root_radius);
  pitch_point  = involute(base_radius, involute_intersect_angle(base_radius, pitch_radius));
  pitch_angle  = atan2(pitch_point[1], pitch_point[0]);
  angmid = pitch_angle + half_thick_angle;
  ang1 = involute_intersect_angle(base_radius, min_radius);
  ang2 = involute_intersect_angle(base_radius, outer_radius);
  res=(involute_facets!=0)?involute_facets:($fn==0)?5:$fn/4;
  for(i=[1:res]) {
    polygon(points=[[0,0],
        rotate_point(angmid, involute(base_radius, ang1+(ang2 - ang1)*(i-1)/res)),
        rotate_point(angmid, involute(base_radius, ang1+(ang2 - ang1)*i/res)),
        mirror_point(rotate_point(angmid, involute(base_radius,ang1+(ang2 - ang1)*i/res))),
        mirror_point(rotate_point(angmid, involute(base_radius,ang1+(ang2 - ang1)*(i-1)/res)))],
        paths=[[0,1,2,3,4,0]]);
  }
}


module gear_shape(number_of_teeth, pitch_radius, root_radius, base_radius, outer_radius,
	              half_thick_angle, involute_facets) {
  union() {
    rotate(half_thick_angle) circle($fn=number_of_teeth*2, r=root_radius);
    for(i = [1:number_of_teeth]){
      rotate([0,0,i*360/number_of_teeth])
      involute_gear_tooth(pitch_radius     = pitch_radius,
                          root_radius      = root_radius,
                          base_radius      = base_radius,
                          outer_radius     = outer_radius,
                          half_thick_angle = half_thick_angle,
                          involute_facets  = involute_facets);
    }
  }
}


module gear(number_of_teeth = 15,
	          circular_pitch  = false,
            diametral_pitch = false,
	          pressure_angle  = 28,
	          clearance       = 0.2,
	          gear_thickness  = 5,
	          rim_thickness   = 8,
	          rim_width       = 5,
	          hub_thickness   = 10,
	          hub_diameter    = 15,
	          bore_diameter   = 5,
	          circles         = 0,
	          backlash        = 0,
	          twist           = 0,
	          involute_facets = 0,
            slices          = 1){
	if(circular_pitch==false && diametral_pitch==false)
		echo("ERROR: gear module needs either a diametral_pitch or circular_pitch");

	// Convert diametrial pitch to our native circular pitch
	circular_pitch             = (circular_pitch!=false?circular_pitch:180/diametral_pitch);

	// Pitch diameter: Diameter of pitch circle.
	pitch_diameter             = number_of_teeth*circular_pitch/180;
	pitch_radius               = pitch_diameter/2;

	// Base Circle
	base_radius                = pitch_radius*cos(pressure_angle);

	// Diametrial pitch: Number of teeth per unit length.
	pitch_diametrial           = number_of_teeth/pitch_diameter;

	// Addendum: Radial distance from pitch circle to outside circle.
	addendum                   = 1/pitch_diametrial;

	//Outer Circle
	outer_radius               = pitch_radius + addendum;

	// Dedendum: Radial distance from pitch circle to root diameter
	dedendum                   = addendum + clearance;

	// Root diameter: Diameter of bottom of tooth spaces.
	root_radius                = pitch_radius - dedendum;
	backlash_angle             = backlash/pitch_radius*180/PI;
	half_thick_angle           = (360/number_of_teeth - backlash_angle)/4;

	// Variables controlling the rim.
	rim_radius                 = root_radius - rim_width;

	// Variables controlling the circular holes in the gear.
	circle_orbit_diameter      = hub_diameter/2 + rim_radius;
	circle_orbit_curcumference = PI*circle_orbit_diameter;

	// Limit the circle size to 90% of the gear face.
	circle_diameter            = min(0.70*circle_orbit_curcumference/circles,
			                             (rim_radius-hub_diameter/2)*0.9);

	difference(){
		union(){
			difference(){
				linear_extrude(height = rim_thickness, convexity = 10, twist = twist, slices=slices)
				gear_shape(number_of_teeth,
					         pitch_radius     = pitch_radius,
					         root_radius      = root_radius,
					         base_radius      = base_radius,
					         outer_radius     = outer_radius,
					         half_thick_angle = half_thick_angle,
					         involute_facets  = involute_facets);
				if(gear_thickness < rim_thickness)
					translate([0,0,gear_thickness])
					  cylinder(r = rim_radius, h = rim_thickness-gear_thickness + 1);
			}
			if(gear_thickness > rim_thickness)
				cylinder(r = rim_radius, h = gear_thickness);
			if(hub_thickness > gear_thickness)
				translate([0,0,gear_thickness])
				cylinder(r = hub_diameter/2, h = hub_thickness - gear_thickness);
		}
		if(circles>0){
			for(i=[0:circles-1])
				rotate([0,0,i*360/circles])
				  translate([circle_orbit_diameter/2, 0, -1])
				    cylinder(r = circle_diameter/2, h = max(gear_thickness, rim_thickness) + 3);
		}
	}
}


module my_gear(teeth, height, circular_pitch, fac=1, slices=1){
  pitch = (teeth*circular_pitch/360);
  gear(number_of_teeth = teeth,
       circular_pitch  = circular_pitch,
       pressure_angle  = 30,
       clearance       = 0.2,
       gear_thickness  = height,
       rim_thickness   = height,
       rim_width       = 5,
       hub_thickness   = height,
       hub_diameter    = 15,
       twist = fac*(180/3.14)*height*1/pitch,
       slices = slices);
}

set OPENSCAD="C:\Program Files\OpenSCAD\openscad.exe"
rem takes about 24 minues?
time /T
%OPENSCAD% tool_changer.scad -D "part=""wire_string_link""" -D double_cleat=1 -o tc2_wire_string_link.stl
%OPENSCAD% tool_changer.scad -D "part=""drill_guide""" -D double_cleat=1 -o tc2_drill_guide.stl
%OPENSCAD% tool_changer.scad -D "part=""plate_a""" -D double_cleat=1 -o tc2_plate_a.stl
%OPENSCAD% tool_changer.scad -D "part=""plate_b""" -D double_cleat=1 -o tc2_plate_b.stl
%OPENSCAD% tool_changer.scad -D "part=""tool_plate""" -D double_cleat=1 -o tc2_tool_plate.stl
%OPENSCAD% tool_changer.scad -D "part=""pulley""" -D double_cleat=1 -o tc2_pulley.stl
%OPENSCAD% tool_changer.scad -D "part=""servo_bracket""" -D double_cleat=1 -o tc2_servo_bracket.stl
%OPENSCAD% tool_changer.scad -D "part=""back_plate""" -D double_cleat=1 -o tc2_back_plate.stl
%OPENSCAD% core_addon.scad -D short=0 -o core_addon.stl
%OPENSCAD% core_addon.scad -D short=1 -o core_addon_short.stl
%OPENSCAD% universal_tool_plate.scad -o universal_tool_plate.stl
%OPENSCAD% tool_carousel_gears.scad -D "part=""wheel""" -o carousel_gear_wheel.stl
%OPENSCAD% tool_carousel_gears.scad -D "part=""motor""" -o carousel_gear_motor.stl
%OPENSCAD% tool_carousel.scad -D "part=""corner_post""" -o carousel_corner_post.stl
%OPENSCAD% tool_carousel.scad -D "part=""cap_bearing_struts""" -o cap_bearing_struts.stl
%OPENSCAD% tool_carousel.scad -D "part=""cap_bearing_holder""" -o cap_bearing_holder.stl
%OPENSCAD% tool_carousel.scad -D "part=""base_roller""" -o base_roller.stl
%OPENSCAD% tool_carousel.scad -D "part=""base_roller_cap""" -o base_roller_cap.stl
%OPENSCAD% tool_carousel.scad -D "part=""motor_rigid_mount""" -o motor_rigid_mount.stl
%OPENSCAD% tool_carousel.scad -D "part=""carousel_plate""" -o carousel_plate.dxf
%OPENSCAD% tool_parking.scad -D "part=""parking""" -o tool_parking.stl
%OPENSCAD% tool_parking.scad -D "part=""hanger""" -o tool_hanger.stl
%OPENSCAD% tool_parking.scad -D "part=""dw660_hanger""" -o dw660_hanger.stl
time /T

pause
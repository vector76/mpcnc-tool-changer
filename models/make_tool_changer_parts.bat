set OPENSCAD="C:\Program Files\OpenSCAD\openscad.exe"
rem takes about 24 minues?
time /T
%OPENSCAD% tool_changer.scad -D "part=""wire_string_link""" -D double_cleat=1 -o ../STLs/wire_string_link.stl
%OPENSCAD% tool_changer.scad -D "part=""drill_guide""" -D double_cleat=1 -o ../STLs/drill_guide.stl
%OPENSCAD% tool_changer.scad -D "part=""plate_a""" -D double_cleat=1 -o ../STLs/plate_a.stl
%OPENSCAD% tool_changer.scad -D "part=""plate_b""" -D double_cleat=1 -o ../STLs/plate_b.stl
%OPENSCAD% tool_changer.scad -D "part=""tool_plate""" -D double_cleat=1 -o ../STLs/tool_plate.stl
%OPENSCAD% tool_changer.scad -D "part=""pulley""" -D double_cleat=1 -o ../STLs/pulley.stl
%OPENSCAD% tool_changer.scad -D "part=""servo_bracket""" -D double_cleat=1 -o ../STLs/servo_bracket.stl
%OPENSCAD% tool_changer.scad -D "part=""back_plate""" -D double_cleat=1 -o ../STLs/back_plate.stl
%OPENSCAD% core_addon.scad -D short=0 -o ../STLs/core_addon.stl
%OPENSCAD% core_addon.scad -D short=1 -o ../STLs/core_addon_short.stl
%OPENSCAD% universal_tool_plate.scad -o ../STLs/universal_tool_plate.stl
%OPENSCAD% tool_carousel_gears.scad -D "part=""wheel""" -o ../STLs/carousel_gear_wheel.stl
%OPENSCAD% tool_carousel_gears.scad -D "part=""motor""" -o ../STLs/carousel_gear_motor.stl
%OPENSCAD% tool_carousel.scad -D "part=""corner_post""" -o ../STLs/carousel_corner_post.stl
%OPENSCAD% tool_carousel.scad -D "part=""cap_bearing_struts""" -o ../STLs/cap_bearing_struts.stl
%OPENSCAD% tool_carousel.scad -D "part=""cap_bearing_holder""" -o ../STLs/cap_bearing_holder.stl
%OPENSCAD% tool_carousel.scad -D "part=""base_roller""" -o ../STLs/base_roller.stl
%OPENSCAD% tool_carousel.scad -D "part=""base_roller_cap""" -o ../STLs/base_roller_cap.stl
%OPENSCAD% tool_carousel.scad -D "part=""motor_rigid_mount""" -o ../STLs/motor_rigid_mount.stl
%OPENSCAD% tool_carousel.scad -D "part=""carousel_plate""" -o ../STLs/carousel_plate.dxf
%OPENSCAD% tool_parking.scad -D "part=""parking""" -o ../STLs/tool_parking.stl
%OPENSCAD% tool_parking.scad -D "part=""hanger""" -o ../STLs/tool_hanger.stl
%OPENSCAD% tool_parking.scad -D "part=""dw660_hanger""" -o ../STLs/dw660_hanger.stl
time /T

pause
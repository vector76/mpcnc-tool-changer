# DIY CNC Machine with Automatic Tool Changer
## Introduction
* Based on MPCNC
* Add-ons add automatic tool changing
## Parts and Tools List
## System Overview
## Step 1. Build MPCNC Primo
* Build to completion.  Don’t want to fight tool changer problems before underlying CNC machine is working.
## Step 2. Gather Materials and Print Tool Changer Parts
* 5mm rod
* 3mm rod
* 8mm balls
* piano wire 0.032”
* piano wire 0.047”
* Dyneema or aramid fishing line, "50lb test" recommended
* #6 x 1/2" sheet metal screws
* #6-32 machine screws and #6-32 nylon lock-nuts
* Additional quantity of parts already needed for Primo: 
  * 608 bearings
  * M3 x 10mm
  * 5/16” x 1.5” bolt and nut
## Step 3. Build Cleats & Bushings
* Cut to length 5mm rod
* Cut to length 3mm rod
* Use drill guide to drill 3mm hole in 5mm rod
* Loctite to secure 3mm rod in 5mm rod
* Ream bushing to 5 mm
* Tie strings onto bushing
* Install bearing and cleat into bushing
## Step 4. Assemble Plate
* Cut spring wire to length and install
* Secure with hot glue
* Glue front plate onto main plate
## Step 5. Set Tension by Setting Length
* Install cleat assembly into plate (without back)
* Install balls into test blank
* Place test blank onto plate
* Adjust stickout until cleat depth is ‘just right’
* Remove cleat assembly from plate
* Measure depth
* Adjust stickout to be 3mm less, and glue in place
* Repeat for the other cleat assembly
## Step 6. Install Cleat Assemblies into Plate and Plate into Z Axis
* Install cleat assemblies into plate and thread cords around pulley and through the openings
* Tape in place to avoid coming off of pulleys
* Install plate onto Z axis rails using #6-32 hardware
* Install back of plate
* Use M3 adjustment screws to press the cleat assemblies forward until they are at just the right depth
## Step 7. Install Servo into Servo Bracket and Add Pushrods
* Create pushrods by cutting and bending wire
* Install cable-pushrod attachment onto the ends of pushrods
* Enable servo and move to 0 and 120 to confirm range of motion
* Move servo to position 10 and orient servo horn to be ‘nearly vertical’
* Install pushrods into servo horn
* Install servo into servo bracket
* Install servo bracket onto Z axis
## Step 8. Attach Pulley Strings to Wires
* Orient cleats horizontally
* Attach strings to wire attachments
* Enable servo and move to various values to determine locked and unlocked positions
* If cleats are not at the same angle when unlocked, adjust
## Step 9. Install Z axis
* Remove leadscrew nut from top of core
* Remove core by removing gantry rails
* Swap location of Y axis clamp to the proper location
* Install core upside-down
* Bolt core extension loosely on to top of (now inverted) core
* Install leadscrew nut on top of core extension
* Insert Z axis through all bearings and tighten core extension onto core
## Step 10. Wire Servo and Test
* Using test blank first, check that depth is correct
* With test blank, move servo to ‘locked’ and ‘unlocked’ position and confirm functionality
* Install pen holder by manually engaging servo
* Draw the standard crown test pattern
* Celebrate
## Step 11. Replace Corner Top with Carousel Holder
* Loosen both belt holders on front-left corner, and remove X belt holder from corner
* Replace front left corner top with modified corner top
* Reinstall belt holders and retighten belts
* Install 25.4mm tube into corner top and tighten screws to secure
## Step 12. Assemble and Install Carousel
* Steps here
* Wire carousel motor to E0 axis
## Step 13. Adjust Firmware and Reflash
* Enable E0
* Set E0 steps per mm (actually steps per degree)
* Check that workspace coordinates are enabled (G53, G54, etc.)
* Reflash and check that carousel rotates by the proper amount
## Step 14. Manually “Home” Machine and Measure Offsets
* Manually move machine to ‘home’ position and perform G53 and G92 X0 Y0 Z0 E0
* Manually move machine to the location where each tool would be engaged, and record location using M114
* Note, these are machine-relative coordinates for tool pickup/dropoff
* Define gcode sequences for parking and unparking each tool according to this template.  Note that these sequences only work after homing (for now, manually)
* Test mounting and unmounting sequences
## Step 15. Measure Mounted Per-tool Offsets
* Choose a tool as the ‘locating’ tool that will be used to determine workpiece location.  Ideally this would be a probe but a pen (or a conductive rod in a pen holder) could work.
* Draw an X on the spoil board (in a location all tools can reach)
* Mount each tool, move to the X, and record the coordinates from M114.  Try to get these as accurate as possible but they will be fine-tuned in a later step
* Calculate the offset between the locating tool and all other tools.
* Generate workspace coordinate setup script that produces workspace coordinates for all tools that coincide.
## Step 16. Use Post-Postprocessor to Insert Tool Change Scripts
* Using Fusion or EstlCAM or your favorite CAM program, generate gcode that includes “T0/T1” tool change commands
* Use web program to replace tool change operations with machine specific tool change sequences:
  * Switch to G53 machine coordinates
  * Drop off the tool that was being used
  * Pick up the next tool to use
  * Switch to workspace coordinates (G54, G55, or …) corresponding to the new tool
  * Jog to the previous location
* Make sure machine is manually homed
* Pick up locating tool
* Jog to workpiece (optionally run G38.2 to probe workpiece)
* Run workspace coordinate setup script
* Run job
## Step 17. Fine-tune Tool Offsets
* Using Post-Postprocessor workflow, run special test pattern job which exercises all tools
* Measure resulting workpiece to determine adjustment factors to the tool offsets
* Regenerate workspace coordinate setup script
## Step 18. Future
* Automatic homing
* Electrical connection to tools (e.g. probes, possibly enable/disable via mount)
* Detect tool mounting and halt if mounting fails
* Vacuum shoe
* Extruder?


# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name TDB_AddresMachine32 -dir "/home/icarosix/FPGA/Spain/Bemforming/ise/TDB_AddresMachine32/planAhead_run_3" -part xc6slx16csg324-3
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "/home/icarosix/FPGA/Spain/Bemforming/ise/TDB_AddresMachine32/Beamformer.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/icarosix/FPGA/Spain/Bemforming/ise/TDB_AddresMachine32} }
set_property target_constrs_file "Beamformer.ucf" [current_fileset -constrset]
add_files [list {Beamformer.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "/home/icarosix/FPGA/Spain/Bemforming/ise/TDB_AddresMachine32/Beamformer.xdl"
if {[catch {read_twx -name results_1 -file "/home/icarosix/FPGA/Spain/Bemforming/ise/TDB_AddresMachine32/Beamformer.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"/home/icarosix/FPGA/Spain/Bemforming/ise/TDB_AddresMachine32/Beamformer.twx\": $eInfo"
}

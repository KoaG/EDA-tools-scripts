#-------------------------------------------------------------------#
#   Script Written By : Rahul Sharma                                #
#   Vivado Ver : 2018.2                                             #
#-------------------------------------------------------------------#
#####################################################################
#       Tcl Script to execute vivado flow from command line         #
#       Parameters required                                         #
#       1. pName    -   Project Name                                #
#       2. sDir     -   Source Directory                            #
#       3. tDev     -   Target device/part name                     #
#                       default xc7k70tfbv676-1                     #
#       3. tmodule  -   Top Module Name                             #
#       4. bitgen   -   boolean for generating bitstream file       #
#                       default off                                 #
#       To execute start vivado tcl shell                           #
#       Open cmd or powershell as admin                             #
#       1. type vivado.bat -mode tcl                                #
#       2. source run_np_flow.tcl                                   #
#       3. run_vivado <pName> <sDir> <tmodule>                      #
#                       <tDev -default xc7k70tfbv676-1>             # 
#                       <bitgen -default 0>                         #
#####################################################################
proc run_vivado {pName sDir tmodule {tDev xc7k70tfbv676-1} {bitgen 0}} {
    #Setting Variables
    set projectName $pName
    set sourceDir $sDir
    append projectDir [pwd] / $projectName
    #Creating output directory to store results
    set outputDir $projectDir/results
    file mkdir $outputDir
    append netlist $projectName _netlist.v
    append xdc $projectName _xdc.xdc
    append bit $projectName _bit.bit

    #Creating vivado project
    create_project $projectName $projectDir -part $tDev -force
    set_property simulator_language Verilog [current_project]
    #adding source files
    set files [glob $sourceDir/*.v]
    add_files -norecurse $files
    update_compile_order -fileset sources_1
    #adding constraints
    add_files -fileset constrs_1 [glob $sourceDir/*.xdc]

    #synthesizing topmodule
    synth_design -top $tmodule -flatten rebuilt
    #writing checkpoint and reports
    write_checkpoint -force $outputDir/post_synth
    report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
    report_power -file $outputDir/post_synth_power.rpt

    #running implementation flow
    #running opt and place
    opt_design
    power_opt_design
    place_design
    phys_opt_design
    write_checkpoint -force $outputDir/post_place
    report_timing_summary -file $outputDir/post_place_timing_summary.rpt

    #routing the design
    route_design
    #generating design checkpoints
    write_checkpoint -force $outputDir/post_route
    #reportig timing, clock util, power and drc
    report_timing_summary -file $outputDir/post_route_timing_summary.rpt -max_paths 10
    report_timing -sort_by group -max_paths 10 -path_type summary -file $outputDir/post_route_timing.rpt
    report_clock_utilization -file $outputDir/clock_util.rpt
    report_utilization -file $outputDir/post_route_util.rpt
    report_power -file $outputDir/post_route_power.rpt
    report_drc -file $outputDir/post_imp_drc.rpt
    #generating netlist and xdc 
    write_verilog -force $outputDir/$netlist
    write_xdc -no_fixed_only -force $outputDir/$xdc
    #writing bitstream
    if { $bitgen } {
        write_bitstream -force $outputDir/$bit
    }
    close_project
}

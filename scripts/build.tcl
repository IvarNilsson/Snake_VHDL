# ------------------------------------------------------------------------------------
# Argument parser (cli options)
# ------------------------------------------------------------------------------------
package require cmdline

# TODO: update usage to be better

#TODO: make the auto install of boards work :)
# Make sure boards are installed
#xhub::install [xhub::get_xitems $board ]
#xhub::update  [xhub::get_xitems $board ]

# Setup Board
set board digilentinc.com:nexys4:part0:1.1

# ------------------------------------------------------------------------------------
# Create project
# ------------------------------------------------------------------------------------
set ROOT [file normalize [file join [file dirname [info script]] .. ]]
set outputdir [file join "$ROOT" vivado_files]
file mkdir $outputdir
create_project projekt $outputdir -force

# Set Properties
set_property board_part $board     [current_project]
set_property target_language VHDL  [current_project]

# Set the file that will be top module
set top_module [file join "$ROOT" src top.vhd]

# VHDL files
add_files [file join "$ROOT" src top.vhd]

add_files [file join "$ROOT" src kb_sync_edge.vhd]
add_files [file join "$ROOT" src kb_scancode.vhd]
add_files [file join "$ROOT" src kb_ctrl.vhd]
add_files [file join "$ROOT" src kb_game_tick.vhd]

add_files [file join "$ROOT" src game_tick_gen.vhd]
add_files [file join "$ROOT" src random_number_PRNG.vhd]
add_files [file join "$ROOT" src segments.vhd]

add_files [file join "$ROOT" src vga_controller.vhd]
add_files [file join "$ROOT" src clk_wiz_wrapper.vhd]

# package
add_files [file join "$ROOT" src matrix_package.vhd]

add_files -fileset constrs_1 [file join "$ROOT" src constraint.xdc]

import_files -force

# set VHDL 2008 as default
set_property file_type {VHDL 2008} [get_files  *.vhd]


source [ file normalize [ file join $ROOT scripts clk_wiz.tcl ] ]

update_compile_order -fileset sources_1

## run impl
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

start_gui

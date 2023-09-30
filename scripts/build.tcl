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
create_project lab2 $outputdir -force

# Set Properties
set_property board_part $board     [current_project]
set_property target_language VHDL  [current_project]

# Set the file that will be top module
set top_module [file join "$ROOT" src top.vhd]

add_files [file join "$ROOT" src top.vhd]

#add_files [file join "$ROOT" src lab2 binary_to_sg.vhd]
#add_files [file join "$ROOT" src lab2 convert_scancode.vhd]
#add_files [file join "$ROOT" src lab2 convert_to_binary.vhd]
#add_files [file join "$ROOT" src lab2 edge_detector.vhd]
#add_files [file join "$ROOT" src lab2 keyboard_ctrl.vhd]
#add_files [file join "$ROOT" src lab2 sync_keyboard.vhd]

#add_files [file join "$ROOT" src axi_lite axi_lite_slave.vhd]
#add_files [file join "$ROOT" src axi_lite rd_en_pulse.vhd]

#add_files [file join "$ROOT" src sample_data sample.vhd]
#add_files [file join "$ROOT" src sample_data sample_clk.vhd]
#add_files [file join "$ROOT" src sample_data collector.vhd]
#add_files [file join "$ROOT" src sample_data full_sample_axi_lite.vhd]

#add_files [file join "$ROOT" src ws_pulse ws_pulse.vhd]

add_files [file join "$ROOT" src matrix_package.vhd]

add_files -fileset constrs_1 [file join "$ROOT" src constraint.xdc]

import_files -force

# set VHDL 2008 as default
set_property file_type {VHDL 2008} [get_files  *.vhd]


#set_property file_type {VHDL} [ get_files *axi_lite_slave.vhd]
# Import Block Designs
#source [ file normalize [ file join $ROOT scripts build_1_array zynq_bd.tcl ] ]
#source [ file normalize [ file join $ROOT scripts build_axi_full fifo_bd.tcl ] ]

# Make wrapper fifo
#make_wrapper -inst_template [ get_files {fifo_bd.bd} ]
#add_files -files [file join "$ROOT" vivado_files acoustic_warfare.srcs sources_1 bd fifo_bd hdl fifo_bd_wrapper.vhd]

# Make wrapper zynq
#make_wrapper -inst_template [ get_files {zynq_bd.bd} ]
#add_files -files [file join "$ROOT" vivado_files acoustic_warfare.srcs sources_1 bd zynq_bd hdl zynq_bd_wrapper.vhd]

update_compile_order -fileset sources_1

## start gui
start_gui

## run synth
#launch_runs synth_1 -jobs 4
#wait_on_run synth_1

## run impl
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

update_compile_order -fileset sources_1

## launch SDK
#file mkdir [file join "$ROOT" vivado_files acoustic_warfare.sdk]
#file copy -force [file join "$ROOT" vivado_files acoustic_warfare.runs impl_1 aw_top_lite.sysdef] [file join "$ROOT" vivado_files acoustic_warfare.sdk aw_top_lite.hdf]

#launch_sdk -workspace [file join "$ROOT" vivado_files acoustic_warfare.sdk] -hwspec [file join "$ROOT" vivado_files acoustic_warfare.sdk aw_top_lite.hdf]
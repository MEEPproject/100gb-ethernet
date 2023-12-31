# Copyright 2022 Barcelona Supercomputing Center-Centro Nacional de Supercomputación

# Licensed under the Solderpad Hardware License v 2.1 (the "License");
# you may not use this file except in compliance with the License, or, at your option, the Apache License version 2.0.
# You may obtain a copy of the License at
# 
#     http://www.solderpad.org/licenses/SHL-2.1
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Author: Alexander Kropotov, BSC-CNS
# Date: 22.02.2022
# Description: 


variable stepSynth 0
variable stepImpl 0
variable stepBits 0
variable jobsNum 16

proc openGUI {} {

	puts "Do you want to launch the GUI? (Y/n)"
	set option [gets stdin]
	puts "\n"
	puts "Selected Option: $option"
	
	switch -regexp $option {
		[Y,y] {
		start_gui
		break
		}
		default {
		puts "End of the script"
		}
	}
}


proc show_options {root_dir designStep} {

variable stepSynth
variable stepImpl
variable stepBits

puts "Do you want to launch the ${designStep} process now? (Y/n)"
# set option [gets stdin]
set option y
puts "\n"
puts "Selected Option: $option"
	switch -regexp $option {
		[Y,y] {
			switch $designStep {
				"synthesis" {
				set stepSynth 1
				}
				"implementation" {
				set stepImpl 1
				}
				"bitstream" {
				set stepBits 1
				}
			}
		}
		[N,n] {
			puts "The ${designStep} process won't be run"			
		}
		default {
		puts "No valid option selected, try again...\n"
		show_options $root_dir $designStep
		}
	}	
}

proc reportImpl {root_dir} {
	open_run impl_1
	file delete -force ./reports
	file mkdir $root_dir/reports
	report_clocks -file "${root_dir}/reports/clock.rpt"
	report_utilization -file "${root_dir}/reports/utilization.rpt"
	report_timing_summary -warn_on_violation -file "${root_dir}/reports/timing_summary.rpt"
	report_power -file "${root_dir}/reports/power.rpt"
	report_drc -file "${root_dir}/reports/drc_imp.rpt"
	report_timing -setup -file "${root_dir}/reports/timing_setup.rpt"
	report_timing -hold -file "${root_dir}/reports/timing_hold.rpt"	
}

set root_dir [pwd]

show_options $root_dir "synthesis"

if { $stepSynth == 1} {
show_options $root_dir "implementation"
	if { $stepImpl == 1} {
	show_options $root_dir "bitstream"
	}
}

if { $stepSynth == 1} {
	reset_run synth_1
	launch_runs synth_1 -jobs $jobsNum
	#wait_on_run synth_1
	
	set synthRuns [get_runs -filter {NAME=~ "*_synth_1"}]
	
	foreach my_run $synthRuns {
	wait_on_run $my_run
	}
}

if { $stepImpl == 1} {
	wait_on_run synth_1
	reset_run impl_1
	if { $stepBits == 0 } {
		launch_runs impl_1 -jobs $jobsNum
	    wait_on_run impl_1
	} else {
		launch_runs impl_1 -jobs $jobsNum -to_step write_bitstream
	    wait_on_run impl_1

		# creating platform for sw development
        write_hw_platform -fixed -include_bit -force -file ./project/ethernet_system_wrapper.xsa
        if { ${g_board_part} ne "versal" } {
          file copy -force ./bd/ethernet_system/ip/ethernet_system_eth100gb_0/ethernet_system_eth100gb_0/header_files/ethernet_system_eth100gb_0_axi4_lite_registers.h ./project/
        }

		# programming FPGA
        # open_hw_manager
        # connect_hw_server
        # current_hw_target
        # open_hw_target -jtag_mode off
        # current_hw_device [get_hw_devices xcu280_0]
        # refresh_hw_device
        # set_property PROGRAM.FILE {./project/ethernet_system.runs/impl_1/ethernet_system_wrapper.bit} [get_hw_devices xcu280_0]
        # program_hw_devices
        # refresh_hw_device
        # close_hw_target
        # close_hw_manager
	}
	reportImpl $root_dir
}

if { $stepSynth == 0} {
	openGUI
} else {
	# exit
}

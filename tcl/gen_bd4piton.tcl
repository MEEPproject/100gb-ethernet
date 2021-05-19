
################################################################
# This is a generated script based on design: ethernet_test
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source ethernet_test_script.tcl

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:cmac_usplus:3.1\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:util_reduced_logic:2.0\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:axis_switch:1.1\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:proc_sys_reset:5.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set qsfp0_156mhz [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 qsfp0_156mhz ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   ] $qsfp0_156mhz

  set qsfp0_4x [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 qsfp0_4x ]

  set s_axi [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {1} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $s_axi


  # Create ports
  set QSFP0_FS [ create_bd_port -dir O -from 0 -to 0 QSFP0_FS ]
  set QSFP0_OEB [ create_bd_port -dir O -from 0 -to 0 QSFP0_OEB ]
  set QSFP1_FS [ create_bd_port -dir O -from 0 -to 0 QSFP1_FS ]
  set QSFP1_OEB [ create_bd_port -dir O -from 0 -to 0 QSFP1_OEB ]
  set intc [ create_bd_port -dir O -from 1 -to 0 intc ]
  set s_axi_clk [ create_bd_port -dir I -type clk s_axi_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axi} \
   CONFIG.PHASE {0.0} \
 ] $s_axi_clk
  set s_axi_rstn [ create_bd_port -dir I -type rst s_axi_rstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $s_axi_rstn

  # Create instance: GT_STATUS, and set properties
  set GT_STATUS [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 GT_STATUS ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $GT_STATUS

  # Create instance: STAT_RX_STATUS_REG, and set properties
  set STAT_RX_STATUS_REG [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 STAT_RX_STATUS_REG ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {14} \
 ] $STAT_RX_STATUS_REG

  # Create instance: STAT_TX_STATUS_REG, and set properties
  set STAT_TX_STATUS_REG [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 STAT_TX_STATUS_REG ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $STAT_TX_STATUS_REG

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]
  set_property -dict [ list \
   CONFIG.enable_timer2 {1} \
 ] $axi_timer_0

  # Create instance: concat_intc, and set properties
  set concat_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_intc ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $concat_intc

  # Create instance: const_gnd, and set properties
  set const_gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_gnd ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $const_gnd

  # Create instance: const_gndx17, and set properties
  set const_gndx17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_gndx17 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {17} \
 ] $const_gndx17

  # Create instance: const_gndx28, and set properties
  set const_gndx28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_gndx28 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {28} \
 ] $const_gndx28

  # Create instance: const_gndx31, and set properties
  set const_gndx31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_gndx31 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {31} \
 ] $const_gndx31

  # Create instance: const_gndx56, and set properties
  set const_gndx56 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_gndx56 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {56} \
 ] $const_gndx56

  # Create instance: const_vcc, and set properties
  set const_vcc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_vcc ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $const_vcc

  # Create instance: ctl_rx_enable, and set properties
  set ctl_rx_enable [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ctl_rx_enable ]

  # Create instance: ctl_rx_force_resync, and set properties
  set ctl_rx_force_resync [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ctl_rx_force_resync ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ctl_rx_force_resync

  # Create instance: ctl_rx_test_pattern, and set properties
  set ctl_rx_test_pattern [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ctl_rx_test_pattern ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ctl_rx_test_pattern

  # Create instance: ctl_tx_enable, and set properties
  set ctl_tx_enable [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ctl_tx_enable ]

  # Create instance: ctl_tx_send_idle, and set properties
  set ctl_tx_send_idle [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ctl_tx_send_idle ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ctl_tx_send_idle

  # Create instance: ctl_tx_send_lfi, and set properties
  set ctl_tx_send_lfi [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ctl_tx_send_lfi ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ctl_tx_send_lfi

  # Create instance: ctl_tx_send_rfi, and set properties
  set ctl_tx_send_rfi [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ctl_tx_send_rfi ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ctl_tx_send_rfi

  # Create instance: ctl_tx_test_pattern, and set properties
  set ctl_tx_test_pattern [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ctl_tx_test_pattern ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ctl_tx_test_pattern

  # Create instance: eth100gb, and set properties
  set eth100gb [ create_bd_cell -type ip -vlnv xilinx.com:ip:cmac_usplus:3.1 eth100gb ]
  set_property -dict [ list \
   CONFIG.ADD_GT_CNRL_STS_PORTS {0} \
   CONFIG.DIFFCLK_BOARD_INTERFACE {qsfp0_156mhz} \
   CONFIG.ENABLE_AXI_INTERFACE {1} \
   CONFIG.ENABLE_PIPELINE_REG {0} \
   CONFIG.ENABLE_TIME_STAMPING {0} \
   CONFIG.ETHERNET_BOARD_INTERFACE {qsfp0_4x} \
   CONFIG.GT_REF_CLK_FREQ {156.25} \
   CONFIG.GT_RX_BUFFER_BYPASS {0} \
   CONFIG.INCLUDE_AUTO_NEG_LT_LOGIC {0} \
   CONFIG.INCLUDE_RS_FEC {1} \
   CONFIG.INCLUDE_STATISTICS_COUNTERS {1} \
   CONFIG.PLL_TYPE {QPLL0} \
   CONFIG.RX_CHECK_ACK {1} \
   CONFIG.RX_EQ_MODE {AUTO} \
   CONFIG.RX_FLOW_CONTROL {0} \
   CONFIG.RX_FORWARD_CONTROL_FRAMES {0} \
   CONFIG.RX_GT_BUFFER {1} \
   CONFIG.TX_FLOW_CONTROL {0} \
   CONFIG.TX_OTN_INTERFACE {0} \
   CONFIG.USER_INTERFACE {AXIS} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $eth100gb
  set_property USER_COMMENTS.comment_3 "https://www.xilinx.com/support/documentation/ip_documentation/l_ethernet/v3_1/pg211-50g-ethernet.pdf#page=26" [get_bd_intf_pins /eth100gb/axis_rx]
  set_property USER_COMMENTS.comment_2 "https://www.xilinx.com/support/documentation/ip_documentation/l_ethernet/v3_1/pg211-50g-ethernet.pdf#page=23" [get_bd_intf_pins /eth100gb/axis_tx]
  set_property USER_COMMENTS.comment_1 "http://www.xilinx.com/support/documentation/ip_documentation/cmac_usplus/v3_1/pg203-cmac-usplus.pdf#page=117
http://www.xilinx.com/support/documentation/user_guides/ug578-ultrascale-gty-transceivers.pdf#page=88" [get_bd_pins /eth100gb/gt_loopback_in]
  set_property USER_COMMENTS.comment_4 "https://www.xilinx.com/support/documentation/user_guides/ug578-ultrascale-gty-transceivers.pdf#page=88" [get_bd_pins /eth100gb/gt_loopback_in]

  # Create instance: eth_dma, and set properties
  set eth_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 eth_dma ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_include_sg {1} \
   CONFIG.c_m_axi_mm2s_data_width {512} \
   CONFIG.c_m_axis_mm2s_tdata_width {512} \
   CONFIG.c_mm2s_burst_size {64} \
   CONFIG.c_s2mm_burst_size {64} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {22} \
 ] $eth_dma

  # Create instance: ext_rstn_inv, and set properties
  set ext_rstn_inv [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 ext_rstn_inv ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
 ] $ext_rstn_inv

  # Create instance: gt_ctl, and set properties
  set gt_ctl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gt_ctl ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_IS_DUAL {0} \
 ] $gt_ctl

  # Create instance: gt_loopback, and set properties
  set gt_loopback [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 gt_loopback ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $gt_loopback

  # Create instance: gt_loopback0, and set properties
  set gt_loopback0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_loopback0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {0} \
   CONFIG.DOUT_WIDTH {3} \
 ] $gt_loopback0

  # Create instance: gt_loopback1, and set properties
  set gt_loopback1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_loopback1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {3} \
 ] $gt_loopback1

  # Create instance: gt_loopback2, and set properties
  set gt_loopback2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_loopback2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {3} \
 ] $gt_loopback2

  # Create instance: gt_loopback3, and set properties
  set gt_loopback3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_loopback3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {3} \
 ] $gt_loopback3

  # Create instance: gts_pwr_ok, and set properties
  set gts_pwr_ok [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 gts_pwr_ok ]
  set_property -dict [ list \
   CONFIG.C_SIZE {4} \
 ] $gts_pwr_ok

  # Create instance: loopback_fifo, and set properties
  set loopback_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 loopback_fifo ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $loopback_fifo

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
   CONFIG.NUM_MI {10} \
   CONFIG.NUM_SI {1} \
 ] $microblaze_0_axi_periph

  # Create instance: rx_axis_switch, and set properties
  set rx_axis_switch [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 rx_axis_switch ]
  set_property -dict [ list \
   CONFIG.DECODER_REG {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.ROUTING_MODE {1} \
 ] $rx_axis_switch

  # Create instance: rx_mem, and set properties
  set rx_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 rx_mem ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {false} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $rx_mem

  # Create instance: rx_mem_cpu, and set properties
  set rx_mem_cpu [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 rx_mem_cpu ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.ECC_TYPE {0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $rx_mem_cpu

  # Create instance: rx_mem_dma, and set properties
  set rx_mem_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 rx_mem_dma ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.ECC_TYPE {0} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $rx_mem_dma

  # Create instance: rx_rst_gen, and set properties
  set rx_rst_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rx_rst_gen ]
  set_property -dict [ list \
   CONFIG.RESET_BOARD_INTERFACE {resetn} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $rx_rst_gen

  # Create instance: sg_mem, and set properties
  set sg_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 sg_mem ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $sg_mem

  # Create instance: sg_mem_cpu, and set properties
  set sg_mem_cpu [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 sg_mem_cpu ]
  set_property -dict [ list \
   CONFIG.ECC_TYPE {0} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $sg_mem_cpu

  # Create instance: sg_mem_dma, and set properties
  set sg_mem_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 sg_mem_dma ]
  set_property -dict [ list \
   CONFIG.ECC_TYPE {Hamming} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $sg_mem_dma

  # Create instance: tx_axis_switch, and set properties
  set tx_axis_switch [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 tx_axis_switch ]
  set_property -dict [ list \
   CONFIG.DECODER_REG {1} \
   CONFIG.M00_S00_CONNECTIVITY {1} \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
   CONFIG.ROUTING_MODE {1} \
 ] $tx_axis_switch

  # Create instance: tx_mem, and set properties
  set tx_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 tx_mem ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {false} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $tx_mem

  # Create instance: tx_mem_cpu, and set properties
  set tx_mem_cpu [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 tx_mem_cpu ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.ECC_TYPE {0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $tx_mem_cpu

  # Create instance: tx_mem_dma, and set properties
  set tx_mem_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 tx_mem_dma ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.ECC_TYPE {0} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $tx_mem_dma

  # Create instance: tx_rst_gen, and set properties
  set tx_rst_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 tx_rst_gen ]
  set_property -dict [ list \
   CONFIG.RESET_BOARD_INTERFACE {resetn} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $tx_rst_gen

  # Create instance: tx_rx_ctl_stat, and set properties
  set tx_rx_ctl_stat [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 tx_rx_ctl_stat ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_IS_DUAL {1} \
 ] $tx_rx_ctl_stat

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_0_1 [get_bd_intf_ports s_axi] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins tx_mem/BRAM_PORTA] [get_bd_intf_pins tx_mem_cpu/BRAM_PORTA]
  connect_bd_intf_net -intf_net cmac_usplus_0_axis_rx [get_bd_intf_pins eth100gb/axis_rx] [get_bd_intf_pins rx_axis_switch/S01_AXIS]
  connect_bd_intf_net -intf_net cmac_usplus_0_gt_serial_port [get_bd_intf_ports qsfp0_4x] [get_bd_intf_pins eth100gb/gt_serial_port]
  connect_bd_intf_net -intf_net eth_dma_M_AXIS_MM2S [get_bd_intf_pins eth_dma/M_AXIS_MM2S] [get_bd_intf_pins tx_axis_switch/S00_AXIS]
  connect_bd_intf_net -intf_net eth_dma_M_AXI_MM2S [get_bd_intf_pins eth_dma/M_AXI_MM2S] [get_bd_intf_pins tx_mem_dma/S_AXI]
  connect_bd_intf_net -intf_net eth_dma_M_AXI_S2MM [get_bd_intf_pins eth_dma/M_AXI_S2MM] [get_bd_intf_pins rx_mem_dma/S_AXI]
  connect_bd_intf_net -intf_net eth_dma_M_AXI_SG [get_bd_intf_pins eth_dma/M_AXI_SG] [get_bd_intf_pins sg_mem_dma/S_AXI]
  connect_bd_intf_net -intf_net loopback_fifo_M_AXIS [get_bd_intf_pins loopback_fifo/M_AXIS] [get_bd_intf_pins rx_axis_switch/S00_AXIS]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins eth100gb/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins eth_dma/S_AXI_LITE] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI] [get_bd_intf_pins tx_rx_ctl_stat/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI] [get_bd_intf_pins tx_axis_switch/S_AXI_CTRL]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins rx_axis_switch/S_AXI_CTRL]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins gt_ctl/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins axi_timer_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M07_AXI [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI] [get_bd_intf_pins sg_mem_cpu/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI] [get_bd_intf_pins tx_mem_cpu/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M09_AXI [get_bd_intf_pins microblaze_0_axi_periph/M09_AXI] [get_bd_intf_pins rx_mem_cpu/S_AXI]
  connect_bd_intf_net -intf_net qsfp0_156mhz_1 [get_bd_intf_ports qsfp0_156mhz] [get_bd_intf_pins eth100gb/gt_ref_clk]
  connect_bd_intf_net -intf_net rx_axis_switch_M00_AXIS [get_bd_intf_pins eth_dma/S_AXIS_S2MM] [get_bd_intf_pins rx_axis_switch/M00_AXIS]
  connect_bd_intf_net -intf_net rx_mem_ctr_BRAM_PORTA [get_bd_intf_pins rx_mem/BRAM_PORTA] [get_bd_intf_pins rx_mem_cpu/BRAM_PORTA]
  connect_bd_intf_net -intf_net rx_mem_dma_BRAM_PORTA [get_bd_intf_pins rx_mem/BRAM_PORTB] [get_bd_intf_pins rx_mem_dma/BRAM_PORTA]
  connect_bd_intf_net -intf_net sg_mem_dma1_BRAM_PORTA [get_bd_intf_pins sg_mem/BRAM_PORTA] [get_bd_intf_pins sg_mem_cpu/BRAM_PORTA]
  connect_bd_intf_net -intf_net sg_mem_dma_BRAM_PORTA [get_bd_intf_pins sg_mem/BRAM_PORTB] [get_bd_intf_pins sg_mem_dma/BRAM_PORTA]
  connect_bd_intf_net -intf_net tx_mem_cpu1_BRAM_PORTA [get_bd_intf_pins tx_mem/BRAM_PORTB] [get_bd_intf_pins tx_mem_dma/BRAM_PORTA]
  connect_bd_intf_net -intf_net tx_switch_M00_AXIS [get_bd_intf_pins loopback_fifo/S_AXIS] [get_bd_intf_pins tx_axis_switch/M00_AXIS]
  connect_bd_intf_net -intf_net tx_switch_M01_AXIS [get_bd_intf_pins eth100gb/axis_tx] [get_bd_intf_pins tx_axis_switch/M01_AXIS]

  # Create port connections
  connect_bd_net -net ACLK_0_1 [get_bd_ports s_axi_clk] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins eth100gb/drp_clk] [get_bd_pins eth100gb/init_clk] [get_bd_pins eth100gb/s_axi_aclk] [get_bd_pins eth_dma/m_axi_sg_aclk] [get_bd_pins eth_dma/s_axi_lite_aclk] [get_bd_pins gt_ctl/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/M08_ACLK] [get_bd_pins microblaze_0_axi_periph/M09_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins rx_axis_switch/s_axi_ctrl_aclk] [get_bd_pins rx_mem_cpu/s_axi_aclk] [get_bd_pins sg_mem_cpu/s_axi_aclk] [get_bd_pins sg_mem_dma/s_axi_aclk] [get_bd_pins tx_axis_switch/s_axi_ctrl_aclk] [get_bd_pins tx_mem_cpu/s_axi_aclk] [get_bd_pins tx_rx_ctl_stat/s_axi_aclk]
  connect_bd_net -net GT_STATUS_dout [get_bd_pins GT_STATUS/dout] [get_bd_pins gt_ctl/gpio_io_i]
  connect_bd_net -net STAT_RX_STATUS_REG_dout [get_bd_pins STAT_RX_STATUS_REG/dout] [get_bd_pins tx_rx_ctl_stat/gpio2_io_i]
  connect_bd_net -net STAT_TX_STATUS_REG1_dout [get_bd_pins eth100gb/gt_loopback_in] [get_bd_pins gt_loopback/dout]
  connect_bd_net -net axi_gpio_0_gpio2_io_o [get_bd_pins ctl_rx_enable/Din] [get_bd_pins ctl_rx_force_resync/Din] [get_bd_pins ctl_rx_test_pattern/Din] [get_bd_pins tx_rx_ctl_stat/gpio2_io_o]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins ctl_tx_enable/Din] [get_bd_pins ctl_tx_send_idle/Din] [get_bd_pins ctl_tx_send_lfi/Din] [get_bd_pins ctl_tx_send_rfi/Din] [get_bd_pins ctl_tx_test_pattern/Din] [get_bd_pins tx_rx_ctl_stat/gpio_io_o]
  connect_bd_net -net cmac_usplus_0_gt_powergoodout [get_bd_pins GT_STATUS/In0] [get_bd_pins eth100gb/gt_powergoodout] [get_bd_pins gts_pwr_ok/Op1]
  connect_bd_net -net cmac_usplus_0_gt_rxusrclk2 [get_bd_pins eth100gb/gt_rxusrclk2] [get_bd_pins eth100gb/rx_clk] [get_bd_pins eth_dma/m_axi_s2mm_aclk] [get_bd_pins loopback_fifo/m_axis_aclk] [get_bd_pins rx_axis_switch/aclk] [get_bd_pins rx_mem_dma/s_axi_aclk] [get_bd_pins rx_rst_gen/slowest_sync_clk]
  connect_bd_net -net cmac_usplus_0_gt_txusrclk2 [get_bd_pins eth100gb/gt_txusrclk2] [get_bd_pins eth_dma/m_axi_mm2s_aclk] [get_bd_pins loopback_fifo/s_axis_aclk] [get_bd_pins tx_axis_switch/aclk] [get_bd_pins tx_mem_dma/s_axi_aclk] [get_bd_pins tx_rst_gen/slowest_sync_clk]
  connect_bd_net -net cmac_usplus_0_stat_rx_aligned [get_bd_pins STAT_RX_STATUS_REG/In1] [get_bd_pins eth100gb/stat_rx_aligned]
  connect_bd_net -net cmac_usplus_0_stat_rx_aligned_err [get_bd_pins STAT_RX_STATUS_REG/In3] [get_bd_pins eth100gb/stat_rx_aligned_err]
  connect_bd_net -net cmac_usplus_0_stat_rx_bad_preamble [get_bd_pins STAT_RX_STATUS_REG/In10] [get_bd_pins eth100gb/stat_rx_bad_preamble]
  connect_bd_net -net cmac_usplus_0_stat_rx_bad_sfd [get_bd_pins STAT_RX_STATUS_REG/In11] [get_bd_pins eth100gb/stat_rx_bad_sfd]
  connect_bd_net -net cmac_usplus_0_stat_rx_got_signal_os [get_bd_pins STAT_RX_STATUS_REG/In12] [get_bd_pins eth100gb/stat_rx_got_signal_os]
  connect_bd_net -net cmac_usplus_0_stat_rx_hi_ber [get_bd_pins STAT_RX_STATUS_REG/In4] [get_bd_pins eth100gb/stat_rx_hi_ber]
  connect_bd_net -net cmac_usplus_0_stat_rx_internal_local_fault [get_bd_pins STAT_RX_STATUS_REG/In7] [get_bd_pins eth100gb/stat_rx_internal_local_fault]
  connect_bd_net -net cmac_usplus_0_stat_rx_local_fault [get_bd_pins STAT_RX_STATUS_REG/In6] [get_bd_pins eth100gb/stat_rx_local_fault]
  connect_bd_net -net cmac_usplus_0_stat_rx_misaligned [get_bd_pins STAT_RX_STATUS_REG/In2] [get_bd_pins eth100gb/stat_rx_misaligned]
  connect_bd_net -net cmac_usplus_0_stat_rx_received_local_fault [get_bd_pins STAT_RX_STATUS_REG/In8] [get_bd_pins eth100gb/stat_rx_received_local_fault]
  connect_bd_net -net cmac_usplus_0_stat_rx_remote_fault [get_bd_pins STAT_RX_STATUS_REG/In5] [get_bd_pins eth100gb/stat_rx_remote_fault]
  connect_bd_net -net cmac_usplus_0_stat_rx_status [get_bd_pins STAT_RX_STATUS_REG/In0] [get_bd_pins eth100gb/stat_rx_status]
  connect_bd_net -net cmac_usplus_0_stat_rx_test_pattern_mismatch [get_bd_pins STAT_RX_STATUS_REG/In9] [get_bd_pins eth100gb/stat_rx_test_pattern_mismatch]
  connect_bd_net -net cmac_usplus_0_stat_tx_local_fault [get_bd_pins STAT_TX_STATUS_REG/In0] [get_bd_pins eth100gb/stat_tx_local_fault]
  connect_bd_net -net concat_intc_dout [get_bd_ports intc] [get_bd_pins concat_intc/dout]
  connect_bd_net -net const_gnd_dout [get_bd_ports QSFP0_OEB] [get_bd_ports QSFP1_OEB] [get_bd_pins axi_timer_0/capturetrig0] [get_bd_pins axi_timer_0/capturetrig1] [get_bd_pins axi_timer_0/freeze] [get_bd_pins const_gnd/dout] [get_bd_pins eth100gb/drp_en] [get_bd_pins eth100gb/drp_we] [get_bd_pins eth100gb/pm_tick] [get_bd_pins eth100gb/tx_axis_tuser]
  connect_bd_net -net const_gndx17_dout [get_bd_pins STAT_RX_STATUS_REG/In13] [get_bd_pins const_gndx17/dout]
  connect_bd_net -net const_gndx18_dout [get_bd_pins STAT_TX_STATUS_REG/In1] [get_bd_pins const_gndx31/dout]
  connect_bd_net -net const_gndx28_dout [get_bd_pins GT_STATUS/In1] [get_bd_pins const_gndx28/dout]
  connect_bd_net -net const_gndx56_dout [get_bd_pins const_gndx56/dout] [get_bd_pins eth100gb/tx_preamblein]
  connect_bd_net -net const_vcc_dout [get_bd_ports QSFP0_FS] [get_bd_ports QSFP1_FS] [get_bd_pins const_vcc/dout]
  connect_bd_net -net ctl_tx_send_idle_Dout [get_bd_pins ctl_tx_send_idle/Dout] [get_bd_pins eth100gb/ctl_tx_send_idle]
  connect_bd_net -net ctl_tx_send_lfi_Dout [get_bd_pins ctl_tx_send_lfi/Dout] [get_bd_pins eth100gb/ctl_tx_send_lfi]
  connect_bd_net -net ctl_tx_send_rfi_Dout [get_bd_pins ctl_tx_send_rfi/Dout] [get_bd_pins eth100gb/ctl_tx_send_rfi]
  connect_bd_net -net eth_dma_mm2s_introut [get_bd_pins concat_intc/In0] [get_bd_pins eth_dma/mm2s_introut]
  connect_bd_net -net eth_dma_mm2s_prmry_reset_out_n [get_bd_pins eth_dma/mm2s_prmry_reset_out_n] [get_bd_pins tx_mem_dma/s_axi_aresetn]
  connect_bd_net -net eth_dma_s2mm_introut [get_bd_pins concat_intc/In1] [get_bd_pins eth_dma/s2mm_introut]
  connect_bd_net -net eth_dma_s2mm_prmry_reset_out_n [get_bd_pins eth_dma/s2mm_prmry_reset_out_n] [get_bd_pins rx_mem_dma/s_axi_aresetn]
  connect_bd_net -net gt_ctl_gpio_io_o [get_bd_pins gt_ctl/gpio_io_o] [get_bd_pins gt_loopback0/Din] [get_bd_pins gt_loopback1/Din] [get_bd_pins gt_loopback2/Din] [get_bd_pins gt_loopback3/Din]
  connect_bd_net -net gt_loopback0_Dout [get_bd_pins gt_loopback/In0] [get_bd_pins gt_loopback0/Dout]
  connect_bd_net -net gt_loopback1_Dout [get_bd_pins gt_loopback/In1] [get_bd_pins gt_loopback1/Dout]
  connect_bd_net -net gt_loopback2_Dout [get_bd_pins gt_loopback/In2] [get_bd_pins gt_loopback2/Dout]
  connect_bd_net -net gt_loopback3_Dout [get_bd_pins gt_loopback/In3] [get_bd_pins gt_loopback3/Dout]
  connect_bd_net -net resetn_1 [get_bd_ports s_axi_rstn] [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins eth_dma/axi_resetn] [get_bd_pins ext_rstn_inv/Op1] [get_bd_pins gt_ctl/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/M08_ARESETN] [get_bd_pins microblaze_0_axi_periph/M09_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rx_axis_switch/s_axi_ctrl_aresetn] [get_bd_pins rx_mem_cpu/s_axi_aresetn] [get_bd_pins rx_rst_gen/aux_reset_in] [get_bd_pins rx_rst_gen/ext_reset_in] [get_bd_pins sg_mem_cpu/s_axi_aresetn] [get_bd_pins sg_mem_dma/s_axi_aresetn] [get_bd_pins tx_axis_switch/s_axi_ctrl_aresetn] [get_bd_pins tx_mem_cpu/s_axi_aresetn] [get_bd_pins tx_rst_gen/aux_reset_in] [get_bd_pins tx_rst_gen/ext_reset_in] [get_bd_pins tx_rx_ctl_stat/s_axi_aresetn]
  connect_bd_net -net resetn_inv_0_Res [get_bd_pins eth100gb/core_drp_reset] [get_bd_pins eth100gb/gtwiz_reset_rx_datapath] [get_bd_pins eth100gb/gtwiz_reset_tx_datapath] [get_bd_pins eth100gb/s_axi_sreset] [get_bd_pins eth100gb/sys_reset] [get_bd_pins ext_rstn_inv/Res] [get_bd_pins rx_rst_gen/mb_debug_sys_rst] [get_bd_pins tx_rst_gen/mb_debug_sys_rst]
  connect_bd_net -net rx_rst_gen_peripheral_aresetn [get_bd_pins rx_axis_switch/aresetn] [get_bd_pins rx_rst_gen/peripheral_aresetn]
  connect_bd_net -net rx_rst_gen_peripheral_reset [get_bd_pins eth100gb/core_rx_reset] [get_bd_pins rx_rst_gen/peripheral_reset]
  connect_bd_net -net stat_tx_local_fault_dout [get_bd_pins STAT_TX_STATUS_REG/dout] [get_bd_pins tx_rx_ctl_stat/gpio_io_i]
  connect_bd_net -net tx_rst_gen_peripheral_aresetn [get_bd_pins loopback_fifo/s_axis_aresetn] [get_bd_pins tx_axis_switch/aresetn] [get_bd_pins tx_rst_gen/peripheral_aresetn]
  connect_bd_net -net tx_rst_gen_peripheral_reset [get_bd_pins eth100gb/core_tx_reset] [get_bd_pins tx_rst_gen/peripheral_reset]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins gts_pwr_ok/Res] [get_bd_pins rx_rst_gen/dcm_locked] [get_bd_pins tx_rst_gen/dcm_locked]

  # Create address segments
  assign_bd_address -offset 0x02000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces eth_dma/Data_S2MM] [get_bd_addr_segs rx_mem_dma/S_AXI/Mem0] -force
  assign_bd_address -offset 0x03000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces eth_dma/Data_SG] [get_bd_addr_segs sg_mem_dma/S_AXI/Mem0] -force
  assign_bd_address -offset 0x01000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces eth_dma/Data_MM2S] [get_bd_addr_segs tx_mem_dma/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00800400 -range 0x00000080 -target_address_space [get_bd_addr_spaces s_axi] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00810000 -range 0x00010000 -target_address_space [get_bd_addr_spaces s_axi] [get_bd_addr_segs eth100gb/s_axi/Reg] -force
  assign_bd_address -offset 0x00800C00 -range 0x00000400 -target_address_space [get_bd_addr_spaces s_axi] [get_bd_addr_segs eth_dma/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x00800800 -range 0x00000200 -target_address_space [get_bd_addr_spaces s_axi] [get_bd_addr_segs gt_ctl/S_AXI/Reg] -force
  assign_bd_address -offset 0x00800600 -range 0x00000080 -target_address_space [get_bd_addr_spaces s_axi] [get_bd_addr_segs rx_axis_switch/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x02000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces s_axi] [get_bd_addr_segs rx_mem_cpu/S_AXI/Mem0] -force
  assign_bd_address -offset 0x03000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces s_axi] [get_bd_addr_segs sg_mem_cpu/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00800500 -range 0x00000080 -target_address_space [get_bd_addr_spaces s_axi] [get_bd_addr_segs tx_axis_switch/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x01000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces s_axi] [get_bd_addr_segs tx_mem_cpu/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00800A00 -range 0x00000200 -target_address_space [get_bd_addr_spaces s_axi] [get_bd_addr_segs tx_rx_ctl_stat/S_AXI/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

}
# End of create_root_design()




proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_root_design"
   puts "#"
   puts "#"
   puts "# The following procedures will create hiearchical blocks with addressing "
   puts "# for IPs within those blocks and their sub-hierarchical blocks. Addressing "
   puts "# will not be handled outside those blocks:"
   puts "#"
   puts "#    create_root_design"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs

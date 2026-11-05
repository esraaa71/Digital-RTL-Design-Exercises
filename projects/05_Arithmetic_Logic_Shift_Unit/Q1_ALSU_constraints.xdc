## Basys3 Constraints for ALSU (Q1)

## Clock - W5, 100 MHz
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset - button BTNC (active high)
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports rst]

## Switches - opcode[2:0]
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {opcode[0]}]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {opcode[1]}]
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports {opcode[2]}]

## Switches - A[2:0]
set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports {A[0]}]
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports {A[1]}]
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports {A[2]}]

## Switches - B[2:0]
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports {B[0]}]
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports {B[1]}]
set_property -dict { PACKAGE_PIN V2    IOSTANDARD LVCMOS33 } [get_ports {B[2]}]

## Switch - cin
set_property -dict { PACKAGE_PIN T3    IOSTANDARD LVCMOS33 } [get_ports cin]

## Switch - red_op_A
set_property -dict { PACKAGE_PIN T2    IOSTANDARD LVCMOS33 } [get_ports red_op_A]

## Switch - red_op_B
set_property -dict { PACKAGE_PIN R3    IOSTANDARD LVCMOS33 } [get_ports red_op_B]

## Switch - bypass_A
set_property -dict { PACKAGE_PIN W2    IOSTANDARD LVCMOS33 } [get_ports bypass_A]

## Switch - bypass_B
set_property -dict { PACKAGE_PIN U1    IOSTANDARD LVCMOS33 } [get_ports bypass_B]

## Switch - direction
set_property -dict { PACKAGE_PIN T1    IOSTANDARD LVCMOS33 } [get_ports direction]

## Switch - serial_in
set_property -dict { PACKAGE_PIN R2    IOSTANDARD LVCMOS33 } [get_ports serial_in]

## LEDs - leds[15:0]
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {leds[2]}]
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {leds[3]}]
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports {leds[4]}]
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports {leds[5]}]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports {leds[6]}]
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports {leds[7]}]
set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports {leds[8]}]
set_property -dict { PACKAGE_PIN V3    IOSTANDARD LVCMOS33 } [get_ports {leds[9]}]
set_property -dict { PACKAGE_PIN W3    IOSTANDARD LVCMOS33 } [get_ports {leds[10]}]
set_property -dict { PACKAGE_PIN U3    IOSTANDARD LVCMOS33 } [get_ports {leds[11]}]
set_property -dict { PACKAGE_PIN P3    IOSTANDARD LVCMOS33 } [get_ports {leds[12]}]
set_property -dict { PACKAGE_PIN N3    IOSTANDARD LVCMOS33 } [get_ports {leds[13]}]
set_property -dict { PACKAGE_PIN P1    IOSTANDARD LVCMOS33 } [get_ports {leds[14]}]
set_property -dict { PACKAGE_PIN L1    IOSTANDARD LVCMOS33 } [get_ports {leds[15]}]

## Configuration
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]


## ---------------------------------------------------------------
## ILA Debug Core
## ---------------------------------------------------------------
create_debug_core u_ila_0 ila
set_property C_DATA_DEPTH 1024        [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN  false       [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false       [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false      [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0   [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU true  [get_debug_cores u_ila_0]

## Connect clock
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_IBUF_BUFG]]

## Probe 0 - A registered
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {DUT/A_r[0]} {DUT/A_r[1]} {DUT/A_r[2]}]]

## Probe 1 - B registered
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 3 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {DUT/B_r[0]} {DUT/B_r[1]} {DUT/B_r[2]}]]

## Probe 2 - opcode registered
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 3 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {DUT/opcode_r[0]} {DUT/opcode_r[1]} {DUT/opcode_r[2]}]]

## Probe 3 - out
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 6 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {out[0]} {out[1]} {out[2]} {out[3]} {out[4]} {out[5]}]]

## Probe 4 - leds
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 16 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {leds[0]} {leds[1]} {leds[2]} {leds[3]} {leds[4]} {leds[5]} {leds[6]} {leds[7]} {leds[8]} {leds[9]} {leds[10]} {leds[11]} {leds[12]} {leds[13]} {leds[14]} {leds[15]}]]

## Probe 5 - invalid flag
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list DUT/invalid]]

create_clock -name refclk -period 10 [get_ports refclk]
derive_pll_clocks -use_net_name
#set clk [get_clocks {memphy:memphy|altpll:pll|altpll_oc41:auto_generated|clk[0]}]
create_generated_clock -name ddrclk -source [get_nets {memphy|pll|auto_generated|clk[0]~CLKENA0}] [get_ports {ddrckp}]
create_generated_clock -name ddrclksh -source [get_nets {memphy|pll|auto_generated|clk[0]~CLKENA0}] [get_ports {ddrckp}] -phase 180 -add
create_generated_clock -name ddrdqsp -source [get_nets {memphy|pll|auto_generated|clk[2]~CLKENA0}] [get_ports {ddrdqsp}]
set_output_delay -clock [get_clocks ddrclk] 0.3 [get_ports {ddra[*] ddrba[*] ddrcs ddrcke ddrras ddrcas ddrwe ddrreset}]
set_input_delay -clock [get_clocks ddrclksh] -max 0.3 [get_ports {ddrdq[*]}]
set_input_delay -clock [get_clocks ddrclksh] -min -0.3 [get_ports {ddrdq[*]}] -add_delay
set_input_delay -clock [get_clocks ddrclksh] -max 0.3 [get_ports {ddrdq[*]}] -add_delay -clock_fall
set_input_delay -clock [get_clocks ddrclksh] -min -0.3 [get_ports {ddrdq[*]}] -add_delay -clock_fall
set_output_delay -clock [get_clocks ddrdqsp] -max 0 [get_ports {ddrdq[*]}]
set_output_delay -clock [get_clocks ddrdqsp] -min 0 [get_ports {ddrdq[*]}] -add_delay
set_multicycle_path -from [get_clocks {ddrclksh}] -to [get_clocks {memphy:memphy|altpll:pll|altpll*:auto_generated|clk[0]}] -end 2 -setup
set_multicycle_path -from [get_clocks {ddrclksh}] -to [get_clocks {memphy:memphy|altpll:pll|altpll*:auto_generated|clk[0]}] -end 2 -hold

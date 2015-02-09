##
## DEVICE  "EP4CE115F29C7"
##

#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************

create_clock -name clock_50 -period 20.000 [get_ports {clock_50}]

# virtual clock for I/O (matches cog_clock)
create_clock -name clock_io -period 12.500

#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks

# create_generated_clock -name cog_pll -source {pll|auto_generated|pll1|inclk[0]} -divide_by 5 -multiply_by 16 -duty_cycle 50.00 -name {pll|auto_generated|pll1|clk[0]} {pll|auto_generated|pll1|clk[0]}

create_generated_clock -name cog_clk -source [get_pins {pll|auto_generated|pll1|clk[0]}] -divide_by 2 [get_registers { tim:clkgen|divide[12] }]

create_generated_clock -name ctra0_pll0 -source {pll|auto_generated|pll1|clk[0]} -divide_by 2   {dig:core|cog:coggen[0].cog_|cog_ctr:cog_ctra|pll_fake[28]}
create_generated_clock -name ctra0_pll1 -source {pll|auto_generated|pll1|clk[0]} -divide_by 4   {dig:core|cog:coggen[0].cog_|cog_ctr:cog_ctra|pll_fake[29]}
create_generated_clock -name ctra0_pll2 -source {pll|auto_generated|pll1|clk[0]} -divide_by 8   {dig:core|cog:coggen[0].cog_|cog_ctr:cog_ctra|pll_fake[30]}
create_generated_clock -name ctra0_pll3 -source {pll|auto_generated|pll1|clk[0]} -divide_by 16  {dig:core|cog:coggen[0].cog_|cog_ctr:cog_ctra|pll_fake[31]}
create_generated_clock -name ctra0_pll4 -source {pll|auto_generated|pll1|clk[0]} -divide_by 32  {dig:core|cog:coggen[0].cog_|cog_ctr:cog_ctra|pll_fake[32]}
create_generated_clock -name ctra0_pll5 -source {pll|auto_generated|pll1|clk[0]} -divide_by 64  {dig:core|cog:coggen[0].cog_|cog_ctr:cog_ctra|pll_fake[33]}
create_generated_clock -name ctra0_pll6 -source {pll|auto_generated|pll1|clk[0]} -divide_by 128 {dig:core|cog:coggen[0].cog_|cog_ctr:cog_ctra|pll_fake[34]}
create_generated_clock -name ctra0_pll7 -source {pll|auto_generated|pll1|clk[0]} -divide_by 256 {dig:core|cog:coggen[0].cog_|cog_ctr:cog_ctra|pll_fake[35]}

create_generated_clock -name ctra1_pll0 -source {pll|auto_generated|pll1|clk[0]} -divide_by 2   {dig:core|cog:coggen[1].cog_|cog_ctr:cog_ctra|pll_fake[28]}
create_generated_clock -name ctra1_pll1 -source {pll|auto_generated|pll1|clk[0]} -divide_by 4   {dig:core|cog:coggen[1].cog_|cog_ctr:cog_ctra|pll_fake[29]}
create_generated_clock -name ctra1_pll2 -source {pll|auto_generated|pll1|clk[0]} -divide_by 8   {dig:core|cog:coggen[1].cog_|cog_ctr:cog_ctra|pll_fake[30]}
create_generated_clock -name ctra1_pll3 -source {pll|auto_generated|pll1|clk[0]} -divide_by 16  {dig:core|cog:coggen[1].cog_|cog_ctr:cog_ctra|pll_fake[31]}
create_generated_clock -name ctra1_pll4 -source {pll|auto_generated|pll1|clk[0]} -divide_by 32  {dig:core|cog:coggen[1].cog_|cog_ctr:cog_ctra|pll_fake[32]}
create_generated_clock -name ctra1_pll5 -source {pll|auto_generated|pll1|clk[0]} -divide_by 64  {dig:core|cog:coggen[1].cog_|cog_ctr:cog_ctra|pll_fake[33]}
create_generated_clock -name ctra1_pll6 -source {pll|auto_generated|pll1|clk[0]} -divide_by 128 {dig:core|cog:coggen[1].cog_|cog_ctr:cog_ctra|pll_fake[34]}
create_generated_clock -name ctra1_pll7 -source {pll|auto_generated|pll1|clk[0]} -divide_by 256 {dig:core|cog:coggen[1].cog_|cog_ctr:cog_ctra|pll_fake[35]}

create_generated_clock -name ctra2_pll0 -source {pll|auto_generated|pll1|clk[0]} -divide_by 2   {dig:core|cog:coggen[2].cog_|cog_ctr:cog_ctra|pll_fake[28]}
create_generated_clock -name ctra2_pll1 -source {pll|auto_generated|pll1|clk[0]} -divide_by 4   {dig:core|cog:coggen[2].cog_|cog_ctr:cog_ctra|pll_fake[29]}
create_generated_clock -name ctra2_pll2 -source {pll|auto_generated|pll1|clk[0]} -divide_by 8   {dig:core|cog:coggen[2].cog_|cog_ctr:cog_ctra|pll_fake[30]}
create_generated_clock -name ctra2_pll3 -source {pll|auto_generated|pll1|clk[0]} -divide_by 16  {dig:core|cog:coggen[2].cog_|cog_ctr:cog_ctra|pll_fake[31]}
create_generated_clock -name ctra2_pll4 -source {pll|auto_generated|pll1|clk[0]} -divide_by 32  {dig:core|cog:coggen[2].cog_|cog_ctr:cog_ctra|pll_fake[32]}
create_generated_clock -name ctra2_pll5 -source {pll|auto_generated|pll1|clk[0]} -divide_by 64  {dig:core|cog:coggen[2].cog_|cog_ctr:cog_ctra|pll_fake[33]}
create_generated_clock -name ctra2_pll6 -source {pll|auto_generated|pll1|clk[0]} -divide_by 128 {dig:core|cog:coggen[2].cog_|cog_ctr:cog_ctra|pll_fake[34]}
create_generated_clock -name ctra2_pll7 -source {pll|auto_generated|pll1|clk[0]} -divide_by 256 {dig:core|cog:coggen[2].cog_|cog_ctr:cog_ctra|pll_fake[35]}

create_generated_clock -name ctra3_pll0 -source {pll|auto_generated|pll1|clk[0]} -divide_by 2   {dig:core|cog:coggen[3].cog_|cog_ctr:cog_ctra|pll_fake[28]}
create_generated_clock -name ctra3_pll1 -source {pll|auto_generated|pll1|clk[0]} -divide_by 4   {dig:core|cog:coggen[3].cog_|cog_ctr:cog_ctra|pll_fake[29]}
create_generated_clock -name ctra3_pll2 -source {pll|auto_generated|pll1|clk[0]} -divide_by 8   {dig:core|cog:coggen[3].cog_|cog_ctr:cog_ctra|pll_fake[30]}
create_generated_clock -name ctra3_pll3 -source {pll|auto_generated|pll1|clk[0]} -divide_by 16  {dig:core|cog:coggen[3].cog_|cog_ctr:cog_ctra|pll_fake[31]}
create_generated_clock -name ctra3_pll4 -source {pll|auto_generated|pll1|clk[0]} -divide_by 32  {dig:core|cog:coggen[3].cog_|cog_ctr:cog_ctra|pll_fake[32]}
create_generated_clock -name ctra3_pll5 -source {pll|auto_generated|pll1|clk[0]} -divide_by 64  {dig:core|cog:coggen[3].cog_|cog_ctr:cog_ctra|pll_fake[33]}
create_generated_clock -name ctra3_pll6 -source {pll|auto_generated|pll1|clk[0]} -divide_by 128 {dig:core|cog:coggen[3].cog_|cog_ctr:cog_ctra|pll_fake[34]}
create_generated_clock -name ctra3_pll7 -source {pll|auto_generated|pll1|clk[0]} -divide_by 256 {dig:core|cog:coggen[3].cog_|cog_ctr:cog_ctra|pll_fake[35]}

create_generated_clock -name ctra4_pll0 -source {pll|auto_generated|pll1|clk[0]} -divide_by 2   {dig:core|cog:coggen[4].cog_|cog_ctr:cog_ctra|pll_fake[28]}
create_generated_clock -name ctra4_pll1 -source {pll|auto_generated|pll1|clk[0]} -divide_by 4   {dig:core|cog:coggen[4].cog_|cog_ctr:cog_ctra|pll_fake[29]}
create_generated_clock -name ctra4_pll2 -source {pll|auto_generated|pll1|clk[0]} -divide_by 8   {dig:core|cog:coggen[4].cog_|cog_ctr:cog_ctra|pll_fake[30]}
create_generated_clock -name ctra4_pll3 -source {pll|auto_generated|pll1|clk[0]} -divide_by 16  {dig:core|cog:coggen[4].cog_|cog_ctr:cog_ctra|pll_fake[31]}
create_generated_clock -name ctra4_pll4 -source {pll|auto_generated|pll1|clk[0]} -divide_by 32  {dig:core|cog:coggen[4].cog_|cog_ctr:cog_ctra|pll_fake[32]}
create_generated_clock -name ctra4_pll5 -source {pll|auto_generated|pll1|clk[0]} -divide_by 64  {dig:core|cog:coggen[4].cog_|cog_ctr:cog_ctra|pll_fake[33]}
create_generated_clock -name ctra4_pll6 -source {pll|auto_generated|pll1|clk[0]} -divide_by 128 {dig:core|cog:coggen[4].cog_|cog_ctr:cog_ctra|pll_fake[34]}
create_generated_clock -name ctra4_pll7 -source {pll|auto_generated|pll1|clk[0]} -divide_by 256 {dig:core|cog:coggen[4].cog_|cog_ctr:cog_ctra|pll_fake[35]}

create_generated_clock -name ctra5_pll0 -source {pll|auto_generated|pll1|clk[0]} -divide_by 2   {dig:core|cog:coggen[5].cog_|cog_ctr:cog_ctra|pll_fake[28]}
create_generated_clock -name ctra5_pll1 -source {pll|auto_generated|pll1|clk[0]} -divide_by 4   {dig:core|cog:coggen[5].cog_|cog_ctr:cog_ctra|pll_fake[29]}
create_generated_clock -name ctra5_pll2 -source {pll|auto_generated|pll1|clk[0]} -divide_by 8   {dig:core|cog:coggen[5].cog_|cog_ctr:cog_ctra|pll_fake[30]}
create_generated_clock -name ctra5_pll3 -source {pll|auto_generated|pll1|clk[0]} -divide_by 16  {dig:core|cog:coggen[5].cog_|cog_ctr:cog_ctra|pll_fake[31]}
create_generated_clock -name ctra5_pll4 -source {pll|auto_generated|pll1|clk[0]} -divide_by 32  {dig:core|cog:coggen[5].cog_|cog_ctr:cog_ctra|pll_fake[32]}
create_generated_clock -name ctra5_pll5 -source {pll|auto_generated|pll1|clk[0]} -divide_by 64  {dig:core|cog:coggen[5].cog_|cog_ctr:cog_ctra|pll_fake[33]}
create_generated_clock -name ctra5_pll6 -source {pll|auto_generated|pll1|clk[0]} -divide_by 128 {dig:core|cog:coggen[5].cog_|cog_ctr:cog_ctra|pll_fake[34]}
create_generated_clock -name ctra5_pll7 -source {pll|auto_generated|pll1|clk[0]} -divide_by 256 {dig:core|cog:coggen[5].cog_|cog_ctr:cog_ctra|pll_fake[35]}

create_generated_clock -name ctra6_pll0 -source {pll|auto_generated|pll1|clk[0]} -divide_by 2   {dig:core|cog:coggen[6].cog_|cog_ctr:cog_ctra|pll_fake[28]}
create_generated_clock -name ctra6_pll1 -source {pll|auto_generated|pll1|clk[0]} -divide_by 4   {dig:core|cog:coggen[6].cog_|cog_ctr:cog_ctra|pll_fake[29]}
create_generated_clock -name ctra6_pll2 -source {pll|auto_generated|pll1|clk[0]} -divide_by 8   {dig:core|cog:coggen[6].cog_|cog_ctr:cog_ctra|pll_fake[30]}
create_generated_clock -name ctra6_pll3 -source {pll|auto_generated|pll1|clk[0]} -divide_by 16  {dig:core|cog:coggen[6].cog_|cog_ctr:cog_ctra|pll_fake[31]}
create_generated_clock -name ctra6_pll4 -source {pll|auto_generated|pll1|clk[0]} -divide_by 32  {dig:core|cog:coggen[6].cog_|cog_ctr:cog_ctra|pll_fake[32]}
create_generated_clock -name ctra6_pll5 -source {pll|auto_generated|pll1|clk[0]} -divide_by 64  {dig:core|cog:coggen[6].cog_|cog_ctr:cog_ctra|pll_fake[33]}
create_generated_clock -name ctra6_pll6 -source {pll|auto_generated|pll1|clk[0]} -divide_by 128 {dig:core|cog:coggen[6].cog_|cog_ctr:cog_ctra|pll_fake[34]}
create_generated_clock -name ctra6_pll7 -source {pll|auto_generated|pll1|clk[0]} -divide_by 256 {dig:core|cog:coggen[6].cog_|cog_ctr:cog_ctra|pll_fake[35]}

create_generated_clock -name ctra7_pll0 -source {pll|auto_generated|pll1|clk[0]} -divide_by 2   {dig:core|cog:coggen[7].cog_|cog_ctr:cog_ctra|pll_fake[28]}
create_generated_clock -name ctra7_pll1 -source {pll|auto_generated|pll1|clk[0]} -divide_by 4   {dig:core|cog:coggen[7].cog_|cog_ctr:cog_ctra|pll_fake[29]}
create_generated_clock -name ctra7_pll2 -source {pll|auto_generated|pll1|clk[0]} -divide_by 8   {dig:core|cog:coggen[7].cog_|cog_ctr:cog_ctra|pll_fake[30]}
create_generated_clock -name ctra7_pll3 -source {pll|auto_generated|pll1|clk[0]} -divide_by 16  {dig:core|cog:coggen[7].cog_|cog_ctr:cog_ctra|pll_fake[31]}
create_generated_clock -name ctra7_pll4 -source {pll|auto_generated|pll1|clk[0]} -divide_by 32  {dig:core|cog:coggen[7].cog_|cog_ctr:cog_ctra|pll_fake[32]}
create_generated_clock -name ctra7_pll5 -source {pll|auto_generated|pll1|clk[0]} -divide_by 64  {dig:core|cog:coggen[7].cog_|cog_ctr:cog_ctra|pll_fake[33]}
create_generated_clock -name ctra7_pll6 -source {pll|auto_generated|pll1|clk[0]} -divide_by 128 {dig:core|cog:coggen[7].cog_|cog_ctr:cog_ctra|pll_fake[34]}
create_generated_clock -name ctra7_pll7 -source {pll|auto_generated|pll1|clk[0]} -divide_by 256 {dig:core|cog:coggen[7].cog_|cog_ctr:cog_ctra|pll_fake[35]}

#**************************************************************
# Set Clock Latency
#**************************************************************

#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty

#**************************************************************
# Set Input Delay
#**************************************************************

# The min/max delays are set to zero, so that TimeQuest doesn't
# input port timing into account.
set_input_delay -clock clock_io -min 0 [get_ports {inp_resn io*}]
set_input_delay -clock clock_io -max 0 [get_ports {inp_resn io*}]

#**************************************************************
# Set Output Delay
#**************************************************************

# The min/max delays are set to zero, so that TimeQuest doesn't
# output port timing into account.
set_output_delay -clock clock_io -min 0 [get_ports {ledg* io*}]
set_output_delay -clock clock_io -max 0 [get_ports {ledg* io*}]

#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -exclusive \
    -group { clock_50 pll|auto_generated|pll1|clk[0] cog_clk}
    
set_clock_groups -exclusive \
    -group {ctra0_pll0} \
    -group {ctra0_pll1} \
    -group {ctra0_pll2} \
    -group {ctra0_pll3} \
    -group {ctra0_pll4} \
    -group {ctra0_pll5} \
    -group {ctra0_pll6} \
    -group {ctra0_pll7}

set_clock_groups -exclusive \
    -group {ctra1_pll0} \
    -group {ctra1_pll1} \
    -group {ctra1_pll2} \
    -group {ctra1_pll3} \
    -group {ctra1_pll4} \
    -group {ctra1_pll5} \
    -group {ctra1_pll6} \
    -group {ctra1_pll7}

set_clock_groups -exclusive \
    -group {ctra2_pll0} \
    -group {ctra2_pll1} \
    -group {ctra2_pll2} \
    -group {ctra2_pll3} \
    -group {ctra2_pll4} \
    -group {ctra2_pll5} \
    -group {ctra2_pll6} \
    -group {ctra2_pll7}

set_clock_groups -exclusive \
    -group {ctra3_pll0} \
    -group {ctra3_pll1} \
    -group {ctra3_pll2} \
    -group {ctra3_pll3} \
    -group {ctra3_pll4} \
    -group {ctra3_pll5} \
    -group {ctra3_pll6} \
    -group {ctra3_pll7}

set_clock_groups -exclusive \
    -group {ctra4_pll0} \
    -group {ctra4_pll1} \
    -group {ctra4_pll2} \
    -group {ctra4_pll3} \
    -group {ctra4_pll4} \
    -group {ctra4_pll5} \
    -group {ctra4_pll6} \
    -group {ctra4_pll7}

set_clock_groups -exclusive \
    -group {ctra5_pll0} \
    -group {ctra5_pll1} \
    -group {ctra5_pll2} \
    -group {ctra5_pll3} \
    -group {ctra5_pll4} \
    -group {ctra5_pll5} \
    -group {ctra5_pll6} \
    -group {ctra5_pll7}

set_clock_groups -exclusive \
    -group {ctra6_pll0} \
    -group {ctra6_pll1} \
    -group {ctra6_pll2} \
    -group {ctra6_pll3} \
    -group {ctra6_pll4} \
    -group {ctra6_pll5} \
    -group {ctra6_pll6} \
    -group {ctra6_pll7}

set_clock_groups -exclusive \
    -group {ctra7_pll0} \
    -group {ctra7_pll1} \
    -group {ctra7_pll2} \
    -group {ctra7_pll3} \
    -group {ctra7_pll4} \
    -group {ctra7_pll5} \
    -group {ctra7_pll6} \
    -group {ctra7_pll7}

#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_clocks {ctra*}] -to clock_io

#**************************************************************
# Set Multicycle Path
#**************************************************************

#**************************************************************
# Set Maximum Delay
#**************************************************************

#**************************************************************
# Set Minimum Delay
#**************************************************************

#**************************************************************
# Set Input Transition
#**************************************************************


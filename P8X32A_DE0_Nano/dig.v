// dig

/*
-------------------------------------------------------------------------------
Copyright 2014 Parallax Inc.

This file is part of the hardware description for the Propeller 1 Design.

The Propeller 1 Design is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your option)
any later version.

The Propeller 1 Design is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
the Propeller 1 Design.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------------
*/

`include "cog.v"	// cog logic and memory (8 instances)
`include "hub.v"	// hub logic and memory

module				dig
(
input				nres,			// reset input (active low)

output		 [7:0]	cfg,			// configuration output (set by clkset instruction)

input				clk_cog,		// cog clock input
input				clk_pll,		// pll simulator clock input (2x cog clock)

input		[31:0]	pin_in,			// pin state inputs
output		[31:0]	pin_out,		// pin state outputs
output		[31:0]	pin_dir,		// pin direction outputs

output		 [7:0]	cog_led			// led outputs to show which cogs are active
);


// cnt

reg [31:0] cnt;

always @(posedge clk_cog)
if (nres)
	cnt <= cnt + 1'b1;


// bus enable

reg ena_bus;

always @(posedge clk_cog or negedge nres)
if (!nres)
	ena_bus <= 1'b0;
else
	ena_bus <= !ena_bus;


// bus select

reg [7:0] bus_sel;

always @(posedge clk_cog or negedge nres)
if (!nres)
	bus_sel <= 8'b0;
else if (ena_bus)
	bus_sel <= {bus_sel[6:0], ~|bus_sel[6:0]};


// cogs

wire [7:0]			bus_r;
wire [7:0]			bus_e;
wire [7:0]			bus_w;
wire [7:0]  [1:0]	bus_s;
wire [7:0] [15:0]	bus_a;
wire [7:0] [31:0]	bus_d;
wire [7:0]			pll;
wire [7:0] [31:0]	outx;
wire [7:0] [31:0]	dirx;

genvar i;
generate
	for (i=0; i<8; i++)
	begin : coggen
		cog cog_(	.nres		(nres),
					.clk_cog	(clk_cog),
					.clk_pll	(clk_pll),
					.ena_bus	(ena_bus),
					.ptr_w		(ptr_w[i]),
					.ptr_d		(ptr_d),
					.ena		(cog_ena[i]),
					.bus_sel	(bus_sel[i]),
					.bus_r		(bus_r[i]),
					.bus_e		(bus_e[i]),
					.bus_w		(bus_w[i]),
					.bus_s		(bus_s[i]),
					.bus_a		(bus_a[i]),
					.bus_d		(bus_d[i]),
					.bus_q		(bus_q),
					.bus_c		(bus_c),
					.bus_ack	(bus_ack[i]),
					.cnt		(cnt),
					.pll_in		(pll),
					.pll_out	(pll[i]),
					.pin_in		(pin_in),
					.pin_out	(outx[i]),
					.pin_dir	(dirx[i])	);
	end
endgenerate


// hub

wire		hub_bus_r	= |bus_r;
wire		hub_bus_e	= |bus_e;
wire		hub_bus_w	= |bus_w;
wire  [1:0]	hub_bus_s	= bus_s[7] | bus_s[6] | bus_s[5] | bus_s[4] | bus_s[3] | bus_s[2] | bus_s[1] | bus_s[0];
wire [15:0]	hub_bus_a	= bus_a[7] | bus_a[6] | bus_a[5] | bus_a[4] | bus_a[3] | bus_a[2] | bus_a[1] | bus_a[0];
wire [31:0]	hub_bus_d	= bus_d[7] | bus_d[6] | bus_d[5] | bus_d[4] | bus_d[3] | bus_d[2] | bus_d[1] | bus_d[0];
wire [31:0]	bus_q;
wire		bus_c;
wire  [7:0]	bus_ack;
wire  [7:0]	cog_ena;
wire  [7:0]	ptr_w;
wire [27:0]	ptr_d;

hub hub_		(	.clk_cog	(clk_cog),
					.ena_bus	(ena_bus),
					.nres		(nres),
					.bus_sel	(bus_sel),
					.bus_r		(hub_bus_r),
					.bus_e		(hub_bus_e),
					.bus_w		(hub_bus_w),
					.bus_s		(hub_bus_s),
					.bus_a		(hub_bus_a),
					.bus_d		(hub_bus_d),
					.bus_q		(bus_q),
					.bus_c		(bus_c),
					.bus_ack	(bus_ack),
					.cog_ena	(cog_ena),
					.ptr_w		(ptr_w),
					.ptr_d		(ptr_d),
					.cfg		(cfg)	);


// pins

assign pin_out		= outx[7] | outx[6] | outx[5] | outx[4] | outx[3] | outx[2] | outx[1] | outx[0];
assign pin_dir		= dirx[7] | dirx[6] | dirx[5] | dirx[4] | dirx[3] | dirx[2] | dirx[1] | dirx[0];


// cog leds

assign cog_led		= cog_ena;

endmodule

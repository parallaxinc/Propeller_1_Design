// hub

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

`include "hub_mem.v"

module				hub
(
input				clk_cog,
input				ena_bus,

input				nres,

input		 [7:0]	bus_sel,
input				bus_r,
input				bus_e,
input				bus_w,
input		 [1:0]	bus_s,
input		[15:0]	bus_a,
input		[31:0]	bus_d,
output reg	[31:0]	bus_q,
output				bus_c,
output		 [7:0]	bus_ack,

output reg	 [7:0]	cog_ena,

output		 [7:0]	ptr_w,
output		[27:0]	ptr_d,

output reg	 [7:0]	cfg
);


// latch bus signals from cog[n]

reg rc;
reg ec;
reg wc;
reg [1:0] sc;
reg [15:0] ac;
reg [31:0] dc;

always @(posedge clk_cog)
if (ena_bus)
	rc <= bus_r;

always @(posedge clk_cog or negedge nres)
if (!nres)
	ec <= 1'b0;
else if (ena_bus)
	ec <= bus_e;

always @(posedge clk_cog)
if (ena_bus)
	wc <= bus_w;

always @(posedge clk_cog)
if (ena_bus)
	sc <= bus_s;

always @(posedge clk_cog)
if (ena_bus)
	ac <= bus_a;

always @(posedge clk_cog)
if (ena_bus)
	dc <= bus_d;


// connect hub memory to signals from cog[n-1]

wire mem_w			= ec && ~&sc && wc;

wire [3:0] mem_wb	= sc[1]	? 4'b1111						// wrlong
					: sc[0]	? ac[1] ? 4'b1100 : 4'b0011		// wrword
							: 4'b0001 << ac[1:0];			// wrbyte

wire [31:0] mem_d	= sc[1]	? dc							// wrlong
					: sc[0]	? {2{dc[15:0]}}					// wrword
							: {4{dc[7:0]}};					// wrbyte

wire [31:0] mem_q;

hub_mem hub_mem_  (	.clk_cog	(clk_cog),
					.ena_bus	(ena_bus),
					.w			(mem_w),
					.wb			(mem_wb),
					.a			(ac[15:2]),
					.d			(mem_d),
					.q			(mem_q) );


// latch bus signals from cog[n-1]

reg rd;
reg ed;
reg [1:0] sd;
reg [1:0] ad;

always @(posedge clk_cog)
if (ena_bus)
	rd <= !rc && ac[15];

always @(posedge clk_cog or negedge nres)
if (!nres)
	ed <= 1'b0;
else if (ena_bus)
	ed <= ec;

always @(posedge clk_cog)
if (ena_bus)
	sd <= sc;

always @(posedge clk_cog)
if (ena_bus)
	ad <= ac[1:0];


// set bus output according to cog[n-2]

wire [31:0] ramq	= !rd ? mem_q : {mem_q[03], mem_q[07], mem_q[21], mem_q[12],	// unscramble rom data if cog loading
								 	 mem_q[06], mem_q[19], mem_q[04], mem_q[17],
									 mem_q[20], mem_q[15], mem_q[08], mem_q[11],
									 mem_q[00], mem_q[14], mem_q[30], mem_q[01],
									 mem_q[23], mem_q[31], mem_q[16], mem_q[05],
									 mem_q[09], mem_q[18], mem_q[25], mem_q[02],
									 mem_q[28], mem_q[22], mem_q[13], mem_q[27],
									 mem_q[29], mem_q[24], mem_q[26], mem_q[10]};

always @(posedge clk_cog)
	bus_q <=  sd[1]	? sd[0]	? {29'b0, sys_q}								// cogid/coginit/locknew
							: ramq											// rdlong
					: sd[0]	? ramq >> {ad[1],   4'b0} & 32'h0000FFFF		// rdword
							: ramq >> {ad[1:0], 3'b0} & 32'h000000FF;		// rdbyte

assign bus_c		= sys_c;


// generate bus acknowledge for cog[n-2]

assign bus_ack		= ed ? {bus_sel[1:0], bus_sel[7:2]} : 8'b0;


// sys common logic
//
//	ac in				dc in				num				sys_q			sys_c
//	-----------------------------------------------------------------------------------------
//	000		CLKSET		config(8)			-				-				-
//	001		COGID		-					-				[n-1]			-
//	010		COGINIT		ptr(28),newx,id(3)	id(3)/newx		id(3)/newx		all
//	011		COGSTOP		-,id(3)				id(3)			id(3)			-
//	100		LOCKNEW		-					newx			newx			all
//	101		LOCKRET		-,id(3)				id(3)			id(3)			-
//	110		LOCKSET		-,id(3)				id(3)			id(3)			lock_state[id(3)]
//	111		LOCKCLR		-,id(3)				id(3)			id(3)			lock_state[id(3)]

wire sys			= ec && (&sc);

wire [7:0] enc		= ac[2] ? lock_e : cog_e;

wire all			= &enc;		// no free cogs/locks

wire [2:0] newx		= &enc[3:0]	? &enc[5:4]	? enc[6]	? 3'b111		// x1111111 -> 111
														: 3'b110		// x0111111 -> 110
											: enc[4]	? 3'b101		// xx011111 -> 101
														: 3'b100		// xxx01111 -> 100
								: &enc[1:0]	? enc[2]	? 3'b011		// xxxx0111 -> 011
														: 3'b010		// xxxxx011 -> 010
											: enc[0]	? 3'b001		// xxxxxx01 -> 001
														: 3'b000;		// xxxxxxx0 -> 000

wire [2:0] num		= ac[2:0] == 3'b010 && dc[3] || ac[2:0] == 3'b100 ? newx : dc[2:0];

wire [7:0] num_dcd	= 1'b1 << num;


// cfg

always @(posedge clk_cog or negedge nres)
if (!nres)
	cfg <= 8'b0;
else if (ena_bus && sys && ac[2:0] == 3'b000)
	cfg <= dc[7:0];


// cogs

reg [7:0] cog_e;

wire cog_start		= sys && ac[2:0] == 3'b010 && !(dc[3] && all);

always @(posedge clk_cog or negedge nres)
if (!nres)
	cog_e <= 8'b00000001;
else if (ena_bus && sys && ac[2:1] == 2'b01)
	cog_e <= cog_e & ~num_dcd | {8{!ac[0]}} & num_dcd;

always @(posedge clk_cog or negedge nres)
if (!nres)
	cog_ena <= 8'b0;
else if (ena_bus)
	cog_ena <= cog_e & ~({8{cog_start}} & num_dcd);

assign ptr_w		= {8{cog_start}} & num_dcd;

assign ptr_d		= dc[31:4];


// locks

reg [7:0] lock_e;
reg [7:0] lock_state;

always @(posedge clk_cog or negedge nres)
if (!nres)
	lock_e <= 8'b0;
else if (ena_bus && sys && ac[2:1] == 2'b10)
	lock_e <= lock_e & ~num_dcd | {8{!ac[0]}} & num_dcd;

always @(posedge clk_cog)
if (ena_bus && sys && ac[2:1] == 2'b11)
	lock_state <= lock_state & ~num_dcd | {8{!ac[0]}} & num_dcd;

wire lock_mux		= lock_state[dc[2:0]];


// output

reg [2:0] sys_q;
reg sys_c;

always @(posedge clk_cog)
if (ena_bus && sys)
	sys_q <= ac[2:0] == 3'b001	? {	bus_sel[7] || bus_sel[6] || bus_sel[5] || bus_sel[0],		// cogid
									bus_sel[7] || bus_sel[4] || bus_sel[3] || bus_sel[0],
									bus_sel[6] || bus_sel[4] || bus_sel[2] || bus_sel[0] }
								: num;															// others

always @(posedge clk_cog)
if (ena_bus && sys)
	sys_c <= ac[2:1] == 2'b11	? lock_mux		// lockset/lockclr
								: all;			// others

endmodule

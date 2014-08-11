// cog_ctr

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

module				cog_ctr
(
input				clk_cog,
input				clk_pll,

input				ena,

input				setctr,
input				setfrq,
input				setphs,

input		[31:0]	data,

input		[31:0]	pin_in,

output reg	[32:0]	phs,

output		[31:0]	pin_out,

output				pll
);


// control

reg [31:0] ctr;
reg [31:0] frq;

always @(posedge clk_cog or negedge ena)
if (!ena)
	ctr <= 32'b0;
else if (setctr)
	ctr <= data;

always @(posedge clk_cog)
if (setfrq)
	frq <= data;

always @(posedge clk_cog)
if (setphs || trig)
	phs <= setphs ? {1'b0, data} : {1'b0, phs[31:0]} + {1'b0, frq};


// input pins

reg [1:0] dly;

always @(posedge clk_cog)
if (|ctr[30:29])
	dly <= {ctr[30] ? pin_in[ctr[13:9]] : dly[0], pin_in[ctr[4:0]]};


// trigger, outputs

					//	trigger			outb		outa
wire [15:0][2:0] tp	= {	dly == 2'b10,	!dly[0],	1'b0,		// neg edge w/feedback
						dly == 2'b10,	1'b0,		1'b0,		// neg edge
						!dly[0],		!dly[0],	1'b0,		// neg w/feedback
						!dly[0],		1'b0,		1'b0,		// neg
						dly == 2'b01,	!dly[0],	1'b0,		// pos edge w/feedback
						dly == 2'b01,	1'b0,		1'b0,		// pos edge
						dly[0],			!dly[0],	1'b0,		// pos w/feedback
						dly[0],			1'b0,		1'b0,		// pos
						1'b1,			!phs[32],	phs[32],	// duty differential
						1'b1,			1'b0,		phs[32],	// duty single
						1'b1,			!phs[31],	phs[31],	// nco differential
						1'b1,			1'b0,		phs[31],	// nco single
						1'b1,			!pll,		pll,		// pll differential
						1'b1,			1'b0,		pll,		// pll single
						1'b1,			1'b0,		1'b0,		// pll internal
						1'b0,			1'b0,		1'b0 };		// off

wire [3:0] pick		= ctr[29:26];
wire [2:0] tba		= tp[pick];

wire trig			= ctr[30] ? pick[dly]	: tba[2];		// trigger
wire outb			= ctr[30] ? 1'b0		: tba[1];		// outb
wire outa			= ctr[30] ? 1'b0		: tba[0];		// outa


// output pins

assign pin_out		= outb << ctr[13:9] | outa << ctr[4:0];


// pll simulator

reg [35:0] pll_fake;

always @(posedge clk_pll)
if (~&ctr[30:28] && |ctr[27:26])
	pll_fake <= pll_fake + {4'b0, frq};

wire [7:0] pll_taps	= pll_fake[35:28];

assign pll			= pll_taps[~ctr[25:23]];

endmodule

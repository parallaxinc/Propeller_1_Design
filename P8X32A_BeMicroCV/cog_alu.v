// cog_alu

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

module				cog_alu
(
input		 [5:0]	i,
input		[31:0]	s,
input		[31:0]	d,
input		 [8:0]	p,
input				run,
input				ci,
input				zi,

input		[31:0]	bus_q,
input				bus_c,

output				wr,
output		[31:0]	r,
output				co,
output				zo
);


// rotation instructions

wire [31:0]	dr		= {	d[0],  d[1],  d[2],  d[3],  d[4],  d[5],  d[6],  d[7],
						d[8],  d[9],  d[10], d[11], d[12], d[13], d[14], d[15],
						d[16], d[17], d[18], d[19], d[20], d[21], d[22], d[23],
						d[24], d[25], d[26], d[27], d[28], d[29], d[30], d[31] };

wire [7:0][30:0] ri	= {	31'b0,				// rev
						{31{d[31]}},		// sar
						{31{ci}},			// rcl
						{31{ci}},			// rcr
						31'b0,				// shl
						31'b0,				// shr
						dr[30:0],			// rol
						d[30:0] };			// ror

wire [62:0] rot		= {ri[i[2:0]], i[0] ? dr : d} >> s[4:0];

wire [31:0]	rotr	= {	rot[0],  rot[1],  rot[2],  rot[3],  rot[4],  rot[5],  rot[6],  rot[7],
						rot[8],  rot[9],  rot[10], rot[11], rot[12], rot[13], rot[14], rot[15],
						rot[16], rot[17], rot[18], rot[19], rot[20], rot[21], rot[22], rot[23],
						rot[24], rot[25], rot[26], rot[27], rot[28], rot[29], rot[30], rot[31] };

wire [31:0] rot_r	= ~&i[2:1] && i[0] ? rotr : rot[31:0];

wire rot_c			= ~&i[2:1] && i[0] ? dr[0] : d[0];


// mins/maxs/min/max/movs/movd/movi/jmpret/and/andn/or/xor/muxc/muxnc/muxz/muxnz

wire [1:0] log_s	= i[2] ? {(i[1] ? zi : ci) ^ i[0], 1'b0}	// muxc/muxnc/muxz/muxnz
						   : {i[1], ~^i[1:0]};					// and/andn/or/xor

wire [3:0][31:0] log_x	= {	d ^  s,								// 11 = xor
							d |  s,								// 10 = or		mux 1
							d &  s,								// 01 = and
							d & ~s };							// 00 = andn	mux 0

wire [3:0][31:0] mov_x	= {	d[31:9], p,							// jmpret
							s[8:0], d[22:0],					// movi
							d[31:18], s[8:0], d[8:0],			// movd
							d[31:9], s[8:0] };					// movs

wire [31:0] log_r	= i[3] ? log_x[log_s]						// and/andn/or/xor/muxc/muxnc/muxz/muxnz
					: i[2] ? mov_x[i[1:0]]						// movs/movd/movi/jmpret
						   : s;									// mins/maxs/min/max

wire log_c			= ^log_r;									// c is parity of result



// add/sub instructions

wire [3:0] ads		= {zi, ci, s[31], 1'b0};

wire add_sub		= i[5:4] == 2'b10			? ads[i[2:1]] ^ i[0]	// add/sub/addabs/subabs/sumc/sumnc/sumz/sumnz/mov/neg/abs/absneg/negc/negnc/negz/negnz
					: i[5:0] == 6'b110010 ||							// addx
					  i[5:0] == 6'b110100 ||							// adds
					  i[5:0] == 6'b110110 ||							// addsx
					  i[5:2] == 4'b1111			? 1'b0					// waitcnt
												: 1'b1;					// other subs

wire add_ci			= i[5:3] == 3'b110 && (i[2:0] == 3'b001 || i[1]) && ci ||		// cmpsx/addx/subx/addsx/subsx
					  i[4:3] == 2'b11 && i[1:0] == 2'b01;							// djnz

wire [31:0] add_d	= i[4:3] == 2'b01 ? 32'b0 : d;		// mov/neg/abs/absneg/negc/negnc/negz/negnz

wire [31:0] add_s	= i[4:0] == 5'b11001 || i[4:1] == 4'b1101	? 32'hFFFFFFFF		// djnz/tjnz/tjz
					: add_sub									? ~s				// subs
																: s;				// adds

wire [34:0] add_x	= {1'b0, add_d[31], 1'b1, add_d[30:0], 1'b1} +
					  {1'b0, add_s[31], 1'b0, add_s[30:0], add_ci ^ add_sub};

wire [31:0] add_r	= {add_x[33], add_x[31:1]};

wire add_co			= add_x[34];

wire add_cm			= !add_x[32];

wire add_cs			= add_co ^ add_d[31] ^ add_s[31];

wire add_c			= i[5:0] == 6'b111000		? add_co				// cmpsub
					: i[5:3] == 3'b101			? s[31]					// source msb
					: i[5] && i[3:2] == 2'b01	? add_co ^ add_cm		// overflow
					: i[4:1] == 4'b1000			? add_cs				// signed
												: add_co ^ add_sub;		// unsigned

// write-cancel instructions

assign wr			= i[5:2] == 4'b0100		? i[0] ^ (i[1] ? !add_co : add_cs)		// mins/maxs/min/max
					: i[5:0] == 6'b111000	? add_co								// cmpsub
											: 1'b1;									// others

// r, c, z results

assign r			= i[5]					? add_r
					: i[4]					? log_r
					: i[3]					? rot_r
					: run || ~&p[8:4]		? bus_q
											: 32'b0;	// write 0's to last 16 registers during load;


assign co			= i[5:3] == 3'b000		? bus_c
					: i[5:3] == 3'b001		? rot_c
					: i[5:3] == 3'b011		? log_c
											: add_c;

assign zo			= ~|r && (zi || !(i[5:3] == 3'b110 && (i[2:0] == 3'b001 || i[1])));		// addx/subx/cmpx/addsx/subsx/cmpsx logically AND the old z

endmodule

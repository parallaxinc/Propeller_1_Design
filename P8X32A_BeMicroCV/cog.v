// cog

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


																  ADD
instruction								mnem	oper	R  C  Z   +- C  D  S
----------------------------------------------------------------------------
000000 ZC0ICCCC DDDDDDDDD SSSSSSSSS		WRBYTE	D,S		_______   __________
000000 ZC1ICCCC DDDDDDDDD SSSSSSSSS		RDBYTE	D,S		B______   __________
000001 ZC0ICCCC DDDDDDDDD SSSSSSSSS		WRWORD	D,S		_______   __________
000001 ZC1ICCCC DDDDDDDDD SSSSSSSSS		RDWORD	D,S		B______   __________
000010 ZC0ICCCC DDDDDDDDD SSSSSSSSS		WRLONG	D,S		_______   __________
000010 ZC1ICCCC DDDDDDDDD SSSSSSSSS		RDLONG	D,S		B______   __________
000011 ZCRICCCC DDDDDDDDD SSSSSSSSS		SYSOP	D,S		B__B___   __________

000100 ZCRICCCC DDDDDDDDD SSSSSSSSS	*	<MUL>	D,S		M__M__Z   __________
000101 ZCRICCCC DDDDDDDDD SSSSSSSSS	*	<MULS>	D,S		M__M__Z   __________
000110 ZCRICCCC DDDDDDDDD SSSSSSSSS	*	<ENC>	D,S		E_____Z   __________
000111 ZCRICCCC DDDDDDDDD SSSSSSSSS	*	<ONES>	D,S		E_____Z   __________

001000 ZCRICCCC DDDDDDDDD SSSSSSSSS		ROR		D,S		R__R__Z   __________
001001 ZCRICCCC DDDDDDDDD SSSSSSSSS		ROL		D,S		R__R__Z   __________
001010 ZCRICCCC DDDDDDDDD SSSSSSSSS		SHR		D,S		R__R__Z   __________
001011 ZCRICCCC DDDDDDDDD SSSSSSSSS		SHL		D,S		R__R__Z   __________
001100 ZCRICCCC DDDDDDDDD SSSSSSSSS		RCR		D,S		R__R__Z   __________
001101 ZCRICCCC DDDDDDDDD SSSSSSSSS		RCL		D,S		R__R__Z   __________
001110 ZCRICCCC DDDDDDDDD SSSSSSSSS		SAR		D,S		R__R__Z   __________
001111 ZCRICCCC DDDDDDDDD SSSSSSSSS		REV		D,S		R__R__Z   __________

010000 ZCRICCCC DDDDDDDDD SSSSSSSSS		MINS	D,S		L__As_Z   1__0__1__1
010001 ZCRICCCC DDDDDDDDD SSSSSSSSS		MAXS	D,S		L__As_Z   1__0__1__1
010010 ZCRICCCC DDDDDDDDD SSSSSSSSS		MIN		D,S		L__Au_Z   1__0__1__1
010011 ZCRICCCC DDDDDDDDD SSSSSSSSS		MAX		D,S		L__Au_Z   1__0__1__1
010100 ZCRICCCC DDDDDDDDD SSSSSSSSS		MOVS	D,S		L______   __________
010101 ZCRICCCC DDDDDDDDD SSSSSSSSS		MOVD	D,S		L______   __________
010110 ZCRICCCC DDDDDDDDD SSSSSSSSS		MOVI	D,S		L______   __________
010111 ZCRICCCC DDDDDDDDD SSSSSSSSS		JMPRET	D,S		L______   __________

011000 ZCRICCCC DDDDDDDDD SSSSSSSSS		AND		D,S		L__L__Z   __________
011001 ZCRICCCC DDDDDDDDD SSSSSSSSS		ANDN	D,S		L__L__Z   __________
011010 ZCRICCCC DDDDDDDDD SSSSSSSSS		OR		D,S		L__L__Z   __________
011011 ZCRICCCC DDDDDDDDD SSSSSSSSS		XOR		D,S		L__L__Z   __________
011100 ZCRICCCC DDDDDDDDD SSSSSSSSS		MUXC	D,S		L__L__Z   __________
011101 ZCRICCCC DDDDDDDDD SSSSSSSSS		MUXNC	D,S		L__L__Z   __________
011110 ZCRICCCC DDDDDDDDD SSSSSSSSS		MUXZ	D,S		L__L__Z   __________
011111 ZCRICCCC DDDDDDDDD SSSSSSSSS		MUXNZ	D,S		L__L__Z   __________

100000 ZCRICCCC DDDDDDDDD SSSSSSSSS		ADD		D,S		A__Au_Z   0__0__1__1
100001 ZCRICCCC DDDDDDDDD SSSSSSSSS		SUB		D,S		A__Au_Z   1__0__1__1
100010 ZCRICCCC DDDDDDDDD SSSSSSSSS		ADDABS	D,S		A__Au_Z   M__0__1__1
100011 ZCRICCCC DDDDDDDDD SSSSSSSSS		SUBABS	D,S		A__Au_Z   Mn_0__1__1
100100 ZCRICCCC DDDDDDDDD SSSSSSSSS		SUMC	D,S		A__Ao_Z   C__0__1__1
100101 ZCRICCCC DDDDDDDDD SSSSSSSSS		SUMNC	D,S		A__Ao_Z   Cn_0__1__1
100110 ZCRICCCC DDDDDDDDD SSSSSSSSS		SUMZ	D,S		A__Ao_Z   Z__0__1__1
100111 ZCRICCCC DDDDDDDDD SSSSSSSSS		SUMNZ	D,S		A__Ao_Z   Zn_0__1__1

101000 ZCRICCCC DDDDDDDDD SSSSSSSSS		MOV		D,S		A__Am_Z   0__0__0__1
101001 ZCRICCCC DDDDDDDDD SSSSSSSSS		NEG		D,S		A__Am_Z   1__0__0__1
101010 ZCRICCCC DDDDDDDDD SSSSSSSSS		ABS		D,S		A__Am_Z   M__0__0__1
101011 ZCRICCCC DDDDDDDDD SSSSSSSSS		ABSNEG	D,S		A__Am_Z   Mn_0__0__1
101100 ZCRICCCC DDDDDDDDD SSSSSSSSS		NEGC	D,S		A__Am_Z   C__0__0__1
101101 ZCRICCCC DDDDDDDDD SSSSSSSSS		NEGNC	D,S		A__Am_Z   Cn_0__0__1
101110 ZCRICCCC DDDDDDDDD SSSSSSSSS		NEGZ	D,S		A__Am_Z   Z__0__0__1
101111 ZCRICCCC DDDDDDDDD SSSSSSSSS		NEGNZ	D,S		A__Am_Z   Zn_0__0__1

110000 ZCRICCCC DDDDDDDDD SSSSSSSSS		CMPS	D,S		A__As_Z   1__0__1__1
110001 ZCRICCCC DDDDDDDDD SSSSSSSSS		CMPSX	D,S		A__As_Z&  1__C__1__1
110010 ZCRICCCC DDDDDDDDD SSSSSSSSS		ADDX	D,S		A__Au_Z&  0__C__1__1
110011 ZCRICCCC DDDDDDDDD SSSSSSSSS		SUBX	D,S		A__Au_Z&  1__C__1__1
110100 ZCRICCCC DDDDDDDDD SSSSSSSSS		ADDS	D,S		A__Ao_Z   0__0__1__1
110101 ZCRICCCC DDDDDDDDD SSSSSSSSS		SUBS	D,S		A__Ao_Z   1__0__1__1
110110 ZCRICCCC DDDDDDDDD SSSSSSSSS		ADDSX	D,S		A__Ao_Z&  0__C__1__1
110111 ZCRICCCC DDDDDDDDD SSSSSSSSS		SUBSX	D,S		A__Ao_Z&  1__C__1__1

111000 ZCRICCCC DDDDDDDDD SSSSSSSSS		CMPSUB	D,S		A__Ac_Z   1__0__1__1
111001 ZCRICCCC DDDDDDDDD SSSSSSSSS		DJNZ	D,S		A__Au_Z   1__1__1__0
111010 ZCRICCCC DDDDDDDDD SSSSSSSSS		TJNZ	D,S		A__Au_Z   1__0__1__0
111011 ZCRICCCC DDDDDDDDD SSSSSSSSS		TJZ		D,S		A__Au_Z   1__0__1__0
111100 ZCRICCCC DDDDDDDDD SSSSSSSSS		WAITPEQ	D,S		_______   __________
111101 ZCRICCCC DDDDDDDDD SSSSSSSSS		WAITPNE	D,S		_______   __________
111110 ZCRICCCC DDDDDDDDD SSSSSSSSS		WAITCNT	D,S		A__Au_Z   0__0__1__1
111111 ZCRICCCC DDDDDDDDD SSSSSSSSS		WAITVID	D,S		_______   __________
----------------------------------------------------------------------------
* future instructions


ZCR		effects
----------------------------------------------------------------------------
000		nz, nc, nr
001		nz, nc, r
010		nz, c,  nr
011		nz, c,  r
100		z,  nc, nr
101		z,  nc, r
110		z,  c,  nr
111		z,  c,  r


CCCC	condition			(easier-to-read list)
----------------------------------------------------------------------------
0000	never				1111	always			(default)
0001	nc  &  nz			1100	if_c							if_b
0010	nc  &  z			0011	if_nc							if_ae
0011	nc					1010	if_z							if_e
0100	 c  &  nz			0101	if_nz							if_ne
0101	nz					1000	if_c_and_z		if_z_and_c
0110	 c  <> z			0100	if_c_and_nz		if_nz_and_c
0111	nc  |  nz			0010	if_nc_and_z		if_z_and_nc
1000	 c  &  z			0001	if_nc_and_nz	if_nz_and_nc	if_a
1001	 c  =  z			1110	if_c_or_z		if_z_or_c		if_be
1010	 z					1101	if_c_or_nz		if_nz_or_c
1011	nc  |  z			1011	if_nc_or_z		if_z_or_nc
1100	 c					0111	if_nc_or_nz		if_nz_or_nc
1101	 c  |  nz			1001	if_c_eq_z		if_z_eq_c
1110	 c  |  z			0110	if_c_ne_z		if_z_ne_c
1111	always				0000	never


I	SSSSSSSSS	source operand
----------------------------------------------------------------------------
0	SSSSSSSSS	register
1	#SSSSSSSSS	immediate, zero-extended


	DDDDDDDDD	destination operand
----------------------------------------------------------------------------
	DDDDDDDDD	register

*/


`include "cog_ram.v"
`include "cog_alu.v"
`include "cog_ctr.v"
`include "cog_vid.v"


module				cog
(
input				nres,			// reset

input				clk_pll,		// clocks
input				clk_cog,
input				ena_bus,

input				ptr_w,			// pointers
input		[27:0]	ptr_d,

input				ena,			// control

input				bus_sel,		// bus
output				bus_r,
output				bus_e,
output				bus_w,
output		 [1:0]	bus_s,
output		[15:0]	bus_a,
output		[31:0]	bus_d,
input		[31:0]	bus_q,
input				bus_c,
input				bus_ack,

input		[31:0]	cnt,			// counter

input		 [7:0]	pll_in,			// pll's
output				pll_out,

input		[31:0]	pin_in,			// pins
output		[31:0]	pin_out,
output		[31:0]	pin_dir
);


parameter oh		= 31;
parameter ol		= 26;
parameter wz		= 25;
parameter wc		= 24;
parameter wr		= 23;
parameter im		= 22;
parameter ch		= 21;
parameter cl		= 18;
parameter dh		= 17;
parameter dl		= 9;
parameter sh		= 8;
parameter sl		= 0;


// pointers

reg [27:0] ptr;

always @(posedge clk_cog or negedge nres)
if (!nres)
	ptr <= 28'b00000000000000_11111000000000;
else if (ena_bus && ptr_w)
	ptr <= ptr_d;


// load/run

reg run;

always @(posedge clk_cog or negedge ena)
if (!ena)
	run <= 1'b0;
else if (m[3] && (&px))
	run <= 1'b1;


// state

reg [4:0] m;

always @(posedge clk_cog or negedge ena)
if (!ena)
	m <= 5'b0;
else
	m <= { (m[2] || m[4]) &&  waiti,				// m[4] = wait
		   (m[2] || m[4]) && !waiti,				// m[3] = write d
			m[1],									// m[2] = read next instruction
			m[0],									// m[1] = read d
		   !m[4] && !m[2] && !m[1] && !m[0] };		// m[0] = read s


// process

reg [8:0] p;
reg c;
reg z;

always @(posedge clk_cog or negedge ena)
if (!ena)
	p <= 1'b0;
else if (m[3] && !(cond && jump_cancel))
	p <= px + 1'b1;

always @(posedge clk_cog or negedge ena)
if (!ena)
	c <= 1'b0;
else if (m[3] && cond && i[wc])
	c <= alu_co;

always @(posedge clk_cog or negedge ena)
if (!ena)
	z <= 1'b0;
else if (m[3] && cond && i[wz])
	z <= alu_zo;


// addressable registers
//
//		addr	read	write
//		------------------------
//
//		000-1EF	RAM		RAM
//
//		1F0		PAR		RAM
//		1F1		CNT		RAM
//		1F2		INA		RAM
//		1F3		INB	*	RAM
//		1F4		RAM		RAM+OUTA
//		1F5		RAM		RAM+OUTB *
//		1F6		RAM		RAM+DIRA
//		1F7		RAM		RAM+DIRB *
//		1F8		RAM		RAM+CTRA
//		1F9		RAM		RAM+CTRB
//		1FA		RAM		RAM+FRQA
//		1FB		RAM		RAM+FRQB
//		1FC		PHSA	RAM+PHSA
//		1FD		PHSB	RAM+PHSB
//		1FE		RAM		RAM+VCFG
//		1FF		RAM		RAM+VSCL
//
// * future 64-pin version

wire wio			= m[3] && cond && i[wr] && (&i[dh:dl+4]);

wire setouta		= wio && i[dl+3:dl] == 4'h4;
wire setdira		= wio && i[dl+3:dl] == 4'h6;
wire setctra		= wio && i[dl+3:dl] == 4'h8;
wire setctrb		= wio && i[dl+3:dl] == 4'h9;
wire setfrqa		= wio && i[dl+3:dl] == 4'hA;
wire setfrqb		= wio && i[dl+3:dl] == 4'hB;
wire setphsa		= wio && i[dl+3:dl] == 4'hC;
wire setphsb		= wio && i[dl+3:dl] == 4'hD;
wire setvid			= wio && i[dl+3:dl] == 4'hE;
wire setscl			= wio && i[dl+3:dl] == 4'hF;


// register ram

wire ram_ena		= m[0] || m[1] || m[2] || m[3] && cond && i[wr];

wire ram_w			= m[3] && alu_wr;

wire [8:0] ram_a	= m[2]	? px
					: m[0]	? i[sh:sl]
							: i[dh:dl];
wire [31:0] ram_q;


cog_ram cog_ram_  (	.clk	(clk_cog),
					.ena	(ram_ena),
					.w		(ram_w),
					.a		(ram_a),
					.d		(alu_r),
					.q		(ram_q) );


// outa/dira

reg [31:0] outa;
reg [31:0] dira;

always @(posedge clk_cog)
if (setouta)
	outa <= alu_r;

always @(posedge clk_cog or negedge ena)
if (!ena)
	dira <= 32'b0;
else if (setdira)
	dira <= alu_r;


// ctra/ctrb

wire [32:0] phsa;
wire [31:0] ctra_pin_out;
wire plla;

cog_ctr cog_ctra  (	.clk_cog	(clk_cog),
					.clk_pll	(clk_pll),
					.ena		(ena),
					.setctr		(setctra),
					.setfrq		(setfrqa),
					.setphs		(setphsa),
					.data		(alu_r),
					.pin_in		(pin_in),
					.phs		(phsa),
					.pin_out	(ctra_pin_out),
					.pll		(plla) );

wire [32:0] phsb;
wire [31:0] ctrb_pin_out;
wire pllb;

cog_ctr cog_ctrb  (	.clk_cog	(clk_cog),
					.clk_pll	(clk_pll),
					.ena		(ena),
					.setctr		(setctrb),
					.setfrq		(setfrqb),
					.setphs		(setphsb),
					.data		(alu_r),
					.pin_in		(pin_in),
					.phs		(phsb),
					.pin_out	(ctrb_pin_out),
					.pll		(pllb) );

assign pll_out		= plla;


// vid

wire vidack;
wire [31:0] vid_pin_out;

cog_vid cog_vid_  (	.clk_cog	(clk_cog),
					.clk_vid	(plla),
					.ena		(ena),
					.setvid		(setvid),
					.setscl		(setscl),
					.data		(alu_r),
					.pixel		(s),
					.color		(d),
					.aural		(pll_in),
					.carrier	(pllb),
					.ack		(vidack),
					.pin_out	(vid_pin_out) );


// instruction

reg [31:0] ix;

always @(posedge clk_cog)
if (m[3])
	ix <= ram_q;

wire [31:0] i		= run ? ix : {14'b000010_001_0_0001, p, 9'b000000000};


// source

reg [31:0] sy;
reg [31:0] s;

always @(posedge clk_cog)
if (m[1])
	sy <= ram_q;

wire [31:0] sx		= i[im]					? {23'b0, i[sh:sl]}
					: i[sh:sl] == 9'h1F0	? {16'b0, ptr[27:14], 2'b0}
					: i[sh:sl] == 9'h1F1	? cnt
					: i[sh:sl] == 9'h1F2	? pin_in
					: i[sh:sl] == 9'h1FC	? phsa[31:0]
					: i[sh:sl] == 9'h1FD	? phsb[31:0]
											: sy;


always @(posedge clk_cog)
if (m[2])
	s <= sx;


// destination

reg [31:0] d;

always @(posedge clk_cog)
if (m[2])
	d <= ram_q;


// condition

wire [3:0] condx	= i[ch:cl];

wire cond			= condx[{c, z}] && !cancel;


// jump/next

reg cancel;

wire dz				= ~|d[31:1];

wire [1:0] jumpx	= i[oh:ol] == 6'b010111		? {1'b1, 1'b0}				// retjmp
					: i[oh:ol] == 6'b111001		? {1'b1, dz && d[0]}		// djnz
					: i[oh:ol] == 6'b111010		? {1'b1, dz && !d[0]}		// tjnz
					: i[oh:ol] == 6'b111011		? {1'b1, !(dz && !d[0])}	// tjz
												: {1'b0, 1'b0};				// no jump

wire jump			= jumpx[1];
wire jump_cancel	= jumpx[0];

wire [8:0] px		= cond && jump ? sx[8:0] : p;

always @(posedge clk_cog or negedge ena)
if (!ena)
	cancel <= 1'b0;
else if (m[3])
	cancel <= cond && jump_cancel || &px;


// bus interface

assign bus_r		= !bus_sel ? 1'b0	: run;
assign bus_e		= !bus_sel ? 1'b0	: i[oh:ol+2] == 4'b0000__ && m[4];
assign bus_w		= !bus_sel ? 1'b0	: !i[wr];
assign bus_s		= !bus_sel ? 2'b0	: i[ol+1:ol];
assign bus_a		= !bus_sel ? 16'b0	: run ? s[15:0] : {ptr[13:0] + {5'b0, p}, s[1:0]};
assign bus_d		= !bus_sel ? 32'b0	: d;


// alu interface

wire alu_wr;
wire [31:0] alu_r;
wire alu_co;
wire alu_zo;

cog_alu cog_alu_  (	.i		(i[oh:ol]),
					.s		(s),
					.d		(d),
					.p		(p),
					.run	(run),
					.ci		(c),
					.zi		(z),
					.bus_q	(bus_q),
					.bus_c	(bus_c),
					.wr		(alu_wr),
					.r		(alu_r),
					.co		(alu_co),
					.zo		(alu_zo) );


// pin/count match

reg match;

always @(posedge clk_cog)
	match <= m[4] && (i[ol+1:ol] == 2'b01 ^ (i[ol+1] ? cnt : pin_in & s) == d);


// wait

wire waitx			= i[oh:ol+2] == 4'b0000__	? !bus_ack
					: i[oh:ol+1] == 5'b11110_	? !match
					: i[oh:ol+0] == 6'b111110	? !match
					: i[oh:ol+0] == 6'b111111	? !vidack
												: 1'b0;

wire waiti			= cond && waitx;


// pins

assign pin_out		= (outa | ctra_pin_out | ctrb_pin_out | vid_pin_out) & dira;

assign pin_dir		= dira;

endmodule

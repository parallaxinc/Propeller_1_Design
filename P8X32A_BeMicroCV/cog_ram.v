// cog_ram

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

module				cog_ram
(
input				clk,
input				ena,

input				w,
input		 [8:0]	a,
input		[31:0]	d,

output reg	[31:0]	q
);


// 512 x 32 ram

reg [511:0] [31:0]	r;

always @(posedge clk)
begin
	if (ena && w)
		r[a] <= d;
	if (ena)
		q <= r[a];
end

endmodule

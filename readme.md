Propeller 1 Design
==================
P8X32A Emulation on FPGA Boards
-------------------------------
The Propeller 1 Design is a collection of Verilog and AHDL source files that describes the hardware of the [Parallax Propeller 1 microcontroller](http://www.parallax.com/microcontrollers/propeller). This source can be compiled and downloaded to a compatible FPGA development board to emulate the Propeller 1. In fact, this is how the Propeller 1 was designed and tested before silicon was produced.

With this project, you can run our Propeller 1 design and experiment with modifications in the Verilog hardware description language right on your own workbench.

If you've ever wondered how the Propeller chip actually works, it's all in front of you now, and it is malleable.

For additional information, see the [Propeller 1 Design Wiki](https://github.com/parallaxinc/Propeller_1_Design/wiki) and the [Propeller 1 Open Source](http://www.parallax.com/microcontrollers/propeller-1-open-source) page.

License - GPL General Public License v3
---------------------------------------

All files provided are Copyright 2014 Parallax Inc. and distributed under the GNU General Public License v3.0. A copy of this license is included with the files of this repository. The GPL license grants end users the freedom to use and modify the software provided it is copylefted to ensure that any derived works are distributed under the same license terms.

Supported FPGA Boards
---------------------

The Propeller 1 Design files are structured to run on the [Terasic DE2­115](http://www.parallax.com/product/60050), [Terasic DE0­Nano](http://www.parallax.com/product/60056), and Arrow BeMicro CV development boards.

Project Structure
-----------------

There are three sub-directories in this repository: one for the DE2-115, one for the DE0-Nano, and one for the BeMicroCV. They each contain an identical set of Verilog and AHDL files, along with unique .qsf and .cof files to differentiate the pinouts and programming images for the three different FPGA boards.

To compile for an FPGA board, go into the appropriate directory and follow the instructions in the readme.txt file. After compilation and download, the FPGA board will behave like a P8X32A Propeller chip, according to the pinout shown in the .png file. The emulated P8X32A chip will behave as if a 5MHz input is fed into the XI pin. This allows normal 80MHz operation when PLL16X is used. You can program the 'chip' via the Propeller Tool or PropellerIDE software by plugging a PropPlug into the pins outlined in the .png file.

The root directory contains the original .src files which contain the program code that exists in the P8X32A's ROM. You must rename them to .spin files and put a 'PUB anyname' at their top before compiling them. They are not directly executable, but are provided to show you what went into the ROM:

* interpreter.src - begins at $F004
* booter.src - begins at $F800
* runner.src - butts up against $FFFF

To properly view the Verilog and AHDL source files, be sure to set the tab size to 4 spaces in Quartus II via:

Tools | Options... | Text Editor

Revision Notes
--------------

* 08/11/2014 - Fixed bug in reset for dira register (cog.v). Added support for the BeMicroCV board.
* 08/06/2014 - First public release.

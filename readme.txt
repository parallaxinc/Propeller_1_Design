P8X32A Emulation on DE2-115 and DE0-Nano
----------------------------------------

There are two sub-directories in this repository: one for
the DE2-115 and one for the DE0-Nano. They each contain
an identical set of Verilog and AHDL files, along with
unique .qsf and .cof files to differentiate the pinouts
and programming images for the DE2-115 and DE0-Nano.

To compile for either FPGA board, go into the appropriate
directory and follow the instructions in the readme.txt
file. After compilation and download, the FPGA board will
behave like a P8X32A Propeller chip, according to the
pinout shown in the .png file. The emulated P8X32A chip
will behave as if a 5MHz input is fed into the XI pin.
This allows normal 80MHz operation when PLL16X is used.
You can progam the 'chip' via the normal Propeller Tool
software by plugging a PropPlug into the pins outlined
in the .png file.

If you've ever wondered how the Propeller chip actually
works, it's all in front of you know, and malleable.

In this directory are the original .src files which
contain the program code that exists in the P8X32A's
ROM. You must rename them to .spin files and put a
'PUB anyname' at their top before compiling them in
the Propeller Tool. They are not directly executable,
but are provided to show you what went into the ROM:

interpreter.src		begins at $F004
booter.src		begins at $F800
runner.src		butts up against $FFFF

To properly view the Verilog and AHDL source files, be
sure to set the tab size to 4 spaces in Quartus II via:

Tools | Options... | Text Editor
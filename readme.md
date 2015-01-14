Propeller 1 Design
==================
P8X32A Emulation on FPGA Boards
-------------------------------
The Propeller 1 Design is a collection of Verilog and AHDL source files that describes the hardware of the [Parallax Propeller 1 microcontroller](http://www.parallax.com/microcontrollers/propeller). This source can be compiled and downloaded to a compatible FPGA development board to emulate the Propeller 1 hardware. In fact, this is how the Propeller 1 was designed and tested before silicon was produced.

With this project, you can run our Propeller 1 design and experiment with modifications in the Verilog hardware description language right on your own workbench.

If you've ever wondered how the Propeller chip actually works, it's all in front of you now, and it is malleable.

For additional information, see the [Propeller 1 Design Wiki](https://github.com/parallaxinc/Propeller_1_Design/wiki) and the [Propeller 1 Open Source](http://www.parallax.com/microcontrollers/propeller-1-open-source) page.

License - GPL General Public License v3
---------------------------------------

All files provided are Copyright 2014 Parallax Inc. and distributed under the GNU General Public License v3.0. A copy of this license is included with the files of this repository. The GPL license grants end users the freedom to use and modify the software provided it is copylefted to ensure that any derived works are distributed under the same license terms.

Supported FPGA Boards
---------------------

The Propeller 1 Design files are structured to run on the following development boards:

* [Terasic DE2-115](http://www.parallax.com/product/60050) (Altera Cyclone IV)
* [Terasic DE0-Nano](http://www.parallax.com/product/60056) (Altera Cyclone IV)
* [Arrow BeMicro CV](https://parts.arrow.com/item/detail/arrow-development-tools/bemicrocv) (Altera Cyclone V)

Other target systems will be added soon, including Xilinx FPGAs!

Project Structure
-----------------

The HDL directory contains all the files you need to turn your supported FPGA board into a Propeller. All targets use the same files, but you have to follow different instructions depending on your hardware. Please go to the directory that's appropriate for your board and follow the instructions there. Note, the PDF files in some directories may be somewhat outdated because it's harder to edit PDF files than text files. The readme.txt files should be the most accurate.

By default, the emulated P8X32A will behave exactly like a real Propeller chip with a 5MHz crystal connected to the XI pin. This allows normal 80MHz operation when PLL16X is used. You can program the 'chip' via any Propeller development software (like Propeller Tool, PropellerIDE, or SimpleIDE) by plugging a [Prop Plug](http://www.parallax.com/product/32201) into the pins outlined in the .png file. On most FPGA boards, there is not enough EEPROM space available to use the "Download to EEPROM" option from the various Propeller tools, so you'll have to run your Propeller program from the internal RAM; instructions on how to modify FPGA boards to install a bigger EEPROM chip will be posted in the Wiki.

The Spin directory contains the original source files for the code in the P8X32A's ROM. They were created with an early version of the development tools, so they might not compile correctly. For example, you will have to put a 'PUB anyname' at the top before compiling some of the files. They are not directly executable, but are provided to show you what went into the ROM:

* interpreter.spin - begins at $F004
* booter.spin - begins at $F800
* runner.spin - butts up against $FFFF

Another file in that directory called cogledtest.spin can be downloaded to the FPGA to verify that the Propeller is working: it simply starts all cogs in succession so you should see the LEDs on your board light up one by one.

Submitting changes
------------------

Everyone is invited to use the sources in whichever way they see fit. If you want to build your own project based on an FPGA that runs this code with or without your modifications, you're free to do so. However, if you're going to make your project available to others, you should follow the rules of the GPL: you should make the source code available to the people to whom you distribute your project.

The easiest way to make your changes available and to make it easy for yourself to integrate awesome changes that others have made, is to fork the Github repository and make your changes in your fork. Others can then make their own forks off your project. But to maintain a minimum amount of order, let's define some rules:

* The "master" branch will/should always generate a Propeller emulator that's as close to the original functionality of the Propeller (running at 5MHz extern, 80MHz intern with PLL16X) as possible. The internal architecture will match the Propeller as much as possible too. Any deficiencies where the emulation can't match the original must be documented; for example the DE0-Nano doesn't emulate the character ROM area in the hub.
* All source files should be de-tabbed (i.e. contain only spaces, not tab characters). Tabs date from a time when printers were slow, memories were small and mass storage was expensive. In the 21st century they'r only a source of disagreement, so we don't use them. All tabs from the original 2014 distribution from Parallax have been eliminated, and you should not introduce any new ones. To make sure that you don't, make sure your editor settings are correct before you make any changes. For example in the Altera Quartus II tool, open any source file and click on the Tools | Options | Text Editor menu. Make sure that "Insert Space on Tab" is enabled. The "Tab Size (in Spaces)" should be set to 4.
* When you submit your files to Github, make sure that no unnecessary files are checked in. We try to maintain a .gitignore file to prevent unneeded files from ending up in source control, but this rule also applies to changes that are automatically entered into the files by the tools. For example, if you only install support for the Cyclone IV in Quartus because you own Cyclone IV based hardware, that's okay, but the program will automatically convert the Cyclone V projects to a Cyclone IV project and if you allow Github to store this change, your build will work fine but others won't be able to build the project for their hardware anymore. Please review your changes before you check them in. The [Github tool for Windows](https://windows.github.com/) is adequate, but there are other tools available that (arguably) do a better job of letting you review your changes, such as [GitExtensions](http://sourceforge.net/projects/gitextensions/).
* [The Parallax forums](http://forums.parallax.com/forumdisplay.php/101) where this project originates, are a friendly place where everyone respects each other. The Github maintainers will continue this great tradition here. While most of the developers in the P1V community may work with Windows, we don't want to discriminate against those who use Linux or OS/X, so you should avoid using any tools that can't be used on other operating systems besides the one you're using. Also, while English is spoken here, you should keep in mind that not everyone is in the USA, so we should avoid confusion with international issues like date/time formats.

Revision Notes
--------------

* 2015-01-13 - (Jac Goudsmit) De-tabbed all source files, merged all sources into one directory to reduce maintenance effort, updated documentation.
* 2014-08-11 - (Parallax) Fixed bug in reset for dira register (cog.v). Added support for the BeMicroCV board.
* 2014-08-06 - (Parallax) First public release.

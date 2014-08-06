--------------------------------------------------------------------------------------
For experts: the instructions below summarize how to use the Propeller 1 Design files.

For beginners: please see "Setup the Propeller 1 Design on a DE0-Nano.pdf"
--------------------------------------------------------------------------------------


To compile the P8X32A hardware description and load it into the DE0-Nano:

1) Open Quartus II
2) File | Open Project...
3) Select 'top' file from this directory
4) Press the 'play' button to start compilation (takes several minutes)

5) File | Convert Programming Files
6) Click 'Open Conversion Setup Data...'
7) Select 'P8X32A_DE0_Nano.cof' file
8) Click 'Generate'

9) Tools | Programmer
10) Connect the DE0-Nano to your PC via USB cable
11) Click 'Hardware Setup...'
12) Select 'USB-Blaster', click 'Close'
13) Set 'Mode:' to 'JTAG'
14) Click 'Delete' to clear any files or devices
15) Click 'Add File'
16) Select 'P8X32A_DE0_Nano.jic' file
17) Check 'Program/Configure' box
18) Click 'Start' to begin programming (takes a few minutes)

19) Unplug and replug the USB cable to cycle power (loads new configuration)
20) P8X32A should now be running on DE0-Nano, indicated by a single green LED (cog0)

21) Install your Propeller Plug into the GPIO header as shown in the .PNG file

22) You can now use the regular Propeller Tool software to talk to the P8X32A being emulated in the DE0-Nano

Note: In order for the P8X32A design to fit into the DE0-Nano, the character ROM ($8000..$BFFF)
was excluded by commenting out line 93 in hub_mem.v. The upper ROM ($C000..$FFFF) now appears
twice at $8000 and $C000.

Have fun!

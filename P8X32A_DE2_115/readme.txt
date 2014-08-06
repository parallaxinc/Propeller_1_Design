--------------------------------------------------------------------------------------
For experts: the instructions below summarize how to use the Propeller 1 Design files.

For beginners: please see "Setup the Propeller 1 Design on a DE2-115.pdf"
--------------------------------------------------------------------------------------


To compile the P8X32A hardware description and load it into the DE2-115:

1) Open Quartus II
2) File | Open Project...
3) Select 'top' file from this directory
4) Press the 'play' button to start compilation (takes several minutes)

5) File | Convert Programming Files
6) Click 'Open Conversion Setup Data...'
7) Select 'P8X32A_DE2_115.cof' file
8) Click 'Generate'

9) Tools | Programmer
10) Power up the DE2-115 board
11) Connect the upper left-most USB jack to your PC
12) Slide the lower-left switch down to the 'PROG' position
13) Click 'Hardware Setup...'
14) Select 'USB-Blaster', click 'Close'
15) Set 'Mode:' to 'Active Serial Programming'
16) Click 'Delete' to clear any files or devices
17) Click 'Add File'
18) Select 'P8X32A_DE2_115.pof' file
19) Check 'Program/Configure' box
20) Click 'Start' to begin programming (takes a few minutes)

21) Slide the lower-left switch up to the 'RUN' position
22) Press red button twice to cycle power on DE2-115 (loads new configuration)
23) P8X32A should now be running on DE2-115, indicated by a single green LED (cog0)

24) Install your Propeller Plug into the GPIO header as shown in the .PNG file
25) You can now use the regular Propeller Tool software to talk to the P8X32A being emulated in the DE2-115

Have fun!

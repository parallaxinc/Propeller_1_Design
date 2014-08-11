To compile the P8X32A hardware description and load it into the BeMicroCV:

1) Open Quartus II
2) File | Open Project...
3) Select 'top' file from this directory
4) Press the 'play' button to start compilation (takes several minutes)

5) File | Convert Programming Files
6) Click 'Open Conversion Setup Data...'
7) Select 'P8X32A_BeMicroCV.cof' file
8) Click 'Generate'

9) Tools | Programmer
10) Connect the BeMicroCV to your PC via USB cable
11) Click 'Hardware Setup...'
12) Select 'USB-Blaster', click 'Close'
13) Set 'Mode:' to 'JTAG'
14) Click 'Delete' to clear any files or devices
15) Click 'Add File'
16) Select 'P8X32A_BeMicroCV.jic' file
17) Check 'Program/Configure' box
18) Click 'Start' to begin programming (takes a few minutes)

19) Place the jumper for 3.3V I/O as shown in the .PNG file
20) Unplug and replug the USB cable to cycle power (loads new configuration)
21) P8X32A should now be running on BeMicroCV, indicated by a single green LED (cog0)

22) Install your Propeller Plug into the header as shown in the .PNG file

22) You can now use the regular Propeller Tool software to talk to the P8X32A being emulated in the BeMicroCV

Have fun!

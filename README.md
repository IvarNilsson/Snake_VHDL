# Snake in VHDL

## Hardware requirements

This project is created to run on a Nexys 4 board connected to a VGA monitor supporting a resolution of 1280 x 1024 at 60 Hz. More about the VGA timing can be found at [tinyvga](http://tinyvga.com/vga-timing/1280x1024@60Hz). The inputs for controlling the snake are a USB keyboard plugged into the development board, and the keyboard has to support the PS/2 protocol.

## Software requirements

This will just be a short explanation of the software used. For a more extensive description and some help on troubleshooting, check out one of my older projects, [FPGA-sampling](https://github.com/acoustic-warfare/FPGA-sampling).

### General

To make the project easy to use, an activation script is used, called `.activate.sh`, which creates some useful paths and aliases. Some paths in this file need to be changed to run the project. By using [aactivator](https://github.com/Yelp/aactivator), this activation script will launch when entering into the project folder.

### Simulation

For simulation, VUnit test benches are used, utilizing GHDL and visualized in GTKWave. To run a test bench, e.g., `tb_top.vhd`, simply write: `gtkwave "tb_top.wave"` in the terminal when located in the project folder. No automatic tests have yet been created, but if they are later done, write: `vunit "tb_top.auto"` to run the auto test in `tb_top`.

### Generate bit-stream

To generate bit-streams, Vivado is launched and run through scripts where it imports all necessary files and block designs and then runs the implementation. To build the project, write: `build` in the terminal when located in the project folder. This will import all the necessary files into Vivado, configure the block designs, and start to generate the bit-stream.

### Versions

Ubuntu 22.04.3
GHDL 2.0.0
VUnit 4.7.0
GTKWave 3.3.104
Vivado 2017.4

## Block diagram of complete project

![block_diagram][link_block_diagram]

[link_block_diagram]: doc/block_diagram.svg

## Description of each part

### matrix_package

The matrix_package includes 2D matrices to keep track of the segment positions. The matrix has a dimension of 128 (the maximum number of segments) with locations for an unsigned number of 6 bits.

### clk_wiz

To generate the 108 MHz clock that the VGA protocol requires for the 1280 x 1024 at 60 Hz resolution, a clk_wiz is used. The clk_wiz is saved as a TCL script, which means that it can be imported already configured when building the project.

### game_tick_gen

Since the clock is way too fast for a human to play snake with, it is scaled down to a more manageable speed. The `game_tick_gen` file creates a one clock cycle long pulse at a specified interval whenever the snake is supposed to move. To reduce the critical path, a `prepare_game_tick_edge` is also created exactly one clock cycle before the game tick. This means that the movement is already calculated and ready in a register whenever the game tick edge is created. To speed up or slow down the game, simply change the value of `countWidth` in the top file.

### random_number_PRNG

To generate a location for the apple, two semi-random numbers are created: one in the range 0-39 and one in the range 0-31. These numbers correspond to the coordinates where the new apple will be placed. Currently, a new apple can be placed on a snake segment, but this could be a nice thing to fix in the future.

### kb_sync_edge

The data directly from the keyboard can be slightly noisy; therefore, the `kb_sync_edge` implements a back-to-back flip-flop based synchronizer for both the data and clock from the keyboard. It also detects falling edges in the `keyboard_clk` signal.

### kb_scancode

The `kb_scancode` takes the data and `keyboard_clk` and sends out a PS/2 code together with a valid signal.

### kb_ctrl

The next step is to convert the PS/2 signal into a more readable command, and this is done in the `kb_ctrl`. It uses a Moore-state machine to generate the output. The output could be 3 bits, but I used 4 just for simplicity: "0000" = stand still, "1000" = up, "0100" = down, "0010" = left, and "0001" = right.

### kb_game_tick

In snake, it should not be possible to turn 180 degrees in one move since this would mean an instant loss. Therefore, the `kb_game_tick` syncs the `kb_ctrl` output to the game tick and only allows direction changes of 90 degrees at a time.

### segments

All the snake movement and keeping track of all the locations of the parts of the snake are done in the `segments` file. It has two arrays of type `position_type` from the `matrix_package`: one is an array with all the segments' X coordinates, and one is with all the Y coordinates. When the snake moves, all the coordinates are shifted down, making the last one disappear, and the new head location is put at the front. When an apple is eaten, the snake simply moves once without making the first shift, which means that the tail is stationary while the head moves one square, making the snake longer. Collisions are detected in a purely combinational process that checks for collisions with the border and snake, which ends the game, but also with an apple, which increases the snake's length. The outputs from `segments` are one array of X coordinates, one array of Y coordinates, the X and Y coordinates for the apple, the size of the snake, and if the game has ended (collision detected).

### vga_controller

To display all of this on a VGA monitor, a custom VGA controller is used. It counts both horizontally and vertically, increasing the horizontal count each clock cycle and increasing the vertical whenever the horizontal is reset. Two sync signals are sent to the VGA monitor whenever the counter is in a specific range, which can be found at [tinyvga](http://tinyvga.com/vga-timing/1280x1024@60Hz). When both counters are in the active region, it means that this pixel is part of what is shown on the monitor. Whenever in the active region, the default value of the RGB signals is set to green. Then, it checks if this pixel is part of a segment or the apple. If it is part of a segment, the color is changed to gray, and if it is an apple pixel, the color is changed to red. If a collision is detected in the segments, then the color of the snake is changed to white and the apple to black. When calculating if the current pixel is part of a segment or an apple, the current solution is not perfect and in some cases, it can create some unwanted artifacts on the screen.

## Known problems and future work

There are still some features that would be nice to implement, one of which is to make the apple not able to be placed wherever there is a snake segment. This could probably be done without too much hassle, but it would make the `random_number_PRNG` a bit more complicated.

Another issue is the artifacts created in the `vga_controller`. It should not be too complicated, but I have not been able to fix it yet.

It would also be good to continue work on the test-benches and create some automatic tests. 

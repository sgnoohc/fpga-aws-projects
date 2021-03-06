
## How to add sources

### Adding IP cores

These files are based on the RTL Kernel Wizard output.
First run the RTL Kernel Wizard with the exact same settings outlined in the [kernel.xml](ip/kernel.xml).
If successful, the skeleton Vivado project will be the same for most of the source files located in [src/](src/)
The RTL Kernel Wizard tips are located [here](https://github.com/sgnoohc/aws-fpga-notes/blob/master/README.md).

Once the Vivado project is open proceed to add the .xci IP cores that I created for this RTL kernel.
Click on '+' icon in the "Sources" tab.
Add the .xci files under the [ip/](ip/).
Make sure to click the option of "Copy sources into project"
If you forget to do so, the IP's are locked.
You can right click on the IP's from the "Sources" tab -> "IP Sources" sub-tab, and copy the sources into the project.

Select all of the IPs that were added, right click and "Generate Output Products".
The .xci files are simple .xml like files.
It just tells Xilinx Vivado to generate source codes out of the .xml files.
These are basically the intellectual property (IP) of Xilinx Vivado.
And you are telling Xilinx Vivado to create these output products (i.e. source codes in verilog/vhdl) for you with the configurable .xci files.

### Adding HDL source files

Now it is time to overwrite some of the skeleton files of the projects with what is in [src/](src/)
If everything went well, then only a few lines in my_matrix_multiplier.v should be different betwen the two files.

    my_matrix_multiplier.v
    my_matrix_multiplier_implementation.v

Copy those files over

    # For example
    cp ~/src/project_data/fpga-aws-projects/matrix_multiplier_rtl/vivado/src/my_matrix_multiplier.v ~/src/project_data/workspace/<SDAccel_Project_Name>/vivado_rtl_kernel/my_matrix_multiplier_ex/imports/my_matrix_multiplier.v

    # For example
    cp my_matrix_multiplier_implementation.sv ~/src/project_data/workspace/matrix_multiplier/vivado_rtl_kernel/my_matrix_multiplier_ex/imports/

The second file must be added to the Vivado xilinx project since the project doesn't know about the file.
If you already copied over the files to ```imports/``` directory, then don't select the "Copy files to project" option.
Since it's easier to place the source files that you are going to edit in one place.

### Running behavioral simulation

Now let's run behavioral simulation to see if things compile OK.
From the left-hand side panel, click on the "Run Simulation" and "Run Behavioral Simulation".
If you get a XSim output with waveform, then success!


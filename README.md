# rfnoc-ootexample

Example RFNOC repo that uses a more complex Makefile process for FPGA builds. 

This lets you add portable functionality to your RFNOC OOT build including:
 - Vivado IP
 - HLS

The repo includes example IP and HLS. The examples should work in both simulation (rfnoc/testbenches) and when building to target e300 or x300 (in uhd-fpga/usrp3/top/XXXX).

The magic here is in the structure and formatting of the Makefile.inc "tree" throughout the rfnoc directories in order to properly build necessary FPGA sources. I've mostly modeled this after the uhd-fpga structure, so it's really quite similar, but still requires some manual editing in the OOT modules at this point (I have not edited rfnocmodtool, though that would be quite nice to get to that point....)

## Building uhd-fpga

In your gnuradio source directory (next to uhd-fpga), checkout rfnoc-ootexample: `git clone git@github.com:ejk43/rfnoc-ootexample.git`

The makefile changes required to build OOT modules with HLS have been mainlined into uhd-fpga-- you should be able to use uhd_image_builder.py and point to the rfnoc-ootexample repo to have all the blocks available to instantiate in your FPGA build.

(if you hit problems, let me know: ejkreinar@gmail.com)

If you want to use the HLS blocks, dont forget to append `HLS` to your make call (e.g., make E310_RFNOC_HLS)


## Simulating HLS

There's a few edits to the uhd-fpga repo needed to simulate HLS code. To get these edits, I have a uhd-fpga fork here: https://github.com/ejk43/fpga/tree/ejk/hls_testbench

(For now, I've left these as separate forks online but I've applied the patches locally on my machine)

After pulling these edits, it should be possible to successfully run "make xsim_hls" from the "rfnoc/testbenches/noc_block_addsuboot_tb" directory.


## Running on the FPGA

Disclaimer: I have NOT run these blocks on an FPGA. I have both simulated and build into the E310 build, but I have not tested on the E310 or cross-compiled. I have also not checked all the GRC hooks. 

To be honest, you probably wouldnt want to use these noc_blocks, since they're stripped down and mostly just demonstrations of the build process. But if this is important, let me know.... 

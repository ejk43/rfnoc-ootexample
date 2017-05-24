# rfnoc-ootexample

Example RFNOC repo that uses a more complex Makefile process for FPGA builds. 

This lets you add portable functionality to your RFNOC OOT build including:
 - Vivado IP
 - HLS

The repo includes example IP and HLS. The examples should work in both simulation (rfnoc/testbenches) and when building to target e300 or x300 (in uhd-fpga/usrp3/top/XXXX).

The magic here is in the structure and formatting of the Makefile.inc "tree" throughout the rfnoc directories in order to properly build necessary FPGA sources. I've mostly modeled this after the uhd-fpga structure, so it's really quite similar, but still requires some manual editing in the OOT modules at this point (I have not edited rfnocmodtool, though that would be quite nice to get to that point....)

## Building uhd-fpga

In order to link correctly to the uhd-fpga builds, a few minor uhd-fpga changes are required from the uhd-fpga fork here: https://github.com/ejk43/fpga/tree/new_oot_includes

This basically tells the overall project Makefile to include a new Makefile.OOT.inc, which is used to specify folders of OOT repositories and point to their sources. 

An example entry for Makefile.OOT.inc for this repo would be: 

```
##################################################
# Include OOT makefiles
##################################################

OOT_DIR = $(BASE_DIR)/../../../rfnoc-ootexample/rfnoc
include $(OOT_DIR)/Makefile.inc
```

Then you can include IP from the rfnoc-ootexample folder in the rfnoc_ce_auto_inst file. 

I have also edited uhd_image_builder.py to correctly format the Makefile.OOT.inc files based on provided include paths. I've *tried* to edit uhd_image_builder_gui.py, but I have not extensively tested. 

Anyway, you can run "make E310_RFNOC" or other commands as usual. 


## Simulating HLS

There's a few edits to the uhd-fpga repo needed to simulate HLS code. To get these edits, I have a uhd-fpga fork here: https://github.com/ejk43/fpga/tree/ejk/hls_testbench

(For now, I've left these as separate forks online but I've applied the patches locally on my machine)

After pulling these edits, it should be possible to successfully run "make xsim_hls" from the "rfnoc/testbenches/noc_block_addsuboot_tb" directory.


## Running on the FPGA

Disclaimer: I have NOT run these blocks on an FPGA. I have both simulated and build into the E310 build, but I have not tested on the E310 or cross-compiled. I have also not checked all the GRC hooks. 

To be honest, you probably wouldnt want to use these noc_blocks, since they're stripped down and mostly just demonstrations of the build process. But if this is important, let me know.... 
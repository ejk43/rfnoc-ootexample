# rfnoc-ootexample

Example RFNOC repo that uses a more complex Makefile process for FPGA builds. 

This lets you add portable functionality to your RFNOC OOT build including:
 - Vivado IP
 - HLS

This repo includes example makefiles for both Xilinx IP (.xci files) and Xilinx HLS. The examples should work in both simulation (rfnoc/testbenches) and when building to target e300 or x300 (in uhd-fpga/usrp3/top/XXXX).

The magic here is in the structure and formatting of the Makefile.inc "tree" throughout the rfnoc directories in order to properly build necessary FPGA sources. I've mostly modeled this after the uhd-fpga structure, so it's really quite similar, but still requires some manual editing in the OOT modules at this point.

#### Requirements

1. Vivado 2015.4
2. [uhd-fpga](https://github.com/ettusresearch/fpga): The `vivado-2015.4` branch of rfnoc-ootexample is compatible with uhd-fpga up to and including commit [434943bf1a](https://github.com/ettusresearch/fpga/commits/434943bf1a) -- basically the commit before Vivado 2017.4 was merged into rfnoc-devel.

NOTE: For vivado 2017.4 compatibility, see the master branch. 

## Simulating OOT noc_blocks

Make sure you have sourced the Vivado environment before running simulations (nominally something like `source  /opt/Xilinx/Vivado/2015.4/settings64.sh`)

#### noc_block_complextomagphase

Demonstrates OOT usage of Xilinx IP:

```
cd rfnoc/testbenches/noc_block_complextomagphase_tb
make xsim
```

See the `rfnoc/ip` folder and subfolders for demonstration Makefiles to include IP in rfnoc builds

#### noc_block_addsuboot

Demonstrates OOT usage of Vivado HLS:

```
cd rfnoc/testbenches/noc_block_complextomagphase_tb
make xsim_hls
```

See the `rfnoc/hls` folder and subfolders for demonstration Makefiles to include HLS in rfnoc builds

## Building uhd-fpga with OOT noc_blocks

In your gnuradio source directory (next to uhd-fpga), checkout rfnoc-ootexample: `git clone git@github.com:ejk43/rfnoc-ootexample.git`

The makefile changes required to build OOT modules with HLS have been mainlined into uhd-fpga-- you should be able to use uhd_image_builder.py and point to the rfnoc-ootexample repo to have all the blocks available to instantiate in your FPGA build.

(if you hit problems, let me know: ejkreinar@gmail.com)

If you want to use the HLS blocks, dont forget to append `HLS` to your make call (e.g., make E310_RFNOC_HLS)

## Running on the FPGA

Disclaimer: I have NOT run these blocks on an FPGA. I have both simulated and build into the E310 build, but I have not tested on the E310 or cross-compiled. I have also not checked all the GRC hooks. 

To be honest, you probably wouldnt want to use these noc_blocks, since they're stripped down and mostly just demonstrations of the build process. But if this is important, let me know.... 

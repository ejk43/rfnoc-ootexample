# 
# Copyright 2017 EJ Kreinar
# 

#-------------------------------------------------
# Top-of-Makefile
#-------------------------------------------------
# Define BASE_DIR to point to the "top" dir
BASE_DIR = $(abspath ../../../../uhd-fpga/usrp3/top)
# Include viv_sim_preample after defining BASE_DIR
include $(BASE_DIR)/../tools/make/viv_sim_preamble.mak
include $(BASE_DIR)/../tools/make/viv_hls_ip_builder.mak

ARCH = zynq
PART_ID = xc7z020/clg484/-1

#-------------------------------------------------
# IP Specific
#-------------------------------------------------
# If simulation contains IP, define the IP_DIR and point
# it to the base level IP directory
RFNOC_OOTEXAMPLE_DIR = $(abspath ../../)

# Include makefiles and sources for all IP components
# *after* defining the LIB_IP_DIR
include $(RFNOC_OOTEXAMPLE_DIR)/ip/complex_to_magphase_oot/Makefile.inc

DESIGN_SRCS += $(abspath \
$(LIB_IP_COMPLEX_TO_MAGPHASE_OOT_SRCS) \
)

#-------------------------------------------------
# Testbench Specific
#-------------------------------------------------
# Define only one toplevel module
SIM_TOP = noc_block_complextomagphase_tb

# Add test bench, user design under test, and
# additional user created files
SIM_SRCS = \
$(abspath noc_block_complextomagphase_tb.sv) \
$(abspath ../../fpga-src/noc_block_complextomagphase.v)

MODELSIM_USER_DO =

#-------------------------------------------------
# Bottom-of-Makefile
#-------------------------------------------------
# Include all simulator specific makefiles here
# Each should define a unique target to simulate
# e.g. xsim, vsim, etc and a common "clean" target
include $(BASE_DIR)/../tools/make/viv_simulator.mak

# 
# Copyright 2017 EJ Kreinar
# 

include $(TOOLS_DIR)/make/viv_hls_ip_builder.mak

# Set the IP Directory
OOTEXAMPLE_HLS_DIR := $(OOT_DIR)/hls

# Add HLS IP to build
include $(OOTEXAMPLE_HLS_DIR)/addsub_oot/Makefile.inc

LIB_HLS_IP_SRCS += \
$(HLS_IP_ADDSUB_HLS_OUTS)

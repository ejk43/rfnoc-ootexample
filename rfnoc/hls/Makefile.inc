# 
# Copyright 2017 EJ Kreinar
# 

include $(TOOLS_DIR)/make/viv_hls_ip_builder.mak

# Set the IP Directory
OOTEXAMPLE_HLS_DIR := $(OOT_DIR)/hls

# Add HLS IP to build
include $(OOTEXAMPLE_HLS_DIR)/addsub_oot/Makefile.inc

hls_ip: $(HLS_IP_BUILD_TARGETS)

.PHONY: hls_ip

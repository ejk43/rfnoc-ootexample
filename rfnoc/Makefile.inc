# Specify all relevant Makefiles to include

RFNOC_OOTEXAMPLE_DIR := $(OOT_DIR)
include $(abspath $(RFNOC_OOTEXAMPLE_DIR)/fpga-src/Makefile.inc)
include $(abspath $(RFNOC_OOTEXAMPLE_DIR)/hls/Makefile.inc)
include $(abspath $(RFNOC_OOTEXAMPLE_DIR)/ip/Makefile.inc)

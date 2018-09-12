# 
# Copyright 2017 EJ Kreinar
# 

# Add C/C++/tcl files relative to usrp3/lib/hls/<ip> directory
HLS_IP_ADDSUB_OOT_SRCS = \
addsub_oot.cpp \
addsub_oot.tcl

HLS_IP_ADDSUB_OOT_HLS_OUTS = $(addprefix $(IP_BUILD_DIR)/addsub_oot/, \
solution/impl/verilog/addsub_oot.v \
)

# Sources in lib directory
HLS_IP_ADDSUB_OOT_LIB_SRCS = $(addprefix $(OOTEXAMPLE_HLS_DIR)/addsub_oot/, $(HLS_IP_ADDSUB_OOT_SRCS))

# Build with HLS
$(HLS_IP_ADDSUB_OOT_HLS_OUTS) : $(HLS_IP_ADDSUB_OOT_LIB_SRCS)
	$(call BUILD_VIVADO_HLS_IP,addsub_oot,$(PART_ID),$(HLS_IP_ADDSUB_OOT_LIB_SRCS),$(OOTEXAMPLE_HLS_DIR),$(IP_BUILD_DIR),)

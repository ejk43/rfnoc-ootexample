# 
# Copyright 2017 EJ Kreinar
# 

include $(TOOLS_DIR)/make/viv_ip_builder.mak

LIB_IP_COMPLEX_TO_MAGPHASE_OOT_SRCS = $(IP_BUILD_DIR)/complex_to_magphase_oot/complex_to_magphase_oot.xci

LIB_IP_COMPLEX_TO_MAGPHASE_OOT_OUTS = $(addprefix $(IP_BUILD_DIR)/complex_to_magphase_oot/, \
complex_to_magphase_oot.xci.out \
synth/complex_to_magphase_oot.vhd \
) 

$(LIB_IP_COMPLEX_TO_MAGPHASE_OOT_SRCS) $(LIB_IP_COMPLEX_TO_MAGPHASE_OOT_OUTS) : $(RFNOC_OOTEXAMPLE_DIR)/ip/complex_to_magphase_oot/complex_to_magphase_oot.xci
	$(call BUILD_VIVADO_IP,complex_to_magphase_oot,$(ARCH),$(PART_ID),$(RFNOC_OOTEXAMPLE_DIR)/ip,$(IP_BUILD_DIR),0)

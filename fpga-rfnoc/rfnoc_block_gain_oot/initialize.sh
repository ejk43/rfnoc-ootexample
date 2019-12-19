#!/bin/bash
if [ -z $UHD_DIR ]
then
 echo "UHD_DIR is not set! Must point to UHD repository!"
 exit 1
fi
python3 $UHD_DIR/host/utils/rfnoc_blocktool/rfnoc_create_verilog.py -c ../../block-defs/gain_oot.yml -d .

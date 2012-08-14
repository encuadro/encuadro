#!/bin/bash
in=$1
#in=Data/Blocks.canny.pgm
dire=~/juanc/develop/external_code/ORT-2.3
$dire/Bins/chainpix < $in > Blocks.str
$dire/Bins/fex < Blocks.str > Blocks.fex
$dire/Bins/lpeg < Blocks.fex > Blocks.lpeg
$dire/Bins/ipeg < Blocks.lpeg > Blocks.ipeg
#create output images
$dire/Bins/ort2image < Blocks.fex  > Blocks.fex.pgm
$dire/Bins/ort2image < Blocks.lpeg > Blocks.lpeg.pgm
$dire/Bins/ort2image < Blocks.ipeg > Blocks.ipeg.pgm
#display output images
display $in &
display Data/Blocks.pgm &
display Blocks.fex.pgm &
display Blocks.ipeg.pgm & 
display Blocks.lpeg.pgm &

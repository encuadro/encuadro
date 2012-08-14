# Makefile for Images in Data directory
# Created by AE @ ICST 17-Feb-93
#
BINDIR=../Bins
test:
	@echo " Testing Data Piping Feature"
	${BINDIR}/chainpix < Blocks.canny.pgm > Blocks.str
	${BINDIR}/fex < Blocks.str > Blocks.fex
	${BINDIR}/lpeg < Blocks.fex > Blocks.lpeg
	${BINDIR}/ipeg < Blocks.lpeg > Blocks.ipeg
	${BINDIR}/chainpix < Blocks.canny.pgm | ${BINDIR}/fex | ${BINDIR}/lpeg | ${BINDIR}/ipeg > Blocks.piped.ipeg
	diff Blocks.piped.ipeg Blocks.ipeg
	@echo " If no difference was found all is fine"
	${BINDIR}/ort2image < Blocks.fex  > Blocks.fex.pgm
	@echo " Now load Blocks.fex or Blocks.lpeg, or Blocks.ipeg. Choose a feature from the "
	@echo " menu (it will be highlighted) and press the Next button. If you can't see"
	@echo " the selected feature try playing with the colour menu. "
	@echo " BUG Altert!! Sometimes a features remains higlighted for no reason that"
	@echo " I can't figure it out. In this case just select any another feature and then"
	@echo " re-select the feature you are interested in. If you see polygons with an"
	@echo " extra line its due to the displayer and not the actual grouping program."
	${BINDIR}/DisplayGrps

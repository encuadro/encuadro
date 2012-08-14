# Makefile for LPEG and FEX papers
#
DVITOPS = dvi2ps
DVIFLG  = -p

all:
	(cd FEX ; make DVITOPS=$(DVITOPS) DVIFLG=$(DVIFLG))
	(cd LPEG; make DVITOPS=$(DVITOPS) DVIFLG=$(DVIFLG))

uncompress:
	find ./FEX  -name '*' -exec uncompress {} \;
	find ./LPEG -name '*' -exec uncompress {} \;

compress:
	find ./FEX  -name '*' -exec compress {} \;
	find ./LPEG -name '*' -exec compress {} \;


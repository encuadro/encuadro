# Makefile for LPEG.tex
#

LAT = latex
BIB = bibtex
TABDIR = Tables
FIGDIR = Figures

LPEG.ps : LPEG.dvi
	@$(DVITOPS) $(DVIFLG) $? > $@

see : LPEG.dvi
	xdvi -s 4 -S 15 $?

clean :
	/bin/rm -f *.aux *.log *.lof *.toc *.blg *.bbl *.~*~ Tables/*~* Figures/*~*

superclean :
	/bin/rm -f *.aux *.log *.lof *.toc *.blg *.bbl *.dvi *.~*~ Tables/*~* Figures/*~*

ultraclean :
	/bin/rm -f *.aux *.log *.lof *.toc *.blg *.bbl *.dvi *.ps *.~*~ Tables/*~* Figures/*~*


LPEG.dvi : LPEG.tex
	@echo "First Latex pass...."
	-${LAT} LPEG
	@echo "Final Latex pass...."
	-${LAT} LPEG
	@echo "Completed Latex Processing...."

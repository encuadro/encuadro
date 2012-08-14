# Makefile for FEX.tex
#

LAT = latex
BIB = bibtex

FEX.ps : FEX.dvi
	@$(DVITOPS) $(DVIFLG) $? > $@

see : FEX.dvi
	xdvi -s 4 -S 15 $?

clean :
	/bin/rm -f *.aux *.log *.dlog *.lof *.toc *.blg *.bbl *.~*~ Tables/*~* Figures/*~*

superclean :
	/bin/rm -f *.aux *.log *.dlog *.lof *.toc *.blg *.bbl *.dvi *.~*~ Tables/*~* Figures/*~*

ultraclean :
	/bin/rm -f *.aux *.log *.dlog *.lof *.toc *.blg *.bbl *.dvi *.ps *.~*~ Tables/*~* Figures/*~*


FEX.dvi : FEX.tex
	@echo "First Latex pass...."
	-${LAT} FEX
	@echo "Final Latex pass...."
	-${LAT} FEX
	@echo "Completed Latex Processing...."

# Makefile for TeX documents/papers
# Created by AE @ ICST 11-4-91
#

DVITOPS=dvi2ps

all:
	(cd LaTeX/LPEG ; make -f Makefile DVITOPS="$(DVITOPS)")
	(cd LaTeX/FEX  ; make -f Makefile DVITOPS="$(DVITOPS)")

clean:
	(cd LaTeX/LPEG ; make -f Makefile clean)
	(cd LaTeX/FEX  ; make -f Makefile clean)

superclean:
	(cd LaTeX/LPEG ; make -f Makefile superclean)
	(cd LaTeX/FEX  ; make -f Makefile superclean)

ultraclean:
	(cd LaTeX/LPEG ; make -f Makefile ultraclean)
	(cd LaTeX/FEX  ; make -f Makefile ultraclean)

encode:
	tar -cvf FEX-Doc.tar  LaTeX/FEX
	tar -cvf LPEG-Doc.tar LaTeX/LPEG
	compress FEX-Doc.tar LPEG-Doc.tar
	uuencode FEX-Doc.tar.Z FEX-Doc.tar.Z | split -800
	mv xaa FEX-Doc.tar.Z.UU.1
	mv xab FEX-Doc.tar.Z.UU.2
	mv xac FEX-Doc.tar.Z.UU.3
	mv xad FEX-Doc.tar.Z.UU.4
	uuencode LPEG-Doc.tar.Z LPEG-Doc.tar.Z | split -800
	mv xaa LPEG-Doc.tar.Z.UU.1
	mv xab LPEG-Doc.tar.Z.UU.2
	mv xac LPEG-Doc.tar.Z.UU.3
	/bin/rm FEX-Doc.tar.Z LPEG-Doc.tar.Z
	(cd LaTeX ; /bin/rm -fr * ; cd .. ; rmdir LaTeX)

decode:
	cat FEX-Doc.tar.Z.UU.1 FEX-Doc.tar.Z.UU.2 \
	    FEX-Doc.tar.Z.UU.3 FEX-Doc.tar.Z.UU.4 > FEX-Doc.tar.Z.UU
	cat LPEG-Doc.tar.Z.UU.1 LPEG-Doc.tar.Z.UU.2 \
	    LPEG-Doc.tar.Z.UU.3 > LPEG-Doc.tar.Z.UU
	uudecode FEX-Doc.tar.Z.UU
	uudecode LPEG-Doc.tar.Z.UU
	uncompress FEX-Doc.tar.Z
	uncompress LPEG-Doc.tar.Z
	tar -xvf FEX-Doc.tar
	tar -xvf LPEG-Doc.tar
	/bin/rm *.tar*

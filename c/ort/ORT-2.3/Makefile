# Makefile for ORT
# Created by AE @ ICST 14-11-90
VERSION = 2.3

# May need to modify these:
# Uncomment these two lines to use gcc (NOT version 1.39 of gcc which has a BUG)
# CC	= /opt/gcc/bin/gcc
# CFLAGS = -traditional -finline-functions -I/usr/include/X11R6

# May need to modify these:
# If you decided to use gcc comment these two lines out
CC	= cc -m32
#CFLAGS= 
# If you trust the Dec optimiser
#CFLAGS= -O -Olimit 2000
# If you trust the Sun,HP, or SGI optimiser
CFLAGS= -O

# May need to modify these:
# Only if your C libraries are not all in /usr/lib
#OTHERLIB=/usr/lang/SC1.0
OTHERLIB=.

# You will most likely NEED to modify this:
# This is the root of your X11 tree where the lib and include directories are.
X11DIR= -L/usr/lib/X11R6

#--------------------- NO NEED TO MODIFY BELOW THIS LINE----------------------#

LSTDIR  = Liste
CHNDIR  = Chain
FEXDIR  = FEX
LPGDIR  = LPEG
IPGDIR  = IPEG
DSPDIR  = DisplayGrps
BINDIR  = Bins
LIBDIR	 = Libs

all:
	(cd $(LSTDIR)/src ; make -f Makefile CC="$(CC)" CFLAGS="$(CFLAGS)")
	(cd $(LPGDIR) ; make -f Makefile CC="$(CC)" CFLAGS="$(CFLAGS)" OTHERLIB="$(OTHERLIB)")
	(cd $(FEXDIR) ; make -f Makefile CC="$(CC)" CFLAGS="$(CFLAGS)" OTHERLIB="$(OTHERLIB)")
	(cd $(IPGDIR) ; make -f Makefile CC="$(CC)" CFLAGS="$(CFLAGS)" OTHERLIB="$(OTHERLIB)")
	(cd $(CHNDIR) ; make -f Makefile CC="$(CC)" CFLAGS="$(CFLAGS)" OTHERLIB="$(OTHERLIB)")
#	(cd $(DSPDIR)/exe ; make -f Makefile CC="$(CC)" CFLAGS="$(CFLAGS)" OTHERLIB="$(OTHERLIB)" X11DIR="$(X11DIR)")

clean:
	-(find . -name '*.o'  -exec /bin/rm -fr {} \;)
	-(find . -name '*.a'  -exec /bin/rm -fr {} \;)
	-(cd Bins ; rm DisplayGrps chainpix fex ipeg lpeg ort2image)


bindir=/opt/ORT/bin
libdir=/opt/ORT/Data
mandir=/opt/ORT/man/man1

EXES=\
 Bins/DisplayGrps Bins/chainpix Bins/fex Bins/ipeg Bins/lpeg Bins/ort2image

DATA=Data/Makefile\
 Data/Blocks.canny.pgm  Data/Fractal.pgm  Data/Blocks.pgm  Data/Grid.pgm

install:
	test -d $(bindir) || mkdirhier $(bindir)
	for i in $(EXES) ; do \
		bsdinst -c  -m 0775 $$i $(bindir) ; \
	done
	test -d $(libdir) || mkdirhier $(libdir)
	for i in $(DATA) ; do \
		bsdinst -c  -m 0644 $$i $(libdir) ; \
	done
	test -d $(mandir) || mkdirhier $(mandir)
	bsdinst -c  -m 0644 Doc/man/Liste.man $(mandir)/Liste.1


prettyclean:
	-(find . -name '*~*' -print -exec /bin/rm -fr {} \;)

superclean:
	-(find . -name '*~*' -print -exec /bin/rm -fr {} \;)
	-(find . -name '*.o' -print -exec /bin/rm -fr {} \;)

ultraclean:
	-(find . -name '*~*' -print -exec /bin/rm -fr {} \;)
	-(find . -name '*.o' -print -exec /bin/rm -fr {} \;)
	-(cd $(BINDIR) ; /bin/rm *)
	-(cd $(LIBDIR) ; /bin/rm *)

tar:
	(cd ..; tar -cvf ORT-$(VERSION).tar ORT)

uue:
	(cd ..; tar -cvf ORT-$(VERSION).tar ORT; \
	compress ORT-$(VERSION).tar; \
	uuencode ORT-$(VERSION).tar.Z ORT-$(VERSION).tar.Z > ORT-$(VERSION).uue)


manifest:
	ls -R > MANIFEST

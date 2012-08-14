# Makefile for Curve library
# Created by AE @ ICST 14-11-90
#

EXEDIR  = exe
SRCDIR  = src
BCKDIR  = ${HOME}/ORT/Backup

all:
	(cd $(SRCDIR) ; make -f Makefile CC="$(CC)" CFLAGS="$(CFLAGS)")
	(cd $(EXEDIR) ; make -f Makefile CC="$(CC)" CFLAGS="$(CFLAGS)" OTHERLIB="$(OTHERLIB)")
clean:
	(cd $(SRCDIR) ; make -f Makefile clean)
	(cd $(EXEDIR) ; make -f Makefile clean)

superclean:
	(cd $(SRCDIR) ; make -f Makefile superclean)
	(cd $(EXEDIR) ; make -f Makefile superclean)

ultraclean:
	(cd $(SRCDIR) ; make -f Makefile ultraclean)
	(cd $(EXEDIR) ; make -f Makefile ultraclean)

count:
	(cd $(SRCDIR) ; make -f Makefile count)
	(cd $(EXEDIR) ; make -f Makefile count)
backup:
	(tar -cvf FEX.tar Makefile README src exe)
	(mv FEX.tar $(BCKDIR)/.; compress $(BCKDIR)/FEX.tar)

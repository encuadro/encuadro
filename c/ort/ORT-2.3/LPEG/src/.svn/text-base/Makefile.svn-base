# Makefile for LPEG library
# Created by AE @ ICST 14-11-90
#

LGRPDIR  = LineGrouping
LINEDIR  = LineRoutines
LISTDIR  = ListRoutines
MISCDIR  = MiscRoutines

all:
	@echo 'Making Line Grouping Routines..... '
	(cd $(LGRPDIR) ; make -f Makefile CC="$(CC)" CFLAGS="$(CFLAGS)")
	@echo 'Making Line Routines..... '
	(cd $(LINEDIR) ; make -f Makefile CC="$(CC)" CFLAGS="$(CFLAGS)")
	@echo 'Making List Routines..... '
	(cd $(LISTDIR) ; make -f Makefile CC="$(CC)" CFLAGS="$(CFLAGS)")
	@echo 'Making Misc Routines..... '
	(cd $(MISCDIR) ; make -f Makefile CC="$(CC)" CFLAGS="$(CFLAGS)")

clean:
	@echo 'Cleaning Line Grouping Routines..... '
	(cd $(LGRPDIR) ; make -f Makefile clean)
	@echo 'Cleaning Line Routines..... '
	(cd $(LINEDIR) ; make -f Makefile clean)
	@echo 'Cleaning List Routines..... '
	(cd $(LISTDIR) ; make -f Makefile clean)
	@echo 'Cleaning Misc Routines..... '
	(cd $(MISCDIR) ; make -f Makefile clean)

superclean:
	@echo 'Supercleaning Line Grouping Routines..... '
	(cd $(LGRPDIR) ; make -f Makefile superclean)
	@echo 'Supercleaning Line Routines..... '
	(cd $(LINEDIR) ; make -f Makefile superclean)
	@echo 'Supercleaning List Routines..... '
	(cd $(LISTDIR) ; make -f Makefile superclean)
	@echo 'Supercleaning Misc Routines..... '
	(cd $(MISCDIR) ; make -f Makefile superclean)

ultraclean:
	@echo 'Ultracleaning Line Grouping Routines..... '
	(cd $(LGRPDIR) ; make -f Makefile ultraclean)
	@echo 'Ultracleaning Line Routines..... '
	(cd $(LINEDIR) ; make -f Makefile ultraclean)
	@echo 'Ultracleaning List Routines..... '
	(cd $(LISTDIR) ; make -f Makefile ultraclean)
	@echo 'Ultracleaning Misc Routines..... '
	(cd $(MISCDIR) ; make -f Makefile ultraclean)

count:
	@echo 'Counting Grouping Routines..... '
	(cd $(LGRPDIR) ; wc -l *.c)
	@echo 'Counting Line Routines..... '
	(cd $(LINEDIR) ; wc -l *.c)
	@echo 'Counting List Routines..... '
	(cd $(LISTDIR) ; wc -l *.c)
	@echo 'Counting Misc Routines..... '
	(cd $(MISCDIR) ;  wc -l *.c)

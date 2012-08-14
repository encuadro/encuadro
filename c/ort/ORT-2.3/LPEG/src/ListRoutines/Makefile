# Makefile for LPEG library
# Created by AE @ ICST 14-11-90
#

OBJDIR  = ../../obj
LIBDIR  = ../../../Libs
SRCDIR  = ../ListRoutines
INCDIR  = ../../../Incs
LIB	 = $(LIBDIR)/libLPEG.a

INCFLG	 = -I$(INCDIR)

OBJECTS	= \
	$(OBJDIR)/CrtORTLineList.o \
	$(OBJDIR)/CrtORTCircularArcList.o \
	$(OBJDIR)/SortByThetaAscending.o

libLPEG: $(OBJECTS)
		-ranlib $(LIB)

lint: $(OBJECTS)
		lint *.c

clean:
		/bin/rm -fr *.*~*
superclean:
		/bin/rm -fr $(OBJECTS) *.*~*

ultraclean:
		/bin/rm -fr $(OBJECTS) *.*~* $(LIB)

$(OBJDIR)/CrtORTLineList.o : $(SRCDIR)/CrtORTLineList.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/CrtORTCircularArcList.o : $(SRCDIR)/CrtORTCircularArcList.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/SortByThetaAscending.o : $(SRCDIR)/SortByThetaAscending.c
		$(CC) -c $(CFLAGS) $(INCFLG) $?  -o $@
		ar rv $(LIB) $@

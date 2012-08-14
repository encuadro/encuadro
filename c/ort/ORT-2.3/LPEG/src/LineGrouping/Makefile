# Makefile for LPEG library
# Created by AE @ ICST 14-11-90
#

OBJDIR  = ../../obj
LIBDIR  = ../../../Libs
SRCDIR  = ../LineGrouping
INCDIR  = ../../../Incs
LIB	 = $(LIBDIR)/libLPEG.a

INCFLG	 = -I$(INCDIR)

OBJECTS	= \
	$(OBJDIR)/CheckParallelOrCollinear.o \
	$(OBJDIR)/CheckJunctionType.o


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

$(OBJDIR)/CheckParallelOrCollinear.o : $(SRCDIR)/CheckParallelOrCollinear.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/CheckJunctionType.o : $(SRCDIR)/CheckJunctionType.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

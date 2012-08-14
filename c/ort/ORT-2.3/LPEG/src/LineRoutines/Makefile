# Makefile for libLPEG library
# Created by AE @ ICST 14-11-90
#

OBJDIR  = ../../obj
LIBDIR  = ../../../Libs
SRCDIR	 = ../LineRoutines
LIB	 = $(LIBDIR)/libLPEG.a

OBJECTS	= \
	$(OBJDIR)/LineLength.o \
	$(OBJDIR)/LineLengthParlVar.o \
	$(OBJDIR)/LineLengthPerpVar.o \
	$(OBJDIR)/LineMidPoint.o \
	$(OBJDIR)/LineSegGradient.o \
	$(OBJDIR)/LineSegTheta.o \
	$(OBJDIR)/LineSegThetaVar.o \
	$(OBJDIR)/LineSegColIntercept.o \
	$(OBJDIR)/LineSegRowIntercept.o \
	$(OBJDIR)/CheckPtParlLineSeg.o \
	$(OBJDIR)/PtLinePerpIntercept.o \
	$(OBJDIR)/PtLinePerpDistance.o


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

$(OBJDIR)/LineSegGradient.o : $(SRCDIR)/LineSegGradient.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/LineLength.o : $(SRCDIR)/LineLength.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/LineLengthParlVar.o : $(SRCDIR)/LineLengthParlVar.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/LineLengthPerpVar.o : $(SRCDIR)/LineLengthPerpVar.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/LineSegTheta.o : $(SRCDIR)/LineSegTheta.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/LineSegThetaVar.o : $(SRCDIR)/LineSegThetaVar.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/LineSegColIntercept.o : $(SRCDIR)/LineSegColIntercept.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/LineSegRowIntercept.o : $(SRCDIR)/LineSegRowIntercept.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/LineMidPoint.o : $(SRCDIR)/LineMidPoint.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/CheckPtParlLineSeg.o : $(SRCDIR)/CheckPtParlLineSeg.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/PtLinePerpIntercept.o : $(SRCDIR)/PtLinePerpIntercept.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/PtLinePerpDistance.o : $(SRCDIR)/PtLinePerpDistance.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

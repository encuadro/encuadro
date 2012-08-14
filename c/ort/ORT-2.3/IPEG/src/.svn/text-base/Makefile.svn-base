# Makefile for IPEG library
# Created by AE @ ICST 14-11-90
#

SRCDIR  = ../src
OBJDIR  = ../obj
LIBDIR  = ../../Libs
INCDIR  = ../../Incs
LIB	 = $(LIBDIR)/libIPEG.a

INCFLG	 = -I$(INCDIR)

#OPT	= -O

OBJECTS	= \
	$(OBJDIR)/CreateLPEGLists.o \
	$(OBJDIR)/WriteLPEGLists.o \
	$(OBJDIR)/IntersectionPt.o \
	$(OBJDIR)/SortByIDVLJunctions.o \
	$(OBJDIR)/SortPolygonsByNumSeg.o \
	$(OBJDIR)/SortCornersByQuality.o \
	$(OBJDIR)/SortTripletsByID.o

libIPEG: $(OBJECTS)
		-ranlib $(LIB)

lint: $(OBJECTS)
		lint *.c

clean:
		/bin/rm -fr *.*~*
superclean:
		/bin/rm -fr $(OBJECTS) *.*~*

ultraclean:
		/bin/rm -fr $(OBJECTS) *.*~* $(LIB)

$(OBJDIR)/CreateLPEGLists.o : $(SRCDIR)/CreateLPEGLists.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/WriteLPEGLists.o : $(SRCDIR)/WriteLPEGLists.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/IntersectionPt.o : $(SRCDIR)/IntersectionPt.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/SortByIDVLJunctions.o : $(SRCDIR)/SortByIDVLJunctions.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/SortPolygonsByNumSeg.o : $(SRCDIR)/SortPolygonsByNumSeg.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/SortCornersByQuality.o : $(SRCDIR)/SortCornersByQuality.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/SortTripletsByID.o : $(SRCDIR)/SortTripletsByID.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

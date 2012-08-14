# Makefile for FEX library
# Created by AE @ ICST 14-11-90
#

SRCDIR  = ../src
OBJDIR  = ../obj
LIBDIR  = ../../Libs
INCDIR  = ../../Incs
LIB	 = $(LIBDIR)/libFEX.a

INCFLG	 = -I$(INCDIR)

#OPT	= -O

OBJECTS	= \
	$(OBJDIR)/ReadRawImageData.o \
	$(OBJDIR)/DrawBezierLine.o \
	$(OBJDIR)/DrawCircularArc.o \
	$(OBJDIR)/CreateStringList.o \
	$(OBJDIR)/StringToSegments.o \
	$(OBJDIR)/CircleLeastSq.o \
	$(OBJDIR)/LinkSegments.o

libFEX: $(OBJECTS)
		-ranlib $(LIB)

lint: $(OBJECTS)
		lint *.c

clean:
		/bin/rm -fr *.*~*
superclean:
		/bin/rm -fr $(OBJECTS) *.*~*

ultraclean:
		/bin/rm -fr $(OBJECTS) *.*~* $(LIB)

$(OBJDIR)/ReadRawImageData.o : $(SRCDIR)/ReadRawImageData.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/DrawBezierLine.o : $(SRCDIR)/DrawBezierLine.c
		$(CC) -c $(CFLAGS) $(INCFLG) $?  -o $@
		ar rv $(LIB) $@

$(OBJDIR)/DrawCircularArc.o : $(SRCDIR)/DrawCircularArc.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/CreateStringList.o : $(SRCDIR)/CreateStringList.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/StringToSegments.o : $(SRCDIR)/StringToSegments.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/CircleLeastSq.o : $(SRCDIR)/CircleLeastSq.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/LinkSegments.o : $(SRCDIR)/LinkSegments.c
		$(CC) -c $(CFLAGS) $(INCFLG) $? -o $@
		ar rv $(LIB) $@


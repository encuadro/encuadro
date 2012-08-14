# Makefile for LPEG library
# Created by AE @ ICST 14-11-90
#

OBJDIR  = ../../obj
LIBDIR  = ../../../Libs
SRCDIR	 = ../MiscRoutines
LIB	 = $(LIBDIR)/libLPEG.a

OBJECTS	= \
	$(OBJDIR)/OpenInFile.o \
	$(OBJDIR)/OpenOutFile.o \
	$(OBJDIR)/SkipLines.o \
	$(OBJDIR)/EPtsToORTLine.o \
	$(OBJDIR)/EPtsToORTLineOut.o


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

$(OBJDIR)/OpenInFile.o : $(SRCDIR)/OpenInFile.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/OpenOutFile.o : $(SRCDIR)/OpenOutFile.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/SkipLines.o : $(SRCDIR)/SkipLines.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/EPtsToORTLine.o : $(SRCDIR)/EPtsToORTLine.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@

$(OBJDIR)/EPtsToORTLineOut.o : $(SRCDIR)/EPtsToORTLineOut.c
		$(CC) -c $(CFLAGS) $? -o $@
		ar rv $(LIB) $@



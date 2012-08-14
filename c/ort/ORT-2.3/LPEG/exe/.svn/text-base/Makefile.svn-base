# Makefile for Testing ICST Library routines
# Created by AE @ ICST 16-2-93
#

LIBS	= -lLPEG -lListe -lm

LIBDIR1= ../../Libs
LIBDIR2= $(OTHERLIB)
LIBDIR3= /usr/lib
LIBFLG	= -L${LIBDIR1} -L${LIBDIR2} -L${LIBDIR3}

INCDIR1= /usr/include
INCDIR2= ../../Incs
INCFLG	= -I${INCDIR2} -I${INCDIR1}

BINDIR	= ../../Bins
OBJDIR	= ../obj
SRCDIR	= ../exe

OPT	= -O

BINARIES	= ${BINDIR}/lpeg

OBJECTS	= ${OBJDIR}/lpeg.o

all:	${BINARIES} ${OBJECTS}

clean:
	/bin/rm -fr *.*~*

superclean:
	/bin/rm -fr *.*~* ${OBJECTS}

ultraclean:
		/bin/rm -fr *.*~* ${OBJECTS} ${BINARIES}
count:
	@echo 'Counting Executable..... '
	(cd $(SRCDIR) ; wc -l *.c)

${BINDIR}/lpeg  : ${OBJDIR}/lpeg.o
		${CC} ${OPT} $? ${LIBFLG} ${LIBS} -o $@

${OBJDIR}/lpeg.o: ${SRCDIR}/lpeg.c 
		${CC} -c ${CFLAGS} $? ${INCFLG} -o $@


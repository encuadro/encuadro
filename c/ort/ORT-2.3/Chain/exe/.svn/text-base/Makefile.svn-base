# Makefile for Chainning algorithms
# Created by AE @ ICST 16-2-93
#

LIBS	=  -lm

LIBDIR1=.
LIBDIR2= $(OTHERLIB)
#LIBFLG	= -L${LIBDIR1} -L${LIBDIR2}

INCDIR1= /usr/include
INCFLG	= -I${INCDIR1}

BINDIR	= ../../Bins
OBJDIR	= ../obj
SRCDIR	= ../exe

BINARIES	= ${BINDIR}/chainpix

OBJECTS	= ${OBJDIR}/chainpix.o

all:	${BINARIES} ${OBJECTS}

clean:
	/bin/rm -fr *.*~*

superclean:
	/bin/rm -fr *.*~* ${OBJECTS}

ultraclean:
		/bin/rm -fr *.*~* ${OBJECTS} ${BINARIES}

${BINDIR}/chainpix  : ${OBJDIR}/chainpix.o
		${CC} ${OPT} $? ${LIBFLG} ${LIBS} -o $@

${OBJDIR}/chainpix.o: ${SRCDIR}/chainpix.c 
		${CC} -c `./11TesT`   ${CFLAGS} $? ${INCFLG} -o $@

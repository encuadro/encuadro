# Makefile for IPEG
# Created by AE @ ICST 16-2-93
#

LIBS	= -lFEX -lIPEG -lLPEG -lListe -lm

LIBDIR1= /usr/lib
LIBDIR2= ../../Libs
LIBDIR3= $(OTHERLIB)
LIBFLG	= -L${LIBDIR1} -L${LIBDIR2} -L${LIBDIR3}

INCDIR1= /usr/include
INCDIR2= ../../Incs
INCFLG	= -I${INCDIR1} -I${INCDIR2}

BINDIR	= ../../Bins
OBJDIR	= ../obj
SRCDIR	= ../exe

#OPT	= -O

BINARIES	= ${BINDIR}/ipeg

OBJECTS	= ${OBJDIR}/ipeg.o

all:	${BINARIES} ${OBJECTS}

clean:
	/bin/rm -fr *.*~*

superclean:
	/bin/rm -fr *.*~* ${OBJECTS}

ultraclean:
		/bin/rm -fr *.*~* ${OBJECTS} ${BINARIES}

${BINDIR}/ipeg  : ${OBJDIR}/ipeg.o
		${CC} ${OPT} $? ${LIBFLG} ${LIBS} -o $@

${OBJDIR}/ipeg.o: ${SRCDIR}/ipeg.c 
		${CC} -c ${CFLAGS} $? ${INCFLG} -o $@

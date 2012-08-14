# Makefile for fex
# Created by AE @ ICST 15-11-90
#

LIBS	= -lFEX -lLPEG -lListe -lm

LIBDIR1= ../../Libs
LIBDIR2= $(OTHERLIB)
LIBDIR3= /usr/lib
LIBFLG	= -L${LIBDIR1} -L${LIBDIR2} -L${LIBDIR3}

INCDIR1= /usr/include
INCDIR2= ../../Incs
INCFLG	= -I${INCDIR1} -I${INCDIR2}

BINDIR	= ../../Bins
OBJDIR	= ../obj
SRCDIR	= ../exe

OPT	= -O

BINARIES	= ${BINDIR}/fex \
		  ${BINDIR}/ort2image

OBJECTS	= ${OBJDIR}/fex.o \
		  ${OBJDIR}/ort2image.o

all:	${BINARIES} ${OBJECTS}

clean:
	/bin/rm -fr *.*~*

superclean:
	/bin/rm -fr *.*~* ${OBJECTS}

ultraclean:
		/bin/rm -fr *.*~* ${OBJECTS} ${BINARIES}

${BINDIR}/fex  : ${OBJDIR}/fex.o
		${CC} ${OPT} $? ${LIBFLG} ${LIBS} -o $@

${OBJDIR}/fex.o: ${SRCDIR}/fex.c 
		${CC} -c ${CFLAGS} $? ${INCFLG} -o $@

${BINDIR}/ort2image  : ${OBJDIR}/ort2image.o
		${CC} ${OPT} $? ${LIBFLG} ${LIBS} -o $@

${OBJDIR}/ort2image.o: ${SRCDIR}/ort2image.c 
		${CC} -c ${CFLAGS} $? ${INCFLG} -o $@



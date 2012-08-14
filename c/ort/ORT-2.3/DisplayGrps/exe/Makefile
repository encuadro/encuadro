# Makefile -- source Make-makefile version 1.16 -- date 88/10/08 20:15:58 

DESTDIR	= ../../Bins
MAKEFILE	= Makefile
OBJECTS	= ../obj
INCDIR1	= ../../Incs
INCDIR2	= ${X11DIR}/include
INCDIR2 =-I. 
INCDIR3	= /usr/contrib/X11R6/include

LIBS		= -L/usr/contrib/X11R6/lib -lXaw -lXmu -lXext -lXt -lX11 -lListe -lm
DLIBS1		= ../../Libs
DLIBS2		= ${X11DIR}/lib
DLIBS3		= $(OTHERLIB)
DLIBS4		= /usr/lib
LDFLAGS	= -L$(DLIBS1) -L$(DLIBS2) -L$(DLIBS3) -L$(DLIBS4)
INCFLAGS	= -I$(INCDIR1) -I$(INCDIR2) -I$(INCDIR3)
PROGRAM	= $(DESTDIR)/DisplayGrps

LISTOBJECT	= \
            $(OBJECTS)/DisplayGrps.o \
            $(OBJECTS)/InitDrawing.o \
            $(OBJECTS)/MakeDial.o \
            $(OBJECTS)/MakeMenuColor.o \
            $(OBJECTS)/MakeMenuZoom.o \
            $(OBJECTS)/ReadORTLines.o \
            $(OBJECTS)/ReadORTCircularArcs.o \
            $(OBJECTS)/ReadLPEGPairs.o \
            $(OBJECTS)/ReadIPEGTriplets.o \
            $(OBJECTS)/ReadIPEGPolygons.o

$(PROGRAM): $(LISTOBJECT)
	$(CC) $(CFLAGS) $(INCFLAGS) $(LISTOBJECT) $(LDFLAGS) $(LIBS) -o $@

clean:
	/bin/rm -f a.out *.o $(PROGRAM).old *.BAK _lint.c _index \
                   Makefile.old core *~*
superclean:
	/bin/rm -f a.out *.o $(PROGRAM).old *.BAK _lint.c _index \
                   Makefile.old core *~*
	/bin/rm -f $(OBJECTS)/*.o $(OBJECTS)/core $(OBJECTS)/*.BAK 

ultraclean:
	/bin/rm -f a.out *.o $(PROGRAM).old *.BAK _lint.c _index \
                   Makefile.old core *~*
	/bin/rm -f $(OBJECTS)/*.o $(OBJECTS)/core $(OBJECTS)/*.BAK $(PROGRAM)

$(OBJECTS)/DisplayGrps.o: DisplayGrps.c ../../Incs/DisplayGrp.h ../../Incs/Liste.h
	 $(CC) -c $(CFLAGS) $(INCFLAGS) DisplayGrps.c -o $@

$(OBJECTS)/InitDrawing.o: InitDrawing.c ../../Incs/DisplayGrp.h
	 $(CC) -c $(CFLAGS) $(INCFLAGS) InitDrawing.c -o $@

$(OBJECTS)/MakeDial.o: MakeDial.c ../../Incs/DisplayGrp.h
	 $(CC) -c $(CFLAGS) $(INCFLAGS) MakeDial.c -o $@

$(OBJECTS)/MakeMenuColor.o: MakeMenuColor.c ../../Incs/DisplayGrp.h
	 $(CC) -c $(CFLAGS) $(INCFLAGS) MakeMenuColor.c -o $@

$(OBJECTS)/MakeMenuZoom.o: MakeMenuZoom.c ../../Incs/DisplayGrp.h
	 $(CC) -c $(CFLAGS) $(INCFLAGS) MakeMenuZoom.c -o $@

$(OBJECTS)/ReadORTLines.o: ReadORTLines.c ../../Incs/DisplayGrp.h ../../Incs/Liste.h
	 $(CC) -c $(CFLAGS) $(INCFLAGS) ReadORTLines.c -o $@

$(OBJECTS)/ReadORTCircularArcs.o: ReadORTCircularArcs.c ../../Incs/DisplayGrp.h ../../Incs/Liste.h
	 $(CC) -c $(CFLAGS) $(INCFLAGS) ReadORTCircularArcs.c -o $@

$(OBJECTS)/ReadLPEGPairs.o: ReadLPEGPairs.c ../../Incs/DisplayGrp.h ../../Incs/Liste.h
	 $(CC) -c $(CFLAGS) $(INCFLAGS) ReadLPEGPairs.c -o $@

$(OBJECTS)/ReadIPEGTriplets.o: ReadIPEGTriplets.c ../../Incs/DisplayGrp.h ../../Incs/Liste.h
	 $(CC) -c $(CFLAGS) $(INCFLAGS) ReadIPEGTriplets.c -o $@

$(OBJECTS)/ReadIPEGPolygons.o: ReadIPEGPolygons.c ../../Incs/DisplayGrp.h ../../Incs/Liste.h
	 $(CC) -c $(CFLAGS) $(INCFLAGS) ReadIPEGPolygons.c -o $@

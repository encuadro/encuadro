# Makefile -- source Make-makefile -- date 89/11/15

MAKEFILE	= Makefile
OBJECTS	= ../obj
INCDIR		= ../../Incs
LIBDIR		= ../../Libs
#STD		= -ansi
LIBS		= -lm
PROGRAM	= TestList
LANGUAGE	= C
NEWLIB		= $(LIBDIR)/libListe.a
LDFLAGS	= -L$(LIBDIR)
INCFLAGS	= -I$(INCDIR)

lib: $(OBJECTS)/AddElmList.o $(OBJECTS)/AppendList.o $(OBJECTS)/CopyList.o $(OBJECTS)/CreatList.o $(OBJECTS)/DestElmList.o $(OBJECTS)/DestList.o $(OBJECTS)/ElmNumList.o $(OBJECTS)/PrintList.o $(OBJECTS)/InsertSortList.o $(OBJECTS)/EmptyList.o $(OBJECTS)/MapList.o $(OBJECTS)/FirstElmList.o $(OBJECTS)/NextElmList.o $(OBJECTS)/SizeList.o $(OBJECTS)/SortList.o
	-ranlib $(NEWLIB)

$(PROGRAM): $(OBJECTS)/TestList.o $(OBJECTS)/AddElmList.o $(OBJECTS)/AppendList.o $(OBJECTS)/CopyList.o $(OBJECTS)/CreatList.o $(OBJECTS)/DestElmList.o $(OBJECTS)/DestList.o $(OBJECTS)/ElmNumList.o $(OBJECTS)/PrintList.o $(OBJECTS)/InsertSortList.o $(OBJECTS)/EmptyList.o $(OBJECTS)/MapList.o $(OBJECTS)/FirstElmList.o $(OBJECTS)/NextElmList.o $(OBJECTS)/SizeList.o $(OBJECTS)/SortList.o
	-ranlib $(NEWLIB)
	$(CC) $(STD) $(INCFLAGS) $(OBJECTS)/TestList.o $(LDFLAGS) $(LIBS) -lListe -o $@

clean:
	/bin/rm -f a.out *.o $(PROGRAM).old $(PROGRAM) *.BAK _lint.c _index \
                   Makefile.old core
superclean:
	/bin/rm -f a.out *.o $(PROGRAM).old $(PROGRAM) *.BAK _lint.c _index \
                   Makefile.old core
	/bin/rm -f $(OBJECTS)/*.o $(OBJECTS)/core $(OBJECTS)/*.BAK 
ultraclean:
	/bin/rm -f a.out *.o $(PROGRAM).old $(PROGRAM) *.BAK _lint.c _index \
                   Makefile.old core
	/bin/rm -f $(OBJECTS)/*.o $(OBJECTS)/core $(OBJECTS)/*.BAK $(NEWLIB)

$(OBJECTS)/AddElmList.o: AddElmList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) AddElmList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/AppendList.o: AppendList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) AppendList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/CopyList.o: CopyList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) CopyList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/CreatList.o: CreatList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) CreatList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/DestElmList.o: DestElmList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) DestElmList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/DestList.o: DestList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) DestList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/ElmNumList.o: ElmNumList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) ElmNumList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/PrintList.o: PrintList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) PrintList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/InsertSortList.o: InsertSortList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) InsertSortList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/EmptyList.o: EmptyList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) EmptyList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/MapList.o: MapList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) MapList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/FirstElmList.o: FirstElmList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) FirstElmList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/NextElmList.o: NextElmList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) NextElmList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/SizeList.o: SizeList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) SizeList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/SortList.o: SortList.c $(INCDIR)/ListeP.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) SortList.c -o $@
	ar rv $(NEWLIB) $@

$(OBJECTS)/TestList.o: TestList.c $(INCDIR)/Liste.h
	$(CC) -c $(CFLAGS) $(STD) $(INCFLAGS) TestList.c -o $@

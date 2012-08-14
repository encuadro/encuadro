#Programa: makefile
#Proyecto: encuadro
#Autor: Martin Etchart
#
#Descripción:
#Demo de opencv usando el lsd.

lsdopencv: lsd.c lsd.h lsd_cmd.c lsd-opencv.c
	cc -O3 -o lsd lsd_cmd.c lsd.c -lm
	gcc -o lsd-opencv lsd-opencv.c lsd.c -lm `pkg-config --cflags --libs opencv`

#lsdopencv: lsd.o segments.o lsd-opencv.o
#	gcc -o lsd-opencv lsd-opencv.o lsd.o segments.o 
#
#lsd.o: lsd.c lsd.h lsd_cmd.c
#	cc -O3 -o lsd lsd_cmd.c lsd.c -lm
#

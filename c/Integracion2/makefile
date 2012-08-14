#Program: makefile
#Proyect: encuadro - Facultad de Ingeniería - UDELAR
#Author: Martin Etchart - mrtn.etchart@gmail.com
#
#Description:
#Real time marker detection for pose estimation.
#Line Segment Detector (LSD) for segment detection and OpenCV as interface.
#This program is the evolution of 'lsd-opencv'.
#
#Both programs hosted on:
#http://code.google.com/p/encuadro/


all: lsd.c lsd.h segments.c segments.h marker_detection.c Composit.c Composit.h coplanar.c coplanar.h Error.c Error.h noise.c PositCopl.c PositCopl.h svd.c svd.h
##	cc -o marker_detection marker_detection.c segments.c lsd.c -lm `pkg-config --cflags --libs opencv`
	cc -g -o marker_detection marker_detection.c segments.c lsd.c Composit.c Composit.h coplanar.c coplanar.h Error.c Error.h noise.c PositCopl.c PositCopl.h svd.c svd.h -lc -lm `pkg-config --cflags --libs opencv`
	
#cc -O3 -o lsd lsd.c -lm
#gcc -o marker_detection marker_detection.c lsd.c -lm `pkg-config --cflags --libs opencv`

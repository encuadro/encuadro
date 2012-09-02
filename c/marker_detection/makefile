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


all: lsd.c lsd.h lsd_cmd.c segments.c segments.h marker.c marker.h marker_detection.c
##	cc -o marker_detection marker_detection.c segments.c lsd.c -lm `pkg-config --cflags --libs opencv`
	gcc -std=c99 -o marker_detection marker_detection.c marker.c segments.c lsd.c -lm `pkg-config --cflags --libs opencv`
	
#cc -O3 -o lsd lsd_cmd.c lsd.c -lm
#gcc -o marker_detection marker_detection.c lsd.c -lm `pkg-config --cflags --libs opencv`

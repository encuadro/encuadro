#Program: makefile
#Proyect: encuadro - Facultad de Ingeniería - UDELAR
#Author: Martin Etchart - mrtn.etchart@gmail.com
#
#Description:
#Single photo marker detection for pose estimation.
#Line Segment Detector (LSD) for segment detection and OpenCV as interface.
#This program is the evolution of 'lsd-opencv'.
#
#Both programs hosted on:
#http://code.google.com/p/encuadro/


SRC = lsd.c segments.c  marker.c Composit.c CoplanarPosit.c Error.c PositCopl.c svd.c 
HDR = lsd.h segments.h marker.h Composit.h CoplanarPosit.h Error.h PositCopl.h svd.h 

all: markerPhoto

markerPhoto: ${SRC} ${HDR} main.c
	gcc -g -std=c99 -o markerPhoto main.c ${SRC} -lm `pkg-config --cflags --libs opencv`
	

	
